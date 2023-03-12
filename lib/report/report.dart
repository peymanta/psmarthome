import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../colors.dart';
import '../outlet/OutletPage.dart';
import '../temp/temp_screen.dart';

TooltipBehavior? _tooltip;

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
        // child: ListView(
        //   children: [
        //     listItemText('Report'),
        //     button(() {}, 'Report'),
        //     button(() {}, 'Full Report'),
        //     button(() {}, 'Version'),
        //
        //     divider(),
        //     listItemText('Device'),
        //     listItemText('description'),
        //     divider(),
        //     listItemText('Graph'),
        //     SizedBox(
        //       height: 10,
        //     ),
        //     SizedBox(
        //       height: 220,
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: SfCartesianChart(
        //             primaryXAxis: CategoryAxis(),
        //             // Chart title
        //             // title: ChartTitle(text: 'Half yearly sales analysis'),
        //             // Enable legend
        //             legend: Legend(isVisible: true),
        //             // Enable tooltip
        //             tooltipBehavior: _tooltip,
        //             series: <LineSeries<SalesData, String>>[
        //               LineSeries<SalesData, String>(
        //                   dataSource: <SalesData>[
        //                     SalesData('Jan', 99),
        //                     SalesData('Feb', 28),
        //                     SalesData('Mar', 88),
        //                     SalesData('Apr', 32),
        //                     SalesData('May', 70)
        //                   ],
        //                   xValueMapper: (SalesData sales, _) => sales.year,
        //                   yValueMapper: (SalesData sales, _) => sales.sales,
        //                   // Enable data label
        //                   dataLabelSettings: DataLabelSettings(isVisible: true))
        //             ]),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 10,
        //     ),
        //     SizedBox(
        //       height: 220,
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: SfCartesianChart(
        //             primaryXAxis: CategoryAxis(),
        //             // Chart title
        //             // title: ChartTitle(text: 'Half yearly sales analysis'),
        //             // Enable legend
        //             legend: Legend(isVisible: true),
        //             // Enable tooltip
        //             tooltipBehavior: _tooltip,
        //             series: <LineSeries<SalesData, String>>[
        //               LineSeries<SalesData, String>(
        //                   dataSource: <SalesData>[
        //                     SalesData('Jan', 99),
        //                     SalesData('Feb', 28),
        //                     SalesData('Mar', 88),
        //                     SalesData('Apr', 32),
        //                     SalesData('May', 70)
        //                   ],
        //                   xValueMapper: (SalesData sales, _) => sales.year,
        //                   yValueMapper: (SalesData sales, _) => sales.sales,
        //                   // Enable data label
        //                   dataLabelSettings: DataLabelSettings(isVisible: true))
        //             ]),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 10,
        //     ),
        //     SizedBox(
        //       height: 220,
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: SfCartesianChart(
        //             primaryXAxis: CategoryAxis(),
        //             // Chart title
        //             // title: ChartTitle(text: 'Half yearly sales analysis'),
        //             // Enable legend
        //             legend: Legend(isVisible: true),
        //             // Enable tooltip
        //             tooltipBehavior: _tooltip,
        //             series: <LineSeries<SalesData, String>>[
        //               LineSeries<SalesData, String>(
        //                   dataSource: <SalesData>[
        //                     SalesData('Jan', 99),
        //                     SalesData('Feb', 28),
        //                     SalesData('Mar', 88),
        //                     SalesData('Apr', 32),
        //                     SalesData('May', 70)
        //                   ],
        //                   xValueMapper: (SalesData sales, _) => sales.year,
        //                   yValueMapper: (SalesData sales, _) => sales.sales,
        //                   // Enable data label
        //                   dataLabelSettings: DataLabelSettings(isVisible: true))
        //             ]),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 10,
        //     ),
        //     SizedBox(
        //       height: 220,
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: SfCartesianChart(
        //             primaryXAxis: CategoryAxis(),
        //             // Chart title
        //             // title: ChartTitle(text: 'Half yearly sales analysis'),
        //             // Enable legend
        //             legend: Legend(isVisible: true),
        //             // Enable tooltip
        //             tooltipBehavior: _tooltip,
        //             series: <LineSeries<SalesData, String>>[
        //               LineSeries<SalesData, String>(
        //                   dataSource: <SalesData>[
        //                     SalesData('Jan', 99),
        //                     SalesData('Feb', 28),
        //                     SalesData('Mar', 88),
        //                     SalesData('Apr', 32),
        //                     SalesData('May', 70)
        //                   ],
        //                   xValueMapper: (SalesData sales, _) => sales.year,
        //                   yValueMapper: (SalesData sales, _) => sales.sales,
        //                   // Enable data label
        //                   dataLabelSettings: DataLabelSettings(isVisible: true))
        //             ]),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 10,
        //     ),
        //     SizedBox(
        //       height: 220,
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: SfCartesianChart(
        //             primaryXAxis: CategoryAxis(),
        //             // Chart title
        //             // title: ChartTitle(text: 'Half yearly sales analysis'),
        //             // Enable legend
        //             legend: Legend(isVisible: true),
        //             // Enable tooltip
        //             tooltipBehavior: _tooltip,
        //             series: <LineSeries<SalesData, String>>[
        //               LineSeries<SalesData, String>(
        //                   dataSource: <SalesData>[
        //                     SalesData('Jan', 99),
        //                     SalesData('Feb', 28),
        //                     SalesData('Mar', 88),
        //                     SalesData('Apr', 32),
        //                     SalesData('May', 70)
        //                   ],
        //                   xValueMapper: (SalesData sales, _) => sales.year,
        //                   yValueMapper: (SalesData sales, _) => sales.sales,
        //                   // Enable data label
        //                   dataLabelSettings: DataLabelSettings(isVisible: true))
        //             ]),
        //       ),
        //     ),
        //     SizedBox(
        //       height: 10,
        //     ),
        //     SizedBox(
        //       height: 220,
        //       child: Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: SfCartesianChart(
        //             primaryXAxis: CategoryAxis(),
        //             // Chart title
        //             // title: ChartTitle(text: 'Half yearly sales analysis'),
        //             // Enable legend
        //             legend: Legend(isVisible: true),
        //             // Enable tooltip
        //             tooltipBehavior: _tooltip,
        //             series: <LineSeries<SalesData, String>>[
        //               LineSeries<SalesData, String>(
        //                   dataSource: <SalesData>[
        //                     SalesData('Jan', 99),
        //                     SalesData('Feb', 28),
        //                     SalesData('Mar', 88),
        //                     SalesData('Apr', 32),
        //                     SalesData('May', 70)
        //                   ],
        //                   xValueMapper: (SalesData sales, _) => sales.year,
        //                   yValueMapper: (SalesData sales, _) => sales.sales,
        //                   // Enable data label
        //                   dataLabelSettings: DataLabelSettings(isVisible: true))
        //             ]),
        //       ),
        //     ),
        //
        //     ///step charts
        //     SfCartesianChart(
        //         primaryXAxis: DateTimeAxis(),
        //         series: <ChartSeries>[
        //           // Renders step line chart
        //           StepLineSeries<SalesData, DateTime>(
        //               dataSource: <SalesData>[
        //                 SalesData('Jan', 99),
        //                 SalesData('Feb', 0),
        //                 SalesData('Mar', 88),
        //                 SalesData('Apr', 45),
        //                 SalesData('May', 70)
        //               ],
        //               xValueMapper: (SalesData data, _) => DateTime.now(),
        //               yValueMapper: (SalesData data, _) => data.sales)
        //         ]),
        //     SfCartesianChart(
        //         primaryXAxis: DateTimeAxis(),
        //         series: <ChartSeries>[
        //           // Renders step line chart
        //           StepLineSeries<SalesData, DateTime>(
        //               dataSource: <SalesData>[
        //                 SalesData('Jan', 99),
        //                 SalesData('Feb', 0),
        //                 SalesData('Mar', 88),
        //                 SalesData('Apr', 45),
        //                 SalesData('May', 70)
        //               ],
        //               xValueMapper: (SalesData data, _) => DateTime.now(),
        //               yValueMapper: (SalesData data, _) => data.sales)
        //         ]),
        //     SfCartesianChart(
        //         primaryXAxis: DateTimeAxis(),
        //         series: <ChartSeries>[
        //           // Renders step line chart
        //           StepLineSeries<SalesData, DateTime>(
        //               dataSource: <SalesData>[
        //                 SalesData('Jan', 99),
        //                 SalesData('Feb', 0),
        //                 SalesData('Mar', 88),
        //                 SalesData('Apr', 45),
        //                 SalesData('May', 70)
        //               ],
        //               xValueMapper: (SalesData data, _) => DateTime.now(),
        //               yValueMapper: (SalesData data, _) => data.sales)
        //         ]),
        //   ],
        // ),
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
          child: Container(alignment: Alignment.centerLeft, child: Text(text))),
      SizedBox(
        height: 20,
      )
    ],
  );
}
