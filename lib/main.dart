import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shome/colors.dart';
import 'package:shome/models/status.dart';
import 'package:shome/pages.dart';
import 'package:shome/relay/bloc/relay_cubit.dart';
import 'package:shome/relay/relay.dart' as relay;
import 'package:shome/relay/relay.dart';
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
import 'package:sms/sms.dart';
import 'package:benchmark_harness/benchmark_harness.dart';

bool securityState = true;
late DeviceStatus deviceStatus;
late Charts chartsObject;
late Box deviceBox, tempBox, constants, chartsBox, logBox;

late BuildContext buildContext;
late MainCubit mainController;
SmsReceiver? smsReceiver;

void main() async {
  WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);

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
  logBox = await Hive.openBox('log'); //log of report page

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

    smsReceiver = SmsReceiver();

    mainController.init();
    FlutterNativeSplash.remove();
  }



  @override
  Widget build(BuildContext context) {
    buildContext = context;

    return Scaffold(
        appBar: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: background,
            title: Text('Smart Home V4.5',
                style: TextStyle(color: Colors.black))),
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

dialog(title, contents, onConfirm, {cancellable = true, removeCancel = false}) {
  return showDialog(
      barrierDismissible: cancellable,
      context: buildContext,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            elevation: 0,
            backgroundColor: Color(0xFFDFE1E6),
            insetPadding: EdgeInsets.all(20.0),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                     title.isNotEmpty ? Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ) : Container(),
                      SizedBox(
                        height: 20,
                      ),
                      contents,
                      SizedBox(height: 40.0),
                      Row(
                        children: <Widget>[
                          Visibility(
                            visible: !removeCancel,
                            child: Expanded(
                              child: MaterialButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 20.0),
                          Expanded(
                            child: MaterialButton(
                                child: Text(
                                  'Confirm',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                  ),
                                ),
                                onPressed: onConfirm),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
            ),
          ));
}
