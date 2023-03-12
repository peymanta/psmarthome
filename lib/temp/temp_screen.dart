import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:knob_widget/knob_widget.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shome/colors.dart';
import 'package:shome/outlet/OutletPage.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart' as date;

import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'package:syncfusion_flutter_charts/charts.dart';

import '../compiling_sms.dart';
import '../main.dart';
import '../models/status.dart';
import 'bloc/heater_cubit.dart';
import 'bloc/temp_cubit.dart';

TempCubit? _cubit;
bool automatic = true, infinity = false;
bool? isCooler, timer, isSwitch, rest, available; // for add or remove device
TooltipBehavior? _tooltip;

double? endMin;
int? sv = 16, ev = 16;
KnobController? start; ///start also using for light
KnobController? end;

Jalali startTime = Jalali.now();
Jalali endTime = Jalali.now();
date.Jalali? startdate;
date.Jalali? enddate;
String selectedStartDate = '';
String selectedEndDate = '';

bool pads=false, hub=false;

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
    _cubit = TempCubit();
    _tooltip = TooltipBehavior();

    _cubit!.init();
  }

  @override
  Widget build(BuildContext context) {
    // return MyApp();
    return BlocBuilder<TempCubit, TempState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is TempInitial) {
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
                child: actulator(_cubit, context, cooler: true),
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
    _cubit = TempCubit();
    _tooltip = TooltipBehavior();
  }

  @override
  Widget build(BuildContext context) {
    // return MyApp();
    return BlocBuilder<TempCubit, TempState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is TempInitial) {
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
                child: actulator(_cubit, context, cooler: false),
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

  start = KnobController(
      minimum: 16,
      maximum: 28, initial: cooler ? double.parse(deviceStatus.getCooler.tempMin).clamp(16, 28) : double.parse(deviceStatus.getHeater.tempMax).clamp(16, 28));
  end = KnobController(
      minimum: 16, //5 endmin+4 or 9
      maximum: 32, //95
      initial: cooler ? int.parse(deviceStatus.getCooler.tempMin).clamp(16, 32).toDouble() : int.parse(deviceStatus.getHeater.tempMax).clamp(16, 32).toDouble()
      );

  return StatefulBuilder(builder: (context, setState) {
    start!.addOnValueChangedListener((double value) {
      setState(() {
        sv = value.toInt();
        endMin = value  <= 32 ? value  : 32;

        ev = endMin!.toInt(); //value.roundToDouble();
      });
      end = KnobController(
          minimum: endMin!,
          maximum: 32,
          initial: endMin!
              .clamp(endMin!, 32));
    });

    end!.addOnValueChangedListener((p) {
      setState(() {
        ev = p.toInt();
      });
    });
    return ListView(physics: ClampingScrollPhysics(), children: [
      Column(
        children: [

          ListTile(
            onTap: () => cubit!.status(),
            title: Container(
                alignment: Alignment.centerLeft,
                child: Text('Automatic ${cooler ? 'cooler' : 'heater'}')),
            // leading: NeumorphicSwitch(value: automatic),
          leading: NeumorphicSwitch(
            value: automatic,
          ),
          ),
          ListTile(
            onTap: () => cubit!.changeRest(),
            title: Container(
                alignment: Alignment.centerLeft,
                child: Text('${cooler ? 'Cooler' : 'Heater'} Rest')),
            // leading: NeumorphicSwitch(value: automatic),
          leading: NeumorphicSwitch(
            value: rest!,
          ),
          ),
          ListTile(
            onTap: () {
              setState(() {
                pads = !pads;
                sendSMS('hello');
              });
            },
            title: Container(
                alignment: Alignment.centerLeft,
                child: Text('Pads')),
            // leading: NeumorphicSwitch(value: automatic),
          leading: NeumorphicSwitch(
            value: pads,
          ),
          ),
        ],
      ),
      SizedBox(
        height: 30,
      ),
        AnimatedOpacity(
        opacity: automatic ? 1 : 0,
    duration: Duration(milliseconds: 600),
    child: AnimatedContainer(
    height: automatic ? 770 : 0,
    duration: Duration(milliseconds: 600),
        child: Column(
          children: [
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
                            endTime = Jalali.fromDateTime(time);
                          },
                          time: endTime!.toDateTime(),
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
                            startTime = Jalali.fromDateTime(time);
                          },
                          time: startTime!.toDateTime(),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),SizedBox(height: 15),
            Container(alignment: Alignment.centerRight, child: Text(selectedStartDate)),
            SizedBox(height: 10,),
            Container(alignment: Alignment.centerRight, child: Text(selectedEndDate)),

            SizedBox(height: 15),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: NeumorphicButton(
                        padding: EdgeInsets.all(15),
                        onPressed: () async {
                          enddate = await date.showPersianDatePicker(
                              context: context,
                              initialDate: date.Jalali.now(),
                              firstDate: date.Jalali.now(),
                              lastDate: date.Jalali(3099));
                          setState(() => selectedEndDate =
                          'تاریخ پایان انتخاب شده: ${enddate!.year}/${enddate!.month}/${enddate!.day}');
                        },
                        child: Center(
                          child: const Text(
                            'انتخاب تاریخ پایان',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Center(
                          child: SizedBox(
                              width: 50,
                              height: 50,
                              child: NeumorphicButton(
                                onPressed: () {},
                                style: NeumorphicStyle(
                                    boxShape:
                                    NeumorphicBoxShape.circle()),
                              )))),
                  Expanded(
                      child: Center(
                        child: NeumorphicCheckbox(
                          value: infinity,
                          onChanged: (value) => _cubit!.loop(),
                        ),
                      )),
                  Expanded(
                    child: Center(
                      child: NeumorphicButton(
                        padding: EdgeInsets.all(15),
                        onPressed: () async {
                          startdate = await date.showPersianDatePicker(
                              context: context,
                              initialDate: date.Jalali.now(),
                              firstDate: date.Jalali.now(),
                              lastDate: date.Jalali(3099));
                          setState(() => selectedStartDate =
                          'تاریخ شروع انتخاب شده: ${startdate!.year}/${startdate!.month}/${startdate!.day}');
                        },
                        child: Center(
                          child: const Text(
                            'انتخاب تاریخ شروع',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

        SizedBox(height: 20,),
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
                            controller: end,
                            style: KnobStyle(
                              labelStyle: const TextStyle(
                                  color: Colors.transparent),
                              controlStyle: const ControlStyle(
                                  tickStyle: ControlTickStyle(
                                      color: Colors.transparent),
                                  glowColor: Colors.transparent,
                                  backgroundColor: Color(0xffdde6e8),
                                  shadowColor: Color(0xffd4d6dd)),
                              pointerStyle: PointerStyle(color: blue),
                              minorTickStyle: const MinorTickStyle(
                                  color: Color(0xffaaadba),
                                  length: 6),
                              majorTickStyle: const MajorTickStyle(
                                  color: Color(0xffaaadba),
                                  length: 6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(ev.toString()),
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
                              controller: start,
                              style: KnobStyle(
                                labelStyle: TextStyle(
                                    color: Colors.transparent),
                                controlStyle: ControlStyle(
                                    tickStyle: ControlTickStyle(
                                        color: Colors.transparent),
                                    glowColor: Colors.transparent,
                                    backgroundColor: Color(0xffdde6e8),
                                    shadowColor: Color(0xffd4d6dd)),
                                pointerStyle: PointerStyle(color: blue),
                                minorTickStyle: MinorTickStyle(
                                    color: Color(0xffaaadba),
                                    length: 6),
                                majorTickStyle: MajorTickStyle(
                                    color: Color(0xffaaadba),
                                    length: 6),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(sv.toString())
                      ],
                    )
                ),
              ],
            ),SizedBox(
          height: 20,
        ),
        Center(
          child: NeumorphicButton(
            onPressed: () => _cubit!.submitData(),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text('ثبت تغییرات'),),),
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

      ],
    ),
      ),),

      SizedBox(
        height: 10,
      ),
      SizedBox(
        height: 220,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              legend: Legend(isVisible: false),
              tooltipBehavior: _tooltip,
              series: <LineSeries>[
                LineSeries(
                    dataSource: tempBox.values.toList(),
                    xValueMapper: (data, _) => data.x,
                    yValueMapper: (data, _) => data.y,
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
        ),
      ),

      divider(),

      ListTile(
        onTap: () {
          setState((){
            hub = !hub;
            sendSMS('hello');
          });
        },
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text('Hub'),
        ),
        leading: NeumorphicSwitch(value: hub),
      ),
      SizedBox(height: 10,),
      ListTile(
        onTap: () => cubit!.addDevice(),
        title: Container(
          alignment: Alignment.centerLeft,
          child: Text('Add device'),
        ),
        leading: NeumorphicButton(
          style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
          child: Icon(Icons.add, color: blue,), onPressed: () {},),
      ),SizedBox(height: 10),
      ListTile(
        onTap: () => cubit!.removeDevice(),
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
