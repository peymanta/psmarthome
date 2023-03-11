import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:knob_widget/knob_widget.dart';
import 'package:shome/colors.dart';
import 'package:shome/outlet/OutletPage.dart';
import 'package:shome/temp/bloc/cooler_cubit.dart';

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:syncfusion_flutter_charts/charts.dart';

import 'bloc/heater_cubit.dart';

CoolerCubit? cooler;
HeaterCubit? heater;
bool automatic = true, infinity = false;
TooltipBehavior? _tooltip;

class CoolerScreen extends StatefulWidget {
  const CoolerScreen({Key? key}) : super(key: key);

  @override
  State<CoolerScreen> createState() => _CoolerScreenState();
}

class _CoolerScreenState extends State<CoolerScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cooler = CoolerCubit();
    _tooltip = TooltipBehavior();
  }

  @override
  Widget build(BuildContext context) {
    // return MyApp();
    return BlocBuilder<CoolerCubit, CoolerState>(
      bloc: cooler,
      builder: (context, state) {
        if (state is CoolerInitial) {
          return Scaffold(
            appBar: AppBar(
                shadowColor: Colors.transparent,
                backgroundColor: NeumorphicColors.background,
                iconTheme: IconThemeData(color: Colors.black)),
            backgroundColor: NeumorphicColors.background,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: EdgeInsets.all(20),
                child: actulator(cooler, context, cooler: true),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}




class HeaterScreen extends StatefulWidget {
  const HeaterScreen({Key? key}) : super(key: key);

  @override
  State<HeaterScreen> createState() => _HeaterScreenState();
}

class _HeaterScreenState extends State<HeaterScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    heater = HeaterCubit();
    _tooltip = TooltipBehavior();
  }

  @override
  Widget build(BuildContext context) {
    // return MyApp();
    return BlocBuilder<HeaterCubit, HeaterState>(
      bloc: heater,
      builder: (context, state) {
        if (state is HeaterInitial) {
          return Scaffold(
            appBar: AppBar(
                shadowColor: Colors.transparent,
                backgroundColor: NeumorphicColors.background,
                iconTheme: IconThemeData(color: Colors.black)),
            backgroundColor: NeumorphicColors.background,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: EdgeInsets.all(20),
                child: actulator(heater, context, cooler: false),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}


Widget actulator(cubit, context, {bool cooler= true}) {
  double endMin = 0, sv = 0, ev = 0;
  KnobController start = KnobController(minimum: 0, maximum: 30);
  KnobController end = KnobController(minimum: endMin, maximum: 30);

  return StatefulBuilder(builder: (context, setState) {
    start.addOnValueChangedListener((double value) {
      setState(() {
        sv = value.roundToDouble();
        endMin = (value + 4.0);

        if (ev < endMin) ev = value.roundToDouble();
      });
      end = KnobController(minimum: endMin, maximum: 30, initial: endMin);
    });

    // start = KnobController(minimum: 0, maximum: 30);

    end.addOnValueChangedListener((p) {
      setState(() {
        ev = p.roundToDouble();
      });
    });
    print(endMin);
    return ListView(physics: ClampingScrollPhysics(), children: [
      Column(
        children: [
          ListTile(
            onTap: () => cubit!.status(),
            title: Container(
              alignment: Alignment.centerLeft,
              child: Text(cooler ? 'Cooler' : 'Heater'),
            ),
            leading: SizedBox(
                width: 50, height: 50,
                child: NeumorphicRadio(
                    groupValue: automatic,
                    value: false,
                style: NeumorphicRadioStyle(selectedColor: blue,
                    shape: NeumorphicShape.convex,
                    boxShape:NeumorphicBoxShape.circle()),
                )

            ),
            // leading: NeumorphicSwitch(value: !automatic),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () => cubit!.status(),
            title: Container(
                alignment: Alignment.centerLeft,
                child: Text('Automatic ${cooler ? 'cooler' : 'heater'}')),
            // leading: NeumorphicSwitch(value: automatic),
          leading: SizedBox(
              width: 50, height: 50,
              child: NeumorphicRadio(
                groupValue: automatic,
                value: true,
                style: NeumorphicRadioStyle(selectedColor: blue,
                    shape: NeumorphicShape.convex,
                    boxShape:NeumorphicBoxShape.circle()),
              )),
          ),
        ],
      ),
      SizedBox(
        height: 30,
      ),
      Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text('ساعت پایان'),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: TimePickerSpinner(
                    is24HourMode: true,
                    isForce2Digits: true,
                    onTimeChange: (DateTime time) {
                      cubit!.status();
                    },
                    time: DateTime.now(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text('ساعت شروع'),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: TimePickerSpinner(
                    is24HourMode: true,
                    isForce2Digits: true,
                    onTimeChange: (DateTime time) {
                      //   setState(() => endTime = time);
                      //   cubit!.status();
                    },
                    time: DateTime.now(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      SizedBox(height: 30),
      Center(
        child: NeumorphicButton(
          onPressed: () {},
          child: Padding(
          padding: EdgeInsets.all(10),
          child: Text('ثبت تغییرات'),),),
      ),
      SizedBox(height: 30),
      Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Expanded(
                child: Center(
                    child: SizedBox(
                        width: 50,
                        height: 50,
                        child: NeumorphicButton(
                          onPressed: () {},
                          style: NeumorphicStyle(
                              boxShape: NeumorphicBoxShape.circle()),
                        )))),
            Expanded(
                child: Center(
              child: NeumorphicCheckbox(
                value: infinity,
                onChanged: (value) => cubit!.loop(),
              ),
            )),
            Expanded(
              child: Center(
                child: NeumorphicButton(
                  padding: EdgeInsets.all(15),
                  onPressed: () {
                    showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(9999));
                  },
                  child: Text(
                    'انتخاب تاریخ',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      SizedBox(height: 40),
      Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Knob(
                      controller: start,
                      style: KnobStyle(
                        labelStyle: TextStyle(color: Colors.transparent),
                        controlStyle: ControlStyle(
                            tickStyle:
                                ControlTickStyle(color: Colors.transparent),
                            glowColor: Colors.transparent,
                            backgroundColor: Color(0xffdde6e8),
                            shadowColor: Color(0xffd4d6dd)),
                        pointerStyle: PointerStyle(color: blue),
                        minorTickStyle:
                            MinorTickStyle(color: Color(0xffaaadba), length: 6),
                        majorTickStyle:
                            MajorTickStyle(color: Color(0xffaaadba), length: 6),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(sv.toString())
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Knob(
                      controller: end,
                      style: KnobStyle(
                        labelStyle: TextStyle(color: Colors.transparent),
                        controlStyle: ControlStyle(
                            tickStyle:
                                ControlTickStyle(color: Colors.transparent),
                            glowColor: Colors.transparent,
                            backgroundColor: Color(0xffdde6e8),
                            shadowColor: Color(0xffd4d6dd)),
                        pointerStyle: PointerStyle(color: blue),
                        minorTickStyle:
                            MinorTickStyle(color: Color(0xffaaadba), length: 6),
                        majorTickStyle:
                            MajorTickStyle(color: Color(0xffaaadba), length: 6),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(ev.toString())
              ],
            ),
          ),
        ],
      ),
      SizedBox(
        height: 10,
      ),
      SizedBox(
        width: 50,
        height: 50,
        child: NeumorphicButton(
          padding: EdgeInsets.all(10),
          onPressed: () {},
          style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
        ),
      ),
      SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 220,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              // title: ChartTitle(text: 'Half yearly sales analysis'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: _tooltip,
              series: <LineSeries<SalesData, String>>[
                LineSeries<SalesData, String>(
                    dataSource: <SalesData>[
                      SalesData('Jan', 99),
                      SalesData('Feb', 28),
                      SalesData('Mar', 88),
                      SalesData('Apr', 32),
                      SalesData('May', 70)
                    ],
                    xValueMapper: (SalesData sales, _) => sales.year,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
        ),
      ),

      divider(),

      ListTile(
        onTap: () => cubit!.status(),
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text('Hub'),
        ),
        leading: NeumorphicSwitch(value: !false),
      ),
      SizedBox(height: 10,),
      ListTile(
        onTap: () => cubit!.status(),
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text('Add device'),
        ),
        leading: NeumorphicButton(
          style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
          child: Icon(Icons.add, color: blue,), onPressed: () {},),
      ),SizedBox(height: 10),
      ListTile(
        onTap: () => cubit!.status(),
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text('Remove device'),
        ),
        leading: NeumorphicButton(
          style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
          child: Icon(Icons.clear, color: blue,), onPressed: () {},),
      ),
    ]);
  });
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

///
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
            child: Knob(
          style: KnobStyle(
            controlStyle: ControlStyle(
                tickStyle: ControlTickStyle(color: Colors.transparent),
                glowColor: Colors.transparent,
                backgroundColor: Color(0xffdde6e8),
                shadowColor: Color(0xffd4d6dd)),
            pointerStyle: PointerStyle(color: blue),
            minorTickStyle: MinorTickStyle(color: Color(0xffaaadba), length: 6),
            majorTickStyle: MajorTickStyle(color: Color(0xffaaadba), length: 6),
          ),
        ) //VolumeKnob(),
            ),
      ),
    );
  }
}

class VolumeKnob extends StatefulWidget {
  const VolumeKnob({Key? key}) : super(key: key);

  @override
  _VolumeKnobState createState() => _VolumeKnobState();
}

class _VolumeKnobState extends State<VolumeKnob> {
  double _angle = -math.pi / 2; // initial angle of the knob
  double _value = 0.5; // initial value of the volume

  void _updateAngle(Offset delta) {
    // calculate the new angle based on the drag delta
    final double radians = math.atan2(delta.dy, delta.dx);
    setState(() {
      //   _angle = radians;
      _angle = (radians / (math.pi / 36)).round() * (math.pi / 36);

      // map the angle to a value between 0 and 1
      _value = (radians + math.pi / 2) / math.pi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => _updateAngle(details.delta),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
            boxShadow: [
              BoxShadow(
                  color: Colors.black38, offset: Offset(4, 4), blurRadius: 5),
              BoxShadow(
                  color: Colors.white, offset: Offset(-4, -4), blurRadius: 5),
            ]),
        child: Stack(children: [
          // draw a circle to show the volume level
          Center(
              child: CircularProgressIndicator(
            value: _value,
            color: _value > 0.5 ? Colors.green : Colors.red,
            strokeWidth: 20,
          )),
          // draw a pointer to indicate the knob position
          Transform.rotate(
              angle: _angle,
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      width: 10,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(5),
                      )))),
        ]),
      ),
    );
  }
}
