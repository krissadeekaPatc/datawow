import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/model/models.dart';
import 'package:todo/model/users_models.dart';
import 'package:todo/services/db.dart';
import 'package:todo/services/users_services.dart';

class WriteNewList extends StatefulWidget {
  final String colors;

  const WriteNewList({Key key, this.colors}) : super(key: key);
  @override
  _WriteNewListState createState() => _WriteNewListState();
}

class _WriteNewListState extends State<WriteNewList> {
  var firebaseUser = FirebaseAuth.instance.currentUser;
  bool isDone = false;
  CalendarController _calendarController;
  TextEditingController date = TextEditingController();

  DateTime _dateTime;
  // create some values
  Color pickerColor = Color(0xffffffff);
  Color currentColor = Color(0xffffffff);
  Color pickerColor2 = Color(0xff4c1717);
  Color currentColor2 = Color(0xff4c1717);
  final controller = SlidableController();
// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void changeColor2(Color color) {
    setState(() => pickerColor2 = color);
  }

  void _showSnackBar(String text, BuildContext context) {
    // Scaffold.of(context).showSnackBar(SnackBar(
    //   content: Text(
    //     text,
    //     style: GoogleFonts.itim(fontSize: 20),
    //     textAlign: TextAlign.center,
    //   ),
    //   backgroundColor: Colors.red,
    // ));
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      title: text,
      duration: Duration(seconds: 2),
      message: "Todo list have been deleted !",
      backgroundColor: Colors.red,
    )..show(context);
  }

  @override
  void initState() {
    _calendarController = CalendarController();

    setState(() {
      date.text = DateTime.now().day.toString() +
          " - " +
          DateTime.now().month.toString() +
          " - " +
          DateTime.now().year.toString();
      _dateTime = DateTime.now();
    });
    setState(() {
      pickerColor2 = Color(int.parse(widget.colors));
    });
    super.initState();
  }

  @override
  void dispose() {
    _calendarController.dispose();

    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  TextEditingController head = TextEditingController();
  TextEditingController goal = TextEditingController();

  Widget build(BuildContext context) {
    return StreamBuilder<List<Users>>(
        stream: UserServices().usersList(firebaseUser.uid),
        builder: (context, s) {
          return GestureDetector(
            onTap: () {
              setState(() {
                FocusScope.of(context).unfocus();
              });
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                child: Column(
                  children: [
                    Expanded(
                      child: StreamBuilder<List<Todo>>(
                          stream: DatabaseService().listTodos(date.text),
                          builder: (context, snapshot) {
                            return !snapshot.hasData
                                ? Center(child: CircularProgressIndicator())
                                : Container(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 30,
                                        ),
                                        TableCalendar(
                                          calendarController:
                                              _calendarController,
                                          startingDayOfWeek:
                                              StartingDayOfWeek.monday,
                                          calendarStyle: CalendarStyle(
                                            selectedColor: Color(0xff4c1717),
                                            todayColor: Color(0xffab9090),
                                            weekdayStyle: TextStyle(
                                              fontWeight: FontWeight.normal,
                                            ),
                                            weekendStyle: TextStyle(
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                          onDaySelected:
                                              (day, events, holidays) {
                                            setState(() {
                                              setState(() {
                                                FocusScope.of(context)
                                                    .unfocus();
                                              });
                                              _dateTime = day;
                                              date.text = day.day.toString() +
                                                  " - " +
                                                  day.month.toString() +
                                                  " - " +
                                                  day.year.toString();
                                            });
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(50),
                                              topRight: Radius.circular(50),
                                            ),
                                            child: GestureDetector(
                                              child: Container(
                                                // height: MediaQuery.of(context).size.height * 0.44,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: pickerColor2,
                                                child: Stack(
                                                  children: [
                                                    Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Expanded(
                                                          child: SingleChildScrollView(
                                                              child: buildForm(
                                                                  context)),
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  top: 0,
                                                                  left: 30),
                                                          child: Text(
                                                            date.text ==
                                                                    DateTime
                                                                                .now()
                                                                            .day
                                                                            .toString() +
                                                                        " - " +
                                                                        DateTime.now()
                                                                            .month
                                                                            .toString() +
                                                                        " - " +
                                                                        DateTime.now()
                                                                            .year
                                                                            .toString()
                                                                ? "Today"
                                                                : _dateTime ==
                                                                        DateTime
                                                                            .now()
                                                                    ? "Today"
                                                                    : DateFormat("EEEE")
                                                                            .format(_dateTime)
                                                                            .toString() +
                                                                        ", " +
                                                                        date.text,
                                                            style: GoogleFonts
                                                                .itim(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 30,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Expanded(
                                                          flex: 4,
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: ListView
                                                                    .builder(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .zero,
                                                                  itemCount: snapshot.data.length ==
                                                                              null ||
                                                                          snapshot.data.length ==
                                                                              0
                                                                      ? 1
                                                                      : snapshot
                                                                          .data
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return snapshot.data.length ==
                                                                                null ||
                                                                            snapshot.data.length ==
                                                                                0
                                                                        ? Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(top: 50.0),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    "There is not things TODO!",
                                                                                    style: GoogleFonts.itim(fontSize: 25, color: Colors.yellow),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          )
                                                                        : InkWell(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                snapshot.data[index].isComplete
                                                                                    ? DatabaseService().deCompletTask(
                                                                                        snapshot.data[index].uid,
                                                                                        date.text,
                                                                                      )
                                                                                    : DatabaseService().completTask(
                                                                                        snapshot.data[index].uid,
                                                                                        date.text,
                                                                                      );
                                                                              });
                                                                            },
                                                                            child:
                                                                                buildContainer(
                                                                              snapshot.data[index].title,
                                                                              snapshot.data[index].isComplete,
                                                                              snapshot,
                                                                              index,
                                                                              snapshot.data[index].color,
                                                                            ),
                                                                          );
                                                                  },
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                          }),
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton(
                child: Icon(
                  Icons.color_lens_outlined,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'เลือกสีฮับ!',
                          style: GoogleFonts.itim(),
                        ),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: pickerColor2,
                            onColorChanged: changeColor2,
                            showLabel: true,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text('Got it'),
                            onPressed: () {
                              setState(() {
                                currentColor2 = pickerColor2;
                                setState(() {
                                  UserServices().updateColor(
                                      pickerColor2.toString().substring(6, 16),
                                      s.data[0].id);
                                });
                              });

                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                          ),
                        ],
                      );
                    },
                  );

                  // Navigator.pop(context);
                },
              ),
            ),
          );
        });
  }

  Form buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            onFieldSubmitted: (value) {
              if (_formKey.currentState.validate()) {
                DatabaseService().createNewTodo(
                  value,
                  date.text,
                  date.text,
                  pickerColor.toString().substring(6, 16),
                );
              }
            },
            validator: (value) {
              if (value.isEmpty) {
                return "ใส่ก่อนเด้ !!";
              } else {
                return null;
              }
            },
            style: GoogleFonts.itim(color: Colors.white, fontSize: 30),
            controller: head,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                padding: EdgeInsets.only(right: 30, top: 25),
                icon: Icon(Icons.color_lens),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'เลือกสีฮับ!',
                          style: GoogleFonts.itim(),
                        ),
                        content: SingleChildScrollView(
                          child: ColorPicker(
                            pickerColor: pickerColor,
                            onColorChanged: changeColor,
                            showLabel: true,
                            pickerAreaHeightPercent: 0.8,
                          ),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: const Text('Got it'),
                            onPressed: () {
                              setState(() {
                                currentColor = pickerColor;
                                print(pickerColor.toString().substring(6, 16));
                                // DatabaseService()
                                //     .createNewTodoColor(
                                //         date.text,
                                //         pickerColor
                                //             .toString()
                                //             .substring(6, 16));
                              });

                              // Navigator.of(context).pop();
                              Navigator.of(context, rootNavigator: true)
                                  .pop('dialog');
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              errorStyle: GoogleFonts.itim(fontSize: 25),
              isDense: false,
              contentPadding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.05),
              labelText: "TODO!",
              labelStyle: GoogleFonts.itim(color: Colors.white),
              hintText: "ตั้งหัวข้อก่อนนะคะ",
              hintStyle: GoogleFonts.itim(color: Colors.white60),
              enabledBorder: UnderlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.green, width: 2.0),
              ),
              focusedBorder: UnderlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.yellow, width: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void displayDialog(AsyncSnapshot<List<Todo>> snapshot) {
    showDialog(
      context: context,
      builder: (BuildContext context) => new CupertinoAlertDialog(
        title: new Text(
          "Delete?",
          style: GoogleFonts.itim(fontSize: 25),
        ),
        content: new Text(
          "อยากลบหยออออออออ เขียนผิดอ่ะดิ้",
          style: GoogleFonts.itim(fontSize: 25, fontWeight: FontWeight.w100),
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text("Close", style: GoogleFonts.itim()),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
            },
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text(
              "Delete !",
              style: GoogleFonts.itim(color: Colors.red),
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');
              DatabaseService()
                  .removeTodo(snapshot.data[0].uid, date.text)
                  .then((value) {
                _showSnackBar("Deleted", context);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildContainer(String title, bool isCom,
      AsyncSnapshot<List<Todo>> snapshot, int index, String color) {
    return Container(
      height: 70,
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black),
        color: Color(int.parse(color)),
      ),
      child: Slidable(
        controller: controller,
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              displayDialog(snapshot);
            },
          ),
        ],
        child: InkWell(
          onTap: () {
            setState(() {
              snapshot.data[index].isComplete
                  ? DatabaseService().deCompletTask(
                      snapshot.data[index].uid,
                      date.text,
                    )
                  : DatabaseService().completTask(
                      snapshot.data[index].uid,
                      date.text,
                    );
            });
          },
          child: Row(
            children: [
              Icon(
                isCom
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.circle,
                color: Color(0xff00cf8d),
                size: 50,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Text(
                  title,
                  style: GoogleFonts.itim(
                    color: Colors.black,
                    fontSize: 25,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
