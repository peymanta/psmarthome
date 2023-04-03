import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:knob_widget/knob_widget.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart' as date;
import '../../colors.dart';
import '../../compiling_sms.dart';
import '../../main.dart';
import '../temp_screen.dart';
part 'temp_state.dart';

class TempCubit extends Cubit<TempState> {
  TempCubit() : super(TempInitial());

  void init() async {
    if (isCooler) {
      available = deviceStatus.getPublicReport.wirelessCooler == 'active';
      automatic = deviceStatus.getPublicReport.autoCooler == 'auto-active';
      infinity = deviceStatus.getCooler.startDate == '11/11/11';
      rest = deviceStatus.publicReport.coolerRest == 'active';
      endMin = 16;
      sv = int.parse(constants.get('tempMin') ?? '16');
      ev = int.parse(constants.get('tempMax') ?? '16');
      if (deviceStatus.getCooler.startClock.contains(RegExp(r'[0-9]'))) {
        startTime = Jalali(
            1234,
            2,
            2,
            int.parse(deviceStatus.getCooler.startClock.split(':')[0]),
            int.parse(deviceStatus.getCooler.startClock.split(':')[1]));
        startdate = date.Jalali(int.parse(deviceStatus.getCooler.startDate.split('/')[0]), int.parse(deviceStatus.getCooler.startDate.split('/')[1]), int.parse(deviceStatus.getCooler.startDate.split('/')[2]));
        selectedStartDate =
            deviceStatus.getCooler.startDate == '11/11/11' ? ':Start & End date\nRepeat every day' : 'Selected date: ${deviceStatus.getCooler.startDate}';
      } else {
        startTime = Jalali.now();
      }
      if (deviceStatus.getCooler.endClock.contains(RegExp(r'[0-9]'))) {
        endTime = Jalali(
            1234,
            2,
            2,
            int.parse(deviceStatus.getCooler.endClock.split(':')[0]),
            int.parse(deviceStatus.getCooler.endClock.split(':')[1]));
        // selectedEndDate =
        //     'Selected end date: ${deviceStatus.getCooler.endDate == '11/11/11' ? 'Repeat every day' : deviceStatus.getCooler.endDate}';
      } else {
        endTime = Jalali.now();
      }
      rest = deviceStatus.getPublicReport.coolerRest == 'active';
    } else {
      available = deviceStatus.getPublicReport.wirelessHeater == 'active';
      automatic = deviceStatus.getPublicReport.autoHeater == 'auto-active';
      rest = deviceStatus.publicReport.heaterRest == 'active';
      endMin = 16;
      sv = int.parse(constants.get('tempMin') ?? '16');
      ev = int.parse(constants.get('tempMax') ?? '16');
      infinity = deviceStatus.getHeater.startDate == '11/11/11';

      ///static routing in hub var
      hub = deviceStatus.staticRouting == 'hub';

      if (deviceStatus.getHeater.startClock.contains(new RegExp(r'[0-9]'))) {
        startTime = Jalali(
            1234,
            2,
            2,
            int.parse(deviceStatus.getHeater.startClock.split(':')[0]),
            int.parse(deviceStatus.getHeater.startClock.split(':')[1]));
        startdate = date.Jalali(int.parse(deviceStatus.getHeater.startDate.split('/')[0]), int.parse(deviceStatus.getHeater.startDate.split('/')[1]), int.parse(deviceStatus.getHeater.startDate.split('/')[2]));
        selectedStartDate =
            (deviceStatus.getHeater.startDate == '11/11/11' && deviceStatus.getHeater.endDate == '11/11/11') ? ':Start & End date\nRepeat every day' : 'Selected date: ${deviceStatus.getHeater.startDate}';
      } else {
        startTime = Jalali.now();
      }
      if (deviceStatus.getHeater.endClock.contains(new RegExp(r'[0-9]'))) {
        endTime = Jalali(
            1234,
            2,
            2,
            int.parse(deviceStatus.getHeater.endClock.split(':')[0]),
            int.parse(deviceStatus.getHeater.endClock.split(':')[1]));
        // selectedEndDate =
        //     '${deviceStatus.getHeater.endDate == '11/11/11' ? '' : 'Selected end date: ' + deviceStatus.getHeater.endDate}';
      } else {
        endTime = Jalali.now();
      }

      rest = deviceStatus.getPublicReport.heaterRest == 'active';
    }
    emit(TempData());
  }

