import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' as m;
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shome/compiling_sms.dart';
import 'package:shome/icon/icon.dart';
import 'package:shome/main.dart';
import 'package:shome/outlet/OutletPage.dart';

import '../../models/status.dart';

part 'outlet_state.dart';

class OutletCubit extends Cubit<OutletState> {
  OutletCubit() : super(OutletInitial());

  init(Plug plug) {
    available = (currentPlug == PlugNumber.plug1
            ? deviceStatus.getPublicReport.wirelessPlug1
            : deviceStatus.getPublicReport.wirelessPlug2) !=
        'remove';

    ///switch status
    upActive = plug.getUPStatus == 'ON' ;
    downActive = plug.getDownStatus == 'ON' ;

    ///relay status
    plugUP = plug.getUPRelayStatus == 'active';
    plugDOWN = plug.getDownRelayStatus == 'active';
    //
    // ///timer status
    timerUP = plug.getUPTimerStatus == 'active';
    timerDown = plug.getDownTimerStatus == 'active';

    if (currentPlug == PlugNumber.plug1) {
      waterLeakPlug = deviceStatus.publicReport.waterLeakagePlug1 == 'yes';
    } else {
      waterLeakPlug = deviceStatus.publicReport.waterLeakagePlug2 == 'yes';
    }
    isSwitchUP = true;
    isSwitchDOWN = true;

    emit(OutletData());
  }

  saveChanges(isUp, Plug plug) {
    try {
      if (isUp) {
        if (upActive) {
          plug.setUPRelayStatus = plugUP ? 'active' : 'deactive';
          plug.setUPTimerStatus = timerUP ? 'active' : 'deactive';

          // if (timerUP) {
            plug.setUPStartClock =
                '${startUpTime!.hour.toString().padLeft(2, '0')}:${startUpTime!.minute.toString().padLeft(2, '0')}';
            plug.setUPEndClock =
                '${endUpTime!.hour.toString().padLeft(2, '0')}:${endUpTime!.minute.toString().padLeft(2, '0')}';
            plug.setUPStartDate = !infinityUp
                ? '${startUpDate.year}/${startUpDate.month}/${startUpDate.day}'
                : '11/11/11';
            plug.setUPEndDate = !infinityUp
                ? '${endUpDate.year}/${endUpDate.month}/${endUpDate.day}'
                : '11/11/11';

            sendSMS(
                'P${currentPlug == PlugNumber.plug1 ? '1' : '2'}UP:${infinityUp ? '111111' : startUpDate.year.toString().substring(2) + startUpDate.month.toString().padLeft(2, '0') + startUpDate.day.toString().padLeft(2, '0')},${startUpTime!.hour.toString().padLeft(2, '0') + startUpTime!.minute.toString().padLeft(2, '0')}-${infinityUp ? '111111' : endUpDate.year.toString().substring(2) + endUpDate.month.toString().padLeft(2, '0') + endUpDate.day.toString().padLeft(2, '0')},${endUpTime!.hour.toString().padLeft(2, '0') + endUpTime!.minute.toString().padLeft(2, '0')}#',
                showDialog: false);
          // }
          ////////////
        } else {
          showMessage('up is not active');
        }
      } else {
        if (downActive) {
          plug.setDownRelayStatus = plugDOWN ? 'active' : 'inactive';
          plug.setDownTimerStatus = timerDown ? 'active' : 'deactive';

          // if (timerDown) {
            plug.setDownStartClock =
                '${startDownTime!.hour.toString().padLeft(2, '0')}:${startDownTime!.minute.toString().padLeft(2, '0')}';
            plug.setDownEndClock =
                '${endDownTime!.hour.toString().padLeft(2, '0')}:${endDownTime!.minute.toString().padLeft(2, '0')}';
            plug.setDownStartDate = !infinityDown
                ? '${startDownDate.year}/${startDownDate.month}/${startDownDate.day}'
                : '11/11/11';
            plug.setDownEndDate = !infinityDown
                ? '${endDownDate.year}/${endDownDate.month}/${endDownDate.day}'
                : '11/11/11';

            sendSMS(
                'P${currentPlug == PlugNumber.plug1 ? '1' : '2'}DN:${infinityDown ? '111111' : startDownDate.year.toString().substring(2) + startDownDate.month.toString() + startDownDate.day.toString()},${startDownTime!.hour.toString().padLeft(2, '0') + startDownTime!.minute.toString().padLeft(2, '0')}-${infinityDown ? '111111' : endDownDate.year.toString().substring(2) + endDownDate.month.toString() + endDownDate.day.toString()},${endDownTime!.hour.toString().padLeft(2, '0') + endDownTime!.minute.toString().padLeft(2, '0')}#',
                showDialog: false);
          // }
          ///////
        } else {
          showMessage('down is not active');
        }
      }
      deviceBox.put('info', deviceStatus);
    } catch (e) {
      dialog(
          'Please set date',
          const m.Text(
              'If you activated timer, you must select start and end date'),
          () => m.Navigator.pop(buildContext),
          removeCancel: true);
    }
  }

