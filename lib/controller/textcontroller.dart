import 'package:flutter/material.dart';

class TextController {
  factory TextController() {
    if (_this == null) _this = TextController._();
    return _this;
  }

  // final spinkit = SpinKitFadingCube(
  //   size: 50,
  //   duration: Duration(milliseconds: 1000),
  //   itemBuilder: (BuildContext context, int index) {
  //     return DecoratedBox(
  //       decoration: BoxDecoration(
  //         color: index.isEven
  //             ? Color(0xffF6F6F6).withOpacity(0.9)
  //             : Color(0xffF6F6F6).withOpacity(0.9),
  //       ),
  //     );
  //   },
  // );

  static TextController _this;
  String _verifications = "";
  String _currentUid;
  String _currentToken = "";
  String _status = "";
  String _finalPhone = "";

  List _dataFromApi = [];

  bool _pdpaStatus = false;
  bool _isVisible = false;

  TextController._();

  /// Allow for easy access to 'the Controller' throughout the application.
  static TextController get loginCon => _this;
  String get verifications => _verifications;
  String get status => _status;
  String get finalPhone => _finalPhone;
  String get currentuserUid => _currentUid;
  String get currentuserToken => _currentToken;
  bool get pdpaStatus => _pdpaStatus;
  bool get isVisible => _isVisible;
  List get listData => _dataFromApi;

  void setData(List data) {
    this._dataFromApi = data;
  }

  void setPdpa(bool status) {
    this._pdpaStatus = status;
  }

  void setVisible(bool status) {
    this._isVisible = status;
  }

  void setVeri(String verification) {
    this._verifications = verification;
  }

  void setStatus(String status) {
    this._status = status;
  }

  void setUserData(String uid, String token) {
    this._currentUid = uid;
    this._currentToken = token;
  }

  void setPhoneNumber(String phone) {
    this._finalPhone = phone;
  }

  TextEditingController get initPage => _initPage;

  TextEditingController get userNamecontroller => _userNamecontroller;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get genderController => _genderController;

  TextEditingController get birthdayController => _birthdayController;
  TextEditingController get emailController => _emailController;

  TextEditingController get passController => _passController;
  TextEditingController get d1Status => _d1Status;
  TextEditingController get d2Status => _d2Status;
  TextEditingController get d5Status => _d5Status;
  TextEditingController get d6Status => _d6Status;
  TextEditingController get automation => _automation;

  TextEditingController get uid => _uid;

  TextEditingController get phoneController => _phoneController;
  TextEditingController get phoneFirstTimeController =>
      _phoneFirstTimeController;

  TextEditingController _userNamecontroller = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _genderController = TextEditingController();

  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  TextEditingController _passController = TextEditingController();
  TextEditingController _d1Status = TextEditingController();
  TextEditingController _d2Status = TextEditingController();
  TextEditingController _d5Status = TextEditingController();
  TextEditingController _d6Status = TextEditingController();
  TextEditingController _automation = TextEditingController();

  TextEditingController _uid = TextEditingController();
  TextEditingController _initPage = TextEditingController();

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _phoneFirstTimeController = TextEditingController();
}