  submitTimer() {
    try {
      if (isCooler) {
        deviceStatus.getCooler.startClock =
            '${startTime.hour}:${startTime.minute}';
        deviceStatus.getCooler.endClock = '${endTime.hour}:${endTime.minute}';
        if (infinity) {
          deviceStatus.getCooler.startDate = '11/11/11';
          deviceStatus.getCooler.endDate = '11/11/11';
          sendSMS(
              'C/H:111111,${startTime.hour.toString().padLeft(2, '0') + startTime.minute.toString().padLeft(2, '0')}-111111,${endTime.hour.toString().padLeft(2, '0') + endTime.minute.toString().padLeft(2, '0')}#',
              showDialog: false);
        } else {
          deviceStatus.getCooler.startDate =
              '${startdate.year}/${startdate.month}/${startdate.day}';
          deviceStatus.getCooler.endDate =
              '${enddate.year}/${enddate.month}/${enddate.day}';

          ///send sms
          var sdate = deviceStatus.getCooler.startDate
                  .split('/')[0]
                  .padLeft(2, '0')
                  .substring(2) +
              deviceStatus.getCooler.startDate.split('/')[1].padLeft(2, '0') +
              deviceStatus.getCooler.startDate.split('/')[2].padLeft(2, '0');
          var edate = deviceStatus.getCooler.endDate
                  .split('/')[0]
                  .padLeft(2, '0')
                  .substring(2) +
              deviceStatus.getCooler.endDate.split('/')[1].padLeft(2, '0') +
              deviceStatus.getCooler.endDate.split('/')[2].padLeft(2, '0');
          var sclock = deviceStatus.getCooler.startClock
                  .split(':')[0]
                  .padLeft(2, '0') +
              deviceStatus.getCooler.startClock.split(':')[1].padLeft(2, '0');
          var eclock =
              deviceStatus.getCooler.endClock.split(':')[0].padLeft(2, '0') +
                  deviceStatus.getCooler.endClock.split(':')[1].padLeft(2, '0');
          sendSMS('C/H:$sdate,$sclock-$edate,$eclock#', showDialog: false);
        }

        deviceBox.put('info', deviceStatus);
      } else {
        constants.put('tempMin', sv.toString());
        constants.put('tempMax', ev.toString());

        deviceStatus.getHeater.startClock =
            '${startTime.hour}:${startTime.minute}';
        deviceStatus.getHeater.endClock = '${endTime.hour}:${endTime.minute}';
        if (infinity) {
          deviceStatus.getHeater.startDate = '11/11/11';
          deviceStatus.getHeater.endDate = '11/11/11';
          sendSMS(
              'C/H:111111,${startTime.hour.toString().padLeft(2, '0') + startTime.minute.toString().padLeft(2, '0')}-111111,${endTime.hour.toString().padLeft(2, '0') + endTime.minute.toString().padLeft(2, '0')}#',
              showDialog: false);
          // sendSMS('T-min:$sv,max:$ev#');
        } else {
          deviceStatus.getHeater.startDate =
              '${startdate.year}/${startdate.month}/${startdate.day}';
          deviceStatus.getHeater.endDate =
              '${enddate.year}/${enddate.month}/${enddate.day}';

          ///send sms
          var sdate = deviceStatus.getHeater.startDate
                  .split('/')[0]
                  .padLeft(2, '0')
                  .substring(2) +
              deviceStatus.getHeater.startDate.split('/')[1].padLeft(2, '0') +
              deviceStatus.getHeater.startDate.split('/')[2].padLeft(2, '0');
          var edate = deviceStatus.getHeater.endDate
                  .split('/')[0]
                  .padLeft(2, '0')
                  .substring(2) +
              deviceStatus.getHeater.endDate.split('/')[1].padLeft(2, '0') +
              deviceStatus.getHeater.endDate.split('/')[2].padLeft(2, '0');
          var sclock = deviceStatus.getHeater.startClock
                  .split(':')[0]
                  .padLeft(2, '0') +
              deviceStatus.getHeater.startClock.split(':')[1].padLeft(2, '0');
          var eclock =
              deviceStatus.getHeater.endClock.split(':')[0].padLeft(2, '0') +
                  deviceStatus.getHeater.endClock.split(':')[1].padLeft(2, '0');
          sendSMS('C/H:$sdate,$sclock-$edate,$eclock#', showDialog: false);
        }
      }
    } catch (c) {
      dialog(
          'Please set date',
          Text('If you activated timer, you must select start and end date'),
          () => Navigator.pop(buildContext),
          removeCancel: true);
    }
    deviceBox.put('info', deviceStatus);
    emit(TempData());
  }

  submitTemp(isCooler) {
    constants.put('tempMin', sv.toString());
    constants.put('tempMax', ev.toString());
    sendSMS('T-min:$sv,max:$ev#', showDialog: false);
  }

  void status() {
    var automaticVar = !automatic;
    if (isCooler) {
      sendSMS('Cooler:${automaticVar ? 'a' : 'd'}#', onPressed: () {
        automatic = automaticVar;

        deviceStatus.getPublicReport.autoCooler =
            automatic ? 'auto-active' : 'auto-deactive';
        // sendSMS('Heater:${automaticVar ? 'd' : 'a'}#', showDialog: false);

        deviceBox.put('info', deviceStatus);
        emit(TempData());
      });
    } else {
      sendSMS('Heater:${automaticVar ? 'a' : 'd'}#', onPressed: () {
        automatic = automaticVar;

        deviceStatus.getPublicReport.autoHeater =
            automatic ? 'auto-active' : 'auto-deactive';
        // sendSMS('Cooler:${automaticVar ? 'd' : 'a'}#', showDialog: false);

        deviceBox.put('info', deviceStatus);
        emit(TempData());
      });
    }
  }