  void status(plug, bool isUp, switchStatus) {
    if(!switchStatus) {
      infinityUp =
          plug.getUPStartDate == '11/11/11' && plug.getUPEndDate == '11/11/11';
      infinityDown = plug.getDownStartDate == '11/11/11' &&
          plug.getDownEndDate == '11/11/11';
      selectedUpStartDate = infinityUp
          ? ':Start & End date\nRepeat every day'
          : 'selected up date: ${plug.getUPStartDate}';
      startUpDate = Jalali(int.parse(plug.getUPStartDate.split('/')[0]), int.parse(plug.getUPStartDate.split('/')[1]), int.parse(plug.getUPStartDate.split('/')[2]));
      // selectedUpEndDate = infinityUp
      //     ? 'Repeat every day'
      //     : 'selected up end date: ${plug.getUPEndDate}';
      selectedDownStartDate = infinityDown
          ? ':Start & End date\nRepeat every day'
          : 'selected down start date: ${plug.getDownStartDate}';
      startDownDate = Jalali(int.parse(plug.getDownStartDate.split('/')[0]), int.parse(plug.getDownStartDate.split('/')[1]), int.parse(plug.getDownStartDate.split('/')[2]));
      // selectedDownEndDate = infinityDown
      //     ? 'Repeat every day'
      //     : 'selected down end date: ${plug.getDownEndDate}';

      // startUpTime =
      //     null; // DateTime(1111, 1, 1, int.parse(plug.getUPStartClock.split(':')[0]), int.parse(plug.getUPStartClock.split(':')[1]));//plug.getUPStartClock; //
      // // startUpDate = null; // Jalali(int.parse(plug.getUPStartDate.split('/')[0]), int.parse(plug.getUPStartDate.split('/')[1]), int.parse(plug.getUPStartDate.split('/')[2]));
      // // startDownDate = null; // Jalali(int.parse(plug.getDownStartDate.split('/')[0]), int.parse(plug.getDownStartDate.split('/')[1]), int.parse(plug.getDownStartDate.split('/')[2]));
      // startDownTime =
      //     null; // DateTime(1111, 1, 1, int.parse(plug.getDownStartClock.split(':')[0]), int.parse(plug.getDownStartClock.split(':')[1])); //
      // endUpTime =
      //     null; // DateTime(1111, 1, 1, int.parse(plug.getUPEndClock.split(':')[0]), int.parse(plug.getUPEndClock.split(':')[1]));//plug.getUPEndClock; //
      // // endUpDate = null; // Jalali(int.parse(plug.getUPEndDate.split('/')[0]),int.parse(plug.getUPEndDate.split('/')[1]),int.parse(plug.getUPEndDate.split('/')[2]));
      // // endDownDate = null; // Jalali(int.parse(plug.getDownEndDate.split('/')[0]),int.parse(plug.getDownEndDate.split('/')[1]),int.parse(plug.getDownEndDate.split('/')[2]));
      // endDownTime =
      null; // DateTime(1111, 1, 1, int.parse(plug.getDownEndClock.split(':')[0]), int.parse(plug.getDownEndClock.split(':')[1]));//plug.getDownEndClock; //

    }
    if (isUp) {
      isSwitchUP = switchStatus;
    } else {
      isSwitchDOWN = switchStatus;
    }
    emit(OutletData());
  }

