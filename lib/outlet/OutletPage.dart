import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../colors.dart';
import '../main.dart';
import '../relay/relay.dart' as relay;
import 'package:persian_datetime_picker/persian_datetime_picker.dart' as date;
import 'bloc/outlet_cubit.dart';

late OutletCubit _cubit;
bool timerUP = false,
    timerDown = false,
    infinityUp = false,
    infinityDown = false;
DateTime? startUpTime = DateTime.now(),
    endUpTime = DateTime.now(),
    startDownTime = DateTime.now(),
    endDownTime = DateTime.now();
late date.Jalali startUpDate, endUpDate, startDownDate, endDownDate;
String selectedUpStartDate = '',
    // selectedUpEndDate = ''
    selectedDownStartDate = '';
    // selectedDownEndDate = '';
late bool plugUP,
    plugDOWN,

    ///for timer switch
    upActive,
    downActive,

    ///for switch
    waterLeakPlug,
    available,
    active;

///for enabling plug

enum PlugNumber { plug1, plug2 }

bool isSwitchUP = false, isSwitchDOWN = false;

///for animated opacity

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

    _cubit.init(currentPlug == PlugNumber.plug1
        ? deviceStatus.getPLug1
        : deviceStatus.getPlug2);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OutletCubit, OutletState>(
      bloc: _cubit,
      builder: (context, state) {
        if (state is OutletData) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Plug ${currentPlug == PlugNumber.plug1 ? '1' : '2'}',
                style: const TextStyle(color: Colors.black),
              ),
              backgroundColor: background,
              shadowColor: Colors.transparent,
              iconTheme: const IconThemeData(color: Colors.black),
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
                      MaterialButton(
                        onPressed: () => _cubit.icon(true),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(children: const [
                            Expanded(flex: 8, child: Center(child: Text('Change connected device up icon'))),
                            Expanded(flex: 2, child: Icon(Icons.edit, color: primary))
                          ]),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () => _cubit.icon(false),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(children: const [
                            Expanded(flex: 8, child: Center(child: Text('Change connected device down icon'))),
                            Expanded(flex: 2, child: Icon(Icons.edit, color: primary))
                          ]),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(currentPlug == PlugNumber.plug1
                                      ? deviceStatus
                                          .getPublicReport.wirelessPlug1
                                      : deviceStatus
                                          .getPublicReport.wirelessPlug2))),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(':Wireless status'))),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(currentPlug == PlugNumber.plug1
                                      ? deviceStatus
                                          .publicReport.waterLeakagePlug1
                                      : deviceStatus
                                          .publicReport.waterLeakagePlug2))),
                          Expanded(
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: const Text(':Water leak status'))),
                        ],
                      ),
                      divider(),
                       Column(
                          children: [
                            option(context, true), //up

                            option(context, false), //down
                          ],
                      ),
                      const SizedBox(height: 20),

              Visibility(
                visible: available,
                child: Column(
                        children: [
                          ListTile(
                              onTap: () => _cubit.changeActive(
                                  true,
                                  currentPlug == PlugNumber.plug1
                                      ? deviceStatus.plug1
                                      : deviceStatus.plug2),
                              title: Container(
                                alignment: Alignment.centerLeft,
                                child: const Text('UP Active'),
                              ),
                              leading: NeumorphicSwitch(value: upActive)),
                          const SizedBox(height: 10),
                          ListTile(
                            onTap: () => _cubit.changeActive(
                                false,
                                currentPlug == PlugNumber.plug1
                                    ? deviceStatus.plug1
                                    : deviceStatus.plug2),
                            title: Container(
                              alignment: Alignment.centerLeft,
                              child: const Text('Down Active'),
                            ),
                            leading: NeumorphicSwitch(value: downActive),
                          ),
                        ],
                      ),),

                      const SizedBox(height: 10),
                      ListTile(
                        onTap: () => _cubit.addDevice(),
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('Add device'),
                        ),
                        leading: NeumorphicButton(
                          style: const NeumorphicStyle(
                              boxShape: NeumorphicBoxShape.circle()),
                          child: const Icon(
                            Icons.add,
                            color: blue,
                          ),
                          onPressed: () => _cubit.addDevice(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      ListTile(
                        onTap: () => _cubit.removeDevice(),
                        title: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('Remove device'),
                        ),
                        leading: NeumorphicButton(
                          style: const NeumorphicStyle(
                              boxShape: NeumorphicBoxShape.circle()),
                          child: const Icon(
                            Icons.clear,
                            color: blue,
                          ),
                          onPressed: () => _cubit.removeDevice(),
                        ),
                      ),
                      // divider(),
                      // ListTile(
                      //   onTap: () => _cubit!.waterLeakageStatus(),
                      //   title: Container(
                      //     alignment: Alignment.centerLeft,
                      //     child: Text('Water leak detector'),
                      //   ),
                      //   leading: NeumorphicSwitch(value: waterLeakPlug!),
                      // ),
                      // SizedBox(height: 20),
                    ],
                  )),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

