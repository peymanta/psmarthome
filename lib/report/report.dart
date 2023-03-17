import 'package:flutter/material.dart';
import 'package:shome/main.dart';
import 'package:shome/models/status.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../colors.dart';
import '../outlet/OutletPage.dart';
import '../temp/temp_screen.dart';
import 'bloc/report_cubit.dart';

TooltipBehavior? _tooltip;
ReportCubit? _cubit;

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tooltip = TooltipBehavior();
    _cubit = ReportCubit();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: background,
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            button(() => _cubit!.notifications(), 'Show Notifications'),
            divider(),
            listItemText('Report'),
            button(() => _cubit!.report(), 'Report'),
            button(() => _cubit!.fullReport(), 'Full Report'),
            button(() => _cubit!.version(), 'Version'),

            divider(),
            listItemText('Device'),
            listItemText('''Outbox temp: ${deviceStatus.getPublicReport.outBoxTemp}
Outbox humidity: ${deviceStatus.getPublicReport.outBoxHumidity}
Room temp: ${deviceStatus.getPublicReport.temp}
Case door: ${deviceStatus.getPublicReport.caseDoor}
Buzzer: ${deviceStatus.getPublicReport.buzzer}
Fan: ${deviceStatus.getPublicReport.fanCount}
5 volt relays: ${deviceStatus.getPublicReport.power5}
5 volt micro controller: ${deviceStatus.getPublicReport.microPower}
Security: ${deviceStatus.getPublicReport.securitySystem}
Water leak 1: ${deviceStatus.getPublicReport.waterLeakagePlug1}
Water leak 2: ${deviceStatus.getPublicReport.waterLeakagePlug2}
Cooler rest: ${deviceStatus.getPublicReport.coolerRest}
Short sms: ${deviceStatus.getPublicReport.shortReport}
View: ${deviceStatus.getPublicReport.view}
Plug: ${deviceStatus.getPublicReport.plug}
Light: ${deviceStatus.getPublicReport.daynight}
Battery State: ${deviceStatus.getPublicReport.battery}
Extention Voltage: ${deviceStatus.getPublicReport.power}
GSM Power signal: ${deviceStatus.getPublicReport.gsmSignalPower}
Motion sensor: ${deviceStatus.getPublicReport.motionSensor}
Reset counts: ${deviceStatus.resetCount}
'''),
            divider(),
            listItemText('Graph'),
            SizedBox(
              height: 10,
            ),
            listItemText('average inbox temp'),
            chart(chartsObject.inBoxTemps!),
            listItemText('average outbox temp'),
            chart(chartsObject.outBoxTemps!),
            listItemText('average outbox humidity'),
            chart(chartsObject.outBoxHumiditys!),
            listItemText('fan active counts'),
            chart(chartsObject.fanCounts!),
            listItemText('average mobile signal power'),
            chart(chartsObject.mobileSignals!),
            listItemText('cap voltages'),
            chart(chartsObject.batteryVoltages!),
            SizedBox(
              height: 10,
            ),

            ///step charts
            listItemText('power outage'),
            chart(chartsObject.electricalIssuses!, isStep: true),
            listItemText('wireless plugs/temp actulator'),
            chart4Lines(chartsObject.onePlugs, chartsObject.twoPlugs, chartsObject.coolers, chartsObject.heaters),
            listItemText('device resets'),
            chart(chartsObject.deviceResets!, isStep: true),
          ],
        ),
      ),
    );
  }
}

Widget chart(List<ChartData> data, {isStep = false}) {
  if (data.isNotEmpty && !isStep) {
    print(1);
    return SizedBox(
      height: 220,
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          legend: Legend(isVisible: false),
          tooltipBehavior: _tooltip,
          series: <LineSeries>[
            LineSeries(
                dataSource: data.toList(),
                xValueMapper: (data, _) => data.x,
                yValueMapper: (data, _) => data.y,
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true))
          ]),
    );
  } else if (data.isNotEmpty && isStep) {
    return SizedBox(
      height: 220,
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          legend: Legend(isVisible: false),
          tooltipBehavior: _tooltip,
          series: <StepLineSeries>[
            StepLineSeries(
                dataSource: data.toList(),
                xValueMapper: (data, _) => data.x,
                yValueMapper: (data, _) => data.y,
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true))
          ]),
    );
  } else {
    print(2);
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/chart.png',
            height: 220,
          ),
          Positioned.fill(
              child: Container(
            child: Center(
              child: Text('No Data'),
            ),
            color: background.withOpacity(.65),
          ))
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////
/////////////////////////////////////////////////////
////////////////////////////////////////////////////
Widget chart4Lines(List<ChartData> data1, data2, data3, data4) {
  if (data1.isNotEmpty &&
      data2.isNotEmpty &&
      data3.isNotEmpty &&
      data4.isNotEmpty) {
    return SizedBox(
      height: 220,
      child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          legend: Legend(isVisible: true, width: '40'),
          tooltipBehavior: _tooltip,
          series: <StepLineSeries>[
            StepLineSeries(
              name: 'plug 1',
                dataSource: data1.toList(),
                xValueMapper: (data, _) => data.x,
                yValueMapper: (data, _) => data.y,
                dataLabelSettings: DataLabelSettings(isVisible: true)),
            StepLineSeries(
              name: 'plug 2',
              color: yellow,
                dataSource: data2.toList(),
                xValueMapper: (data, _) => data.x,
                yValueMapper: (data, _) => data.y,
                dataLabelSettings: DataLabelSettings(isVisible: true)),
            StepLineSeries(
              name: 'cooler',
              color: green,
                dataSource: data3.toList(),
                xValueMapper: (data, _) => data.x,
                yValueMapper: (data, _) => data.y,
                dataLabelSettings: DataLabelSettings(isVisible: true)),
            StepLineSeries(
              name: 'heater',
              color: red,
                dataSource: data4.toList(),
                xValueMapper: (data, _) => data.x,
                yValueMapper: (data, _) => data.y,
                dataLabelSettings: DataLabelSettings(isVisible: true)),
          ]),
    );
  } else {
    print(2);
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          Image.asset(
            'assets/images/chart.png',
            height: 220,
          ),
          Positioned.fill(
              child: Container(
            child: Center(
              child: Text('No Data'),
            ),
            color: background.withOpacity(.65),
          ))
        ],
      ),
    );
  }
}

Widget button(onPressed, name) {
  return Column(
    children: [
      MaterialButton(
        onPressed: onPressed,
        child: Padding(
            padding: const EdgeInsets.all(15),
            child:
                Container(alignment: Alignment.centerLeft, child: Text(name))),
      ),
      SizedBox(height: 10)
    ],
  );
}

Widget listItemText(text) {
  return Column(
    children: [
      Padding(
          padding: const EdgeInsets.all(15),
          child: Container(alignment: Alignment.centerLeft, child: Text(text, style: TextStyle(fontSize: 12),))),
      SizedBox(
        height: 20,
      )
    ],
  );
}
