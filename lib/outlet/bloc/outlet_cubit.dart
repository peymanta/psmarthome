import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shome/compiling_sms.dart';
import 'package:shome/main.dart';
import 'package:shome/outlet/OutletPage.dart';

import '../../models/status.dart';
import '../../relay/relay.dart' as relay;

part 'outlet_state.dart';

class OutletCubit extends Cubit<OutletState> {
  OutletCubit() : super(OutletInitial());

  init(Plug plug) {
    available = (currentPlug==PlugNumber.plug1? deviceStatus.getPublicReport.wirelessPlug1 : deviceStatus.getPublicReport.wirelessPlug2) != 'remove';

///switch status
    upActive = plug.getUPStatus == 'ON' ? true : false;
    downActive = plug.getDownStatus == 'ON' ? true : false;
///relay status
    plugUP =  plug.getUPRelayStatus == 'active';
    plugDOWN = plug.getDownRelayStatus == 'active';
///timer status
    timerUP = plug.getUPTimerStatus == 'active';
    timerDown = plug.getDownTimerStatus == 'active';
    print(upActive.toString() + 'qqqqqqqq');
    if(currentPlug == PlugNumber.plug1) {
      waterLeakPlug = deviceStatus.publicReport.waterLeakagePlug1 == 'yes';
    } else {
      waterLeakPlug = deviceStatus.publicReport.waterLeakagePlug2 == 'yes';
    }
    isSwitchUP = true;
    isSwitchDOWN = true;
    infinityUp = plug.getUPStartDate == '11/11/11' && plug.getUPEndDate == '11/11/11';
    infinityDown = plug.getDownStartDate == '11/11/11' && plug.getDownEndDate == '11/11/11';
    selectedUpStartDate = '';
    selectedUpEndDate = '';
    selectedDownStartDate = '';
    selectedDownEndDate = '';

    startUpTime = null; // DateTime(1111, 1, 1, int.parse(plug.getUPStartClock.split(':')[0]), int.parse(plug.getUPStartClock.split(':')[1]));//plug.getUPStartClock; //
    startUpDate = null; // Jalali(int.parse(plug.getUPStartDate.split('/')[0]), int.parse(plug.getUPStartDate.split('/')[1]), int.parse(plug.getUPStartDate.split('/')[2]));
    startDownDate = null; // Jalali(int.parse(plug.getDownStartDate.split('/')[0]), int.parse(plug.getDownStartDate.split('/')[1]), int.parse(plug.getDownStartDate.split('/')[2]));
    startDownTime = null; // DateTime(1111, 1, 1, int.parse(plug.getDownStartClock.split(':')[0]), int.parse(plug.getDownStartClock.split(':')[1])); //
    endUpTime = null; // DateTime(1111, 1, 1, int.parse(plug.getUPEndClock.split(':')[0]), int.parse(plug.getUPEndClock.split(':')[1]));//plug.getUPEndClock; //
    endUpDate = null; // Jalali(int.parse(plug.getUPEndDate.split('/')[0]),int.parse(plug.getUPEndDate.split('/')[1]),int.parse(plug.getUPEndDate.split('/')[2]));
    endDownDate = null; // Jalali(int.parse(plug.getDownEndDate.split('/')[0]),int.parse(plug.getDownEndDate.split('/')[1]),int.parse(plug.getDownEndDate.split('/')[2]));
    endDownTime = null; // DateTime(1111, 1, 1, int.parse(plug.getDownEndClock.split(':')[0]), int.parse(plug.getDownEndClock.split(':')[1]));//plug.getDownEndClock; //


  }

  saveChanges(isUp, Plug plug) {
try {
  if (isUp) {
    if (upActive!) {
      plug.setUPRelayStatus = plugUP! ? 'active' : 'deactive';
      plug.setUPTimerStatus = timerUP ? 'active' : 'deactive';

      if (timerUP) {
        plug.setUPStartClock =
        '${startUpTime!.hour.toString().padLeft(2, '0')}:${startUpTime!.minute
            .toString().padLeft(2, '0')}';
        plug.setUPEndClock =
        '${endUpTime!.hour.toString().padLeft(2, '0')}:${endUpTime!.minute
            .toString().padLeft(2, '0')}';
        plug.setUPStartDate = !infinityUp
            ? '${startUpDate!.year}/${startUpDate!.month}/${startUpDate!.day}'
            : '11/11/11';
        plug.setUPEndDate = !infinityUp
            ? '${endUpDate!.year}/${endUpDate!.month}/${endUpDate!.day}'
            : '11/11/11';

        sendSMS(
            'P${currentPlug == PlugNumber.plug1 ? '1' : '2'}UP:${infinityUp
                ? '111111'
                : startUpDate!.year.toString().substring(2) +
                startUpDate!.month.toString() +
                startUpDate!.day.toString()},${startUpTime!.hour.toString()
                .padLeft(2, '0') +
                startUpTime!.minute.toString().padLeft(2, '0')}-${infinityUp
                ? '111111'
                : endUpDate!.year.toString().substring(2) +
                endUpDate!.month.toString() +
                endUpDate!.day.toString()},${endUpTime!.hour.toString().padLeft(
                2, '0') + endUpTime!.minute.toString().padLeft(2, '0')}#', showDialog: false);
      }
      sendSMS(
          'P${currentPlug == PlugNumber.plug1 ? '1' : '2'}UP:${plug
              .getUPRelayStatus == 'active' ? 'a' : 'd'},time:${plug
              .getUPTimerStatus == 'active' ? 'a' : 'd'}#');
    } else {
      showMessage('up is not active');
    }
  }
  else {
    if (downActive!) {
      plug.setDownRelayStatus = plugDOWN! ? 'active' : 'inactive';
      plug.setDownTimerStatus = timerDown ? 'active' : 'deactive';

      if (timerDown) {
        plug.setDownStartClock =
        '${startDownTime!.hour.toString().padLeft(2, '0')}:${startDownTime!
            .minute.toString().padLeft(2, '0')}';
        plug.setDownEndClock =
        '${endDownTime!.hour.toString().padLeft(2, '0')}:${endDownTime!.minute
            .toString().padLeft(2, '0')}';
        plug.setDownStartDate = !infinityDown
            ? '${startDownDate!.year}/${startDownDate!.month}/${startDownDate!
            .day}'
            : '11/11/11';
        plug.setDownEndDate = !infinityDown
            ? '${endDownDate!.year}/${endDownDate!.month}/${endDownDate!.day}'
            : '11/11/11';