Widget option(context, bool isUp) {
  return StatefulBuilder(builder: (context, setState) {
    return Visibility(
      visible: isUp ? upActive: downActive,
      child: Column(
        children: [
          Column(
            children: [
              ListTile(
                onTap: () => _cubit.status(isUp, true),
                title: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(isUp == true ? 'UP' : 'DOWN'),
                ),
                leading: SizedBox(
                  width: 100,
                  height: 100,
                  child: NeumorphicRadio(
                      onChanged: (v) => _cubit.status(isUp, true),
                      style: const NeumorphicRadioStyle(
                          boxShape: NeumorphicBoxShape.circle(),
                          selectedColor: blue),
                      groupValue: isUp == true ? isSwitchUP : isSwitchDOWN,
                      value: true),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () => _cubit.status(isUp, false),
                title: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text('Timing')),
                leading: SizedBox(
                  width: 100,
                  height: 100,
                  child: NeumorphicRadio(
                      onChanged: (v) => _cubit.status(isUp, false),
                      style: const NeumorphicRadioStyle(
                          boxShape: NeumorphicBoxShape.circle(),
                          selectedColor: blue),
                      groupValue: isUp == true ? isSwitchUP : isSwitchDOWN,
                      value: false),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Visibility(
              visible: isUp ? !isSwitchUP : !isSwitchDOWN,
              child: Column(children: [
                relay.listItemSwitch(
                    'Timing Active',
                    () => _cubit.timerChangeStatus(isUp),
                    isUp ? timerUP : timerDown),

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
                                if (isUp) {
                                  endUpTime = time;
                                } else {
                                  endDownTime = time;
                                }
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
                                if (isUp) {
                                  startUpTime = time;
                                } else {
                                  startDownTime = time;
                                }
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
                    child: Text(
                        isUp ? selectedUpStartDate : selectedDownStartDate)),
                const SizedBox(height: 5),
                // Container(
                //     alignment: Alignment.centerLeft,
                //     child:
                        // Text(isUp ? selectedUpEndDate : selectedDownEndDate)),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Expanded(
                          child: Center(
                        child: NeumorphicCheckbox(
                          value: isUp ? infinityUp : infinityDown,
                          onChanged: (value) => _cubit.loop(isUp),
                        ),
                      )),
                      Expanded(
                        child: Center(
                          child: NeumorphicButton(
                            padding: const EdgeInsets.all(15),
                            onPressed: () async {
                              var output = await date.showPersianDatePicker(
                                  context: context,
                                  initialDate: date.Jalali.now(),
                                  firstDate: date.Jalali.now(),
                                  lastDate: date.Jalali(3099));

                              setState(() {
                                if (isUp) {
                                  startUpDate = output!;
                                  endUpDate = startUpDate; //end is tomorrow of start

                                  selectedUpStartDate =
                                      'Selected up date: ${startUpDate.formatCompactDate()}';
                                  // selectedUpEndDate =
                                  //     'Selected up end date: ${endUpDate.formatCompactDate()}';
                                } else {
                                  startDownDate = output!;
                                  endDownDate = startDownDate;

                                  selectedDownStartDate =
                                      'Selected down date: ${startDownDate.formatCompactDate()}';
                                  // selectedDownEndDate =
                                  //     'Selected down end date: ${endDownDate.formatCompactDate()}';
                                }
                              });
                            },
                            child: const Center(
                              child: Text(
                                'select date',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                NeumorphicButton(
                  padding: const EdgeInsets.all(20),
                  child: const Text('submit'),
                  onPressed: () => _cubit.saveChanges(
                      isUp,
                      currentPlug == PlugNumber.plug1
                          ? deviceStatus.plug1
                          : deviceStatus.plug2),
                ),
              ])),
          Visibility(
            // duration: Duration(milliseconds: 600),
            visible: isUp ? isSwitchUP : isSwitchDOWN,
            child: relay.listItemSwitch('Plug: ON/OFF',
                () => _cubit.plugChangeStatus(isUp), isUp ? plugUP : plugDOWN),
          ),
          divider(),
        ],
      ),
    );
  });
}

Widget divider() {
  return Column(
    children: const [
      SizedBox(
        height: 15,
      ),
      Divider(color: Colors.black54),
      SizedBox(
        height: 15,
      ),
    ],
  );
}
