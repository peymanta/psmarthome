import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as widget;

import '../colors.dart';

class HomeItem {
  var Image,
      Icon,
      iconColor,
      icEnabled,
      notif,
      messageLength, //number of messages shows in notification
      iWidth,
      iHeight,
      bottomImageVar,
      secondaryBottomImageVar,
      thirdImageVar,
      bILeft = false,
      clickable;
  HomeItem(this.Image,
      {icon,
      icColor = primary,
      iconEnabled = true,
      notificationEnabled = false,
      msgLength = 0,
      imageWidth = 70.0,
      imageHeight = 70.0,
      bottomImage,
      secondaryBottomImage,
      thirdImage,
      isBottomImageLeft = false,
      onPressed}) {
    Icon = icon;
    iconColor = icColor;
    icEnabled = iconEnabled;
    notif = notificationEnabled;
    messageLength = msgLength;
    iWidth = imageWidth;
    iHeight = imageHeight;
    bottomImageVar = bottomImage;
    secondaryBottomImageVar = secondaryBottomImage;
    thirdImageVar = thirdImage;
    clickable = onPressed;
    bILeft = isBottomImageLeft;
  }

  IconData get icon => Icon;
  String get image => Image;
  get bottomImage => bottomImageVar;
  get secondaryBottomImage => secondaryBottomImageVar;
  get getIconColor => iconColor;
  get thirdImage => thirdImageVar;
  bool get isIconEnabled => icEnabled;
  bool get isNotificationEnabled => notif;
  int get msgLength => messageLength;
  double get getImageWidth => iWidth;
  double get getImageHeight => iHeight;
  get pressed => clickable;
  get isBottomImageLeft => bILeft;
}
