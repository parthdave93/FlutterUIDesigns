import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CardPaginationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CardPaginationScreenState();
}

class CardPaginationScreenState extends State<CardPaginationScreen> {
  var _firstCardColor = Colors.purple;
  var _secondCardColor = Colors.amberAccent;

  ScrollController _firstWidgetScrollController = new ScrollController();
  ScrollController _secondWidgetScrollController = new ScrollController();

  var touchedScrollIndex = -1;

  var _initialSecondChildPositionFromBottom = 200.0;
  var _secondChildLastBottomPosition = 60.0,
      _secondChildLastGlobalBottomPosition = 0.0,
      _secondChildPositionafterFirstChildExpandLastBottomPosition = 30.0;
  var _topHeaderExpandedHeight = 500.0;
  var _bottomWidgetInitialHeightWhenToolbarExpanded = 0.0;
  var _secondWidgetTopMargin = 0.0;

  Widget secondChild, firstChild;

  listener() {
    touchedScrollIndex = 0;
    var height = MediaQuery.of(context).size.height;
    _topHeaderExpandedHeight = height - 450.0;
    _bottomWidgetInitialHeightWhenToolbarExpanded =
        height - _topHeaderExpandedHeight;
    _secondChildLastBottomPosition =
        _bottomWidgetInitialHeightWhenToolbarExpanded -
            _secondChildLastBottomPosition;
    _secondChildLastGlobalBottomPosition =
        height - _secondChildLastBottomPosition;
    _secondWidgetTopMargin = _bottomWidgetInitialHeightWhenToolbarExpanded +
        _initialSecondChildPositionFromBottom;
    _secondChildLastGlobalBottomPosition = _secondWidgetTopMargin;
    _secondChildPositionafterFirstChildExpandLastBottomPosition =
        height - _secondChildPositionafterFirstChildExpandLastBottomPosition;

    _firstWidgetScrollController.addListener(() {
      var scrollPosition = _firstWidgetScrollController.position;
      if (scrollPosition.atEdge && !isToolbarCollapsed) {
        _secondWidgetTopMargin = _secondChildLastGlobalBottomPosition;
        print("_secondWidgetTopMargin =: $_secondWidgetTopMargin  51");
        pointDownY = 0;
        setState(() {});
      }
    });

    _secondWidgetScrollController.addListener(() {
      var scrollPosition = _secondWidgetScrollController.position;
      if (scrollPosition.atEdge) {
        isSecondChildExpandedAllTheWay = false;
        scrollingPhysics = NeverScrollableScrollPhysics();
        setState(() {});
      }
    });
  }

  var pointDownY = 0.0;
  var previousPointY = 0.0;
  ScrollPhysics scrollingPhysics = NeverScrollableScrollPhysics();
  var isSecondChildExpandedAllTheWay = false;
  var isToolbarCollapsed = false;

  @override
  Widget build(BuildContext context) {
    if (_bottomWidgetInitialHeightWhenToolbarExpanded == 0) listener();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (touchedScrollIndex != 0) return false;
              if (pointDownY == 0) {
                pointDownY = scrollInfo.metrics.pixels;
                previousPointY = pointDownY;
              } else if (previousPointY > scrollInfo.metrics.pixels &&
                  !_firstWidgetScrollController.position.atEdge &&
                  !isToolbarCollapsed) {
                if (_secondWidgetTopMargin >
                    _secondChildLastGlobalBottomPosition) {
                  _secondWidgetTopMargin -= 2;
                  if (_secondWidgetTopMargin <
                      _secondChildLastGlobalBottomPosition) {
                    _secondWidgetTopMargin =
                        _secondChildLastGlobalBottomPosition;
                  }
                  setState(() {});
                }
              } else {
                if (_secondWidgetTopMargin <
                        _secondChildPositionafterFirstChildExpandLastBottomPosition &&
                    !isToolbarCollapsed) {
                  _secondWidgetTopMargin += 2;
                  if (_secondWidgetTopMargin >
                      _secondChildPositionafterFirstChildExpandLastBottomPosition) {
                    _secondWidgetTopMargin =
                        _secondChildPositionafterFirstChildExpandLastBottomPosition;
                  }
                  setState(() {});
                }
              }
              previousPointY = scrollInfo.metrics.pixels;
              return false;
            },
            child: CustomScrollView(
              controller: _firstWidgetScrollController,
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Color.fromARGB(255, 240, 240, 240),
                  expandedHeight: _topHeaderExpandedHeight,
                  pinned: true,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      var height = constraints.biggest.height;
                      if (height <= 110) {
                        isToolbarCollapsed = true;
                      } else {
                        isToolbarCollapsed = false;
                      }
                      return FlexibleSpaceBar(
                        title: Text(
                          'FilledStacks',
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: GestureDetector(
                    onPanDown: (details) {
                      touchedScrollIndex = 0;
                    },
                    // todo: overflow here
                    child: AboutWidget(),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: _secondWidgetTopMargin,
            left: 0,
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: (details) {
                touchedScrollIndex = 1;
                bool isGoingDown = false;
                if (pointDownY == 0) {
                  pointDownY = details.globalPosition.dy;
                  return;
                } else if (previousPointY < details.globalPosition.dy) {
                  isGoingDown = true;
                }

                //if toolbar already been collapsed and scroll is still going up
                if (isSecondChildExpandedAllTheWay && !isGoingDown) return;
                //when toolbar not collapsed and scroll going up
                if (!isGoingDown &&
                    _secondWidgetTopMargin <=
                        _secondChildLastGlobalBottomPosition &&
                    _secondWidgetTopMargin >= 150) {
                  if (_secondWidgetTopMargin < _topHeaderExpandedHeight + 80) {
                    _firstWidgetScrollController.jumpTo(
                        _firstWidgetScrollController.position.pixels -
                            details.delta.dy);
                  }
                  _secondWidgetTopMargin += details.delta.dy;
                  if (_secondWidgetTopMargin < 150) {
                    _secondWidgetTopMargin = 150;
                  } else if (_secondWidgetTopMargin >
                      _secondChildLastGlobalBottomPosition) {
                    _secondWidgetTopMargin =
                        _secondChildLastGlobalBottomPosition;
                  }
                }
                //when toolbar already been collapsed
                if (_secondWidgetTopMargin <= 150 &&
                    scrollingPhysics is NeverScrollableScrollPhysics &&
                    !isGoingDown) {
                  isSecondChildExpandedAllTheWay = true;
                  scrollingPhysics = AlwaysScrollableScrollPhysics();
                }
                //when going down
                else if (_secondWidgetTopMargin >= 150 &&
                    isGoingDown &&
                    _secondWidgetTopMargin <=
                        _secondChildLastGlobalBottomPosition) {
                  _secondWidgetTopMargin += details.delta.dy;
                  if (_firstWidgetScrollController.position.pixels <
                      _topHeaderExpandedHeight)
                    _firstWidgetScrollController.jumpTo(
                        _firstWidgetScrollController.position.pixels -
                            details.delta.dy);
                  if (_secondWidgetTopMargin < 150) {
                    _secondWidgetTopMargin = 150;
                  } else if (_secondWidgetTopMargin >
                      _secondChildLastGlobalBottomPosition) {
                    _secondWidgetTopMargin =
                        _secondChildLastGlobalBottomPosition;
                  }
                }
                previousPointY = details.globalPosition.dy;
                setState(() {});
              },
              onPanEnd: (details) {
                pointDownY = 0;
                //if toolbar not collapsed then expand again
                if (_secondWidgetTopMargin > 150) {
                  _secondWidgetTopMargin = _secondChildLastGlobalBottomPosition;
                  _firstWidgetScrollController.jumpTo(0);
                  setState(() {});
                }
              },
              child:
                  FeedWidget(scrollingPhysics, _secondWidgetScrollController),
            ),
          ),
        ],
      ),
    );
  }
}

