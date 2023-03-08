import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import '../colors.dart';
import 'bloc/outlet_cubit.dart';

OutletCubit? _cubit;
bool timer = false, infinity = false;

enum PlugNumber {
  plug1, plug2
}

var currentPlug;

var endTime;

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
                        onTap: () => _cubit!.status(),
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('UP Active'),
                        ),
                        leading: NeumorphicSwitch(value: !timer),
                      ),
                      SizedBox(height: 10),
                      ListTile(
                        onTap: () => _cubit!.status(),
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Down Active'),
                        ),
                        leading: NeumorphicSwitch(value: !timer),
                      ),SizedBox(height: 10),
                      ListTile(
                        onTap: () => _cubit!.status(),
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Add device'),
                        ),
                        leading: NeumorphicButton(
                          style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
                          child: Icon(Icons.add, color: blue,), onPressed: () {},),
                      ),SizedBox(height: 10),
                      ListTile(
                        onTap: () => _cubit!.status(),
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Remove device'),
                        ),
                        leading: NeumorphicButton(
                          style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
                          child: Icon(Icons.clear, color: blue,), onPressed: () {},),
                      ),
                      divider(),
                      ListTile(
                        onTap: () => _cubit!.status(),
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Water leak detector'),
                        ),
                        leading: NeumorphicSwitch(value: !timer),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text('true'))),
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

Widget option(context, up) {
  return Column(
    children: [
      Column(
        children: [
          ListTile(
            onTap: () => _cubit!.status(),
            title: Container(
              alignment: Alignment.centerLeft,
              child: Text(up ? 'UP' : 'DOWN'),
            ),
            leading: NeumorphicSwitch(value: !timer),
          ),
          SizedBox(
            height: 10,
          ),
          ListTile(
            onTap: () => _cubit!.status(),
            title: Container(
                alignment: Alignment.centerLeft, child: Text('Timing Active')),
            leading: NeumorphicSwitch(value: timer),
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
                      _cubit!.status();
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
                      //   _cubit!.status();
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
                onChanged: (value) => _cubit!.loop(),
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
      )
    ],
  );
}

Widget divider () {
  return Column(children: [
    SizedBox(
      height: 15,
    ),
    Divider(),
    SizedBox(
      height: 15,
    ),
  ],);
}