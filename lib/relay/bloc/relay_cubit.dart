import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' as m;
import 'package:knob_widget/knob_widget.dart';
import 'package:meta/meta.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shome/compiling_sms.dart';
import 'package:shome/main.dart';
import 'package:shome/relay/relay.dart';
import '../../icon/icon.dart';
import '../../models/status.dart' as model;

part 'relay_state.dart';

model.Relay? newRelayState;

enum Status {
  sw,
  timer,
  sensor, //sensor for r3 = humidity
  act
}

class RelayCubit extends Cubit<RelayState> {
  RelayCubit() : super(RelayInitial());

  initRelay() async {
    try {
      statusOfRelay = Status.sw;
      startdate = null;
      enddate = null;
      selectedStartDate = '';
      selectedEndDate = '';

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

        newRelayState = deviceStatus.getR1;
      } else if (currentPage == Page.Relay6) {
        relayStatus = deviceStatus.getR6.relay == 'active' ? true : false;
        sw = deviceStatus.getR6.status == 'ON' ? true : false;
        sensor = deviceStatus.getPublicReport.currentSensor6 == 'active'
            ? true
            : false;
        timer = deviceStatus.getR6.timer == 'active' ? true : false;
        sensorState = deviceStatus.getPublicReport.currentSensor6;

        startTime = Jalali.now();
        endTime = Jalali.now();
        newRelayState = deviceStatus.getR6;
      } else if (currentPage == Page.Relay3) {
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
        newRelayState = deviceStatus.getR3;
      } else if (currentPage == Page.Relay7) {
        relayStatus = deviceStatus.getR7.relay == 'active' ? true : false;
        sw = deviceStatus.getR7.status == 'ON' ? true : false;
        timer = deviceStatus.getR7.timer == 'active' ? true : false;

        light = deviceStatus.getR7.light == 'active' ? true : false;

        startTime = Jalali.now();
        endTime = Jalali.now();
        newRelayState = deviceStatus.getR7;
      } else if (currentPage == Page.Relay2) {
        relayStatus = deviceStatus.getR2.relay == 'active' ? true : false;
        sw = deviceStatus.getR2.status == 'ON' ? true : false;
        timer = deviceStatus.getR2.timer == 'active' ? true : false;

        startTime = Jalali.now();
        endTime = Jalali.now();
        newRelayState = deviceStatus.getR2;
      } else if (currentPage == Page.Relay5) {
        relayStatus = deviceStatus.getR5.relay == 'active' ? true : false;
        sw = deviceStatus.getR5.status == 'ON' ? true : false;
        timer = deviceStatus.getR5.timer == 'active' ? true : false;

        startTime = Jalali.now();
        endTime = Jalali.now();
        newRelayState = deviceStatus.getR5;
      } else if (currentPage == Page.Relay4) {
        sw = deviceStatus.getR4.status == 'ON' ? true : false;
      }
    } catch (e) {
      dialog(
          'Error',
          m.Text(
              'No Data Found, Please request a full report from your device'),
          () => m.Navigator.pop(buildContext));
    }
  }

  changeMode(Status status) {
    statusOfRelay = status;
    emit(RelayInitial());
  }

  updateUI() => emit(RelayInitial());



  changeTime() {
    ///relay status
    //if (statusOfRelay == Status.sw) {

    // deviceStatus.setR1 = newRelayState;

    // }

    ///timer status
    newRelayState!.timer = timer == false ? 'deactive' : 'active';
    try {
      if (timer!) {
        //(statusOfRelay == Status.timer) {
        //in r1 else = timer
        newRelayState!.startClock = '${startTime!.hour}:${startTime!.minute}';
        newRelayState!.endClock = '${endTime!.hour}:${endTime!.minute}';
        if (infinity) {
          //set infinity loop for timer
          newRelayState!.startDate = '11/11/11';
          newRelayState!.endDate = '11/11/11';
//sms send
          sendSMS(
              '$pageNumber:111111,${startTime!.hour.toString().padLeft(2, '0')}${startTime!.minute.toString().padLeft(2, '0')}-111111,${endTime!.hour.toString().padLeft(2, '0')}${endTime!.minute.toString().padLeft(2, '0')}#',
              showDialog: false);
        } else {
          newRelayState!.startDate =
              '${startdate!.year.toString().substring(2)}/${startdate!.month}/${startdate!.day}';
          newRelayState!.endDate =
              '${enddate!.year.toString().substring(2)}/${enddate!.month}/${enddate!.day}';
//sms send
          sendSMS(
              '$pageNumber:${newRelayState!.startDate.replaceAll('/', '')},${startTime!.hour.toString().padLeft(2, '0')}${startTime!.minute.toString().padLeft(2, '0')}-${newRelayState!.endDate.replaceAll('/', '')},${endTime!.hour.toString().padLeft(2, '0')}${endTime!.minute.toString().padLeft(2, '0')}#',
              showDialog: false);
        }

        ///set timer status
        newRelayState!.timer = timer == false ? 'deactive' : 'active';
      }
    } catch (e) {
      dialog(
          'Please set date',
          m.Text('If you activated timer, you must select start and end date'),
          () => m.Navigator.pop(buildContext),
          removeCancel: true);
    }

    if (pageNumber == '1') {
      deviceStatus.setR1 = newRelayState;
    } else if (pageNumber == '6') {
      deviceStatus.setR6 = newRelayState;
    } else if (pageNumber == '3') {
      deviceStatus.setR3 = newRelayState;
    } else if (pageNumber == '7') {
      deviceStatus.setR7 = newRelayState;
    } else if (pageNumber == '2') {
      deviceStatus.setR2 = newRelayState;
    } else if (pageNumber == '5') {
      deviceStatus.setR2 = newRelayState;
    }
  }

  switchMode() async {
    sw = !sw!;

    newRelayState!.status = sw == true ? 'ON' : 'OFF';
    sendSMS(
        '$pageNumber:rl:${sw == false ? 'd' : 'a'},time:${timer == false ? 'd' : 'a'}${currentPage == Page.Relay7 ? ',lu:${light! ? 'a' : 'd'}' : currentPage == Page.Relay3 ? ',hu:${humidity! ? 'a' : 'd'}' : ''}#');
    await deviceBox.put('info', deviceStatus);
    emit(RelayInitial());
  }

  relay() async{
    relayStatus = !relayStatus!;

    newRelayState!.relay = relayStatus == false ? 'deactive' : 'active';
    sendSMS(relayStatus == false ? '$pageNumber:off#' : '$pageNumber:on#');

    await deviceBox.put('info', deviceStatus);
    emit(RelayInitial());
  }

  ///just for relay 1 or 6 or 3
  currentSensor() async{
    sensor = !sensor!;

    var current = currentPage == Page.Relay1
        ? deviceStatus.getPublicReport.currentSensor1
        : currentPage == Page.Relay3
            ? deviceStatus.getPublicReport.currentSensor3
            : deviceStatus.getPublicReport.currentSensor6;

    current = sensor! ? 'active' : 'deactive';

    sensorState = current;
    sendSMS(sensor! ? '$pageNumber:CA#' : '$pageNumber:CD#');

    if(currentPage == Page.Relay1) deviceStatus.getPublicReport.currentSensor1 = current;
    else if(currentPage == Page.Relay3) deviceStatus.getPublicReport.currentSensor3 = current;
    else if(currentPage == Page.Relay6) deviceStatus.getPublicReport.currentSensor6 = current;

    await deviceBox.put('info', deviceStatus);
    emit(RelayInitial());
  }

  timerChangeStatus() {
    timer = !timer!;
    sendSMS(
        '$pageNumber:rl:${sw == false ? 'd' : 'a'},time:${timer == false ? 'd' : 'a'}${currentPage == Page.Relay7 ? ',lu:${light! ? 'a' : 'd'}' : currentPage == Page.Relay3 ? ',hu:${humidity! ? 'a' : 'd'}' : ''}#');

    emit(RelayInitial());
  }

  humidityStatus() {
    humidity = !humidity!;
    newRelayState!.humStatus = humidity! ? 'active' : 'deactive';

    sendSMS(
        '$pageNumber:rl:${sw == false ? 'd' : 'a'},time:${timer == false ? 'd' : 'a'},hu:${humidity! ? 'a' : 'd'}#');

    deviceStatus.setR3 = newRelayState; ///because humidity only in relay 3
    deviceBox.put('info', deviceStatus);
    emit(RelayInitial());
  }

  lightStatus() async{
    light = !light!;
    newRelayState!.light = light! ? 'active' : 'deactive';

    sendSMS(
        '$pageNumber:rl:${sw == false ? 'd' : 'a'},time:${timer == false ? 'd' : 'a'},lu:${light! ? 'a' : 'd'}#');

    deviceStatus.setR7 = newRelayState;
    await deviceBox.put('info', deviceStatus);
    emit(RelayInitial());
  }

  humudityAct(){
    newRelayState!.humStatus = humidity! ? 'active' : 'deactive';

      newRelayState!.humMin = sv.toString();
      newRelayState!.humMax = ev.toString();
      sendSMS('h-min:$sv,max:$ev#', showDialog: false); //run operation if humidity is active

    deviceStatus.setR3 = newRelayState;
    deviceBox.put('info', deviceStatus);
  }

  lightAct(){
      newRelayState!.lux = sv.toString();
      sendSMS('lux:$sv#', showDialog: false); //run operation if light is active

    deviceStatus.setR7 = newRelayState;
    deviceBox.put('info', deviceStatus);
  }

  loop() {
    infinity = !infinity;
    emit(RelayInitial());

    if (infinity) {
      selectedStartDate = ':Start & End date';
      selectedEndDate = 'Repeat every day';
    } else {
      selectedStartDate = '';
      selectedEndDate = '';
    }
  }

  relay4Switch() {
    sendSMS('4:on#');
  }

  icon({is2b = false}) {
    if (is2b) {
      iconKey = 'IR2b';
    } else if (currentPage == Page.Relay2) {
      iconKey = 'IR2';
    } else if (currentPage == Page.Relay4) {
      iconKey = 'IR4';
    } else if (currentPage == Page.Relay3) {
      iconKey = 'IR3';
    } else if (currentPage == Page.Relay5) {
      iconKey = 'IR5';
    } else if (currentPage == Page.Relay6) {
      iconKey = 'IR6';
    } else if (currentPage == Page.Relay7) {
      iconKey = 'IR7';
    }

    m.Navigator.push(
        buildContext, m.MaterialPageRoute(builder: (context) => Icon()));
  }
}
