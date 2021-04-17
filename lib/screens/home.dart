import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/model/public_post_model.dart';
import 'package:todo/model/users_models.dart';
import 'package:todo/screens/create_post/create_post_page.dart';
import 'package:todo/screens/writenewtodo.dart';
import 'package:todo/services/db.dart';
import 'package:todo/services/users_services.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Users>>(
        stream: UserServices().usersList(firebaseUser.uid),
        builder: (context, userSnapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              title: Text(
                "Social",
                style: GoogleFonts.itim(fontSize: 30),
              ),
              toolbarHeight: 100,
            ),
            drawer: Drawer(
                elevation: 20,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          DrawerHeader(
                            decoration: BoxDecoration(
                              color: Color(0xff4F9698),
                            ),
                            child: Center(
                              child: Text(
                                "Set name in setting",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.kanit(
                                  color: Colors.white,
                                  fontSize: 32,
                                ),
                              ),
                            ),
                          ),
                          ListTile(
                            onTap: () async {
                              Navigator.pop(context);
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WriteNewList(
                                      colors: userSnapshot.data[0].color,
                                    ),
                                  ));
                            },
                            title: Row(children: [
                              Icon(Icons.edit),
                              SizedBox(
                                width: 20,
                              ),
                              Text("Write a new ToDo List")
                            ]),
                          ),
                          ListTile(
                            onTap: () async {
                              Navigator.pop(context);
                              await Navigator.pushNamed(context, "/profiles");
                            },
                            title: Row(children: [
                              Icon(Icons.settings),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Setting",
                                style: GoogleFonts.itim(fontSize: 20),
                              )
                            ]),
                          ),
                        ],
                      ),
                    ),
                    SafeArea(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        height: 60,
                        child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)),
                            color: Color(0xffFF708B),
                            child: Text(
                              "Log out",
                              style: GoogleFonts.kanit(
                                  fontSize: 28, color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                firebaseAuth.signOut().then((value) {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, "/login", (route) => false);
                                });
                              });
                            }),
                      ),
                    )
                  ],
                )),
            backgroundColor: Color(0xff355C7D),
            body: StreamBuilder<List<Users>>(
                stream: UserServices().usersList(firebaseUser.uid),
                builder: (context, userBodySnapshot) {
                  return !userBodySnapshot.hasData
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    PublicPostPage(
                                                      name: userBodySnapshot
                                                          .data[0].name,
                                                      url: userBodySnapshot
                                                          .data[0].imageURL,
                                                    ),
                                                fullscreenDialog: true));
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              "${userBodySnapshot.data[0].name}",
                                              style: GoogleFonts.kanit(
                                                  color: Colors.black),
                                            ),
                                            Icon(CupertinoIcons.pencil,
                                                color: Colors.black)
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Color.fromARGB(
                                              180, 150, 208, 255),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage: userBodySnapshot
                                                  .data[0].imageURL !=
                                              null
                                          ? NetworkImage(
                                              userBodySnapshot.data[0].imageURL,
                                            )
                                          : AssetImage(
                                              "assets/image/avatar.jpeg"),
                                    ),
                                    // ClipRRect(
                                    //   borderRadius: BorderRadius.circular(100),
                                    //   child:
                                    //       userBodySnapshot.data[0].imageURL !=
                                    //               null
                                    //           ? FadeInImage.assetNetwork(
                                    //               placeholder:
                                    //                   "assets/image/loadings.gif",
                                    //               fit: BoxFit.cover,
                                    //               image: userBodySnapshot
                                    //                   .data[0].imageURL,
                                    //             )
                                    //           : Image(
                                    //               image: AssetImage(
                                    //                   "assets/image/avatar.jpeg"),
                                    //             ),
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                            StreamBuilder<List<PublicPost>>(
                                stream: DatabaseService().post(),
                                builder: (context, snapshot) {
                                  return !snapshot.hasData
                                      ? Expanded(
                                          flex: 6,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              backgroundColor: Colors.white,
                                            ),
                                          ),
                                        )
                                      : snapshot.data.length == 0
                                          ? Expanded(
                                              flex: 6,
                                              child: Center(
                                                child: Text(
                                                  "Do not have any post !\nMake it !",
                                                  style: GoogleFonts.itim(
                                                    color: Colors.white,
                                                    fontSize: 25,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            )
                                          : Expanded(
                                              flex: 6,
                                              child: CarouselSlider.builder(
                                                options: CarouselOptions(
                                                  initialPage: 0,
                                                  viewportFraction: 0.9,
                                                  height: 100,
                                                  pageSnapping: true,
                                                  disableCenter: true,
                                                  enableInfiniteScroll: true,
                                                ),
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    child: Card(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                      ),
                                                      color: Colors.white,
                                                      child: StreamBuilder<
                                                              List<Users>>(
                                                          stream: UserServices()
                                                              .usersList(
                                                                  snapshot
                                                                      .data[
                                                                          index]
                                                                      .uid),
                                                          builder:
                                                              (context, users) {
                                                            return !users
                                                                    .hasData
                                                                ? CircularProgressIndicator()
                                                                : Column(
                                                                    children: [
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Center(
                                                                            child:
                                                                                //     Container(
                                                                                //   width: 80,
                                                                                //   height: 80,
                                                                                //   decoration: BoxDecoration(
                                                                                //     shape: BoxShape.circle,
                                                                                //   ),
                                                                                //   child: ClipRRect(
                                                                                //     borderRadius: BorderRadius.circular(100),
                                                                                //     child: users.data[0].imageURL != null
                                                                                //         ? FadeInImage.assetNetwork(
                                                                                //             placeholder: "assets/image/loadings.gif",
                                                                                //             fit: BoxFit.cover,
                                                                                //             image: userBodySnapshot.data[0].imageURL,
                                                                                //           )
                                                                                //         : Image(
                                                                                //             image: AssetImage("assets/image/avatar.jpeg"),
                                                                                //           ),
                                                                                //   ),
                                                                                // ),

                                                                                CircleAvatar(
                                                                              radius: 30,
                                                                              backgroundImage: users.data[0].imageURL != null
                                                                                  ? NetworkImage(
                                                                                      users.data[0].imageURL,
                                                                                    )
                                                                                  : AssetImage("assets/image/avatar.jpeg"),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Center(
                                                                            child:
                                                                                Text(
                                                                              users.data[0].name,
                                                                              style: GoogleFonts.kanit(fontSize: 25),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Text(
                                                                        snapshot
                                                                            .data[index]
                                                                            .post,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        maxLines:
                                                                            5,
                                                                        style: GoogleFonts.itim(
                                                                            fontSize:
                                                                                30),
                                                                      ),
                                                                      snapshot.data[index].postUrls.length >
                                                                              0
                                                                          ? Expanded(
                                                                              child: GridView.count(
                                                                              crossAxisCount: 2,
                                                                              shrinkWrap: false,
                                                                              children: List.generate(snapshot.data[index].postUrls.length < 1 ? 0 : snapshot.data[index].postUrls.length, (indexs) {
                                                                                return Container(
                                                                                  padding: EdgeInsets.all(10),
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(22),
                                                                                  ),
                                                                                  child: ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(22),
                                                                                      child: snapshot.data[index].postUrls.isEmpty
                                                                                          ? SizedBox()
                                                                                          : FadeInImage.assetNetwork(
                                                                                              placeholder: "assets/image/loadings.gif",
                                                                                              fit: BoxFit.cover,
                                                                                              image: snapshot.data[index].postUrls[indexs],
                                                                                            )

                                                                                      // Image(
                                                                                      //     fit: BoxFit.cover,
                                                                                      //     image: Image.network(
                                                                                      //       snapshot.data[index].postUrls[indexs],
                                                                                      //     ).image),
                                                                                      ),
                                                                                );
                                                                              }),
                                                                            ))
                                                                          : SizedBox(
                                                                              child: Text(
                                                                                "There is no image",
                                                                                style: GoogleFonts.kanit(),
                                                                              ),
                                                                            ),
                                                                    ],
                                                                  );
                                                          }),
                                                    ),
                                                  );
                                                },
                                                itemCount: snapshot == null
                                                    ? 0
                                                    : snapshot.data.length,
                                              ),
                                            );
                                }),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        );
                }),
          );
        });
  }
}
