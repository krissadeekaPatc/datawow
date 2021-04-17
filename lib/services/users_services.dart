import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:todo/model/users_models.dart';

class UserServices {
  var firebaseUser = FirebaseAuth.instance.currentUser;

  List<Users> usersFromFirestore(QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.docs
          .map((e) {
            return Users(
                name: e.data()["displayName"],
                email: e.data()["email"],
                imageURL: e.data()["urlimage"],
                dateOfReg: e.data()["date of register"],
                password: e.data()["password"],
                color: e.data()["color"],
                id: e.id);
          })
          .toList()
          .reversed
          .toList();
    } else {
      return null;
    }
  }

  Stream<List<Users>> usersList(uid) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("data")
        .snapshots()
        .map(usersFromFirestore);
  }

  Future updateValue(uid, name, id) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser.uid)
        .collection("data")
        .doc(id)
        .update({
      "displayName": name,
    });
  }

  Future updateUrl(String url, id) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser.uid)
        .collection("data")
        .doc(id)
        .update({"urlimage": url});
  }

  Future updateColor(color, id) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser.uid)
        .collection("data")
        .doc(id)
        .update({"color": color});
  }
}
