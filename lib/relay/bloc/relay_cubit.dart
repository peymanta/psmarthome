import 'package:bloc/bloc.dart';
import 'package:knob_widget/knob_widget.dart';
import 'package:meta/meta.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shome/compiling_sms.dart';
import 'package:shome/main.dart';
import 'package:shome/relay/relay.dart';
import '../../models/status.dart' as model;

part 'relay_state.dart';

enum Status {
  sw,
  timer,
  sensor, //sensor for r3 = humidity
  act
}

class RelayCubit extends Cubit<RelayState> {
  RelayCubit() : super(RelayInitial());

  initRelay() {
    if (currentPage == Page.Relay1) {
      relayStatus = deviceStatus.getR1.relay == 'active' ? true : false;
      sw = deviceStatus.getR1.status == 'ON' ? true : false;
      sensor = deviceStatus.getPublicReport.currentSensor1 == 'active'
          ? true
          : false;
      timer = deviceStatus.getR1.timer == 'active' ? true : false;
      sensorState = deviceStatus.getPublicReport.currentSensor1;

      startTime = Jalali.now();
      endTime = Jalali.now();
    }
    else if (currentPage == Page.Relay6) {
      relayStatus = deviceStatus.getR6.relay == 'active' ? true : false;
      sw = deviceStatus.getR6.status == 'ON' ? true : false;
      sensor =
          deviceStatus.getPublicReport.currentSensor6 == 'active' ? true : false;
      timer = deviceStatus.getR6.timer == 'active' ? true : false;
      sensorState = deviceStatus.getPublicReport.currentSensor6;

      startTime = Jalali.now();
      endTime = Jalali.now();
    }
    else if (currentPage == Page.Relay3) {
      relayStatus = deviceStatus.getR3.relay == 'active' ? true : false;
      sw = deviceStatus.getR3.status == 'ON' ? true : false;
      sensor = deviceStatus.getPublicReport.currentSensor3 == 'active'
          ? true
          : false;
      timer = deviceStatus.getR3.timer == 'active' ? true : false;
      sensorState = deviceStatus.getPublicReport.currentSensor3;
      humidity = deviceStatus.getR3.humStatus == 'active' ? true : false;

      startTime = Jalali.now();
      endTime = Jalali.now();
    }
    else if (currentPage == Page.Relay7) {
      relayStatus = deviceStatus.getR7.relay == 'active' ? true : false;
      sw = deviceStatus.getR7.status == 'ON' ? true : false;
      timer = deviceStatus.getR7.timer == 'active' ? true : false;

      light = deviceStatus.getR7.light == 'active' ? true : false;

      startTime = Jalali.now();
      endTime = Jalali.now();
    }
    else if (currentPage == Page.Relay2) {
      relayStatus = deviceStatus.getR2.relay == 'active' ? true : false;
      sw = deviceStatus.getR2.status == 'ON' ? true : false;
      timer = deviceStatus.getR2.timer == 'active' ? true : false;

      startTime = Jalali.now();
      endTime = Jalali.now();
    }
    else if (currentPage == Page.Relay5) {
      relayStatus = deviceStatus.getR5.relay == 'active' ? true : false;
      sw = deviceStatus.getR5.status == 'ON' ? true : false;
      timer = deviceStatus.getR5.timer == 'active' ? true : false;

      startTime = Jalali.now();
      endTime = Jalali.now();
    }
  }

  changeMode(Status status) {
    statusOfRelay = status;
    emit(RelayInitial());
  }

  ///submit changes of relay
  changeStatus() async {
    ///for relay 1
    if (currentPage == Page.Relay1) {
      model.Relay newRelayState = deviceStatus.getR1;
      relayTimerSensor(newRelayState, '1', currentSensor: deviceStatus.getPublicReport.currentSensor1);

      sendSMS(
          '1:rl:${relayStatus == false ? 'd' : 'a'},time:${timer == false ? 'd' : 'a'}#');
    }else if (currentPage == Page.Relay6) {
      model.Relay newRelayState = deviceStatus.getR6;
      relayTimerSensor(newRelayState, '6', currentSensor: deviceStatus.getPublicReport.currentSensor6);

      sendSMS(
          '6:rl:${relayStatus == false ? 'd' : 'a'},time:${timer == false ? 'd' : 'a'}#');
    }else if (currentPage == Page.Relay3) {
      model.Relay newRelayState = deviceStatus.getR3;
      relayTimerSensor(deviceStatus.getR3, '3', currentSensor: deviceStatus.getPublicReport.currentSensor3);

      sendSMS(
          '3:rl:${relayStatus == false ? 'd' : 'a'},time:${timer == false ? 'd' : 'a'},hu:${humidity! ? 'a' : 'd'}#');
    }else if (currentPage == Page.Relay7) {
      model.Relay newRelayState = deviceStatus.getR7;
      relayTimerSensor(deviceStatus.getR7, '7');

      sendSMS(
          '7:rl:${relayStatus == false ? 'd' : 'a'},time:${timer == false ? 'd' : 'a'},lu:${light! ? 'a' : 'd'}#');
    }
    else if (currentPage == Page.Relay2) {
      model.Relay newRelayState = deviceStatus.getR2;
      relayTimerSensor(deviceStatus.getR2, '2');

      sendSMS(
          '2:rl:${relayStatus == false ? 'd' : 'a'},time:${timer == false ? 'd' : 'a'}#');
    }
    else if (currentPage == Page.Relay5) {
      model.Relay newRelayState = deviceStatus.getR5;
      relayTimerSensor(deviceStatus.getR5, '5');

      sendSMS(
          '5:rl:${relayStatus == false ? 'd' : 'a'},time:${timer == false ? 'd' : 'a'}#');
    }
    await deviceBox.put('info', deviceStatus);
    emit(RelayInitial());
  }

