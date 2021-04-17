class Users {
  String uid;
  String email;
  String password;
  String dateOfReg;
  String imageURL;
  String name;
  String did;
  String id;
  String color;
  Users({
    this.did,
    this.name,
    this.imageURL,
    this.uid,
    this.email,
    this.password,
    this.dateOfReg,
    this.id,
    this.color,
  });

  Users.fromMap(Map<String, dynamic> map) {
    name = map["displayName"];
    email = map["email"];
    imageURL = map["urlimage"];
    dateOfReg = map["date of register"];
    password = map["password"];
  }
}
