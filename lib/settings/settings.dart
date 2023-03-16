import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:shome/colors.dart';
import 'package:shome/main.dart';

import '../outlet/OutletPage.dart';
import 'bloc/settings_cubit.dart';

enum TaskEnum { Home, Sleep, Rest }

SettingsCubit? _cubit;
TaskEnum? task = TaskEnum.Home; //example
bool? buzzer, view, publicReport, shortSMS, remoteControl;
String? num1, num2, num3;
DateTime? selectedTime;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = SettingsCubit();
    _cubit!.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: background,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is SettingsInitial) {
            return Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.all(20),
                color: background,
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  children: [
                    listItemText('Time'),
                    button(() => _cubit!.setTime(), 'Set Time (SMS)'),
                    button(() => _cubit!.setTimeNTP(), 'Set Time (NTP)'),
                    divider(),
                    listItemSwitch(
                        'Buzzer', () => _cubit!.setBuzzer(), buzzer!),
                    listItemSwitch('View', () => _cubit!.setView(), view),
                    button(() => _cubit!.setLog(), 'Log'),
                    divider(),
                    listItemText('Report'),
                    listItemSwitch('Public Report',
                        () => _cubit!.setPublicReport(), publicReport!),
                    publicReport!
                        ? AnimatedContainer(
                            curve: Curves.easeInOut,
                            duration: Duration(milliseconds: 600),
                            height: publicReport! ? 250 : 0,
                            child: Column(
                              children: [
                                Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: TimePickerSpinner(
                                    isForce2Digits: true,
                                    is24HourMode: true,
                                    time: DateTime
                                        .now(), //DateTime(0,0,0, int.parse(constants.get('publicreportTimer').substring(1,3) ?? DateTime.now().hour), int.parse(constants.get('publicreportTimer').substring(3)?? DateTime.now().minute)),
                                    onTimeChange: (DateTime event) {
                                      setState(() {
                                        selectedTime = event;
                                      });
                                    },
                                  ),
                                ),
                                SizedBox(height: 10),
                                Center(
                                    child: NeumorphicButton(
                                  padding:
                                      const EdgeInsets.fromLTRB(60, 10, 60, 10),
                                  onPressed: () => _cubit!.submitClock(),
                                  child: Text('Send'),
                                )),
                              ],
                            ),
                          )
                        : Container(),
                    divider(),
                    listItemText('Task'),
                    listItemSwitch('Home', () => _cubit!.setHome(),
                        task! == TaskEnum.Home),
                    listItemSwitch('Sleep', () => _cubit!.setSleep(),
                        task! == TaskEnum.Sleep),
                    listItemSwitch('Rest', () => _cubit!.setResting(),
                        task! == TaskEnum.Rest),
                    divider(),
                    button(
                        () => _cubit!.setDefaultSetting(), 'Default Setting'),
                    button(() => _cubit!.setResting(), 'Rest Device'),
                    button(() => _cubit!.restGSM(), 'Rest GSM'),
                    listItemSwitch('Short SMS', () {}, true),
                    listItemSwitch('Remote Control',
                        () => _cubit!.setRemoteControl(), remoteControl),
                    divider(),
                    listItemPhone('Phone number 1', num1 ?? '0912XXXXXXX',
                        () => _cubit!.getNumber(1)),
                    listItemPhone('Phone number 2', num2 ?? '0912XXXXXXX',
                        () => _cubit!.getNumber(2)),
                    listItemPhone('Phone number 3', num3 ?? '021XXXXXXXX',
                        () => _cubit!.getNumber(3)),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
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

Widget listItemSwitch(name, onPressed, value) {
  return MaterialButton(
    onPressed: onPressed,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(13, 0, 13, 0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerRight,
                    height: 40,
                    child: Switch(
                      value: value,
                      onChanged: (bool value) {
                    onPressed;
                      },
                    )),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  height: 40,
                  child: Text(name,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    ),
  );
}

Widget listItemText(text) {
  return Column(
    children: [
      Padding(
          padding: const EdgeInsets.all(15),
          child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: TextStyle(fontSize: 12),
              ))),
      SizedBox(
        height: 20,
      )
    ],
  );
}

Widget listItemPhone(subject, status, onPressed) {
  return Column(
    children: [
      MaterialButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Expanded(
                  child: Container(
                      alignment: Alignment.centerRight, child: Text(status))),
              Expanded(
                  child: Container(
                      alignment: Alignment.centerLeft, child: Text(subject))),
            ],
          ),
        ),
      ),
      SizedBox(height: 10)
    ],
  );
}
