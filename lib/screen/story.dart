import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:triplan/model/post.dart';

import 'details.dart';

class StoryPage extends StatefulWidget {
  final int id;

  StoryPage(this.id);

  @override
  State createState() {
    return new StoryPageState(id);
  }
}

class StoryPageState extends State<StoryPage> {
  final int id;

  double _initialY;

  StoryPageState(this.id);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance.collection('postJson').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Text('Loading...');
            DocumentSnapshot ds = snapshot.data.documents[0];
            Post _post = PostList(ds.data['content']).post[id];

            return new Stack(
              children: <Widget>[
                new Container(
                  foregroundDecoration:
                      BoxDecoration(color: const Color(0x55000000)),
                  child: FadeInImage.memoryNetwork(
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    placeholder: kTransparentImage,
                    image: _post.fullImage,
                  ),
                ),
                new Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 48.0, horizontal: 20.0),
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new InkWell(
                            onTap: () => Navigator.pop(context),
                            child: new Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        new Padding(
                          padding: EdgeInsets.only(bottom: 16.0, top: 32.0),
                          child: new Text(
                              "${_post.details.day} DAY - ${_post.details.place} PLACE",
                              style: new TextStyle(color: Colors.white)),
                        ),
                        new Padding(
                            padding: EdgeInsets.only(bottom: 32.0, top: 16.0),
                            child: new Text(_post.postTitle,
                                style: new TextStyle(
                                    fontSize: 28.0, color: Colors.white))),
                        new Text(
                          _post.details.memo,
                          style: new TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.white),
                        )
                      ],
                    )),
                new Positioned(
                    bottom: 80.0,
                    left: 20.0,
                    child: new Row(
                      children: <Widget>[
                        new CircleAvatar(
                          backgroundImage: NetworkImage(_post.avatarUrl),
                        ),
                        new Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: new Text(
                            "${_post.name}\n${_post.date}",
                            style: new TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )),
                new Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: new Center(
                      child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      new Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white,
                      ),
                      new Text(
                        "Swipe to see more",
                        style: new TextStyle(color: Colors.white),
                      )
                    ],
                  )),
                ),
                new GestureDetector(
                  onVerticalDragStart: (dragDetails) {
                    _initialY = dragDetails.globalPosition.dy;
                  },
                  onVerticalDragUpdate: (dragDetails) {
                    if (_initialY - dragDetails.globalPosition.dy > 50)
                      Navigator.of(context).push(CupertinoPageRoute<void>(
                        fullscreenDialog: true,
                        builder: (BuildContext context) => DetailsPage(id),
                      ));
                  },
                )
              ],
            );
          }),
    );
  }

  String getImage(int id) {
    switch (id) {
      default:
        return "assets/images/STORY_1.jpg";
    }
  }
}
