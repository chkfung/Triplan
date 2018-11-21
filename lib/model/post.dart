import 'dart:convert';

import 'package:intl/intl.dart';

class PostList {
  List<Post> post;
  PostList(String result) {
    var parsedJson = json.decode(result);
    var items = parsedJson['items'] as List;
    post = items.map((i) => Post.fromJson(i)).toList();
  }
}

class Post {
  String name;
  String avatarUrl;
  String date;
  String postTitle;
  String fullImage;
  String thumbnails;
  int postComments;
  int postViews;
  PostDetails details;
  Post(this.name, this.avatarUrl, this.date, this.postTitle, this.thumbnails,
      this.fullImage, this.postComments, this.postViews, this.details);

  factory Post.fromJson(Map<String, dynamic> json) {
    var dd = new DateFormat.yMMMd()
        .format(new DateTime.fromMillisecondsSinceEpoch(json['date'] * 1000));

    return Post(
        json['author'],
        json['avatar'],
        dd,
        json['title'],
        json['thumbnails'],
        json['image'],
        json['commentCount'],
        json['viewCount'],
        PostDetails.fromJson(json['details']));
  }
}

class PostDetails {
  int day;
  int place;
  String shortDesc;
  String memo;
  List<PostDetailsContent> content;

  PostDetails(this.day, this.place, this.shortDesc, this.memo, this.content);

  factory PostDetails.fromJson(Map<String, dynamic> json) {
    var items = json['content'] as List;
    var _content = items.map((f) => PostDetailsContent.fromJson(f)).toList();
    return PostDetails(
        json['day'], json['place'], json['shortDesc'], json['memo'], _content);
  }
}

class PostDetailsContent {
  List<PostDetailsContentItem> postitem;

  PostDetailsContent(this.postitem);

  factory PostDetailsContent.fromJson(Map<String, dynamic> json) {
    var items = json['posting'] as List;
    var _postItem =
        items.map((f) => PostDetailsContentItem.fromJson(f)).toList();
    return PostDetailsContent(_postItem);
  }
}

class PostDetailsContentItem {
  String p;
  String desc;
  String lat;
  String lon;
  String img;
  int type;

  PostDetailsContentItem(
      this.p, this.desc, this.lat, this.lon, this.img, this.type);

  factory PostDetailsContentItem.fromJson(Map<String, dynamic> json) {
    return PostDetailsContentItem(
      json['p'],
      json['desc'],
      json['lat'],
      json['lon'],
      json['img'],
      json['type'],
    );
  }
}
