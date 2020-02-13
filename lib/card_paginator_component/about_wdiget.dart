
import 'package:flutter/material.dart';
import 'local_card_dimen.dart';

class AboutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: WIDGET_TOP_PADDING,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: WIDGET_CARD_CIRCULAR_RADIUS,
          topRight: WIDGET_CARD_CIRCULAR_RADIUS,
        ),
        color: Color.fromARGB(255, 216, 220, 255),
      ),
      child: Column(
        children: aboutList(),
      ),
    );
  }
}


aboutList() {
  List<Widget> listItems = [cardTitle("About")];
  listItems
    ..addAll(
      List<int>.generate(DUMMY_LIST_ITEM_COUNT, (index) => index)
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
