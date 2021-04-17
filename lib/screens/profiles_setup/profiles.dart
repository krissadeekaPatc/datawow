import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo/controller/textcontroller.dart';
import 'package:todo/model/users_models.dart';
import 'package:todo/services/users_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ProfilesSetting extends StatefulWidget {
  @override
  _ProfilesSettingState createState() => _ProfilesSettingState();
}

class _ProfilesSettingState extends State<ProfilesSetting> {
  var firebaseUser = FirebaseAuth.instance.currentUser;

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController cfPass = TextEditingController();
  bool isLoading = true;
  TextController con = TextController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  final picker = ImagePicker();

  Future _takeImage(bool isCamera, id) async {
    // Get image from gallery.
    var pickedFile = await picker.getImage(
        source: !isCamera ? ImageSource.gallery : ImageSource.camera);
    final File imageFile = File(pickedFile.path);
    _uploadImageToFirebase(imageFile, id);
  }

  Future<void> _uploadImageToFirebase(File imageFile, id) async {
    try {
      // Make random image name.
      int randomNumber = Random().nextInt(100000);
      String imageLocation = 'Users/${firebaseUser.uid}/image$randomNumber.jpg';

      // Upload image to firebase.
      dynamic url = await (await firebase_storage.FirebaseStorage.instance
              .ref(imageLocation)
              .putFile(imageFile))
          .ref
          .getDownloadURL();
      UserServices().updateUrl(url, id);
      setState(() {});
    } on FirebaseException catch (e) {
      print(e.code);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.code),
            );
          });
    } catch (e) {
      print(e.message);
    }
  }

  Widget buildTFF(String hint, String label, TextEditingController controller,
      String error, bool obs) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        left: 30,
        right: 30,
        bottom: 10,
      ),
      child: TextFormField(
        onSaved: (newValue) {
          setState(() {
            controller.text = newValue;
            print(controller.text);
          });
        },
        obscureText: obs,
        controller: controller,
        textAlign: TextAlign.center,
        style: GoogleFonts.itim(fontSize: 20, color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.itim(fontSize: 20, color: Colors.grey),
          labelText: label,
          labelStyle: GoogleFonts.itim(fontSize: 20, color: Colors.grey),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: StreamBuilder<List<Users>>(
          stream: UserServices().usersList(firebaseUser.uid),
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Scaffold(
                    // backgroundColor: Colors.transparent, //Color(0xFF8185E2),
                    backgroundColor: Color(0xff355C7D),
                    resizeToAvoidBottomInset: true,
                    appBar: AppBar(
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        title: Text("Profiles Setting")),
                    body: Container(
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                            ),
                          ),
                          SingleChildScrollView(
                            child: Container(
                              height: MediaQuery.of(context).size.height,
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showCupertinoModalPopup(
                                              context: context,
                                              builder: (context) {
                                                return CupertinoActionSheet(
                                                  title:
                                                      Text("เลือกวิธีเลือกรูป"),
                                                  actions: [
                                                    CupertinoActionSheetAction(
                                                      onPressed: () async {
                                                        await _takeImage(
                                                          true,
                                                          snapshot.data[0].id,
                                                        );
                                                        Navigator.of(context)
                                                            .pop('cancel');
                                                        setState(() {});
                                                      },
                                                      child: Text("กล้อง"),
                                                    ),
                                                    CupertinoActionSheetAction(
                                                      onPressed: () async {
                                                        await _takeImage(
                                                          false,
                                                          snapshot.data[0].id,
                                                        );
                                                        Navigator.of(context)
                                                            .pop('cancel');
                                                        setState(() {});
                                                      },
                                                      child: Text("อัลบั้ม"),
                                                    ),
                                                  ],
                                                  cancelButton:
                                                      CupertinoActionSheetAction(
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop('cancel');
                                                    },
                                                  ),
                                                );
                                              });
                                        },
                                        child: CircleAvatar(
                                            radius: 60,
                                            backgroundImage: snapshot
                                                        .data[0].imageURL !=
                                                    null
                                                ? NetworkImage(
                                                    snapshot.data[0].imageURL)
                                                : AssetImage(
                                                    "assets/image/avatar.jpeg")),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        snapshot.data[0].name ?? "null",
                                        style: GoogleFonts.itim(
                                            color: Colors.white),
                                      ),
                                      Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: 10,
                                              ),
                                              buildTFF(
                                                  snapshot.data[0].name ??
                                                      "NULL",
                                                  "Name",
                                                  name,
                                                  "",
                                                  false),
                                              // buildTFF(
                                              //     snapshot.data[0].email ??
                                              //         "NULL",
                                              //     "Email",
                                              //     email,
                                              //     "",
                                              //     false),
                                              // buildTFF("Password", "Password",
                                              //     password, "", true),
                                              // buildTFF(
                                              //     "New password",
                                              //     "New password",
                                              //     newPass,
                                              //     "",
                                              //     true),
                                              // buildTFF(
                                              //     "Confirm new password",
                                              //     "Confirm  password",
                                              //     cfPass,
                                              //     "",
                                              //     true),
                                              RaisedButton(
                                                child: Text("ตกลง"),
                                                onPressed: () {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    _formKey.currentState
                                                        .save();
                                                    UserServices().updateValue(
                                                      firebaseUser.uid,
                                                      name.text,
                                                      snapshot.data[0].id,
                                                    );
                                                  } else {}
                                                },
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
          }),
    );
  }
}