  void changeRest() {
    var restVar = !rest;

    sendSMS('C-H-${restVar? 'Active' : 'Deactive'} Rest', onPressed: () {
      rest = restVar;
      if (isCooler) {
        deviceStatus.getPublicReport.coolerRest = rest? 'active' : 'deactive';
      } else {
        deviceStatus.getPublicReport.heaterRest = rest? 'active' : 'deactive';
      }

      deviceBox.put('info', deviceStatus);
      emit(TempData());
    });
  }

  void loop() {
    infinity = !infinity;
    if(infinity) {
      selectedStartDate = ':Start & End date\nRepeat every day';
    } else {
      selectedStartDate = startdate.formatCompactDate().contains('0011/')? '' : 'Selected date: ${startdate.formatCompactDate()}';
    }
    // selectedEndDate = infinity ? 'Repeat every day' : '';
    emit(TempData());
  }

  void update(datetime) {
    // endTime = datetime;
    emit(TempData());
  }

  addDeviceToDB() {
    if (isCooler) {
      deviceStatus.getPublicReport.wirelessCooler = 'active';
      deviceStatus.getPublicReport.wirelessHeater = 'deactive'; /////
    } else {
      deviceStatus.getPublicReport.wirelessHeater = 'active';
      deviceStatus.getPublicReport.wirelessCooler = 'deactive'; /////
    }
    deviceBox.put('info', deviceStatus);

    available = true;

    emit(TempData());
  }

  removeDeviceFromDB() {
    if (isCooler) {
      deviceStatus.getPublicReport.wirelessCooler = 'deactive';
      deviceStatus.getPublicReport.wirelessHeater = 'active'; /////
    } else {
      deviceStatus.getPublicReport.wirelessHeater = 'deactive';
      deviceStatus.getPublicReport.wirelessCooler = 'active'; /////
    }
    deviceBox.put('info', deviceStatus);

    available = false;

    emit(TempData());
  }

  addDevice() {
    if (isCooler) {
      sendSMS('Device,ADD,Cooler', onPressed: () => addDeviceToDB());
    } else {
      sendSMS('Device,ADD,Heater', onPressed: () => addDeviceToDB());
    }
  }

  removeDevice() {
    if (isCooler) {
      sendSMS('Device,RMV,Cooler', onPressed: () => removeDeviceFromDB());
    } else {
      sendSMS('Device,RMV,Heater', onPressed: () => removeDeviceFromDB());
    }
  }

  knobDialog() {
    start = KnobController(
        minimum: 16,
        maximum: 28,
        initial: isCooler
            ? double.parse(constants.get('tempMin') ?? '16').clamp(16, 28)
            : double.parse(constants.get('tempMax') ?? '28').clamp(16, 28));
    end = KnobController(
        minimum: 16, //5 endmin+4 or 9
        maximum: 32, //95
        initial: isCooler
            ? int.parse(constants.get('tempMin') ?? '16')
                .clamp(16, 32)
                .toDouble()
            : int.parse(constants.get('tempMax') ?? '32')
                .clamp(16, 32)
                .toDouble());

    dialog('Set temp', StatefulBuilder(builder: (context, setState) {
      start!.addOnValueChangedListener((double value) {
        setState(() {
          sv = value.toInt();
          endMin = value <= 32 ? value+4 : 32;

          ev = endMin.toInt(); //value.roundToDouble();
        });
        end = KnobController(
            minimum: endMin, maximum: 32, initial: endMin.clamp(endMin, 32));
      });

      end!.addOnValueChangedListener((p) {
        setState(() {
          ev = p.toInt();
        });
      });
      return Column(children: [
        Row(
          children: [
            knob(start!, sv),
            knob(end!, ev),
          ],
        ),
        SizedBox(
          height: 30,
        ),
        // Center(
        //   child: NeumorphicButton(
        //     onPressed: () => _cubit!.submitTemp(isCooler),
        //     child: Padding(
        //       padding: EdgeInsets.all(10),
        //       child: Text('submit'),
        //     ),
        //   ),
        // ),
      ]);
    }), () {
      submitTemp(isCooler);
      Navigator.pop(buildContext);
    }).then((mount) {
      //on disposed
      start!.dispose();
      end!.dispose();
    });
  }

  Widget knob(KnobController controller, int value) {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              width: 150,
              height: 150,
              child: Knob(
                controller: controller,
                style: KnobStyle(
                  labelStyle: const TextStyle(color: Colors.transparent),
                  controlStyle: const ControlStyle(
                      tickStyle: ControlTickStyle(color: Colors.transparent),
                      glowColor: Colors.transparent,
                      backgroundColor: Color(0xffdde6e8),
                      shadowColor: Color(0xffd4d6dd)),
                  pointerStyle: PointerStyle(color: blue),
                  minorTickStyle:
                      const MinorTickStyle(color: Color(0xffaaadba), length: 6),
                  majorTickStyle:
                      const MajorTickStyle(color: Color(0xffaaadba), length: 6),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(value.toString()),
        ],
      ),
    );
  }
}
