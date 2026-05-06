
// Prerequisites:
//   1. Install firebase-tools: `npm install -g firebase-tools`
//   2. Start emulators: `firebase emulators:start --only auth,firestore`
//   3. Run: `flutter test integration_test/`

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseAuth auth;
  late FirebaseFirestore firestore;

  setUpAll(() async {
    await Firebase.initializeApp();

    auth = FirebaseAuth.instance;
    await auth.useAuthEmulator('localhost', 9099);

    firestore = FirebaseFirestore.instance;
    firestore.useFirestoreEmulator('localhost', 8080);
  });

  setUp(() async {
    await auth.signOut();
  });

  group('Auth Flow Integration', () {
    const testEmail = 'integration@test.com';
    const testPassword = 'Password123';
    const testUsername = 'integrationuser';

    test('register creates a new Firebase Auth user', () async {
      final credential = await auth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );

      expect(credential.user, isNotNull);
      expect(credential.user!.email, testEmail);

      await firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'username': testUsername,
        'email': testEmail,
        'displayName': 'Integration User',
        'phone': '0901234567',
        'isActive': true,
        'role': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      final doc = await firestore
          .collection('users')
          .doc(credential.user!.uid)
          .get();
      expect(doc.exists, isTrue);
      expect(doc.data()?['username'], testUsername);
    });

    test('login returns correct user after registration', () async {
      final registered = await auth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
      await auth.signOut();
      final loggedIn = await auth.signInWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );

      expect(loggedIn.user, isNotNull);
      expect(loggedIn.user!.uid, registered.user!.uid);
    });

    test('logout clears currentUser', () async {
      await auth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
      expect(auth.currentUser, isNotNull);

      await auth.signOut();
      expect(auth.currentUser, isNull);
    });

    test('currentUser is null when not logged in', () async {
      expect(auth.currentUser, isNull);
    });
  });
}