  void loop(isUp) {
    if (isUp) {
      infinityUp = !infinityUp;
    } else {
      infinityDown = !infinityDown;
    }

    if (isUp && infinityUp) {
      selectedUpStartDate = ':Start & End date\nRepeat every day';
      // selectedUpEndDate = 'Repeat every day';
    } else if (!isUp && infinityDown) {
      selectedDownStartDate = ':Start & End date\nRepeat every day';
      // selectedDownEndDate = 'Repeat every day';
    } else {
      if(isUp) {
        selectedUpStartDate = startUpDate.formatCompactDate().contains('0011/')? '' : 'Selected date: ${startUpDate.formatCompactDate()}';
      } else {
        selectedDownStartDate = startDownDate.formatCompactDate().contains('0011/')? '' : 'Selected date: ${startDownDate.formatCompactDate()}';
      }

    }
    emit(OutletData());
  }

  void update(datetime) {
    // endTime = datetime;
    emit(OutletData());
  }

  ///this function only called when timerChangeStatus(isUp) is running
  timer() {
    Plug plug = currentPlug == PlugNumber.plug1
        ? deviceStatus.getPLug1
        : deviceStatus.getPlug2;
    plug.setUPTimerStatus = timerUP ? 'active' : 'deactive';
    plug.setDownTimerStatus = timerDown ? 'active' : 'deactive';

    if (currentPlug == PlugNumber.plug1) {
      deviceStatus.setPlug1 = plug;
    } else if (currentPlug == PlugNumber.plug1) {
      deviceStatus.setPlug2 = plug;
    }
    deviceBox.put('info', deviceStatus);

    emit(OutletData());
  }

  timerChangeStatus(isUp) {
    if (isUp) {
      var timerUPVar = !timerUP;
      sendSMS(
          'P${currentPlug == PlugNumber.plug1 ? '1' : '2'}UP:${upActive ? 'a' : 'd'},time:${timerUPVar ? 'a' : 'd'}#',
          onPressed: () {
        timerUP = timerUPVar;
        timer();
      });
    } else {
      var timerDownVar = !timerDown;
      sendSMS(
          'P${currentPlug == PlugNumber.plug1 ? '1' : '2'}DN:${downActive ? 'a' : 'd'},time:${timerDownVar ? 'a' : 'd'}#',
          onPressed: () {
        timerDown = timerDownVar;
        timer();
      });
    }
  }

  plug() {
    Plug plug = currentPlug == PlugNumber.plug1
        ? deviceStatus.getPLug1
        : deviceStatus.getPlug2;
    plug.setUPRelayStatus = plugUP ? 'active' : 'deactive';
    plug.setDownRelayStatus = plugDOWN ? 'active' : 'deactive';

    if (currentPlug == PlugNumber.plug1) {
      deviceStatus.setPlug1 = plug;
    } else if (currentPlug == PlugNumber.plug1) {
      deviceStatus.setPlug2 = plug;
    }
    deviceBox.put('info', deviceStatus);

    emit(OutletData());
  }

