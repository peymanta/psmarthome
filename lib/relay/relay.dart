import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:knob_widget/knob_widget.dart';
import 'package:shome/colors.dart';
import 'package:shome/outlet/OutletPage.dart';

import 'bloc/relay_cubit.dart';

RelayCubit? _cubit;
Status? statusOfRelay = Status.sw;
bool infinity = false;

String _4image = 'assets/icons/question.png';

enum Page { Relay1, Relay2, Relay3, Relay4, Relay5, Relay6, Relay7 }

Page? currentPage;

class Relay extends StatefulWidget {
  const Relay({Key? key}) : super(key: key);

  @override
  State<Relay> createState() => _RelayState();
}

class _RelayState extends State<Relay> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = RelayCubit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RelayCubit, RelayState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is RelayInitial) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: NeumorphicColors.background,
              appBar: AppBar(
                  backgroundColor: NeumorphicColors.background,
                  shadowColor: Colors.transparent,
                  title: Text(currentPage == Page.Relay1 ? '1': currentPage == Page.Relay2 ? '2':currentPage == Page.Relay3 ? '3':currentPage == Page.Relay4 ? '4':currentPage == Page.Relay5 ? '5': currentPage == Page.Relay6? '6' : '7', style: TextStyle(color: Colors.black),),
                  iconTheme: IconThemeData(color: Colors.black)),
              body: Container(
                color: NeumorphicColors.background,
                padding: EdgeInsets.all(20),
                child:  currentPage == Page.Relay3
                        ? Relay3()
                        : currentPage == Page.Relay4
                            ? Relay4()
                            : currentPage == Page.Relay7
                                ? Relay7()
                                : Relays(),
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

Widget Relay3() {
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
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        ListTile(
          onTap: () => _cubit!.changeStatus(Status.sw),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text('Switch'),
          ),
          leading: NeumorphicSwitch(value: statusOfRelay == Status.sw),
        ),
        SizedBox(
          height: 10,
        ),
        ListTile(
          onTap: () => _cubit!.changeStatus(Status.timer),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text('Timer'),
          ),
          leading: NeumorphicSwitch(value: statusOfRelay == Status.timer),
        ),
        SizedBox(
          height: 10,
        ),
        ListTile(
          onTap: () => _cubit!.changeStatus(Status.sensor),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text('Humidity'),
          ),
          leading: NeumorphicSwitch(value: statusOfRelay == Status.sensor),
        ),
        SizedBox(height: 30),
        AnimatedOpacity(
          opacity: statusOfRelay != Status.timer ? 0 : 1,
          duration: Duration(milliseconds: 600),
          child: AnimatedContainer(
            height: statusOfRelay != Status.timer ? 0.01 : 300,
            curve: Curves.linear,
            duration: Duration(milliseconds: 200),
            child: AspectRatio(
              aspectRatio: 18.5 / 9,
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
                                  // cubit!.status();
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
                              onPressed: () {
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(9999));
                              },
                              child: const Text(
                                'انتخاب تاریخ',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        Center(
          child: NeumorphicButton(
            onPressed: () {},
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text('ثبت تغییرات'),
            ),
          ),
        ),
        AnimatedOpacity(
            opacity: statusOfRelay != Status.sensor ? 0 : 1,
            duration: Duration(milliseconds: 600),
            child: AnimatedContainer(
                height: statusOfRelay != Status.sensor ? 0.01 : 350,
                curve: Curves.linear,
                duration: Duration(milliseconds: 200),
                child: AspectRatio(
                    aspectRatio: 18.5 / 9,
                    child: Column(children: [
                      divider(),
                      Center(
                          child: Text('Set Humidity',
                              style: TextStyle(fontSize: 15),
                              textDirection: TextDirection.ltr)),
                      SizedBox(
                        height: 30,
                      ),
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
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: SizedBox(
                              width: 50,
                              height: 50,
                              child: NeumorphicButton(
                                onPressed: () {},
                                style: NeumorphicStyle(
                                    boxShape: NeumorphicBoxShape.circle()),
                              ))),
                    ])))),
        divider(),
        listItemSwitch(
            'Current sensor',
            () => _cubit!.changeStatus(Status.sensor),
            statusOfRelay == Status.sensor),
        listItemText('Status', 'Overload! -off'),
        divider(),
        listItemSwitch('Switch 3 Active', () {}, true)
      ],
    );
  });
}

