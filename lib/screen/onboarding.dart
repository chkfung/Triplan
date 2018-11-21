import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:triplan/screen/home.dart';
import 'package:triplan/value/string.dart';

String src =
    "https://www.setaswall.com/wp-content/uploads/2018/04/Razer-Phone-Stock-Wallpaper-02-1704x2560-380x571.jpg";

class OnBoardingPage extends StatefulWidget {
  @override
  State createState() {
    return new OnBoardingPageState();
  }
}

class OnBoardingPageState extends State<OnBoardingPage> {
  final _controller = new PageController();

  static const _kDuration = const Duration(milliseconds: 300);

  static const _kCurve = Curves.ease;

  final _kArrowColor = Colors.black.withOpacity(0.8);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.black,
        body: new Stack(
          children: <Widget>[
            new Container(
              child: new PageView.builder(
                controller: _controller,
                itemCount: 5,
                physics: new ClampingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return _OnBoardingViewPager(index);
                },
              ),
            ),
            new Container(
                margin: new EdgeInsets.all(20.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.all(20.0),
                      child: new DotsIndicator(
                        controller: _controller,
                        itemCount: 5,
                        onPageSelected: (int page) {
                          _controller.animateToPage(page,
                              duration: _kDuration, curve: _kCurve);
                        },
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(bottom: 30.0, top: 80.0),
                      child: new Row(children: <Widget>[
                        Expanded(
                          child: new Text(
                            "SIGN UP",
                            style: new TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: new InkWell(
                              onTap: () {
                                {
                                  Navigator.of(context)
                                      .push(CupertinoPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        HomePage(),
                                  ));
                                }
                              },
                              child: new Center(
                                child: new Text(
                                  "LOG IN",
                                  style: new TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                        ),
                      ]),
                    )
                  ],
                ))
          ],
        ));
  }
}

class _OnBoardingViewPager extends StatelessWidget {
  int index;

  _OnBoardingViewPager(this.index);

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      new Image.asset(
        getImageAssets(),
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      ),
      new Container(
        foregroundDecoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.center,
            end: Alignment
                .bottomCenter, // 10% of the width, so there are ten blinds.
            colors: [Colors.transparent, Colors.black], // whitish to gray
            // repeats the gradient over the canvas
          ),
        ),
      ),
      new Container(
          margin: new EdgeInsets.only(
              left: 24.0, right: 24.0, top: 200.0, bottom: 20.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text(
                getTitle(),
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              new Padding(
                  padding: new EdgeInsets.only(top: 20.0),
                  child: new Center(
                    child: new Text(
                      getDesc(),
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),
            ],
          ))
    ]);
  }

  String getImageAssets() {
    switch (index) {
      case 0:
        return "assets/images/BG_0.jpg";
      case 1:
        return "assets/images/BG_1.jpg";
      case 2:
        return "assets/images/BG_2.jpg";
      case 3:
        return "assets/images/BG_3.jpg";
      case 4:
        return "assets/images/BG_4.jpg";
    }
  }

  String getTitle() {
    switch (index) {
      case 0:
        return onboarding_vp_title1;
      case 1:
        return onboarding_vp_title2;
      case 2:
        return onboarding_vp_title3;
      case 3:
        return onboarding_vp_title4;
      case 4:
        return onboarding_vp_title5;
    }
  }

  String getDesc() {
    switch (index) {
      case 0:
        return onboarding_vp_desc1;
      case 1:
        return onboarding_vp_desc2;
      case 2:
        return onboarding_vp_desc3;
      case 3:
        return onboarding_vp_desc4;
      case 4:
        return onboarding_vp_desc5;
    }
  }
}

/// An indicator showing the currently selected page of a PageController
class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 8.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}