        sendSMS(
            'P${currentPlug == PlugNumber.plug1 ? '1' : '2'}DN:${infinityDown
                ? '111111'
                : startDownDate!.year.toString().substring(2) +
                startDownDate!.month.toString() +
                startDownDate!.day.toString()},${startDownTime!.hour.toString()
                .padLeft(2, '0') +
                startDownTime!.minute.toString().padLeft(2, '0')}-${infinityDown
                ? '111111'
                : endDownDate!.year.toString().substring(2) +
                endDownDate!.month.toString() +
                endDownDate!.day.toString()},${endDownTime!.hour.toString()
                .padLeft(2, '0') +
                endDownTime!.minute.toString().padLeft(2, '0')}#', showDialog: false);
      }
      sendSMS(
          'P${currentPlug == PlugNumber.plug1 ? '1' : '2'}DN:${plug
              .getDownRelayStatus == 'active' ? 'a' : 'd'},time:${plug
              .getDownTimerStatus == 'active' ? 'a' : 'd'}#');
    } else {
      showMessage('down is not active');
    }
  }
}
catch( e) {
  dialog('Please set date', Text('If you activated timer, you must select start and end date'), ()=>Navigator.pop(buildContext), removeCancel: true);
    }
    deviceBox.put('info', deviceStatus);
  }

  void status(bool isUp, switchStatus) {
    if (isUp) {
      isSwitchUP = switchStatus;
    } else {
      isSwitchDOWN = switchStatus;
    }
    emit(OutletInitial());
  }

  void loop(isUp) {
    if(isUp) {
      infinityUp = !infinityUp;
    } else {
      infinityDown = !infinityDown;
    }
    emit(OutletInitial());
  }

  void update(datetime) {
    // endTime = datetime;
    emit(OutletInitial());
  }

  timerChangeStatus(isUp) {
    if (isUp) {
      timerUP = !timerUP;
    } else {
      timerDown = !timerDown;
    }
    emit(OutletInitial());
  }

  plug(isUp) {
    if (isUp) {
      plugUP = !plugUP!;
    } else {
      plugDOWN = !plugDOWN!;
    }

    emit(OutletInitial());
  }

  changeActive(bool isUp, Plug plug) {
    if (isUp) {
      upActive = !upActive!;

      plug.setUPStatus = upActive! ? 'ON' : 'OFF';
      deviceBox.put('info', deviceStatus);
      sendSMS('P${currentPlug == PlugNumber.plug1 ? '1' : '2'}UP:${upActive! ? 'on' : 'off'}#');
    } else {
      downActive = !downActive!;

      plug.setDownStatus = downActive! ? 'ON' : 'OFF';
      deviceBox.put('info', deviceStatus);
      sendSMS('P${currentPlug == PlugNumber.plug1 ? '1' : '2'}DN:${downActive! ? 'on' : 'off'}#');
    }
    emit(OutletInitial());
  }

  addDevice() {
    print(deviceStatus.getPublicReport.wirelessPlug1);
    if((currentPlug == PlugNumber.plug1?deviceStatus.getPublicReport.wirelessPlug1=='remove' : deviceStatus.getPublicReport.wirelessPlug2=='remove')){
    // if(!constants.values.toList().contains(currentPlug == PlugNumber.plug1? 'plug1' : 'plug2')) {
    //   constants.add(currentPlug == PlugNumber.plug1? 'plug1' : 'plug2');

      if(currentPlug == PlugNumber.plug1)deviceStatus.getPublicReport.wirelessPlug1='connect';
      else deviceStatus.getPublicReport.wirelessPlug2='connect';
      deviceBox.put('info', deviceStatus);

      sendSMS('Device,ADD,PLUG${currentPlug == PlugNumber.plug1 ? '1' : '2'}');
    }
    available = true;
    emit(OutletInitial());
  }
  removeDevice() {
    // for (int i = 0 ; i < constants.values.length; i++) {
    //   if(constants.values.toList()[i]==(currentPlug == PlugNumber.plug1? 'plug1' : 'plug2')) {
    //     constants.deleteAt(i);
    //   }
    // }

    if(currentPlug == PlugNumber.plug1)deviceStatus.getPublicReport.wirelessPlug1='remove';
    else deviceStatus.getPublicReport.wirelessPlug2='remove';
    deviceBox.put('info', deviceStatus);

    sendSMS('Device,RMV,PLUG${currentPlug == PlugNumber.plug1 ? '1' : '2'}');

    available = false;
    emit(OutletInitial());
  }

  waterLeakageStatus() {
    waterLeakPlug = !waterLeakPlug!;
    if(currentPlug == PlugNumber.plug1) {
      deviceStatus.publicReport.waterLeakagePlug1 = waterLeakPlug! ? 'yes' : 'deactived by key';
      sendSMS('');
    } else {
      deviceStatus.publicReport.waterLeakagePlug2 = waterLeakPlug! ? 'yes' : 'deactived by key';
    }
    deviceBox.put('info', deviceStatus);

    emit(OutletInitial());
  }
}
