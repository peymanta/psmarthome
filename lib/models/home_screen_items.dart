import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as widget;

class HomeItem {
  var Image, Icon, icEnabled, notif,
      messageLength, //number of messages shows in notification
  iWidth, iHeight, bottomImageVar, bILeft = false, clickable;
  HomeItem(this.Image, {icon, iconEnabled = true, notificationEnabled = false, msgLength = 0, imageWidth = 70.0, imageHeight = 70.0, bottomImage, isBottomImageLeft = false,  onPressed}) {
    Icon = icon;
    icEnabled = iconEnabled;
    notif = notificationEnabled;
    messageLength = msgLength;
    iWidth = imageWidth;
    iHeight = imageHeight;
    bottomImageVar = bottomImage;
    clickable = onPressed;
    bILeft = isBottomImageLeft;
  }

  IconData get icon => Icon;
  String get image => Image;
  get bottomImage => bottomImageVar;
  bool get isIconEnabled => icEnabled;
  bool get isNotificationEnabled => notif;
  int get msgLength => messageLength;
  double get getImageWidth => iWidth;
  double get getImageHeight => iHeight;
  get pressed => clickable;
  get isBottomImageLeft => bILeft;

}