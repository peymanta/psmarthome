import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../colors.dart';
import '../main.dart';
import '../relay/relay.dart' as relay;
import 'package:persian_datetime_picker/persian_datetime_picker.dart' as date;
import 'bloc/outlet_cubit.dart';

OutletCubit? _cubit;
bool timerUP = false, timerDown = false, infinityUp = false, infinityDown = false;
DateTime? startUpTime = DateTime.now(), endUpTime = DateTime.now(), startDownTime = DateTime.now(), endDownTime = DateTime.now();
date.Jalali? startUpDate, endUpDate, startDownDate, endDownDate;
String selectedUpStartDate = '', selectedUpEndDate = '', selectedDownStartDate = '', selectedDownEndDate = '';
bool? plugUP, plugDOWN, ///for timer switch
 upActive, downActive, ///for switch
    waterLeakPlug;

enum PlugNumber { plug1, plug2 }

bool isSwitchUP = false, isSwitchDOWN = false; ///for animated opacity

var currentPlug;

class Outlet extends StatefulWidget {
  const Outlet({Key? key}) : super(key: key);

  @override
  State<Outlet> createState() => _OutletState();
}

class _OutletState extends State<Outlet> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = OutletCubit();

    _cubit!.init(currentPlug == PlugNumber.plug1 ? deviceStatus.getPLug1 : deviceStatus.getPlug2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OutletCubit, OutletState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is OutletInitial) {
          return
              // Directionality(
              // textDirection: TextDirection.rtl,
              // child:
              Scaffold(
            appBar: AppBar(
              backgroundColor: background,
              shadowColor: Colors.transparent,
              iconTheme: IconThemeData(color: Colors.black),
            ),
            body: Container(
              color: background,
              height: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      option(context, true),
                      divider(),
                      option(context, false),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text('connected'))),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Wireless Status:'))),
                        ],
                      ),
                      SizedBox(height: 20),
                      ListTile(
                          onTap: () => _cubit!.changeActive(true, currentPlug == PlugNumber.plug1 ? deviceStatus.plug1 : deviceStatus.plug2),
                          title: Container(
                            alignment: Alignment.centerLeft,
                            child: Text('UP Active'),
                          ),
                          leading: NeumorphicSwitch(value: upActive!)),
                      SizedBox(height: 10),
                      ListTile(
                        onTap: () => _cubit!.changeActive(false, currentPlug == PlugNumber.plug1 ? deviceStatus.plug1 : deviceStatus.plug2),
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Down Active'),
                        ),
                        leading: NeumorphicSwitch(value: downActive!),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        onTap: () {},
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Add device'),
                        ),
                        leading: NeumorphicButton(
                          style: NeumorphicStyle(
                              boxShape: NeumorphicBoxShape.circle()),
                          child: Icon(
                            Icons.add,
                            color: blue,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        onTap: () {},
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Remove device'),
                        ),
                        leading: NeumorphicButton(
                          style: NeumorphicStyle(
                              boxShape: NeumorphicBoxShape.circle()),
                          child: Icon(
                            Icons.clear,
                            color: blue,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      divider(),
                      ListTile(
                        onTap: () => _cubit!.waterLeakageStatus(),
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Water leak detector'),
                        ),
                        leading: NeumorphicSwitch(value: waterLeakPlug!),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(currentPlug == PlugNumber.plug1 ? deviceStatus.publicReport.waterLeakagePlug1 : deviceStatus.publicReport.waterLeakagePlug2))),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text('Status'))),
                        ],
                      ),
                    ],
                  )),
            ),
          );
        } else
          return Container();
      },
    );
  }
}

