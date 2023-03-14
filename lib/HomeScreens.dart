import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shome/main.dart';
import 'package:shome/models/home_screen_items.dart';

import 'outlet/OutletPage.dart';



Widget homePage(List items) {
    return Builder(
      builder: (context) {
        return Container(
          color: Color(0xffeceef7),
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: (MediaQuery.of(context).size.width /
                      (MediaQuery.of(context).size.height / 1.9))),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Center(
                  child: SizedBox(
                    width: 250,
                    height: 550,
                    child: MaterialButton(
                      onPressed: items[index].pressed,
                      child: Center(
                        child: Stack(
                            children: [
                          SizedBox(
                            width: 850,
                            height: 850,
                            child: Neumorphic(
                              margin: const EdgeInsets.all(8),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    items[index].image,
                                    width: items[index].getImageWidth,
                                    height: items[index].getImageHeight,
                                  ),
                                  items[index].isIconEnabled
                                      ? Positioned(
                                          bottom: 10,
                                          right: 10,
                                          child: Icon(
                                            items[index].icon,
                                            color: Color(0xff838fa3),
                                          ))
                                      : Container(),
                                  items[index].bottomImage !=null
                                      ? Positioned(
                                          bottom: 10,
                                          // right: 0,//items[index].isBottomImageLeft == true? 0:null,
                                          child: Image.asset(
                                            items[index].bottomImage,
                                            width: 150,
                                            height: 30,
                                            // color: Color(0xff838fa3),
                                          ))
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          //notification
                          items[index].isNotificationEnabled && (logBox.length - constants.get('notifBadge'))>0
                              ? Positioned(
                                top: 5,
                                left: 0,
                                child: Center(
                                  child: Container(
                          width: items[index].msgLength < 100 ? 26 : 39,
                          height: items[index].msgLength < 100 ? 26 : 39,
                            margin: EdgeInsets.only(top: 10, left: 15),
                            padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Color(0xffd63030),
                                          borderRadius: BorderRadius.circular(50)),
                                      child: Center(
                                        child: Text(
                                          (logBox.length - constants.get('notifBadge')).toString(),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                ),
                              )
                              : Container(),
                        ]),
                      ),
                    ),
                  ),
                );
              }),
        );
      }
    );
  }

