import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:social_media_game/domain/auth/auth_failure.dart';
import 'package:social_media_game/infrastructure/auth/auth_repo.dart';

import 'auth_repo_test.mocks.dart';

@GenerateMocks([UserCredential, FirebaseAuth, User, FirebaseDatabase])
void main() {
  late AuthRepo _authRepo;

  late MockFirebaseAuth _mockFirebaseAuth;

  setUp(() {
    _mockFirebaseAuth = MockFirebaseAuth();
    _authRepo = AuthRepo(firebaseAuth: _mockFirebaseAuth);
  });

  group('getSignedInUser', () {
    test(
        'should return [right(GameUser)] when call to signInAnonymously is success',
        () async {
      final MockUserCredential _mockUserCredential = MockUserCredential();
      final MockUser _mockUser = MockUser();

      // arrange
      when(_mockUserCredential.user).thenReturn(_mockUser);
      when(_mockUser.uid).thenReturn("");
      when(_mockUser.displayName).thenReturn("");

      when(_mockFirebaseAuth.signInAnonymously())
          .thenAnswer((_) async => _mockUserCredential);

      // act
      final result = await _authRepo.getSignedInUser();

      // assert
      expect(result, isA<Right>());
      verify(_mockFirebaseAuth.signInAnonymously());
      verifyNoMoreInteractions(_mockFirebaseAuth);
    });

    test('should return [AuthFailure.noUserFailure] when user is null',
        () async {
      final MockUserCredential _mockUserCredential = MockUserCredential();

      // arrange
      when(_mockUserCredential.user).thenReturn(null);

      when(_mockFirebaseAuth.signInAnonymously())
          .thenAnswer((_) async => _mockUserCredential);

      // act
      final result = await _authRepo.getSignedInUser();

      // assert
      expect(result, left(const AuthFailure.noUserFailure()));
      verify(_mockFirebaseAuth.signInAnonymously());
      verifyNoMoreInteractions(_mockFirebaseAuth);
    });

    test(
        'should return [AuthFailure.serverFailure] when [FirebaseAuthException] is thrown',
        () async {
      // arrange
      when(_mockFirebaseAuth.signInAnonymously())
          .thenThrow(FirebaseAuthException(code: 'any'));

      // act
      final result = await _authRepo.getSignedInUser();

      // assert
      expect(result, left(const AuthFailure.serverFailure()));
      verify(_mockFirebaseAuth.signInAnonymously());
      verifyNoMoreInteractions(_mockFirebaseAuth);
    });
  });
}
