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
            onNotification: (ScrollNotification scrollInfo) =>
                onSliverScrollNotificationReceived(scrollInfo),
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
              onPanUpdate: (details) => onFeedWidgetGestureUpdate(details),
              onPanEnd: (details) => onFeedWidgetPanEnd(details),
              child:
                  FeedWidget(scrollingPhysics, _secondWidgetScrollController),
            ),
          ),
        ],
      ),
    );
  }

  onSliverScrollNotificationReceived(ScrollNotification scrollInfo) {
    {
      if (touchedScrollIndex != 0) return false;
      if (pointDownY == 0) {
        pointDownY = scrollInfo.metrics.pixels;
        previousPointY = pointDownY;
      } else if (previousPointY > scrollInfo.metrics.pixels &&
          !_firstWidgetScrollController.position.atEdge &&
          !isToolbarCollapsed) {
        if (_secondWidgetTopMargin > _secondChildLastGlobalBottomPosition) {
          _secondWidgetTopMargin -= 2;
          if (_secondWidgetTopMargin < _secondChildLastGlobalBottomPosition) {
            _secondWidgetTopMargin = _secondChildLastGlobalBottomPosition;
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
    }
  }

  onFeedWidgetGestureUpdate(DragUpdateDetails details) {
    {
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
          _secondWidgetTopMargin <= _secondChildLastGlobalBottomPosition &&
          _secondWidgetTopMargin >= 150) {
        if (_secondWidgetTopMargin < _topHeaderExpandedHeight + 80) {
          _firstWidgetScrollController.jumpTo(
              _firstWidgetScrollController.position.pixels - details.delta.dy);
        }
        _secondWidgetTopMargin += details.delta.dy;
        if (_secondWidgetTopMargin < 150) {
          _secondWidgetTopMargin = 150;
        } else if (_secondWidgetTopMargin >
            _secondChildLastGlobalBottomPosition) {
          _secondWidgetTopMargin = _secondChildLastGlobalBottomPosition;
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
          _secondWidgetTopMargin <= _secondChildLastGlobalBottomPosition) {
        _secondWidgetTopMargin += details.delta.dy;
        if (_firstWidgetScrollController.position.pixels <
            _topHeaderExpandedHeight)
          _firstWidgetScrollController.jumpTo(
              _firstWidgetScrollController.position.pixels - details.delta.dy);
        if (_secondWidgetTopMargin < 150) {
          _secondWidgetTopMargin = 150;
        } else if (_secondWidgetTopMargin >
            _secondChildLastGlobalBottomPosition) {
          _secondWidgetTopMargin = _secondChildLastGlobalBottomPosition;
        }
      }
      previousPointY = details.globalPosition.dy;
      setState(() {});
    }
  }

  onFeedWidgetPanEnd(DragEndDetails details) {
    pointDownY = 0;
    //if toolbar not collapsed then expand again
    if (_secondWidgetTopMargin > 150) {
      _secondWidgetTopMargin = _secondChildLastGlobalBottomPosition;
      _firstWidgetScrollController.jumpTo(0);
      setState(() {});
    }
  }
}
