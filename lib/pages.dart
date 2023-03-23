import 'package:flutter/material.dart';
import 'package:shome/ups/ups.dart';
import 'package:shome/relay/bloc/relay_cubit.dart';
import 'package:shome/relay/relay.dart' as relay;
import 'package:shome/report/report.dart';
import 'package:shome/security/security.dart';
import 'package:shome/settings/settings.dart';
import 'package:shome/temp/temp_screen.dart';
import 'package:shome/ups/ups.dart';
import 'colors.dart';
import 'main.dart';
import 'models/home_screen_items.dart';
import 'outlet/OutletPage.dart';

late List page1, page2;

void getPages() {
  page1 = [

    HomeItem('assets/icons/outlet.png',
        bottomImage: constants.get('PLUG1B') ?? 'assets/selectable-icons/question.png',
        isBottomImageLeft: true,
        thirdImage: deviceStatus.getPublicReport.waterLeakagePlug1 == 'yes' ? 'assets/selectable-icons/leaking.png' : null,
        icon: Icons.wifi_rounded,
        onPressed: () {
          currentPlug = PlugNumber.plug1;
          Navigator.push(
              buildContext,
              MaterialPageRoute(builder: (buildContext) => Outlet()));
        }),
    HomeItem('assets/icons/outlet.png', icon: Icons.wifi_rounded,
        bottomImage: constants.get('PLUG2B') ?? 'assets/selectable-icons/question.png',
        isBottomImageLeft: true,
        thirdImage: deviceStatus.getPublicReport.waterLeakagePlug2 == 'yes' ? 'assets/selectable-icons/leaking.png' : null,
        onPressed: () {
          currentPlug = PlugNumber.plug2;
          Navigator.push(
              buildContext,
              MaterialPageRoute(builder: (buildContext) => Outlet()));
        }),
    HomeItem('assets/icons/cooler.png',
        icon: Icons.wifi_rounded,
        onPressed: () {
          isCooler = true;
          Navigator.push(buildContext,
              MaterialPageRoute(builder: (buildContext) => CoolerScreen()));
        }),
    HomeItem('assets/icons/heater.png',
        icon: Icons.wifi_rounded,
        imageWidth: 110.0,
        imageHeight: 110.0,
        onPressed: () {
          isCooler = false;
          Navigator.push(buildContext,
              MaterialPageRoute(builder: (buildContext) => HeaterScreen()));
        }),
    // HomeItem('assets/icons/shield-inactive.png', iconEnabled: false),
    HomeItem(
        securityState
            ? 'assets/icons/shield-active.png'
            : 'assets/icons/shield-inactive.png',
        iconEnabled: false,
        onPressed: () =>
            Navigator.push(
                buildContext,
                MaterialPageRoute(builder: (buildContext) => Security()))),
    HomeItem('assets/icons/report.png',
        icon: Icons.analytics_outlined,
        notificationEnabled: true,
        msgLength: 30,
        onPressed: () =>
            Navigator.push(
                buildContext,
                MaterialPageRoute(builder: (buildContext) => Report()))),
    HomeItem('assets/icons/camera1.png',
        icon: Icons.shield_rounded,
        icColor: securityState
  ? green
      :primary,
        imageWidth: 200.0,
        imageHeight: 200.0, onPressed: () {
          relay.currentPage = relay.Page.Relay1;
          Navigator.push(
              buildContext,
              MaterialPageRoute(builder: (buildContext) => relay.Relay()));
        }),
    HomeItem(constants.get('IR4') ?? 'assets/icons/question.png', iconEnabled: false, onPressed: () {
      relay.currentPage = relay.Page.Relay4;
      Navigator.push(
          buildContext,
          MaterialPageRoute(builder: (buildContext) => relay.Relay()));
    }),
  ];

  page2 = [
    HomeItem(constants.get('IR2') ?? 'assets/icons/question.png',
        bottomImage: constants.get('IR2b') ?? 'assets/icons/question.png',
        icon: Icons.access_time_rounded,
        isBottomImageLeft: true, onPressed: () {
          relay.currentPage = relay.Page.Relay2;
          Navigator.push(
              buildContext,
              MaterialPageRoute(builder: (buildContext) => relay.Relay()));
        }),
    HomeItem(constants.get('IR3') ?? 'assets/icons/question.png',
        bottomImage: 'assets/icons/bottomImage1.png',
        icon: Icons.water_drop, onPressed: () {
          relay.currentPage = relay.Page.Relay3;
          Navigator.push(
              buildContext,
              MaterialPageRoute(builder: (buildContext) => relay.Relay()));
        }),
    HomeItem(constants.get('IR5') ?? 'assets/icons/question.png', icon: Icons.access_time_rounded,
        onPressed: () {
          relay.currentPage = relay.Page.Relay5;
          Navigator.push(
              buildContext,
              MaterialPageRoute(builder: (buildContext) => relay.Relay()));
        }),
    HomeItem(constants.get('IR6') ?? 'assets/icons/question.png',
        bottomImage: 'assets/icons/bottomImage1.png',
        iconEnabled: false, onPressed: () {
          relay.currentPage = relay.Page.Relay6;
          Navigator.push(
              buildContext,
              MaterialPageRoute(builder: (buildContext) => relay.Relay()));
        }),
    HomeItem(constants.get('IR7') ?? 'assets/icons/question.png',
        bottomImage: 'assets/icons/bottomImage2.png',
        icon: Icons.shield_rounded,
        icColor: securityState
            ? green
            :primary,
        onPressed: () {
          relay.currentPage = relay.Page.Relay7;
          Navigator.push(
              buildContext,
              MaterialPageRoute(builder: (buildContext) => relay.Relay()));
        }),
    HomeItem('assets/icons/ups.png',
        bottomImage: 'assets/icons/bottomImage3.png',
        iconEnabled: false,
        onPressed: () =>
            Navigator.push(
                buildContext,
                MaterialPageRoute(builder: (buildContext) => UPS()))),
    HomeItem('assets/icons/setting.png',
        iconEnabled: false,
        onPressed: () =>
            Navigator.push(
                buildContext,
                MaterialPageRoute(builder: (buildContext) => Settings()))),
  ];
}