const _WIDGET_TOP_PADDING = EdgeInsets.only(top: 40);
const _WIDGET_CARD_CIRCULAR_RADIUS = Radius.circular(80);
const _CARD_INNER_PADDINGS = const EdgeInsets.all(16.0);
const _DUMMY_LIST_ITEM_COUNT = 100;

class AboutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: _WIDGET_TOP_PADDING,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: _WIDGET_CARD_CIRCULAR_RADIUS,
          topRight: _WIDGET_CARD_CIRCULAR_RADIUS,
        ),
        color: Color.fromARGB(255, 216, 220, 255),
      ),
      child: Column(
        children: aboutList(),
      ),
    );
  }
}

class FeedWidget extends StatelessWidget {
  ScrollPhysics _scrollPhysics;
  ScrollController _scrollController;

  FeedWidget(this._scrollPhysics, this._scrollController);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: _scrollPhysics,
      controller: _scrollController,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: _WIDGET_CARD_CIRCULAR_RADIUS,
            topRight: _WIDGET_CARD_CIRCULAR_RADIUS,
          ),
          color: Colors.black,
        ),
        padding: _WIDGET_TOP_PADDING,
        child: Column(
          children: feedList(),
        ),
      ),
    );
  }
}

const dummyImageLink =
    "https://scontent-frx5-1.xx.fbcdn.net/v/t1.0-9/83671486_2645031582229101_3281948020278558720_o.jpg?_nc_cat=111&_nc_ohc=IuTr_yV-_PQAX8d4ilp&_nc_ht=scontent-frx5-1.xx&oh=8de2643cf7330f184cfbd21d9ec2770d&oe=5EC65A5F";

aboutList() {
  List<Widget> listItems = [cardTitle("About")];
  listItems
    ..addAll(
      List<int>.generate(_DUMMY_LIST_ITEM_COUNT, (index) => index)
          .map(
            (index) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  width: 90,
                  height: 90,
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(8.0),
                  decoration:
                      BoxDecoration(color: Color.fromARGB(255, 179, 195, 253)),
                  child: Icon(Icons.airplay),
                ),
                Container(
                  width: 90,
                  height: 90,
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(8.0),
                  decoration:
                      BoxDecoration(color: Color.fromARGB(255, 179, 195, 253)),
                  child: Icon(Icons.airplay),
                ),
                Container(
                  width: 90,
                  height: 90,
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(8.0),
                  decoration:
                      BoxDecoration(color: Color.fromARGB(255, 179, 195, 253)),
                  child: Icon(Icons.airplay),
                )
              ],
            ),
          )
          .toList(),
    );
  return listItems;
}

feedList() {
  List<Widget> listItems = [cardTitle("Feed")];
  listItems
    ..addAll(
      List<int>.generate(_DUMMY_LIST_ITEM_COUNT, (index) => index)
          .map(
            (index) => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: _WIDGET_CARD_CIRCULAR_RADIUS,
                        topRight: _WIDGET_CARD_CIRCULAR_RADIUS),
                    child: Image.network(dummyImageLink),
                  ),
                  Container(
                    padding:
                        EdgeInsets.only(left: 22.0, top: 16.0, bottom: 22.0),
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Image from Parth Dave",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  return listItems;
}

cardTitle(cardTitle) {
  return Container(
    padding: EdgeInsets.only(left: 22.0, top: 16.0, bottom: 22.0),
    alignment: Alignment.topLeft,
    child: Text(
      cardTitle,
      style: TextStyle(
          color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
    ),
  );
}