Widget Relay7() {
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
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        ListTile(
          onTap: () => _cubit!.changeStatus(Status.sw),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text('Switch'),
          ),
          leading: NeumorphicSwitch(value: statusOfRelay == Status.sw),
        ),
        SizedBox(
          height: 10,
        ),
        ListTile(
          onTap: () => _cubit!.changeStatus(Status.timer),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text('Timer'),
          ),
          leading: NeumorphicSwitch(value: statusOfRelay == Status.timer),
        ),
        SizedBox(
          height: 10,
        ),
        ListTile(
          onTap: () => _cubit!.changeStatus(Status.sensor),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text('Lighting'),
          ),
          leading: NeumorphicSwitch(value: statusOfRelay == Status.sensor),
        ),
        SizedBox(height: 30),

        //timer
        AnimatedOpacity(
          opacity: statusOfRelay != Status.timer ? 0 : 1,
          duration: Duration(milliseconds: 600),
          child: AnimatedContainer(
            height: statusOfRelay != Status.timer ? 0.01 : 300,
            curve: Curves.linear,
            duration: Duration(milliseconds: 200),
            child: AspectRatio(
              aspectRatio: 18.5 / 9,
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
                                  // cubit!.status();
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
                              onPressed: () {
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(9999));
                              },
                              child: const Text(
                                'انتخاب تاریخ',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        AnimatedOpacity(
            opacity: statusOfRelay != Status.sensor ? 0 : 1,
            duration: Duration(milliseconds: 600),
            child: AnimatedContainer(
                height: statusOfRelay != Status.sensor ? 0.01 : 350,
                curve: Curves.linear,
                duration: Duration(milliseconds: 200),
                child: AspectRatio(
                    aspectRatio: 18.5 / 9,
                    child: Column(children: [
                      divider(),
                      Center(
                          child: Text('Set Lighting',
                              style: TextStyle(fontSize: 15),
                              textDirection: TextDirection.ltr)),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Knob(
                            controller: end,
                            style: KnobStyle(
                              labelStyle:
                                  const TextStyle(color: Colors.transparent),
                              controlStyle: const ControlStyle(
                                  tickStyle: ControlTickStyle(
                                      color: Colors.transparent),
                                  glowColor: Colors.transparent,
                                  backgroundColor: Color(0xffdde6e8),
                                  shadowColor: Color(0xffd4d6dd)),
                              pointerStyle: PointerStyle(color: blue),
                              minorTickStyle: const MinorTickStyle(
                                  color: Color(0xffaaadba), length: 6),
                              majorTickStyle: const MajorTickStyle(
                                  color: Color(0xffaaadba), length: 6),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(child: Text(ev.toString())),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                          child: SizedBox(
                              width: 50,
                              height: 50,
                              child: NeumorphicButton(
                                onPressed: () {},
                                style: NeumorphicStyle(
                                    boxShape: NeumorphicBoxShape.circle()),
                              ))),
                    ])))),
        SizedBox(height: 30),
        Center(
          child: NeumorphicButton(
            onPressed: () {},
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text('ثبت تغییرات'),
            ),
          ),
        ),
        divider(),

        listItemSwitch(
            'Switch 7 Active',
            () => _cubit!.changeStatus(Status.sensor),
            statusOfRelay == Status.sensor),
      ],
    );
  });
}

Widget Relays() {
  return StatefulBuilder(builder: (context, setState) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        ListTile(
          onTap: () => _cubit!.changeStatus(Status.sw),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text('Switch'),
          ),
          leading: NeumorphicSwitch(value: statusOfRelay == Status.sw),
        ),
        SizedBox(
          height: 10,
        ),
        ListTile(
          onTap: () => _cubit!.changeStatus(Status.timer),
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text('Timer'),
          ),
          leading: NeumorphicSwitch(value: statusOfRelay == Status.timer),
        ),

        SizedBox(height: 30),

        //timer
        AnimatedOpacity(
          opacity: statusOfRelay != Status.timer ? 0 : 1,
          duration: Duration(milliseconds: 600),
          child: AnimatedContainer(
            height: statusOfRelay != Status.timer ? 0.01 : 300,
            curve: Curves.linear,
            duration: Duration(milliseconds: 200),
            child: AspectRatio(
              aspectRatio: 18.5 / 9,
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
                                  // cubit!.status();
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
                              onPressed: () {
                                showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(9999));
                              },
                              child: const Text(
                                'انتخاب تاریخ',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Center(
          child: NeumorphicButton(
            onPressed: () {},
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text('ثبت تغییرات'),
            ),
          ),
        ),
        ///only visible when relay 1 or 6 opened
        Visibility(
          visible: currentPage == Page.Relay1 || currentPage == Page.Relay6 ,
          child: Column(
            children: [
              divider(),

              listItemSwitch(
                  'Current sensor',
                  () => _cubit!.changeStatus(Status.sensor),
                  statusOfRelay == Status.sensor),
              listItemText('Status', 'working'),
            ],
          ),
        ),

        divider(),

        listItemSwitch(
            'Switch ${currentPage == Page.Relay1 ? '1': currentPage == Page.Relay2 ? '2': currentPage == Page.Relay5? '5' : '6'}', () {}, true)
      ],
    );
  });
}

Widget listItemSwitch(name, onPressed, value) {
  return ListTile(
    onTap: () => onPressed,
    title: Container(
      alignment: Alignment.centerLeft,
      child: Text(name),
    ),
    leading: NeumorphicSwitch(value: value),
  );
}

Widget listItemText(subject, status) {
  return Padding(
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
  );
}

Widget Relay4() {
  return Column(
    children: [
      SizedBox(
        height: 400,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 90),
              child: Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: NeumorphicButton(
                      onPressed: () {},
                      style: NeumorphicStyle(
                          boxShape: NeumorphicBoxShape.circle(),
                          shape: NeumorphicShape.convex)),
                ),
              ),
            ),
            Positioned(
              right: 10,
              child: SizedBox(
                width: 220,
                height: 110,
                child: MaterialButton(
                  onPressed: (){},
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: blue)),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(13),
                          child: Image.asset(_4image),
                        ),
                        Expanded(child: Text('میتوانید عکس پیشفرض این سوییچ را تغییر دهید')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],),
      ),

       Column(children: [
        divider(),
        listItemSwitch('Switch 4 Active', () {}, true)
       ],
       )
    ],
  );
}