  relayTimerSensor(model.Relay newRelayState, String relay, {currentSensor}) {
    ///relay status
    //if (statusOfRelay == Status.sw) {
      newRelayState.relay = relayStatus == false ? 'deactive' : 'active';
      // deviceStatus.setR1 = newRelayState;
      sendSMS(relayStatus == false ? '$relay:off#' : '$relay:on#');
    // }

    ///timer status
     newRelayState.timer = timer == false ? 'deactive' : 'active';
     if (timer!) {//(statusOfRelay == Status.timer) {
      //in r1 else = timer
      newRelayState.startClock = '${startTime!.hour}:${startTime!.minute}';
      newRelayState.endClock = '${endTime!.hour}:${endTime!.minute}';
      if (infinity) {
        //set infinity loop for timer
        newRelayState.startDate = '11/11/11';
        newRelayState.endDate = '11/11/11';
//sms send
        sendSMS(
            '$relay:111111,${startTime!.hour.toString().padLeft(2, '0')}${startTime!.minute.toString().padLeft(2, '0')}-111111,${endTime!.hour.toString().padLeft(2, '0')}${endTime!.minute.toString().padLeft(2, '0')}#');
      } else {
        newRelayState.startDate =
            '${startdate!.year.toString().substring(2)}/${startdate!.month}/${startdate!.day}';
        newRelayState.endDate =
            '${enddate!.year.toString().substring(2)}/${enddate!.month}/${enddate!.day}';
//sms send
        sendSMS(
            '$relay:${newRelayState.startDate.replaceAll('/', '')},${startTime!.hour.toString().padLeft(2, '0')}${startTime!.minute.toString().padLeft(2, '0')}-${newRelayState.endDate.replaceAll('/', '')},${endTime!.hour.toString().padLeft(2, '0')}${endTime!.minute.toString().padLeft(2, '0')}#');
      }

      ///set timer status
      newRelayState.timer = timer == false ? 'deactive' : 'active';
    } //else if() {
      ///sensor
      if (currentSensor != null) {
        ///just for relay 1 or 6
        currentSensor = sensor! ? 'active' : 'deactive';
        sensorState = currentSensor;
        sendSMS(sensor! ? '$relay:CA#' : '$relay:CD#');
      }

    // }

    if (relay == '1') {
      deviceStatus.setR1 = newRelayState;
      deviceStatus.getPublicReport.currentSensor1 = currentSensor;
    } else if (relay == '6') {
      deviceStatus.setR6 = newRelayState;
      deviceStatus.getPublicReport.currentSensor6 = currentSensor;
    }else if (relay == '3') {
      newRelayState.humStatus = humidity! ? 'active' : 'deactive';
      if(humidity!) {
        newRelayState.humMin = sv.toString();
        newRelayState.humMax = ev.toString();
        sendSMS('h-min:$sv,max:$ev#'); //run operation if humidity is active
         }

      deviceStatus.setR3 = newRelayState;
      deviceStatus.getPublicReport.currentSensor3 = currentSensor;
    }else if (relay == '7') {
      newRelayState.light = light! ? 'active' : 'deactive';
      if(light!) {
        newRelayState.lux = sv.toString();
        sendSMS('lux:$sv#'); //run operation if light is active
         }

      deviceStatus.setR7 = newRelayState;
    } else if (relay == '2') {
      deviceStatus.setR2 = newRelayState;
    } else if (relay == '5') {
      deviceStatus.setR2 = newRelayState;
    }
  }

  switchMode() async {
    sw = !sw!;

    if (currentPage == Page.Relay1) {
      model.Relay newRelayState = deviceStatus.getR1;
      newRelayState.status = sw == true ? 'ON' : 'OFF';
    } else if (currentPage == Page.Relay6) {
      model.Relay newRelayState = deviceStatus.getR6;
      newRelayState.status = sw == true ? 'ON' : 'OFF';
    } else if (currentPage == Page.Relay3) {
      model.Relay newRelayState = deviceStatus.getR3;
      newRelayState.status = sw == true ? 'ON' : 'OFF';
    }else if (currentPage == Page.Relay7) {
      model.Relay newRelayState = deviceStatus.getR7;
      newRelayState.status = sw == true ? 'ON' : 'OFF';
    }else if (currentPage == Page.Relay2) {
      model.Relay newRelayState = deviceStatus.getR2;
      newRelayState.status = sw == true ? 'ON' : 'OFF';
    }else if (currentPage == Page.Relay5) {
      model.Relay newRelayState = deviceStatus.getR5;
      newRelayState.status = sw == true ? 'ON' : 'OFF';
    }

    await deviceBox.put('info', deviceStatus);
    emit(RelayInitial());
  }

  relay() {
    relayStatus = !relayStatus!;
    emit(RelayInitial());
  }

  currentSensor() {
    sensor = !sensor!;
    emit(RelayInitial());
  }

  timerChangeStatus() {
    timer = !timer!;
    emit(RelayInitial());
  }

  humidityStatus() {
    humidity = !humidity!;
    emit(RelayInitial());
  }

  lightStatus() {
    light = !light!;
    emit(RelayInitial());
  }

  loop() {
    infinity = !infinity;
    emit(RelayInitial());

    if (infinity) {
      selectedStartDate = 'حلقه تکرار';
      selectedEndDate = '';
    } else {
      selectedStartDate = '';
      selectedEndDate = '';
    }
  }
}