import 'package:flutter/material.dart';

const WIDGET_TOP_PADDING = EdgeInsets.only(top: 40);
const WIDGET_CARD_CIRCULAR_RADIUS = Radius.circular(80);
const CARD_INNER_PADDINGS = const EdgeInsets.all(16.0);
const DUMMY_LIST_ITEM_COUNT = 100;

const dummyImageLink =
    "https://scontent-frx5-1.xx.fbcdn.net/v/t1.0-9/83671486_2645031582229101_3281948020278558720_o.jpg?_nc_cat=111&_nc_ohc=IuTr_yV-_PQAX8d4ilp&_nc_ht=scontent-frx5-1.xx&oh=8de2643cf7330f184cfbd21d9ec2770d&oe=5EC65A5F";

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