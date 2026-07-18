import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/core/services/preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PreferencesService.initialize();
  });

  group('静的メソッド', () {
    test('T-P.1: readString/readBoolは未設定時にデフォルト値を返す', () {
      expect(PreferencesService.readString('missing_key'), isNull);
      expect(PreferencesService.readBool('missing_key'), false);
      expect(
        PreferencesService.readBool('missing_key', defaultValue: true),
        true,
      );
      expect(PreferencesService.readInt('missing_key'), isNull);
    });
  });

  group('インスタンスメソッド', () {
    late PreferencesService service;

    setUp(() {
      service = PreferencesService();
    });

    test('T-P.2: setString/getStringで文字列を保存・取得できる', () async {
      await service.setString('name', '柿崎');
      expect(service.getString('name'), '柿崎');
    });

    test('T-P.3: setBool/getBoolで真偽値を保存・取得できる', () async {
      await service.setBool('flag', true);
      expect(service.getBool('flag'), true);
    });

    test('T-P.4: setInt/getIntで整数を保存・取得できる', () async {
      await service.setInt('count', 42);
      expect(service.getInt('count'), 42);
    });

    test('T-P.5: containsKeyで存在確認ができる', () async {
      expect(service.containsKey('exists'), false);
      await service.setString('exists', 'yes');
      expect(service.containsKey('exists'), true);
    });

    test('T-P.6: removeでキーを削除できる', () async {
      await service.setString('temp', 'value');
      expect(service.containsKey('temp'), true);
      await service.remove('temp');
      expect(service.containsKey('temp'), false);
    });

    test('T-P.7: clearで全キーを削除できる', () async {
      await service.setString('a', '1');
      await service.setString('b', '2');
      await service.clear();
      expect(service.containsKey('a'), false);
      expect(service.containsKey('b'), false);
    });
  });
}
