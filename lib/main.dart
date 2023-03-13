import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shome/colors.dart';
import 'package:shome/models/status.dart';
import 'package:shome/pages.dart';
import 'package:shome/relay/bloc/relay_cubit.dart';
import 'package:shome/relay/relay.dart' as relay;
import 'package:shome/report/report.dart';
import 'package:shome/security/security.dart';
import 'package:shome/settings/settings.dart';
import 'package:shome/temp/temp_screen.dart';
import 'package:shome/ups/ups.dart';

import 'HomeScreens.dart';
import 'a.dart';
import 'bloc/main_cubit.dart';
import 'compiling_sms.dart';
import 'outlet/OutletPage.dart';
import 'models/home_screen_items.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

bool securityState = true;
late DeviceStatus deviceStatus;
late Charts chartsObject;
late Box deviceBox, tempBox, constants, chartsBox;

late BuildContext buildContext;
late MainCubit mainController;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive
    ..init((await getApplicationDocumentsDirectory()).path)
    ..registerAdapter(DeviceStatusAdapter())
    ..registerAdapter(RelayAdapter())
    ..registerAdapter(PlugAdapter())
    ..registerAdapter(PublicReportAdapter())
    ..registerAdapter(ChartDataAdapter())
    ..registerAdapter(ChartsAdapter());

  deviceBox = await Hive.openBox('deviceInfo');
  deviceStatus = deviceBox.get('info') ?? DeviceStatus();

  tempBox = await Hive.openBox('temp'); //temp chart
  constants = await Hive.openBox('const'); //vars
  chartsBox = await Hive.openBox('charts'); //charts of report page

  chartsObject = chartsBox.get('object') ?? Charts();

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
    mainController = MainCubit();
    mainController.init();
  }

  @override
  Widget build(BuildContext context) {
    buildContext = context;
    // compile('sms');
    ss() async {
      deviceStatus = await deviceBox.get('info');


      // chartsObject.inBoxTemps.add(ChartData('12/16', 30));
      // chartsObject.inBoxTemps.add(ChartData('12/19', 50));
      // chartsObject.inBoxTemps.add(ChartData('12/21', 10));
      // chartsObject.inBoxTemps.add(ChartData('12/24', 31));
    }

    ss();

    return Scaffold(
        appBar: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: background,
            title: Container(
                alignment: Alignment.centerRight,
                child: Text('خانه هوشمند',
                    style: TextStyle(color: Colors.black)))),
        body: BlocBuilder<MainCubit, MainState>(
          bloc: mainController,
          builder: (context, state) {
            getPages(); //get pages with updated details
            if (state is MainInitial) {
              return PageView(
                children: [
                  Center(
                    child: homePage(page1),
                  ),
                  Center(
                    child: homePage(page2),
                  )
                ],
              );
            } else {
              return Container();
            }
          },
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

showMessage(msg) {
  ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(content: Text(msg)));
}
