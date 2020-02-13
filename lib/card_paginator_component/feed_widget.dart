import 'package:flutter/material.dart';
import 'local_card_dimen.dart';

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
            topLeft: WIDGET_CARD_CIRCULAR_RADIUS,
            topRight: WIDGET_CARD_CIRCULAR_RADIUS,
          ),
          color: Colors.black,
        ),
        padding: WIDGET_TOP_PADDING,
        child: Column(
          children: feedList(),
        ),
      ),
    );
  }
}

feedList() {
  List<Widget> listItems = [cardTitle("Feed")];
  listItems
    ..addAll(
      List<int>.generate(DUMMY_LIST_ITEM_COUNT, (index) => index)
          .map(
            (index) => Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: WIDGET_CARD_CIRCULAR_RADIUS,
                        topRight: WIDGET_CARD_CIRCULAR_RADIUS),
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