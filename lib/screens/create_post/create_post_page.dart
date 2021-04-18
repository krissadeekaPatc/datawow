import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:todo/model/users_models.dart';
import 'package:todo/services/db.dart';
import 'package:todo/services/users_services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image/image.dart' as IM;
import 'package:path/path.dart' as path;

class PublicPostPage extends StatefulWidget {
  final String name, url;

  const PublicPostPage({Key key, this.name, this.url}) : super(key: key);
  @override
  _PublicPostPageState createState() => _PublicPostPageState();
}

class _PublicPostPageState extends State<PublicPostPage> {
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  var firebaseUser = FirebaseAuth.instance.currentUser;
  TextEditingController controllerText = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  TextEditingController urlcon = TextEditingController();
  bool isPosting = false;
  List<File> listImage = [];
  final picker = ImagePicker();
  File _file;
  String postUrl;
  List<String> listUrl = [];
  List<Asset> images = <Asset>[];
  List<File> _images = List<File>();
  String _error = "No error Detected";

  void posting() async {
    _uploadImageToFirebase().then((value) async {
      await DatabaseService()
          .createPostPublic(
        controllerText.text,
        DateTime.now().toString(),
        widget.name,
        widget.url,
        listUrl,
      )
          .then((value) {
        Navigator.pop(context);
      });
    });
  }

  @override
  void initState() {
    print(controllerText.text.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Users>>(
        stream: UserServices().usersList(firebaseUser.uid),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Scaffold(
                  resizeToAvoidBottomInset: true,
                  appBar: AppBar(
                    backgroundColor: Color(0xff355C7D),
                    toolbarHeight: 120,
                    title: Text(snapshot.data[0].name),
                  ),
                  body: SafeArea(
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  controllerText.text = value;
                                  controllerText.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: controllerText.text.length));
                                });
                              },
                              // onSaved: (newValue) {
                              //   controllerText.text = newValue;
                              // },
                              // validator: (value) {
                              //   if (value.isEmpty)
                              //     return "ถ้าไม่เขียนอะไรก็โพสไม่ได้น้าาาาา";
                              //   else
                              //     return null;
                              // },
                              controller: controllerText,
                              minLines: 5,
                              maxLines: 99,
                              maxLength: 200,
                              style: GoogleFonts.itim(
                                fontSize: 25,
                              ),
                              decoration: InputDecoration(
                                hintText: "Says something.",
                                hintStyle: GoogleFonts.itim(fontSize: 25),
                              ),
                            ),
                            Container(
                                // margin: EdgeInsets.only(top: 20),
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                child: GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  crossAxisCount: 2,
                                  shrinkWrap: true,
                                  children:
                                      List.generate(images.length, (index) {
                                    Asset asset = images[index];
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(22),
                                      ),
                                      child: Card(
                                        elevation: 20,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(22)),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          child: AssetThumb(
                                            asset: asset,
                                            width: 500,
                                            height: 500,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                )),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                (images.isEmpty &&
                                        controllerText.text.length < 1)
                                    ? SizedBox()
                                    : Container(
                                        width: 200,
                                        height: 60,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(22.0),
                                              side: BorderSide(
                                                  color: Colors.blue)),
                                          onPressed: posting,
                                          color: Color(0xff355C7D),
                                          textColor: Colors.white,
                                          child: Text("  Post  ".toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14,
                                              )),
                                        ),
                                      ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  floatingActionButton: FloatingActionButton(
                    // onPressed: posting,
                    backgroundColor: Color(0xff355C7D),
                    child: Icon(
                      Icons.image,
                    ),
                    onPressed: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) {
                            return CupertinoActionSheet(
                              title: Text("เลือกวิธีเลือกรูป"),
                              actions: [
                                // CupertinoActionSheetAction(
                                //   onPressed: () async {
                                //     if (_images.length > 0) {
                                //       _images.clear();
                                //     }
                                //     Navigator.of(context).pop('cancel');

                                //     await loadAssets();
                                //     setState(() {});
                                //   },
                                //   child: Text("กล้อง"),
                                // ),
                                CupertinoActionSheetAction(
                                  onPressed: () async {
                                    if (_images.length > 0) {
                                      _images.clear();
                                    }

                                    Navigator.of(context).pop('cancel');

                                    await loadAssets();
                                    setState(() {});
                                  },
                                  child: Text("อัลบั้ม"),
                                ),
                              ],
                              cancelButton: CupertinoActionSheetAction(
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop('cancel');
                                },
                              ),
                            );
                          });
                    },
                  ),
                );
        });
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    String error = 'No Error Detected';
    List<File> list = [];
    try {
      setState(() {
        isPosting = true;
      });
      resultList = await MultiImagePicker.pickImages(
        maxImages: 4,
        enableCamera: false,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
        ),
        materialOptions: MaterialOptions(
          useDetailsView: true,
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }
    if (!mounted) return;
    setState(() {});
    images = resultList;
    _error = error;

    for (int i = 0; i < images.length; i++) {
      final temp = await Directory.systemTemp.createTemp();

      final data = await images[i].getByteData();
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      // list.add(await File('${temp.path}/img$i').writeAsBytes(bytes));
      File imageFile = await File('${temp.path}/img$i').writeAsBytes(bytes);
      IM.Image image = IM.decodeImage(imageFile.readAsBytesSync());
      IM.Image smallerImage = IM.copyResize(
        image,
        width: 500,
      );

      _images.add(await File('${temp.path}/img$i')
          .writeAsBytes(IM.encodeJpg(smallerImage)));
    }

    // setState(() {
    //   isPosting = false;
    //   _images.addAll(list);
    //   print("IMAGE[0] : ${_images[0]}");
    //   print("IMAGE[1] : ${_images[1]}");
    //   print("IMAGE[2] : ${_images[2]}");
    //   print("IMAGE[3] : ${_images[3]}");
    // });
  }

  Future<void> _uploadImageToFirebase() async {
    try {
      for (int i = 0; i < _images.length; i++) {
        int randomNumber = Random().nextInt(100000);
        String imageLocation =
            'Post/Public/${firebaseUser.uid}/image$randomNumber.jpg';
        postUrl = await (await firebase_storage.FirebaseStorage.instance
                .ref(imageLocation)
                .putFile(_images[i]))
            .ref
            .getDownloadURL();
        print("INDEX $i :: $postUrl ");
        listUrl.add(postUrl);
      }
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
}