  plugChangeStatus(isUp) {
    if (isUp) {
      var plugUPVar = !plugUP;
      sendSMS(
          'P${currentPlug == PlugNumber.plug1 ? '1' : '2'}UP:${plugUPVar ? 'on' : 'off'}#',
          onPressed: () {
        plugUP = plugUPVar;
        plug();
      });
    } else {
      var plugDOWNVar = !plugDOWN;
      sendSMS(
          'P${currentPlug == PlugNumber.plug1 ? '1' : '2'}DN:${plugDOWNVar ? 'on' : 'off'}#',
          onPressed: () {
        plugDOWN = plugDOWNVar;
        plug();
      });
    }
  }

  changeActive(bool isUp, Plug plug) {
    if (isUp) {
      var upActiveVar = !upActive;

      sendSMS(
          'P${currentPlug == PlugNumber.plug1 ? '1' : '2'}UP:${upActiveVar ? 'a' : 'd'},time:${timerUP ? 'a' : 'd'}#',
          onPressed: () {
        upActive = upActiveVar;
        plug.setUPStatus = upActive ? 'ON' : 'OFF';
        deviceBox.put('info', deviceStatus);
        emit(OutletData());
      });
    } else {
      var downActiveVar = !downActive;
      sendSMS(
          'P${currentPlug == PlugNumber.plug1 ? '1' : '2'}DN:${downActiveVar ? 'a' : 'd'},time:${timerDown ? 'a' : 'd'}#',
          onPressed: () {
        downActive = downActiveVar;
        plug.setDownStatus = downActive ? 'ON' : 'OFF';
        deviceBox.put('info', deviceStatus);
        emit(OutletData());
      });
    }
  }

  addDevice() {
    if (currentPlug == PlugNumber.plug1
        ? deviceStatus.getPublicReport.wirelessPlug1 == 'remove'
        : deviceStatus.getPublicReport.wirelessPlug2 == 'remove') {
      sendSMS('Device,ADD,PLUG${currentPlug == PlugNumber.plug1 ? '1' : '2'}',
          onPressed: () {
        if (currentPlug == PlugNumber.plug1) {
          deviceStatus.getPublicReport.wirelessPlug1 = 'connect';
        } else {
          deviceStatus.getPublicReport.wirelessPlug2 = 'connect';
        }
        deviceBox.put('info', deviceStatus);
        available = true;
        emit(OutletData());
      });
    }
  }

  removeDevice() {
    sendSMS('Device,RMV,PLUG${currentPlug == PlugNumber.plug1 ? '1' : '2'}',
        onPressed: () {
      if (currentPlug == PlugNumber.plug1) {
        deviceStatus.getPublicReport.wirelessPlug1 = 'remove';
        upActive = false;
        downActive = false;
        deviceStatus.getPLug1.setUPStatus = 'OFF';
        deviceStatus.getPLug1.setDownStatus = 'OFF';
      } else {
        deviceStatus.getPublicReport.wirelessPlug2 = 'remove';
        upActive = false;
        downActive = false;
        deviceStatus.getPlug2.setUPStatus = 'OFF';
        deviceStatus.getPlug2.setDownStatus = 'OFF';
      }



      deviceBox.put('info', deviceStatus);
      available = false;
      emit(OutletData());
    });
  }

  waterLeakageStatus() {
    waterLeakPlug = !waterLeakPlug;
    if (currentPlug == PlugNumber.plug1) {
      deviceStatus.publicReport.waterLeakagePlug1 =
          waterLeakPlug ? 'yes' : 'deactived by key';
      sendSMS('');
    } else {
      deviceStatus.publicReport.waterLeakagePlug2 =
          waterLeakPlug ? 'yes' : 'deactived by key';
    }
    deviceBox.put('info', deviceStatus);

    emit(OutletData());
  }

  icon(bool isUp) {
    if (currentPlug == PlugNumber.plug1) {
      iconKey = 'PLUG1${isUp ? 'UP':'DN'}';
    } else {
      iconKey = 'PLUG2${isUp ? 'UP':'DN'}';
    }

    m.Navigator.push(
        buildContext, m.MaterialPageRoute(builder: (context) => const Icon()));
  }
}
