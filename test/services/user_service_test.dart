import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/core/services/firestore_service.dart';
import 'package:password_generator/services/user_service.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreService firestoreService;
  late UserService userService;
  const userId = 'test-user-123';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    firestoreService = FirestoreService(firestore: fakeFirestore);
    userService = UserService(firestoreService: firestoreService);
  });

  group('T-11.1: 初回起動フロー', () {
    test('usersドキュメントが存在しない場合、デフォルト値で作成される', () async {
      final exists = await userService.exists(userId);
      expect(exists, false);

      await userService.createDefault(userId);

      final exists2 = await userService.exists(userId);
      expect(exists2, true);

      final user = await userService.get(userId);
      expect(user, isNotNull);
      expect(user?.generationCount, 0);
      expect(user?.reviewPromptShown, false);
    });
  });

  group('T-11.2: 2回目以降の起動', () {
    test('usersドキュメントが存在する場合、読み取りできる', () async {
      await userService.createDefault(userId);

      final user = await userService.get(userId);
      expect(user, isNotNull);
      expect(user?.generationCount, 0);
    });
  });

  group('generationCount のインクリメント', () {
    test('generationCount が正しくインクリメントされる', () async {
      await userService.createDefault(userId);
      await userService.incrementGenerationCount(userId);

      final user = await userService.get(userId);
      expect(user?.generationCount, 1);
    });
  });

  group('reviewPromptShown の更新', () {
    test('reviewPromptShown が true に更新される', () async {
      await userService.createDefault(userId);
      await userService.markReviewPromptShown(userId);

      final user = await userService.get(userId);
      expect(user?.reviewPromptShown, true);
    });
  });
}
