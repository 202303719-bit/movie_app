import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

/// Handles every read/write to the `users` collection in Firestore.
/// Document id == Firebase Auth uid.
class FirestoreService {
  final CollectionReference<Map<String, dynamic>> _usersRef =
  FirebaseFirestore.instance.collection('users');

  Future<void> createUserProfile({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String avatar,
  }) {
    return _usersRef.doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'avatar': avatar,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> createUserProfileIfMissing({
    required String uid,
    required String name,
    required String email,
    required String avatar,
  }) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) {
      await _usersRef.doc(uid).set({
        'name': name,
        'email': email,
        'phone': '',
        'avatar': avatar,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<AppUser?> getUserProfile(String uid) async {
    final doc = await _usersRef.doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromMap(uid, doc.data()!);
  }

  Stream<AppUser?> watchUserProfile(String uid) {
    return _usersRef.doc(uid).snapshots().map(
          (doc) => doc.exists ? AppUser.fromMap(uid, doc.data()!) : null,
    );
  }

  /// Update Profile screen -> save button
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? phone,
    String? avatar,
  }) {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phone != null) data['phone'] = phone;
    if (avatar != null) data['avatar'] = avatar;
    return _usersRef.doc(uid).update(data);
  }

  /// Update Profile screen -> delete account button
  Future<void> deleteUserProfile(String uid) {
    return _usersRef.doc(uid).delete();
  }

  // --- Optional: favourites / watchlist, used by the Profile tab ---

  Future<void> toggleFavorite(String uid, int movieId, bool isFavorite) {
    final favRef = _usersRef.doc(uid).collection('favorites').doc('$movieId');
    if (isFavorite) {
      return favRef.set({'movieId': movieId, 'addedAt': FieldValue.serverTimestamp()});
    }
    return favRef.delete();
  }

  Stream<List<int>> watchFavoriteIds(String uid) {
    return _usersRef
        .doc(uid)
        .collection('favorites')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d['movieId'] as int).toList());
  }
}