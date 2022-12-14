import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterfire_trial0/constants/db_constants.dart';
import 'package:flutterfire_trial0/models/custom_error.dart';

import '../models/user_model.dart';

class ProfileRepository {
  final FirebaseFirestore firebaseFirestore;
  ProfileRepository({
    required this.firebaseFirestore,
  });

  Future<User> getProfile({required String uid}) async {
    try {
      final DocumentSnapshot userDoc = await usersRef.doc(uid).get();

      if (userDoc.exists) {
        final User currentUser = User.fromDoc(userDoc);

        return currentUser;
      } else
        throw 'User Not Found';
    } on FirebaseException catch (e) {
      throw CustomError(code: e.code, message: e.message!, plugin: e.plugin);
    } catch (e) {
      throw CustomError(
          code: 'Exception',
          message: e.toString(),
          plugin: 'flutter_error/server_error');
    }
  }
}
