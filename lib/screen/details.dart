import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:triplan/model/post.dart';

import 'map.dart';

class DetailsPage extends StatefulWidget {
  final int id;

  DetailsPage(this.id);

  @override
  State createState() {
    return new DetailsPageState(id);
  }
}

class DetailsPageState extends State<DetailsPage> {
  final int id;
  final List<PostDetailsContentItem> visitedPlace = [];

  DetailsPageState(this.id);

  Post _post;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        elevation: 0.0,
        leading: new InkWell(
          child: new Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onTap: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection('postJson').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text('Loading...');
          DocumentSnapshot ds = snapshot.data.documents[0];
          _post = PostList(ds.data['content']).post[id];
          return new ListView.builder(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: _post.details.day + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0)
                  return new Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: new Text(
                      _post.details.shortDesc,
                      style: new TextStyle(fontStyle: FontStyle.italic),
                    ),
                  );
                return new StickyHeader(
                  header: new Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: makeRow(index - 1, _post.details.day),
                  ),
                  content: new Column(
                    children: makePostContent(
                        context, _post.details.content[index - 1]),
                  ),
                );
              });
        },
      ),
    );
  }

  List<Widget> makePostContent(
      BuildContext context, PostDetailsContent postContent) {
    List<Widget> widgetArry = [];
    for (int i = 0; i < postContent.postitem.length; i++) {
      widgetArry.add(makePost(context, postContent.postitem[i]));
    }
    return widgetArry;
  }

  Widget makePost(
      BuildContext context, PostDetailsContentItem postDetailsContentItem) {
    switch (postDetailsContentItem.type) {
      case 0:
        return new Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: new Text(
            postDetailsContentItem.p,
            style: new TextStyle(fontFamily: 'PTSerif', fontSize: 16.0),
          ),
        );
      case 1:
        return new Card(
          elevation: 10.0,
          color: Colors.blue,
          margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: new InkWell(
            onTap: () => showBottomSheet(context),
            child: new ListTile(
              leading: new Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              title: new Text(postDetailsContentItem.p,
                  style: new TextStyle(color: Colors.white)),
              subtitle: new Text(
                postDetailsContentItem.desc,
                style: new TextStyle(color: Colors.white),
              ),
            ),
          ),
        );
      case 2:
        return new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Image.network(postDetailsContentItem.img),
            new Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: new Text(
                postDetailsContentItem.p,
                style: new TextStyle(color: Colors.grey, fontSize: 12.0),
              ),
            )
          ],
        );
    }
  }

  showBottomSheet(context) {
    if (visitedPlace.length == 0) {
      for (int i = 0; i < _post.details.content.length; i++) {
        for (int j = 0; j < _post.details.content[i].postitem.length; j++) {
          PostDetailsContentItem item = _post.details.content[i].postitem[j];
          if (item.type == 1) {
            visitedPlace.add(item);
          }
        }
      }
    }
    List<Widget> wid = [];
    wid.add(new Text("PLACES VISITED (${_post.details.place})"));
    for (int i = 0; i < visitedPlace.length; i++) {
      wid.add(new Card(
          elevation: 4.0,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          color: Colors.white,
          child: new InkWell(
              onTap: () => Navigator.of(context).push(CupertinoPageRoute<void>(
                    builder: (BuildContext context) => MapPage(visitedPlace),
                  )),
              child: new ListTile(
                leading: new Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                title: new Text(visitedPlace[i].p),
                subtitle: new Text(visitedPlace[i].desc),
              ))));
    }
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            color: const Color(0xFFF7F8FA),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            child: new ListView(
              children: wid,
            ),
          );
        });
  }
}

Widget makeRow(int index, int totalDays) {
  List<Widget> widgetArry = [];
  for (int i = 0; i < totalDays; i++) {
    widgetArry.add(makeButton(i, i == index));
  }
  return new Row(children: widgetArry);
}

Widget makeButton(int index, bool highlight) {
  return new Expanded(
      child: new RaisedButton(
    onPressed: () {},
    color: highlight ? const Color(0xFFFE4365) : const Color(0xFFEFF0F3),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100.0),
            topRight: Radius.circular(100.0),
            bottomRight: Radius.circular(25.0))),
    child: new Text(
      "DAY ${index + 1}",
      style: new TextStyle(
          color: highlight ? Colors.white : const Color(0xFFD1D5DD)),
    ),
  ));
}
