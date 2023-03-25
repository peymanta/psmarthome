import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:knob_widget/knob_widget.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shome/colors.dart';
import 'package:shome/outlet/OutletPage.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart' as date;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../compiling_sms.dart';
import '../main.dart';
import 'bloc/temp_cubit.dart';

late TempCubit _cubit;
bool automatic = true, infinity = false;
late bool isCooler,
    timer,
    isSwitch,
    rest,
    available; // for add or remove device
TooltipBehavior? _tooltip;

late double endMin;
int sv = 16, ev = 16;
KnobController? start;

///start also using for light
KnobController? end;

Jalali startTime = Jalali.now();
Jalali endTime = Jalali.now();
late date.Jalali startdate;
late date.Jalali enddate;
String selectedStartDate = '';
String selectedEndDate = '';

bool pads = false, hub = false;

class Actulator extends StatelessWidget {
  final TempCubit cubit;
  final bool cooler;
  const Actulator(this.cubit, context, this.cooler, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // start = KnobController(
    //     minimum: 16,
    //     maximum: 28,
    //     initial: cooler
    //         ? double.parse(constants.get('tempMin') ?? '16').clamp(16, 28)
    //         : double.parse(constants.get('tempMax') ?? '28').clamp(16, 28));
    // end = KnobController(
    //     minimum: 16, //5 endmin+4 or 9
    //     maximum: 32, //95
    //     initial: cooler
    //         ? int.parse(constants.get('tempMin') ?? '16').clamp(16, 32).toDouble()
    //         : int.parse(constants.get('tempMax') ?? '32').clamp(16, 32).toDouble());
    //

    return StatefulBuilder(builder: (context, setState) {
      // start!.addOnValueChangedListener((double value) {
      //   setState(() {
      //     sv = value.toInt();
      //     endMin = value <= 32 ? value : 32;
      //
      //     ev = endMin!.toInt(); //value.roundToDouble();
      //   });
      //   end = KnobController(
      //       minimum: endMin!, maximum: 32, initial: endMin!.clamp(endMin!, 32));
      // });
      //
      // end!.addOnValueChangedListener((p) {
      //   setState(() {
      //     ev = p.toInt();
      //   });
      // });
      return ListView(physics: const ClampingScrollPhysics(), children: [
        //   AnimatedOpacity(
        // opacity: constants.values.contains(isCooler! ? 'cooler' : 'heater') ? 1 : 0,
        //     duration: Duration(milliseconds: 600),
        //     child:
        Visibility(
          visible: available,
          // duration: Duration(milliseconds: 500),
          // height: constants.values.contains(isCooler! ? 'cooler' : 'heater') ? (automatic ? 1000 : 200) : 0,
          child: Column(
            children: [
              RadioItem('Automatic ${cooler ? 'cooler' : 'heater'}', automatic,
                  () => cubit.status()),
              RadioItem('${cooler ? 'Cooler' : 'Heater'} Rest', rest,
                  () => cubit.changeRest()),
              isCooler
                  ? RadioItem('Pads', pads, () {
                      setState(() {
                        pads = !pads;
                        sendSMS('hello');
                      });
                    })
                  : Container(),
              const SizedBox(
                height: 30,
              ),
              Visibility(
                visible: automatic,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [const Text('end time'), Time(false)],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [const Text('start time'), Time(true)],
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 15),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(selectedStartDate)),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                        alignment: Alignment.centerLeft,
                        child: Text(selectedEndDate)),
                    const SizedBox(height: 15),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          // Expanded(
                          //   child: Center(
                          //     child: NeumorphicButton(
                          //       padding: EdgeInsets.all(15),
                          //       onPressed: () async {
                          //         enddate = (await date.showPersianDatePicker(
                          //             context: context,
                          //             initialDate: date.Jalali.now(),
                          //             firstDate: date.Jalali.now(),
                          //             lastDate: date.Jalali(3099)))!;
                          //         setState(() => selectedEndDate =
                          //         'Selected end date: ${enddate!.year}/${enddate!.month}/${enddate!.day}');
                          //       },
                          //       child: Center(
                          //         child: const Text(
                          //           'select end date',
                          //         ),
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          Expanded(
                              child: Center(
                            child: NeumorphicCheckbox(
                              value: infinity,
                              onChanged: (value) => _cubit.loop(),
                            ),
                          )),
                          Expanded(
                            child: Center(
                              child: NeumorphicButton(
                                padding: const EdgeInsets.all(15),
                                onPressed: () async {
                                  startdate = (await date.showPersianDatePicker(
                                      context: context,
                                      initialDate: date.Jalali.now(),
                                      firstDate: date.Jalali.now(),
                                      lastDate: date.Jalali(3099)))!;
                                  setState(() {
                                    enddate = startdate.addDays(1);

                                    selectedStartDate =
                                        'Selected start date: ${startdate.year}/${startdate.month}/${startdate.day}';
                                    selectedEndDate =
                                        'Selected end date: ${enddate.year}/${enddate.month}/${enddate.day}';
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
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: NeumorphicButton(
                        onPressed: () => _cubit.submitTimer(),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('submit'),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    NeumorphicButton(
                      padding: const EdgeInsets.all(20),
                      onPressed: () => cubit.knobDialog(),
                      child: const Text('show temp volumes'),
                    )
                  ],
                  // ),
                ),
              ),
            ],
          ),
          // ),
        ),
        const SizedBox(
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
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true))
                ]),
          ),
        ),

        divider(),

        ListTile(
          onTap: () {

              if (!isCooler) {
                if (hub) {
                  sendSMS('Static Routing for Remote Devices:H', onPressed: ()=>setState(() => hub = !hub));
                } else {
                  sendSMS('Static Routing for Remote Devices:m', onPressed: ()=>setState(() => hub = !hub));
                }
              }

          },
          title: Container(
            alignment: Alignment.centerLeft,
            child: Text(isCooler ? 'Hub' : 'Static Routing for Remote'),
          ),
          leading: NeumorphicSwitch(value: hub),
        ),
        const SizedBox(
          height: 10,
        ),
        ListTile(
          onTap: () => cubit.addDevice(),
          title: Container(
            alignment: Alignment.centerLeft,
            child: const Text('Add device'),
          ),
          leading: NeumorphicButton(
            style: const NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
            child: const Icon(
              Icons.add,
              color: blue,
            ),
            onPressed: () {},
          ),
        ),
        const SizedBox(height: 10),
        ListTile(
          onTap: () => cubit.removeDevice(),
          title: Container(
            alignment: Alignment.centerLeft,
            child: const Text('Remove device'),
          ),
          leading: NeumorphicButton(
            style: const NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
            child: const Icon(
              Icons.clear,
              color: blue,
            ),
            onPressed: () {},
          ),
        ),
      ]);
    });
  }
}

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

    _cubit.init();
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
                iconTheme: const IconThemeData(color: Colors.black)),
            backgroundColor: NeumorphicColors.background,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Actulator(_cubit, context, true),
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

    _cubit.init();
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
                iconTheme: const IconThemeData(color: Colors.black)),
            backgroundColor: NeumorphicColors.background,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Actulator(_cubit, context, false),
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

class RadioItem extends StatelessWidget {
  String name;
  bool active;
  var onPressed;
  RadioItem(this.name, this.active, this.onPressed, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      title: Container(alignment: Alignment.centerLeft, child: Text(name)),
      // leading: NeumorphicSwitch(value: automatic),
      leading: NeumorphicSwitch(
        value: active,
      ),
    );
  }
}

class Time extends StatelessWidget {
  bool start;
  Time(this.start, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: TimePickerSpinner(
        is24HourMode: true,
        isForce2Digits: true,
        onTimeChange: (DateTime time) {
          if (start) {
            startTime = Jalali.fromDateTime(time);
          } else {
            endTime = Jalali.fromDateTime(time);
          }
        },
        time: start ? startTime.toDateTime() : endTime.toDateTime(),
      ),
    );
  }
}
