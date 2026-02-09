#!/bin/bash
set -euo pipefail

# ============================================================
# Flutter Fast Starter セットアップスクリプト
#
# 使い方:
#   ./setup.sh                                          # 対話モード
#   ./setup.sh my_todo_app "My Todo App"                # 非対話モード（Firebase ID 自動生成）
#   ./setup.sh my_todo_app "My Todo App" my-todo-app-01 # 非対話モード（Firebase ID 指定）
# ============================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# --- ユーティリティ関数 ---

# snake_case → camelCase (例: my_todo_app → myTodoApp)
to_camel_case() {
  echo "$1" | awk -F_ '{for(i=1;i<=NF;i++){if(i==1){printf "%s",$i}else{printf "%s%s",toupper(substr($i,1,1)),substr($i,2)}}}'
}

# snake_case → PascalCase (例: my_todo_app → MyTodoApp)
to_pascal_case() {
  echo "$1" | awk -F_ '{for(i=1;i<=NF;i++){printf "%s%s",toupper(substr($i,1,1)),substr($i,2)}}'
}

ok() { echo -e "  ${GREEN}OK${NC}"; }

# pubspec.yaml の dev_dependencies をアルファベット順にソート
sort_pubspec_dev_deps() {
  python3 << 'PYEOF'
import re

with open('pubspec.yaml') as f:
    content = f.read()

pattern = r'(dev_dependencies:\n)((?:  \S[^\n]*\n(?:    [^\n]*\n)*)*)'
match = re.search(pattern, content)
if not match:
    exit(0)

header = match.group(1)
body = match.group(2)
entries = re.findall(r'  \S[^\n]*\n(?:    [^\n]*\n)*', body)
entries.sort(key=lambda e: e.strip().split(':')[0])
new_body = header + ''.join(entries)
content = content[:match.start()] + new_body + content[match.end():]

with open('pubspec.yaml', 'w') as f:
    f.write(content)
PYEOF
}

# --- 前提条件チェック ---

if [ ! -f "pubspec.yaml" ]; then
  echo -e "${RED}エラー: pubspec.yaml が見つかりません。プロジェクトルートで実行してください。${NC}"
  exit 1
fi

if ! grep -q "^name: flutter_fast_starter$" pubspec.yaml; then
  echo -e "${RED}エラー: 既にセットアップ済みか、テンプレートではありません。${NC}"
  exit 1
fi

# --- 入力 ---