Widget option(context, bool isUp) {
  return StatefulBuilder(builder: (context, setState) {
    return Column(
      children: [
        Column(
          children: [
            ListTile(
              onTap: () => _cubit!.status(isUp, true),
              title: Container(
                alignment: Alignment.centerLeft,
                child: Text(isUp == true ? 'UP' : 'DOWN'),
              ),
              leading: SizedBox(
                width: 100,
                height: 100,
                child: NeumorphicRadio(
                    onChanged: (v) => _cubit!.status(isUp, true),
                    style: NeumorphicRadioStyle(
                        boxShape: NeumorphicBoxShape.circle(),
                        selectedColor: blue),
                    groupValue: isUp == true ? isSwitchUP : isSwitchDOWN,
                    value: true),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              onTap: () => _cubit!.status(isUp, false),
              title: Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Timing Active')),
              leading: SizedBox(
                width: 100,
                height: 100,
                child: NeumorphicRadio(
                    onChanged: (v) => _cubit!.status(isUp, false),
                    style: NeumorphicRadioStyle(
                        boxShape: NeumorphicBoxShape.circle(),
                        selectedColor: blue),
                    groupValue: isUp == true ? isSwitchUP : isSwitchDOWN,
                    value: false),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        AnimatedOpacity(
          curve: Curves.linear,
          opacity: isUp ? (!isSwitchUP ? 1 : 0) : (!isSwitchDOWN ? 1 : 0),
          duration: Duration(milliseconds: 600),
          child: AnimatedContainer(
              duration: Duration(milliseconds: 600),
              height:
                  isUp ? (!isSwitchUP ? 450 : 0) : (!isSwitchDOWN ? 450 : 0),
              child: Column(children: [
                relay.listItemSwitch(
                    'Timer', () => _cubit!.timerChangeStatus(isUp), isUp ? timerUP : timerDown),

                SizedBox(
                  height: 20,
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
                                if(isUp) endUpTime = time;
                                else endDownTime = time;
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

                                if(isUp) startUpTime = time;
                                else startDownTime = time;
                                print(startUpTime);},
                              time: DateTime.now(),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                ///selected dates
                SizedBox(height: 5),
                Container(
                    alignment: Alignment.centerRight,
                    child: Text(isUp ? selectedUpStartDate : selectedDownStartDate)),
                SizedBox(height: 5),
                Container(
                    alignment: Alignment.centerRight,
                    child: Text(isUp ? selectedUpEndDate : selectedDownEndDate)),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: NeumorphicButton(
                            padding: EdgeInsets.all(15),
                            onPressed: () async {
                              var output = await date.showPersianDatePicker(
                                  context: context,
                                  initialDate: date.Jalali.now(),
                                  firstDate: date.Jalali.now(),
                                  lastDate: date.Jalali(3099));
                              if(isUp) endUpDate = output;
                              else endDownDate = output;

                              setState(() {
                                if(isUp) {
                                  selectedUpEndDate =
                                  'تاریخ پایان انتخاب شده: ${endUpDate!.year}/${endUpDate!.month}/${endUpDate!.day}';
                                } else {
                                  selectedDownEndDate =
                                  'تاریخ پایان انتخاب شده: ${endDownDate!.year}/${endDownDate!.month}/${endDownDate!.day}';
                                }
                              });
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
                                        boxShape: NeumorphicBoxShape.circle()),
                                  )))),
                      Expanded(
                          child: Center(
                        child: NeumorphicCheckbox(
                          value: isUp ? infinityUp : infinityDown,
                          onChanged: (value) => _cubit!.loop(isUp),
                        ),
                      )),
                      Expanded(
                        child: Center(
                          child: NeumorphicButton(
                            padding: EdgeInsets.all(15),
                            onPressed: () async {
                              var output = await date.showPersianDatePicker(
                                  context: context,
                                  initialDate: date.Jalali.now(),
                                  firstDate: date.Jalali.now(),
                                  lastDate: date.Jalali(3099));
                              if(isUp) startUpDate = output;
                              else startDownDate = output;

                              setState(() {
                                if(isUp) {
                                  selectedUpStartDate =
                                  'تاریخ شروع انتخاب شده: ${startUpDate!
                                      .year}/${startUpDate!.month}/${startUpDate!
                                      .day}';
                                } else {
                                  selectedDownStartDate =
                                  'تاریخ شروع انتخاب شده: ${startDownDate!
                                      .year}/${startDownDate!.month}/${startDownDate!
                                      .day}';
                                }
                              });
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
              ])),
        ),
        AnimatedOpacity(
            opacity: isUp ? (isSwitchUP ? 1 : 0) : (isSwitchDOWN ? 1 : 0),
            duration: Duration(milliseconds: 600),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 600),
              child: relay.listItemSwitch('Plug Active', () => _cubit!.plug(isUp), isUp ? plugUP : plugDOWN),
            )),
        SizedBox(height: 20),
        NeumorphicButton(
          padding: EdgeInsets.all(20),
          child: Text('ثبت تغییرات'),
          onPressed: () => _cubit!.saveChanges(isUp, currentPlug == PlugNumber.plug1 ? deviceStatus.plug1 : deviceStatus.plug2),
        )
      ],
    );
  });
}

Widget divider() {
  return Column(
    children: [
      SizedBox(
        height: 15,
      ),
      Divider(),
      SizedBox(
        height: 15,
      ),
    ],
  );
}
