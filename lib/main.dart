import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shome/colors.dart';
import 'package:shome/models/status.dart';
import 'package:shome/relay/bloc/relay_cubit.dart';
import 'package:shome/relay/relay.dart' as relay;
import 'package:shome/report/report.dart';
import 'package:shome/security/security.dart';
import 'package:shome/settings/settings.dart';
import 'package:shome/temp/temp_screen.dart';
import 'package:shome/ups/ups.dart';

import 'HomeScreens.dart';
import 'a.dart';
import 'compiling_sms.dart';
import 'outlet/OutletPage.dart';
import 'models/home_screen_items.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

bool securityState = true;
late DeviceStatus deviceStatus;
late Box deviceBox;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive
    ..init((await getApplicationDocumentsDirectory()).path)
    ..registerAdapter(DeviceStatusAdapter())
    ..registerAdapter(RelayAdapter())
    ..registerAdapter(PlugAdapter())
    ..registerAdapter(PublicReportAdapter());

  deviceBox = await Hive.openBox('deviceInfo');
  deviceStatus = deviceBox.get('info') ?? DeviceStatus();

  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
    scrollBehavior: MyCustomScrollBehavior(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // await box.put('a', 'hello');
    //
  }

  @override
  Widget build(BuildContext context) {
    compile('sms');
    ss() async{
      deviceStatus = await deviceBox.get('info');
      print(deviceStatus.getR3.humMin);
      print(deviceStatus.getR3.humMax);
    }
    ss();
    List page1 = [
      // HomeItem('assets/icons/outlet.png', icon: Icons.wifi_rounded,
      //     onPressed: () {
      //   currentPlug = PlugNumber.plug1;
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => DualPotentiometer()));
      // }),

      HomeItem('assets/icons/outlet.png', icon: Icons.wifi_rounded,
          onPressed: () {
        currentPlug = PlugNumber.plug1;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Outlet()));
      }),
      HomeItem('assets/icons/outlet.png', icon: Icons.wifi_rounded,
          onPressed: () {
        currentPlug = PlugNumber.plug2;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Outlet()));
      }),
      HomeItem('assets/icons/cooler.png',
          icon: Icons.wifi_rounded,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => CoolerScreen()))),
      HomeItem('assets/icons/heater.png',
          icon: Icons.wifi_rounded,
          imageWidth: 110.0,
          imageHeight: 110.0,
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => HeaterScreen()))),
      // HomeItem('assets/icons/shield-inactive.png', iconEnabled: false),
      HomeItem(
          securityState
              ? 'assets/icons/shield-active.png'
              : 'assets/icons/shield-inactive.png',
          iconEnabled: false,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Security()))),
      HomeItem('assets/icons/report.png',
          icon: Icons.analytics_outlined,
          notificationEnabled: true,
          msgLength: 30,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Report()))),
      HomeItem('assets/icons/camera1.png',
          icon: Icons.shield_rounded,
          imageWidth: 200.0,
          imageHeight: 200.0, onPressed: () {
        relay.currentPage = relay.Page.Relay1;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => relay.Relay()));
      }),
      HomeItem('assets/icons/question.png', iconEnabled: false, onPressed: () {
        relay.currentPage = relay.Page.Relay4;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => relay.Relay()));
      }),
    ];

    List page2 = [
      HomeItem('assets/icons/question.png',
          bottomImage: 'assets/icons/question.png',
          icon: Icons.access_time_rounded,
          isBottomImageLeft: true, onPressed: () {
        relay.currentPage = relay.Page.Relay2;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => relay.Relay()));
      }),
      HomeItem('assets/icons/question.png',
          bottomImage: 'assets/icons/bottomImage1.png',
          icon: Icons.water_drop, onPressed: () {
        relay.currentPage = relay.Page.Relay3;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => relay.Relay()));
      }),
      HomeItem('assets/icons/question.png', icon: Icons.access_time_rounded,
          onPressed: () {
        relay.currentPage = relay.Page.Relay5;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => relay.Relay()));
      }),
      HomeItem('assets/icons/question.png',
          bottomImage: 'assets/icons/bottomImage1.png',
          iconEnabled: false, onPressed: () {
        relay.currentPage = relay.Page.Relay6;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => relay.Relay()));
      }),
      HomeItem('assets/icons/question.png',
          bottomImage: 'assets/icons/bottomImage2.png',
          icon: Icons.shield_rounded, onPressed: () {
        relay.currentPage = relay.Page.Relay7;
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => relay.Relay()));
      }),
      HomeItem('assets/icons/ups.png',
          bottomImage: 'assets/icons/bottomImage3.png',
          iconEnabled: false,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => UPS()))),
      HomeItem('assets/icons/setting.png',
          iconEnabled: false,
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => Settings()))),
    ];

    return Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          backgroundColor: background,
          title: Container(
              alignment: Alignment.centerRight,
              child: Text(
                'خانه هوشمند',
                style: TextStyle(color: Colors.black),
              )),
        ),
        body: PageView(
          children: [
            Center(
              child: homePage(page1),
            ),
            Center(
              child: homePage(page2),
            )
          ],
        ));
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
