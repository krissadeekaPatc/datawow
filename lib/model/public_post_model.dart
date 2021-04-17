class PublicPost {
  final String post;
  final String dateTime;
  final List<String> comment;
  final String uid;
  final String id;
  final String name, url;
  final List<dynamic> postUrls;
  PublicPost({
    this.postUrls,
    this.id,
    this.name,
    this.url,
    this.uid,
    this.post,
    this.dateTime,
    this.comment,
  });
}
