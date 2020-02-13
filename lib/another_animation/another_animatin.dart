import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 80), vsync: this);

    animation = IntTween(begin: 100, end: 0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.easeOut));

    
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    

    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return new Scaffold(
            body: new Center(
              child: Container(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Loading...'),
                    Text(animation.value.toString(), style: TextStyle(
                      fontSize: 52.0
                    ),)
                  ],
                )
              )
            )
          );
        });
  }
}