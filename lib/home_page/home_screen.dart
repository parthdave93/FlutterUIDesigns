import 'package:flutter/material.dart';
import 'package:flutter_dribble_designs/another_animation/another_animatin.dart';
import '../card_paginator_component/card_pagination_screen.dart';
import '../shopping_screen/shopping_screen.dart';

class HomeScreen extends StatelessWidget {
  var pages = [
    ListScreenModel(
        screen: CardPaginationScreen(),
        assetImage: "assets/card_pagination.png",
        videoLink:
            "https://cdn.dribbble.com/users/4859/videos/17269/slider_2.mp4",
        mainPage:
            "https://dribbble.com/shots/6160500-Card-Paginator-Component"),
    ListScreenModel(
        assetImage: "assets/card_pagination.png",
        screen: ShoppingScreen(),
        videoLink: "https://cdn.dribbble.com/users/4859/videos/16204/cart.mp4",
        mainPage:
            "https://dribbble.com/shots/6120171-Groceries-Shopping-App-Interaction"),
    ListScreenModel(
        assetImage: "assets/card_pagination.png",
        screen: MyHomePage(),
        videoLink: "https://cdn.dribbble.com/users/4859/videos/16204/cart.mp4",
        mainPage:
            "https://dribbble.com/shots/6120171-Groceries-Shopping-App-Interaction"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
      ),
      body: Container(
        color: Colors.grey,
        child: ListView.builder(
            itemBuilder: (context, index) {
              if (pages[index].screen is CardPaginationScreen)
                return generateListTile(
                    context, "Card Pagination", pages[index]);
              if (pages[index].screen is ShoppingScreen) {
                return generateListTile(
                    context, "Shopping screen", pages[index]);
              }
              if (pages[index].screen is MyHomePage) {
                return generateListTile(
                    context, "Another Animation screen", pages[index]);
              }
            },
            itemCount: pages.length),
      ),
    );
  }

  generateListTile(
      BuildContext context, String message, ListScreenModel model) {
    return InkWell(
      onTap: () => openWidget(context, model.screen),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: Image.asset(
                  model.assetImage,
                  fit: BoxFit.fitWidth,
                  height: 150,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                message,
                style: TextStyle(color: Colors.black, fontSize: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }

  openWidget(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }
}

class ListScreenModel<T> {
  T screen;
  String assetImage;
  String videoLink;
  String mainPage;

  ListScreenModel(
      {this.screen, this.assetImage, this.videoLink, this.mainPage});
}
