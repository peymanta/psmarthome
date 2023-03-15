import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:knob_widget/knob_widget.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart' as date;
import 'package:shome/colors.dart';
import 'package:shome/outlet/OutletPage.dart';

import '../a.dart' as a;
import '../main.dart';
import 'bloc/relay_cubit.dart';
import 'package:shamsi_date/shamsi_date.dart';

RelayCubit? relayCubit;
Status? statusOfRelay = Status.sw;
bool infinity = false;
bool? relayStatus;

Jalali? startTime;
Jalali? endTime;

date.Jalali? startdate;
date.Jalali? enddate;
String selectedStartDate = '';
String selectedEndDate = '';

bool? sw, sensor, timer, humidity, light;

String? sensorState;

String _4image = 'assets/icons/question.png';

enum Page { Relay1, Relay2, Relay3, Relay4, Relay5, Relay6, Relay7 }

Page? currentPage;

///hum vars
double? endMin;
int? sv, ev;
KnobController? start; ///start also using for light
KnobController? end;


late String pageNumber;

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
    relayCubit = RelayCubit();

    relayCubit!.initRelay();
    pageNumber = currentPage == Page.Relay1
        ? '1'
        : currentPage == Page.Relay2
        ? '2'
        : currentPage == Page.Relay3
        ? '3'
        : currentPage == Page.Relay4
        ? '4'
        : currentPage == Page.Relay5
        ? '5'
        : currentPage == Page.Relay6
        ? '6'
        : '7';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RelayCubit, RelayState>(
      bloc: relayCubit,
      builder: (context, state) {
        if (state is RelayInitial) {
          return Scaffold(
            backgroundColor: NeumorphicColors.background,
            appBar: AppBar(
                backgroundColor: NeumorphicColors.background,
                shadowColor: Colors.transparent,
                title: Text(
                  pageNumber,
                  style: const TextStyle(color: Colors.black),
                ),
                iconTheme: const IconThemeData(color: Colors.black)),
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                color: NeumorphicColors.background,
                padding: const EdgeInsets.all(20),
                child:currentPage == Page.Relay4
                        ? Relay4()
                        :  Relays(),
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

Widget Relays() {
  double rheight = currentPage == Page.Relay2 ? (sw! ? statusOfRelay == Status.sw || statusOfRelay == Status.sensor ? 340 : 750 : 0)
  : currentPage == Page.Relay3 ? (sw! ? statusOfRelay == Status.sw || statusOfRelay == Status.sensor ? 600 : 950 : 0)
  : currentPage == Page.Relay5 ? (sw! ? statusOfRelay == Status.sw || statusOfRelay == Status.sensor ? 350 : 760 : 0)
  : currentPage == Page.Relay6 ? (sw! ? statusOfRelay == Status.sw || statusOfRelay == Status.sensor ? 510 : 870 : 0)
  :(sw! ? statusOfRelay == Status.sw || statusOfRelay == Status.sensor ? 540 : 890 : 0);
  if (currentPage == Page.Relay3) {
    endMin = 0;
    sv = int.parse(deviceStatus.getR3.humMin);
    ev = int.parse(deviceStatus.getR3.humMax);
    start = KnobController(
        minimum: 5, //0
        maximum: 95, //95
        initial:
            endMin!.clamp(double.parse(deviceStatus.getR3.humMin), 95));
    end = KnobController(
        minimum: 9, //5 endmin+4 or 9
        maximum: 95, //95
        initial:
            endMin!.clamp(double.parse(deviceStatus.getR3.humMax), 95));
  }
  else if(currentPage == Page.Relay7) {
    sv = int.parse(deviceStatus.getR7.lux);
    start = KnobController(
        minimum: 1,
        maximum: 50,
        initial: double.parse(deviceStatus.getR7.lux).clamp(1, 50));
  }
  return StatefulBuilder(builder: (context, setState) {
    if (currentPage == Page.Relay3) {
      start!.addOnValueChangedListener((double value) {
        setState(() {
          sv = value.toInt();
          endMin = (value + 5.0) <= 95 ? (value + 5.0) : 95;

          ev = endMin!.toInt(); //value.roundToDouble();
        });
        end = KnobController(
            minimum: endMin!,
            maximum: double.parse(deviceStatus.getR3.humMax),
            initial: endMin!
                .clamp(endMin!, double.parse(deviceStatus.getR3.humMax)));
      });

      end!.addOnValueChangedListener((p) {
        setState(() {
          ev = p.toInt();
        });
      });
    } else if(currentPage == Page.Relay7) {
      start!.addOnValueChangedListener((p) {
        setState(() {
          sv = p.toInt();
        });
      });
    }
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: [
        Directionality(
            textDirection: TextDirection.ltr,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                MaterialButton(onPressed: ()=>relayCubit!.icon(), child: ListTile(leading: Icon(Icons.edit, color: primary), title: const Text('Change Icon'),)),
                currentPage == Page.Relay2 ? MaterialButton(onPressed: ()=>relayCubit!.icon(is2b: true), child: ListTile(leading: Icon(Icons.edit, color: primary), title: const Text('Change Icon bottom'),)) : Container(),
              ],
            )),
        AnimatedOpacity(
          opacity: sw! ? 1 : 0,
          duration: const Duration(milliseconds: 600),
          child: AnimatedContainer(
            height: rheight,
            duration: const Duration(milliseconds: 600),
            child: Column(
              children: [
                ListTile(
                  onTap: () => relayCubit!.changeMode(Status.sw),
                  title: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text('Switch'),
                  ),
                  leading: SizedBox(
                    width: 100,
                    height: 100,
                    child: NeumorphicRadio(
                        onChanged: (v) => relayCubit!.changeMode(v!),
                        style: NeumorphicRadioStyle(
                            selectedColor: blue, boxShape: const NeumorphicBoxShape.circle()),
                        groupValue: statusOfRelay,
                        value: Status.sw),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  onTap: () => relayCubit!.changeMode(Status.timer),
                  title: Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    child: const Text('Timer'),
                  ),
                  leading: SizedBox(
                    width: 100,
                    height: 100,
                    child: NeumorphicRadio(
                        onChanged: (v) => relayCubit!.changeMode(v!),
                        style: NeumorphicRadioStyle(
                            selectedColor: blue, boxShape: const NeumorphicBoxShape.circle()),
                        groupValue: statusOfRelay,
                        value: Status.timer),
                  ),
                ),

                ///humidity only visible when relay 3 opened
                Visibility(
                    visible: currentPage == Page.Relay3 || currentPage == Page.Relay7,
                    child: ListTile(
                      onTap: () => relayCubit!.changeMode(Status.act),
                      title: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        child: Text(currentPage == Page.Relay3 ? 'Humidity' : 'Light'),
                      ),
                      leading: SizedBox(
                        width: 100,
                        height: 100,
                        child: NeumorphicRadio(
                            onChanged: (v) => relayCubit!.changeMode(v!),
                            style: NeumorphicRadioStyle(
                                selectedColor: blue,
                                boxShape: const NeumorphicBoxShape.circle()),
                            groupValue: statusOfRelay,
                            value: Status.act),
                      ),
                    )),

                ///current sensor only visible when relay 1 or 3 or 6 opened
                Visibility(
                    visible: currentPage == Page.Relay1 ||
                        currentPage == Page.Relay3 ||
                        currentPage == Page.Relay6,
                    child: ListTile(
                      onTap: () => relayCubit!.changeMode(Status.sensor),
                      title: Container(
                        height: 80,
                        alignment: Alignment.centerLeft,
                        child: const Text('Current sensor'),
                      ),
                      leading: SizedBox(
                        width: 100,
                        height: 100,
                        child: NeumorphicRadio(
                            onChanged: (v) => relayCubit!.changeMode(v!),
                            style: NeumorphicRadioStyle(
                                selectedColor: blue,
                                boxShape: const NeumorphicBoxShape.circle()),
                            groupValue: statusOfRelay,
                            value: Status.sensor),
                      ),
                    )),

                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: AnimatedOpacity(
                    opacity: statusOfRelay != Status.sw ? 0 : 1,
                    duration: const Duration(milliseconds: 600),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      height: statusOfRelay != Status.sw ? 0.01 : 50,
                      child: ListTile(
                        onTap: () => relayCubit!.relay(),
                        title: const Align(
                            alignment: Alignment.centerLeft, child: Text('Status')),
                        leading: NeumorphicSwitch(
                            onChanged: (v) => relayCubit!.relay(), value: relayStatus!),
                      ),
                    ),
                  ),
                ),

                ///timer
                AnimatedOpacity(
                  opacity: statusOfRelay != Status.timer ? 0 : 1,
                  duration: const Duration(milliseconds: 600),
                  child: AnimatedContainer(
                    height: statusOfRelay != Status.timer ? 0.01 : 480,
                    curve: Curves.linear,
                    duration: const Duration(milliseconds: 200),
                    child: AspectRatio(
                      aspectRatio: 18.5 / 9,
                      child: Column(
                        children: [
                          listItemSwitch(
                              'Timer', () => relayCubit!.timerChangeStatus(), timer!),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text('end time'),
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: TimePickerSpinner(
                                        is24HourMode: true,
                                        isForce2Digits: true,
                                        onTimeChange: (DateTime time) {
                                          endTime = Jalali.fromDateTime(time);
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
                                    const Text('start time'),
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: TimePickerSpinner(
                                        is24HourMode: true,
                                        isForce2Digits: true,
                                        onTimeChange: (DateTime time) {
                                          startTime = Jalali.fromDateTime(time);
                                        },
                                        time: DateTime.now(),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),

                          ///selected dates
                          const SizedBox(height: 5),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(selectedStartDate)),
                          const SizedBox(height: 5),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(selectedEndDate)),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                    child: NeumorphicButton(
                                      padding: const EdgeInsets.all(15),
                                      onPressed: () async {
                                        enddate = await date.showPersianDatePicker(
                                            context: context,
                                            initialDate: date.Jalali.now(),
                                            firstDate: date.Jalali.now(),
                                            lastDate: date.Jalali(3099));
                                        setState(() => selectedEndDate =
                                            'Selected end date: ${enddate!.year}/${enddate!.month}/${enddate!.day}');
                                      },
                                      child: const Center(
                                        child: Text(
                                          'select end date',
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
                                              style: const NeumorphicStyle(
                                                  boxShape:
                                                      NeumorphicBoxShape.circle()),
                                            )))),
                                Expanded(
                                    child: Center(
                                  child: NeumorphicCheckbox(
                                    value: infinity,
                                    onChanged: (value) => relayCubit!.loop(),
                                  ),
                                )),
                                Expanded(
                                  child: Center(
                                    child: NeumorphicButton(
                                      padding: const EdgeInsets.all(15),
                                      onPressed: () async {
                                        startdate = await date.showPersianDatePicker(
                                            context: context,
                                            initialDate: date.Jalali.now(),
                                            firstDate: date.Jalali.now(),
                                            lastDate: date.Jalali(3099));
                                        setState(() => selectedStartDate =
                                            'Selected start date: ${startdate!.year}/${startdate!.month}/${startdate!.day}');
                                      },
                                      child: const Center(
                                        child: Text(
                                          'select start date',
                                        ),
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

                ///only visible when relay 1 or 6 or 3 opened
                currentPage == Page.Relay1 || currentPage == Page.Relay3 || currentPage == Page.Relay6 ? AnimatedOpacity(
                    opacity: statusOfRelay != Status.sensor ? 0 : 1,
                    duration: const Duration(milliseconds: 600),
                    child: AnimatedContainer(
                      margin: const EdgeInsets.only(bottom: 30),
                      duration: const Duration(milliseconds: 600),
                      height: statusOfRelay != Status.sensor ? 0.01 : 120,
                      child: Column(
                        children: [
                          listItemSwitch(
                              'Sensor status', () => relayCubit!.currentSensor(), sensor!),
                          listItemText('Status', sensorState),
                        ],
                      ),
                    )) : Container(),

                 AnimatedOpacity(
                        opacity: statusOfRelay != Status.act ? 0 : 1,
                        duration: const Duration(milliseconds: 600),
                        child: AnimatedContainer(
                            height: statusOfRelay != Status.act ? 0.01 : 400,
                            curve: Curves.linear,
                            duration: const Duration(milliseconds: 200),
                            child: currentPage == Page.Relay3
                                ? relay3humidity() : currentPage == Page.Relay7 ? Column(
                              children: [
                                listItemSwitch(
                                    'Light status', () => relayCubit!.lightStatus(), light!),
                                const SizedBox(height: 30),
                                const Text('Set light'),
                                const SizedBox(height: 20),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: SizedBox(
                                      width: 150,
                                      height: 150,
                                      child: Knob(
                                        controller: start,
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
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(sv.toString()),
                              ],
                            ) : Container()
    )
    ),
                Center(
                  child: NeumorphicButton(
                    onPressed: () => relayCubit!.changeStatus(),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('submit'),
                    ),
                  ),
                ),

                divider(),
              ],
            ),
          ),
        )
            ,



        listItemSwitch(
            'Switch $pageNumber',
            () => relayCubit!.switchMode(),
            sw!),
      ],
    );
  });
}

Widget listItemSwitch(name, onPressed, value) {
  return ListTile(
    onTap: onPressed,
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
      AnimatedOpacity(
        opacity: sw!? 1 : 0,
        duration: const Duration(milliseconds: 600),
        child: AnimatedContainer(
          height: sw!? 400 : 0,
          duration: const Duration(milliseconds: 600),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: Center(
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: NeumorphicButton(
                        onPressed: () => relayCubit!.relay4Switch(),
                        child: Center(child: Icon(Icons.power_settings_new_rounded, color: blue, size: 40,)),
                        style: const NeumorphicStyle(
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
                    onPressed: () => relayCubit!.icon(),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: blue)),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(13),
                            child: Image.asset(constants.get('IR4') ?? _4image),
                          ),
                          Expanded(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: const Text(
                                    'you can change this icon now'),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Column(
        children: [divider(), listItemSwitch('Switch 4', () => relayCubit!.switchMode(), sw!)],
      )
    ],
  );
}

Widget relay3humidity() {
  return Column(children: [
    listItemSwitch('Humidity status',
            () => relayCubit!.humidityStatus(), humidity!),
    const SizedBox(height: 20,),
    const Center(
        child: Text('Set Humidity',
            style: TextStyle(fontSize: 15),
            textDirection: TextDirection.ltr)),
    const SizedBox(
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
                Text(sv.toString())
              ],
            )
        ),
      ],
    ),
    const SizedBox(
      height: 10,
    ),
    Center(
        child: SizedBox(
            width: 50,
            height: 50,
            child: NeumorphicButton(
              onPressed: () {},
              style: const NeumorphicStyle(
                  boxShape: NeumorphicBoxShape.circle()),
            ))),
  ]);
}
////////////////////
