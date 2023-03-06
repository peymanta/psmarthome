import 'package:flutter/material.dart';

import '../colors.dart';
import '../outlet/OutletPage.dart';

class Report extends StatefulWidget {
  const Report({Key? key}) : super(key: key);

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: background,
      shadowColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black),),
      body: Container(
        color: background,
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          listItemText('Report'),
          button((){}, 'Report'),
          button((){}, 'Full Report'),
          button((){}, 'Version'),

          divider(),
          listItemText('Device'),
          listItemText('description'),
          divider(),
          listItemText('Graph'),
        ],),
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