if [ $# -ge 2 ]; then
  PROJECT_NAME="$1"
  DISPLAY_NAME="$2"
  FIREBASE_PROJECT_ID_INPUT="${3:-}"
else
  echo "========================================"
  echo "  Flutter Fast Starter セットアップ"
  echo "========================================"
  echo ""
  read -rp "プロジェクト名 (snake_case, 例: my_todo_app): " PROJECT_NAME
  read -rp "表示名 (例: My Todo App): " DISPLAY_NAME
  DEFAULT_FIREBASE_ID=$(echo "$PROJECT_NAME" | tr '_' '-')
  read -rp "Firebase プロジェクト ID (デフォルト: ${DEFAULT_FIREBASE_ID}): " FIREBASE_PROJECT_ID_INPUT
fi

# バリデーション
if [[ ! "$PROJECT_NAME" =~ ^[a-z][a-z0-9_]*$ ]]; then
  echo -e "${RED}エラー: プロジェクト名は snake_case で入力してください (例: my_todo_app)${NC}"
  exit 1
fi

if [ -z "$DISPLAY_NAME" ]; then
  echo -e "${RED}エラー: 表示名を入力してください${NC}"
  exit 1
fi

# --- 変数生成 ---

CAMEL_CASE=$(to_camel_case "$PROJECT_NAME")
PASCAL_CASE=$(to_pascal_case "$PROJECT_NAME")
BUNDLE_ID="com.h.dev.${CAMEL_CASE}"
LINT_PACKAGE="${PROJECT_NAME}_lints"
if [ -n "${FIREBASE_PROJECT_ID_INPUT:-}" ]; then
  FIREBASE_PROJECT_ID="$FIREBASE_PROJECT_ID_INPUT"
else
  FIREBASE_PROJECT_ID=$(echo "$PROJECT_NAME" | tr '_' '-')
fi

echo ""
echo "設定内容:"
echo -e "  パッケージ名:    ${GREEN}${PROJECT_NAME}${NC}"
echo -e "  表示名:          ${GREEN}${DISPLAY_NAME}${NC}"
echo -e "  Bundle ID:       ${GREEN}${BUNDLE_ID}${NC}"
echo -e "  Lint パッケージ:   ${GREEN}${LINT_PACKAGE}${NC}"
echo -e "  Firebase ID:     ${GREEN}${FIREBASE_PROJECT_ID}${NC}"
echo ""

if [ $# -lt 2 ]; then
  read -rp "この設定で続行しますか? (y/N): " CONFIRM
  if [[ "$CONFIRM" != "y" && "$CONFIRM" != "Y" ]]; then
    echo "キャンセルしました"
    exit 0
  fi
fi

echo ""

# --- Step 1: pubspec.yaml ---
echo "Step 1/13: pubspec.yaml のパッケージ名・説明を変更..."
sed -i '' "s/^name: flutter_fast_starter$/name: ${PROJECT_NAME}/" pubspec.yaml
sed -i '' 's/^description: "A new Flutter project."$/description: "'"${DISPLAY_NAME}"'"/' pubspec.yaml
ok

# --- Step 2: Dart imports ---
echo "Step 2/13: lib/ と test/ の import を一括置換..."
find lib test -name '*.dart' -exec sed -i '' "s/package:flutter_fast_starter/package:${PROJECT_NAME}/g" {} +
ok

# --- Step 3: Custom lint package ---
echo "Step 3/13: カスタム lint パッケージのリネーム..."
mv flutter_fast_starter_lints "${LINT_PACKAGE}"
sed -i '' "s/flutter_fast_starter_lints/${LINT_PACKAGE}/g" "${LINT_PACKAGE}/pubspec.yaml" pubspec.yaml
mv "${LINT_PACKAGE}/lib/flutter_fast_starter_lints.dart" "${LINT_PACKAGE}/lib/${LINT_PACKAGE}.dart"
sed -i '' "s/_FlutterFastStarterLints/_${PASCAL_CASE}Lints/g" "${LINT_PACKAGE}/lib/${LINT_PACKAGE}.dart"
sort_pubspec_dev_deps
ok

# --- Step 4: iOS Bundle ID ---
echo "Step 4/13: iOS Bundle ID を置換..."
sed -i '' "s/com\.h\.dev\.flutterFastStarter/${BUNDLE_ID}/g" ios/Runner.xcodeproj/project.pbxproj
ok

# --- Step 5: Android Bundle ID ---
echo "Step 5/13: Android Bundle ID を置換..."
sed -i '' "s/com\.h\.dev\.flutterFastStarter/${BUNDLE_ID}/g" android/app/build.gradle.kts
ok

# --- Step 6: Android MainActivity ---
echo "Step 6/13: Android MainActivity のパッケージ名を置換..."
ANDROID_OLD_DIR="android/app/src/main/kotlin/com/h/dev/flutter_fast_starter"
ANDROID_NEW_DIR="android/app/src/main/kotlin/com/h/dev/${PROJECT_NAME}"
sed -i '' "s/package com\.h\.dev\.flutter_fast_starter/package com.h.dev.${PROJECT_NAME}/g" "${ANDROID_OLD_DIR}/MainActivity.kt"
mv "${ANDROID_OLD_DIR}" "${ANDROID_NEW_DIR}"
ok

# --- Step 7: Display names ---
echo "Step 7/13: 表示名を変更..."
# iOS (CFBundleName + CFBundleDisplayName)
sed -i '' "s/<string>flutter_fast_starter<\/string>/<string>${DISPLAY_NAME}<\/string>/g" ios/Runner/Info.plist
sed -i '' "s/<string>Flutter Fast Starter<\/string>/<string>${DISPLAY_NAME}<\/string>/g" ios/Runner/Info.plist
# Android
sed -i '' "s/android:label=\"flutter_fast_starter\"/android:label=\"${DISPLAY_NAME}\"/g" android/app/src/main/AndroidManifest.xml
ok

# --- Step 8: Import order fix ---
echo "Step 8/13: import 順序を修正 (dart fix)..."
dart fix --apply lib/ > /dev/null 2>&1
dart fix --apply test/ > /dev/null 2>&1
ok

# --- Step 9: Dependencies ---
echo "Step 9/13: 依存関係を取得..."
flutter pub get > /dev/null 2>&1
ok

# --- Step 10: Firebase project creation ---
echo "Step 10/13: Firebase プロジェクトを作成..."
FIREBASE_OK=true
FIREBASE_CREATED=false
if ! command -v firebase &> /dev/null; then
  echo -e "  ${RED}スキップ: firebase CLI が見つかりません${NC}"
  FIREBASE_OK=false
elif firebase projects:create "$FIREBASE_PROJECT_ID" --display-name "$DISPLAY_NAME" 2>&1 | tail -1; then
  FIREBASE_CREATED=true
  ok
else
  echo -e "  ${RED}警告: Firebase プロジェクトの作成に失敗しました（既に存在する可能性があります）${NC}"
fi

# --- Step 11: FlutterFire configure ---
echo "Step 11/13: FlutterFire で Firebase を接続..."
if [ "$FIREBASE_OK" = false ]; then
  echo -e "  ${RED}スキップ: firebase CLI が利用できないため${NC}"
elif ! command -v flutterfire &> /dev/null; then
  echo -e "  ${RED}スキップ: flutterfire CLI が見つかりません${NC}"
  echo "  インストール: dart pub global activate flutterfire_cli"
else
  # 新規作成直後はプロパゲーション待機が必要
  if [ "$FIREBASE_CREATED" = true ]; then
    echo "  Firebase プロジェクトの反映を待機中（15秒）..."
    sleep 15
  fi
  if flutterfire configure \
    --project="$FIREBASE_PROJECT_ID" \
    --platforms=ios,android \
    --ios-bundle-id="$BUNDLE_ID" \
    --android-package-name="$BUNDLE_ID" \
    --yes 2>&1 | tail -3; then
    ok
  else
    echo -e "  ${RED}警告: FlutterFire の設定に失敗しました${NC}"
    echo "  手動で実行: flutterfire configure --project=${FIREBASE_PROJECT_ID}"
  fi
fi

# --- Step 12: Static analysis ---
echo "Step 12/13: 静的解析を実行..."
ANALYZE_OUTPUT=$(flutter analyze 2>&1)
if echo "$ANALYZE_OUTPUT" | grep -q "No issues found"; then
  ok
else
  echo -e "  ${RED}警告: 解析で問題が見つかりました${NC}"
  echo "$ANALYZE_OUTPUT" | grep -E "error|warning|info" || true
fi

# --- Step 13: Tests ---
echo "Step 13/13: テストを実行..."
TEST_OUTPUT=$(flutter test 2>&1)
if echo "$TEST_OUTPUT" | grep -q "All tests passed"; then
  ok
else
  echo -e "  ${RED}警告: テストが失敗しました${NC}"
  echo "$TEST_OUTPUT" | tail -5
fi

echo ""
echo "========================================"
echo -e "  ${GREEN}セットアップ完了!${NC}"
echo "========================================"
echo ""
echo -e "${RED}【手動作業が必要です】${NC}"
echo ""
echo "Firebase コンソール（https://console.firebase.google.com）で以下を有効化してください:"
echo ""
echo "  1. Authentication（匿名認証）の有効化"
echo "     → Authentication → ログイン方法 → 匿名 → 有効にする"
echo ""
echo "  2. Firestore Database の作成"
echo "     → Firestore Database → データベースの作成 → テストモードで開始"
echo ""
echo "上記が完了したら:"
echo "  flutter run で動作確認"
echo ""
