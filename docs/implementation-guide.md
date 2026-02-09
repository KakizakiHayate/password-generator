# 実装手順ガイド

## 実装順序

新機能を追加する際は、以下の順序で実装する。

### 1. Model（データモデル）

Freezed でデータクラスを定義する。

```dart
// lib/models/todo.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

@freezed
sealed class Todo with _$Todo {
  const factory Todo({
    String? id,
    required String title,
    @Default(false) bool completed,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
```

コード生成: `dart run build_runner build --delete-conflicting-outputs`

### 2. Service（ビジネスロジック）

データの取得・保存ロジックを実装する。テンプレートの `FirestoreService` を利用すれば、新しいコレクション名を渡すだけで CRUD が可能。

### 3. ViewModel（状態管理）

`@riverpod class` で ViewModel を定義する。

```dart
// lib/viewmodels/todo_viewmodel.dart
@riverpod
class TodoViewModel extends _$TodoViewModel {
  @override
  Future<List<Todo>> build() async {
    // データ取得ロジック
  }

  Future<void> addTodo(Todo todo) async {
    // 追加ロジック
    ref.invalidateSelf();
  }
}
```

### 4. View（画面）

`ConsumerWidget` で画面を実装し、ViewModel の Provider を参照する。

```dart
// lib/views/screens/todo_screen.dart
class TodoScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoViewModelProvider);
    // Cupertino ウィジェットで UI を構築
  }
}
```

## TDD ワークフロー

各ステップで TDD（Red → Green → Refactor）を適用する。

1. **Red**: テストを書く（実装前なので失敗する）
2. **Green**: テストが通る最小限のコードを書く
3. **Refactor**: テストが通ったままコードを改善する

テストファイルの配置:

```
test/
├── models/          # Model のテスト
├── viewmodels/      # ViewModel のテスト
└── services/        # Service のテスト
```
