import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:shome/colors.dart';

import '../outlet/OutletPage.dart';
import 'bloc/settings_cubit.dart';

enum TaskEnum {
  Home,
  Sleep,
  Rest
}

SettingsCubit? _cubit;
TaskEnum? task = TaskEnum.Home; //example

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
          if(state is SettingsInitial) {
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
                  button(() {}, 'Set Time (SMS)'),
                  button(() {}, 'Set Time (NTP)'),
                  divider(),
                  listItemSwitch('Buzzer', () {}, true),
                  listItemSwitch('View', () {}, false),
                  button(() {}, 'Log'),
                  divider(),
                  listItemText('Report'),
                  listItemSwitch('Public Report', () {}, true),
                  TimePickerSpinner(
                    isForce2Digits: true,
                    is24HourMode: true,
                    time: DateTime.now(),
                  ),
                  SizedBox(height: 10),
                  Center(
                      child: NeumorphicButton(
                        padding: const EdgeInsets.fromLTRB(60, 10, 60, 10),
                        onPressed: () {},
                        child: Text('ارسال'),
                      )),
                  divider(),
                  listItemText('Task'),
                  listItemSwitch('Home', () => _cubit!.changeTask(TaskEnum.Home), task! == TaskEnum.Home),
                  listItemSwitch('Sleep', () => _cubit!.changeTask(TaskEnum.Sleep), task! == TaskEnum.Sleep),
                  listItemSwitch('Rest', () => _cubit!.changeTask(TaskEnum.Rest), task! == TaskEnum.Rest),
                  divider(),
                  button((){}, 'Default Setting'),
                  button((){}, 'Rest Device'),
                  button((){}, 'Rest GSM'),
                  listItemSwitch('Short SMS', () {}, true),
                  listItemSwitch('Remote Control', () {}, true),
                  divider(),

                  listItemPhone('Phone number 1', '0912XXXXXXX'),
                  listItemPhone('Phone number 2', '0938XXXXXXX'),
                  listItemPhone('Phone number 3', '0920XXXXXXX'),


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
  return Column(
    children: [
      ListTile(
        onTap: onPressed,
        title: Container(
          alignment: Alignment.centerLeft,
          child:
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
        ),
        leading: NeumorphicSwitch(value: value),
      ),
      SizedBox(height: 10),
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

Widget listItemPhone(subject, status) {
  return Column(
    children: [
      MaterialButton(
        onPressed: () {},
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
