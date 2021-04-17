import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/controller/textcontroller.dart';
import 'package:todo/model/colors_model.dart';
import 'package:todo/model/comments.dart';
import 'package:todo/model/models.dart';
import 'package:todo/model/public_post_model.dart';

class DatabaseService {
  TextController con = TextController();
  var firebaseUser = FirebaseAuth.instance.currentUser;
  // Future createNewTodoColor(
  //     String date, String colors) async {
  //   return await FirebaseFirestore.instance
  //       .collection(con.currentuserUid)
  //       .doc("TODOS")
  //       .collection(date)
  //       .doc("Colors")
  //       .set({"Colors": colors});
  // }

  Future createNewTodo(
      String title, String collection, String date, String color) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser.uid)
        .collection(date)
        .add({
      "title": title,
      "isComplete": false,
      "date": date,
      "color": color ?? "0xffffffff",
    });
  }

  Future createColor(String colors, String date) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser.uid)
        .collection(date)
        .doc("Colors")
        .set({
      "colors": colors,
    });
  }

  Future createUser(String uid, String email, String password, String date,
      String url, String displayName) async {
    return await FirebaseFirestore.instance
        .collection("Users")
        .doc(uid)
        .collection("data")
        .add({
      "uid": uid,
      "email": email,
      "password": password,
      "date of register": date,
      "urlimage": url ?? null,
      "displayName": displayName ?? "not set",
      "color": "0xff4c1717"
    });
  }

  Future createUser2(String uid, String email, String password, String date,
      String url, String displayName) async {
    return await FirebaseFirestore.instance.collection("Users").add({
      "uid": uid,
      "email": email,
      "password": password,
      "date of register": date,
      "urlimage": url ?? null,
      "displayName": displayName ?? "not set",
    });
  }

  Future completTask(uid, String collection) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser.uid)
        .collection(collection)
        .doc(uid)
        .update({"isComplete": true});
  }

  Future deCompletTask(uid, String collection) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser.uid)
        .collection(collection)
        .doc(uid)
        .update({"isComplete": false});
  }

  Future removeTodo(uid, String collection) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser.uid)
        .collection(collection)
        .doc(uid)
        .delete();
  }

  List<Todo> todoFromFirestore(QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.docs
          .map((e) {
            return Todo(
              isComplete: e.data()["isComplete"],
              title: e.data()["title"],
              date: e.data()["date"],
              color: e.data()["color"],
              uid: e.id,
            );
          })
          .toList()
          .reversed
          .toList();
    } else {
      return null;
    }
  }

  Stream<List<Todo>> listTodos(String date) {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser.uid)
        .collection(date)
        .snapshots()
        .map(todoFromFirestore);
  }

  List<ColorsModels> colorsFromFirestore(QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.docs.map((e) {
        return ColorsModels(
          colors: e.data()["colors"],
        );
      }).toList();
    } else {
      return null;
    }
  }

  Stream<List<ColorsModels>> listColors(String date) {
    var result = FirebaseFirestore.instance
        .collection("Users")
        .doc(firebaseUser.uid)
        .collection(date)
        .doc("Colors")
        .get()
        .then((value) => print(value.data()["colors"]));
  }

  List<PublicPost> publicPost(QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.docs
          .map((e) {
            return PublicPost(
              post: e.data()["post"],
              comment: e.data()["comment"],
              dateTime: e.data()["date"],
              id: e.id,
              uid: e.data()["uid"],
              name: e.data()["name"],
              url: e.data()["url"],
              postUrls: e.data()["postURL"],
            );
          })
          .toList()
          .reversed
          .toList();
    } else {
      return null;
    }
  }

  Stream<List<PublicPost>> post() {
    return FirebaseFirestore.instance
        .collection("Public")
        .snapshots()
        .map(publicPost);
  }

  Future createPostPublic(String post, String date, String name, String url,
      List<String> postURL) async {
    print("TEST POST URL: $postURL");
    return await FirebaseFirestore.instance.collection("Public").add({
      "uid": firebaseUser.uid,
      "post": post,
      "date": date,
      "name": name,
      "postURL": postURL ?? null,
      "url": url,
    });
  }

  List<Comments> publicComments(QuerySnapshot snapshot) {
    if (snapshot != null) {
      return snapshot.docs
          .map((e) {
            return Comments(
              name: e.data()["name"],
              comment: e.data()["comment"],
              dateTime: e.data()["date"],
              uid: e.id,
            );
          })
          .toList()
          .reversed
          .toList();
    } else {
      return null;
    }
  }

  Stream<List<Comments>> comments(String pUID) {
    return FirebaseFirestore.instance
        .collection("Public")
        .doc(pUID)
        .collection("comments")
        .snapshots()
        .map(publicComments);
  }

  Future createCommentPublic(
      String comment, String name, String date, String pUID) async {
    return await FirebaseFirestore.instance
        .collection("Public")
        .doc(pUID)
        .collection("comments")
        .add({
      "name": name,
      "date": date,
      "comment": comment,
    });
  }
}
