import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:triplan/model/post.dart';
import 'package:triplan/screen/story.dart';

class HomePage extends StatefulWidget {
  @override
  State createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animationFirst;
  Animation<double> animationSecond;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animationFirst = Tween(begin: 0.0, end: 600.0).animate(controller);
    animationSecond = Tween(begin: 0.0, end: 600.0).animate(controller);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          new AnimatedBackground(
              -250.0, -150.0, const Color(0xFF0356A9), animationFirst),
          new AnimatedBackground(MediaQuery.of(context).size.width - 300.0,
              -250.0, const Color(0xFF046FDB), animationSecond),
          new Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: new Column(
              children: <Widget>[
                new Padding(
                  padding: EdgeInsets.only(top: 48.0, bottom: 20.0),
                  child: new Text(
                    "News Feed",
                    style: new TextStyle(color: Colors.white, fontSize: 16.0),
                  ),
                ),
                new Card(
                    child: new ListTile(
                  title: const Text(
                    "Awesome You! Let's Tell the World!",
                    style: const TextStyle(color: Colors.blue, fontSize: 12.0),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  ),
                )),
                new Expanded(
                  child: StreamBuilder(
                    stream:
                        Firestore.instance.collection('postJson').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return const Center(child: CircularProgressIndicator());
                      DocumentSnapshot ds = snapshot.data.documents[0];
                      PostList postList = PostList(ds.data['content']);
                      return new ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: postList.post.length,
                        itemBuilder: (BuildContext context, int index) {
                          return PostCard(postList.post[index], index);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBackground extends AnimatedWidget {
  final _kx;
  final _ky;
  final _color;

  AnimatedBackground(
      this._kx, this._ky, this._color, Animation<double> animation)
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
        child: new Positioned(
      right: _kx > 0 ? -300.0 : null,
      left: _kx < 0 ? _kx : null,
      top: _ky,
      child: new Material(
          type: MaterialType.circle,
          color: _color,
          child: new Container(
            width: animation.value,
            height: animation.value,
          )),
    ));
  }
}

class PostCard extends StatelessWidget {
  final Post _kpost;
  final int index;

  PostCard(this._kpost, this.index);

  @override
  Widget build(BuildContext context) {
    return new InkWell(
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute<void>(
            builder: (BuildContext context) => StoryPage(index),
          ));
        },
        child: new Card(
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                child: new Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: new CircleAvatar(
                        backgroundImage: NetworkImage(_kpost.avatarUrl),
                      ),
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                          children: <Widget>[
                            new Text(
                              _kpost.name,
                              style: new TextStyle(
                                  color: Colors.blueAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                            new Text(" published a trip")
                          ],
                        ),
                        new Text(_kpost.date)
                      ],
                    )
                  ],
                ),
              ),
              FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: _kpost.thumbnails,
              ),
              new Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: new Text(
                  _kpost.postTitle,
                  style: new TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              new Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                child: new Row(
                  children: <Widget>[
                    new Text('${_kpost.postComments} comments - '),
                    new Text('${_kpost.postViews}K views')
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
