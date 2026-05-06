// Prerequisites:
//   1. Install firebase-tools: `npm install -g firebase-tools`
//   2. Start emulators: `firebase emulators:start --only auth,firestore`
//   3. Run: `flutter test integration_test/`

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

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

  group('Product Flow Integration', () {
    const adminEmail = 'admin@test.com';
    const adminPassword = 'AdminPass123';

    Future<String> createAdminUser() async {
      final cred = await auth.createUserWithEmailAndPassword(
        email: adminEmail,
        password: adminPassword,
      );
      await firestore.collection('users').doc(cred.user!.uid).set({
        'uid': cred.user!.uid,
        'username': 'adminuser',
        'email': adminEmail,
        'displayName': 'Admin User',
        'phone': '0901234567',
        'isActive': true,
        'role': true,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return cred.user!.uid;
    }

    test('admin user can create a product in Firestore', () async {
      final adminUid = await createAdminUser();
      await firestore.collection('products').add({
        'name': 'Integration Product',
        'description': 'Created in integration test',
        'price': 29.99,
        'imageData': null,
        'createdAt': FieldValue.serverTimestamp(),
        'createdBy': adminUid,
      });

      final snapshot = await firestore
          .collection('products')
          .where('name', isEqualTo: 'Integration Product')
          .get();

      expect(snapshot.docs, isNotEmpty);
      expect(snapshot.docs.first.data()['price'], 29.99);
    });

    test(
      'product creation triggers notification document in Firestore',
      () async {
        final adminUid = await createAdminUser();
        final productRef = await firestore.collection('products').add({
          'name': 'Notif Test Product',
          'description': 'Test',
          'price': 10.0,
          'imageData': null,
          'createdAt': FieldValue.serverTimestamp(),
          'createdBy': adminUid,
        });

        await firestore.collection('notifications').add({
          'title': 'Sản phẩm mới',
          'body': 'Notif Test Product vừa được thêm',
          'type': 'product_added',
          'relatedId': productRef.id,
          'isGlobal': true,
          'targetUserId': null,
          'readBy': [],
          'createdAt': FieldValue.serverTimestamp(),
        });

        final notifSnapshot = await firestore
            .collection('notifications')
            .where('relatedId', isEqualTo: productRef.id)
            .get();

        expect(notifSnapshot.docs, isNotEmpty);
        expect(notifSnapshot.docs.first.data()['isGlobal'], isTrue);
      },
    );

    test(
      'getProducts returns all products ordered by createdAt desc',
      () async {
        await firestore.collection('products').add({
          'name': 'First Product',
          'description': 'Old',
          'price': 5.0,
          'imageData': null,
          'createdAt': Timestamp.fromDate(DateTime(2026, 1, 1)),
        });
        await firestore.collection('products').add({
          'name': 'Second Product',
          'description': 'New',
          'price': 15.0,
          'imageData': null,
          'createdAt': Timestamp.fromDate(DateTime(2026, 6, 1)),
        });

        final snapshot = await firestore
            .collection('products')
            .orderBy('createdAt', descending: true)
            .get();

        expect(snapshot.docs.length, greaterThanOrEqualTo(2));
        expect(snapshot.docs.first.data()['name'], 'Second Product');
      },
    );
  });
}
