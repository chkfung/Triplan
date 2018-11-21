import 'package:flutter/material.dart';
import 'package:triplan/model/post.dart';

class MapPage extends StatefulWidget {
  final List<PostDetailsContentItem> visitedPlace;

  MapPage(this.visitedPlace);

  @override
  State createState() {
    return new MapPageState(visitedPlace);
  }
}

class MapPageState extends State<MapPage> {
  final List<PostDetailsContentItem> visitedPlace;
  int dayNow = 0;

  MapPageState(this.visitedPlace);

  @override
  Widget build(BuildContext context) {
    List<Widget> buttonDay = [];
    changeDay(int day) {
      setState(() {
        dayNow = day;
      });
    }

    for (int i = 0; i < visitedPlace.length / 2; i++) {
      buttonDay.add(new Padding(
          padding: EdgeInsets.all(10.0),
          child: new RaisedButton(
            onPressed: () => changeDay(i),
            color: Colors.blue,
            child: (i == dayNow)
                ? new Text("Day\n${i + 1}",
                    textAlign: TextAlign.center,
                    style: new TextStyle(color: Colors.white, fontSize: 16.0))
                : new Text(
                    "${i + 1}",
                    textAlign: TextAlign.center,
                    style: new TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(30.0),
            )),
          )));
    }
    return new Scaffold(
      backgroundColor: Colors.black,
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Text(
          "Trip Routes",
          style: new TextStyle(color: Colors.black),
        ),
        leading: new InkWell(
            onTap: () => Navigator.pop(context),
            child: new Icon(
              Icons.close,
              color: Colors.black,
            )),
      ),
      body: new Stack(
        children: <Widget>[
          const Center(
            child: const CircularProgressIndicator(),
          ),
          Image.network(
            constructMap(dayNow),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          new Container(
            alignment: Alignment.bottomRight,
            child: ButtonTheme(
                minWidth: 60.0,
                height: 60.0,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: buttonDay,
                )),
          )
        ],
      ),
    );
  }

  String constructMap(int dayNow) {
    PostDetailsContentItem item1 = visitedPlace[dayNow * 2];
    PostDetailsContentItem item2 = visitedPlace[dayNow * 2 + 1];
    return "https://image.maps.api.here.com/mia/1.6/routing?"
        "app_id=WVj5RDYiIo49cA9SnAxQ&app_code=Igp24GtQ3ifYYZk3ci957g"
        "&waypoint0=geo%21"
        "${item1.lat}"
        ","
        "${item1.lon}"
        "&waypoint1=geo%21"
        "${item2.lat}"
        ","
        "${item2.lon}"
        "&t=7&w=1000&h=2000"
        "&poix0=${item1.lat},${item1.lon};yellow;blue;50;Start"
        "&poix1=${item2.lat},${item2.lon};yellow;blue;50;End";
  }
}
