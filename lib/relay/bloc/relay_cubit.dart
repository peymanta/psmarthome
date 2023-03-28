import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' as m;
import 'package:knob_widget/knob_widget.dart';
import 'package:meta/meta.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:shamsi_date/shamsi_date.dart' as shamsi_date;
import 'package:shome/compiling_sms.dart';
import 'package:shome/main.dart';
import 'package:shome/relay/relay.dart';
import '../../colors.dart';
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
      // startdate = null;
      // enddate = null;
      selectedStartDate = '';
      // selectedEndDate = '';

      switch(currentPage){
        case Page.Relay1:
          relayStatus = deviceStatus.getR1.relay == 'active' ;
          sw = deviceStatus.getR1.status == 'ON';
          sensor = deviceStatus.getPublicReport.currentSensor1 == 'active';
          timer = deviceStatus.getR1.timer == 'active';
          sensorState = deviceStatus.getPublicReport.currentSensor1;
          startTime = shamsi_date.Jalali.now();
          endTime = shamsi_date.Jalali.now();
          infinity = deviceStatus.getR1.startDate == '11/11/11' && deviceStatus.getR1.endDate == '11/11/11';
          startdate = Jalali(int.parse(deviceStatus.getR1.startDate.split('/')[0]),int.parse(deviceStatus.getR1.startDate.split('/')[1]),int.parse(deviceStatus.getR1.startDate.split('/')[2]));
          enddate = Jalali(int.parse(deviceStatus.getR1.endDate.split('/')[0]),int.parse(deviceStatus.getR1.endDate.split('/')[1]),int.parse(deviceStatus.getR1.endDate.split('/')[2]));
          newRelayState = deviceStatus.getR1;
          print(startdate);
          break;

        case Page.Relay2:
          relayStatus = deviceStatus.getR2.relay == 'active' ;
          sw = deviceStatus.getR2.status == 'ON' ;
          timer = deviceStatus.getR2.timer == 'active' ;
          startTime = shamsi_date.Jalali.now();
          endTime = shamsi_date.Jalali.now();
          infinity = deviceStatus.getR2.startDate == '11/11/11' && deviceStatus.getR2.endDate == '11/11/11';
          startdate = Jalali(int.parse(deviceStatus.getR2.startDate.split('/')[0]),int.parse(deviceStatus.getR2.startDate.split('/')[1]),int.parse(deviceStatus.getR2.startDate.split('/')[2]));
          enddate = Jalali(int.parse(deviceStatus.getR2.endDate.split('/')[0]),int.parse(deviceStatus.getR2.endDate.split('/')[1]),int.parse(deviceStatus.getR2.endDate.split('/')[2]));
          newRelayState = deviceStatus.getR2;
          break;

        case Page.Relay3:
          relayStatus = deviceStatus.getR3.relay == 'active' ;
          sw = deviceStatus.getR3.status == 'ON' ;
          sensor = deviceStatus.getPublicReport.currentSensor3 == 'active'? true: false;
          timer = deviceStatus.getR3.timer == 'active' ;
          sensorState = deviceStatus.getPublicReport.currentSensor3;
          humidity = deviceStatus.getR3.humStatus == 'active' ;
          startTime = shamsi_date.Jalali.now();
          endTime = shamsi_date.Jalali.now();
          infinity = deviceStatus.getR3.startDate == '11/11/11' && deviceStatus.getR3.endDate == '11/11/11';
          startdate = Jalali(int.parse(deviceStatus.getR3.startDate.split('/')[0]),int.parse(deviceStatus.getR3.startDate.split('/')[1]),int.parse(deviceStatus.getR3.startDate.split('/')[2]));
          enddate = Jalali(int.parse(deviceStatus.getR3.endDate.split('/')[0]),int.parse(deviceStatus.getR3.endDate.split('/')[1]),int.parse(deviceStatus.getR3.endDate.split('/')[2]));
          newRelayState = deviceStatus.getR3;
          break;

        case Page.Relay4:
          sw = deviceStatus.getR4.status == 'ON' ;
          break;

        case Page.Relay5:
          relayStatus = deviceStatus.getR5.relay == 'active' ;
          sw = deviceStatus.getR5.status == 'ON' ;
          timer = deviceStatus.getR5.timer == 'active' ;
          startTime = shamsi_date.Jalali.now();
          endTime = shamsi_date.Jalali.now();
          infinity = deviceStatus.getR5.startDate == '11/11/11' && deviceStatus.getR5.endDate == '11/11/11';
          startdate = Jalali(int.parse(deviceStatus.getR5.startDate.split('/')[0]),int.parse(deviceStatus.getR5.startDate.split('/')[1]),int.parse(deviceStatus.getR5.startDate.split('/')[2]));
          enddate = Jalali(int.parse(deviceStatus.getR5.endDate.split('/')[0]),int.parse(deviceStatus.getR5.endDate.split('/')[1]),int.parse(deviceStatus.getR5.endDate.split('/')[2]));
          newRelayState = deviceStatus.getR5;
          break;

        case Page.Relay6:
          relayStatus = deviceStatus.getR6.relay == 'active' ;
          sw = deviceStatus.getR6.status == 'ON' ;
          sensor = deviceStatus.getPublicReport.currentSensor6 == 'active'? true: false;
          timer = deviceStatus.getR6.timer == 'active' ;
          sensorState = deviceStatus.getPublicReport.currentSensor6;
          startTime = shamsi_date.Jalali.now();
          endTime = shamsi_date.Jalali.now();
          infinity = deviceStatus.getR6.startDate == '11/11/11' && deviceStatus.getR6.endDate == '11/11/11';
          startdate = Jalali(int.parse(deviceStatus.getR6.startDate.split('/')[0]),int.parse(deviceStatus.getR6.startDate.split('/')[1]),int.parse(deviceStatus.getR6.startDate.split('/')[2]));
          enddate = Jalali(int.parse(deviceStatus.getR6.endDate.split('/')[0]),int.parse(deviceStatus.getR6.endDate.split('/')[1]),int.parse(deviceStatus.getR6.endDate.split('/')[2]));
          newRelayState = deviceStatus.getR6;
          break;

        case Page.Relay7:
          relayStatus = deviceStatus.getR7.relay == 'active' ;
          sw = deviceStatus.getR7.status == 'ON';
          timer = deviceStatus.getR7.timer == 'active';
          light = deviceStatus.getR7.light == 'active';
          startTime  = shamsi_date.Jalali.now();
          endTime = shamsi_date.Jalali.now();
          infinity = deviceStatus.getR7.startDate == '11/11/11' && deviceStatus.getR7.endDate == '11/11/11';
          startdate = Jalali(int.parse(deviceStatus.getR7.startDate.split('/')[0]),int.parse(deviceStatus.getR7.startDate.split('/')[1]),int.parse(deviceStatus.getR7.startDate.split('/')[2]));
          enddate = Jalali(int.parse(deviceStatus.getR7.endDate.split('/')[0]),int.parse(deviceStatus.getR7.endDate.split('/')[1]),int.parse(deviceStatus.getR7.endDate.split('/')[2]));
          newRelayState = deviceStatus.getR7;
          break;

        default:
          dialog(
              'Error',
              const m.Text(
                  'No Data Found, Please request a full report from your device'),
                  () => m.Navigator.pop(buildContext)
          );
          break;
      }

      if(infinity) {
        selectedStartDate = ':Start & End date\nRepeat every day';
        // selectedEndDate = 'Repeat every day';
      } else {
        selectedStartDate = 'Selected date: ${startdate.formatCompactDate()}';
        // selectedEndDate = 'selected end date: ${enddate.formatCompactDate()}';
      }
    } catch (e) {
      dialog(
          'Error',
          const m.Text(
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
    ///timer status
    newRelayState!.timer = timer == false ? 'deactive' : 'active';
    try {
      // if (timer) {
        //in r1 else = timer
        newRelayState!.startClock = '${startTime.hour}:${startTime.minute}';
        newRelayState!.endClock = '${endTime.hour}:${endTime.minute}';
        if (infinity) {
          //set infinity loop for timer
          newRelayState!.startDate = '11/11/11';
          newRelayState!.endDate = '11/11/11';
//sms send
          sendSMS(
              '$pageNumber:111111,${startTime.hour.toString().padLeft(2, '0')}${startTime.minute.toString().padLeft(2, '0')}-111111,${endTime.hour.toString().padLeft(2, '0')}${endTime.minute.toString().padLeft(2, '0')}#',
              showDialog: false);
        } else {
          newRelayState!.startDate =
          '${startdate.year.toString()}/${startdate.month.toString().padLeft(2, '0')}/${startdate.day.toString().padLeft(2, '0')}';
          newRelayState!.endDate =
          '${enddate.year.toString()}/${enddate.month.toString().padLeft(2, '0')}/${enddate.day.toString().padLeft(2, '0')}';

          var start =
              '${startdate.year.toString().substring(2)}/${startdate.month.toString().padLeft(2, '0')}/${startdate.day.toString().padLeft(2, '0')}';
          var end =
              '${enddate.year.toString().substring(2)}/${enddate.month.toString().padLeft(2, '0')}/${enddate.day.toString().padLeft(2, '0')}';

//sms send
          sendSMS(
              '$pageNumber:${start.replaceAll('/', '')},${startTime.hour.toString().padLeft(2, '0')}${startTime.minute.toString().padLeft(2, '0')}-${end.replaceAll('/', '')},${endTime.hour.toString().padLeft(2, '0')}${endTime.minute.toString().padLeft(2, '0')}#',
              showDialog: false);
        }

        ///set timer status
        newRelayState!.timer = timer == false ? 'deactive' : 'active';
      // }
    } catch (e) {
      dialog(
          'Please set date',
          const m.Text('If you activated timer, you must select start and end date'),
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
      deviceStatus.setR5 = newRelayState;
    }
    
    deviceBox.put('info', deviceStatus);
  }

  switchMode() async {
    var swVar = !sw;

    sendSMS(
        '$pageNumber:rl:${swVar == false ? 'd' : 'a'},time:${timer == false ? 'd' : 'a'}${currentPage == Page.Relay7 ? ',lu:${light? 'a' : 'd'}' : currentPage == Page.Relay3 ? ',hu:${humidity? 'a' : 'd'}' : ''}#',
    onPressed: () async{
          sw = swVar;
      newRelayState!.status = sw == true ? 'ON' : 'OFF';
      await deviceBox.put('info', deviceStatus);
      emit(RelayInitial());});
  }

  relay() async{
    var relayStatusVar = !relayStatus;
    sendSMS(relayStatusVar == false ? '$pageNumber:off#' : '$pageNumber:on#', onPressed: () async{
      relayStatus = relayStatusVar;
      newRelayState!.relay = relayStatus == false ? 'deactive' : 'active';
      await deviceBox.put('info', deviceStatus);
      emit(RelayInitial());
    });

  }

  ///just for relay 1 or 6 or 3
  currentSensor() async{
    var sensorVar = !sensor;

    sendSMS(sensorVar? '$pageNumber:CA#' : '$pageNumber:CD#', onPressed: () async{
      sensor = sensorVar;

      var current = currentPage == Page.Relay1
          ? deviceStatus.getPublicReport.currentSensor1
          : currentPage == Page.Relay3
          ? deviceStatus.getPublicReport.currentSensor3
          : deviceStatus.getPublicReport.currentSensor6;

      current = sensor? 'active' : 'deactive';

      sensorState = current;

      if(currentPage == Page.Relay1) deviceStatus.getPublicReport.currentSensor1 = current;
      else if(currentPage == Page.Relay3) deviceStatus.getPublicReport.currentSensor3 = current;
      else if(currentPage == Page.Relay6) deviceStatus.getPublicReport.currentSensor6 = current;

      await deviceBox.put('info', deviceStatus);
      emit(RelayInitial());
    });

  }

  timerChangeStatus() {
    var timerVar = !timer;
    sendSMS(
        '$pageNumber:rl:${sw == false ? 'd' : 'a'},time:${timerVar == false ? 'd' : 'a'}${currentPage == Page.Relay7 ? ',lu:${light? 'a' : 'd'}' : currentPage == Page.Relay3 ? ',hu:${humidity? 'a' : 'd'}' : ''}#',
    onPressed: () {
          timer = timerVar;
          newRelayState!.timer = timer? 'active' : 'deactive';
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
            deviceStatus.setR5 = newRelayState;
          }
          deviceBox.put('info', deviceStatus);
      emit(RelayInitial());
        });


  }

  humidityStatus() {
    var humidityVar = !humidity;

    sendSMS(
        '$pageNumber:rl:${sw == false ? 'd' : 'a'},time:${timer == false ? 'd' : 'a'},hu:${humidityVar? 'a' : 'd'}#', onPressed: (){
          humidity = humidityVar;
      newRelayState!.humStatus = humidity? 'active' : 'deactive';

      deviceStatus.setR3 = newRelayState; ///because humidity only in relay 3
      deviceBox.put('info', deviceStatus);
      constants.put('IR2', humidity? 'assets/selectable-icons/fan.png' : 'assets/selectable-icons/question.png');
      mainController.updateMain();

      emit(RelayInitial());
    });

  }

  lightStatus() async{
    var lightVar = !light;

    sendSMS(
        '$pageNumber:rl:${sw == false ? 'd' : 'a'},time:${timer == false ? 'd' : 'a'},lu:${lightVar? 'a' : 'd'}#', onPressed: () async{
          light = lightVar;

      newRelayState!.light = light? 'active' : 'deactive';

      deviceStatus.setR7 = newRelayState;
      await deviceBox.put('info', deviceStatus);
      emit(RelayInitial());
    });

  }

  humudityAct(){
    newRelayState!.humStatus = humidity? 'active' : 'deactive';

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
      selectedStartDate = ':Start & End date\nRepeat every day';
      // selectedEndDate = 'Repeat every day';
    } else {
      selectedStartDate = startdate.formatCompactDate().contains('0011/')? '' : 'Selected date: ${startdate.formatCompactDate()}';
      // selectedStartDate = '';
      // selectedEndDate = '';
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
        buildContext, m.MaterialPageRoute(builder: (context) => const Icon()));
  }

  void relay7knob(){
    sv = deviceStatus.getR7.lux.isNotEmpty ? int.parse(deviceStatus.getR7.lux) : 1;
    start = KnobController(
        minimum: 1,
        maximum: 50,
        initial: deviceStatus.getR7.lux.isNotEmpty ? double.parse(deviceStatus.getR7.lux).clamp(1, 50) : 1);

    dialog('Set light',
     m.StatefulBuilder(
       builder: (context, setState) {
         start!.addOnValueChangedListener((p) {
           setState(() {
             sv = p.toInt();
           });
         });
         return m.Column(
          children: [
            m.Center(
              child: m.Padding(
                padding: const m.EdgeInsets.all(5),
                child: m.SizedBox(
                  width: 150,
                  height: 150,
                  child: Knob(
                    controller: start,
                    style: const KnobStyle(
                      labelStyle: m.TextStyle(
                          color: m.Colors.transparent),
                      controlStyle: ControlStyle(
                          tickStyle: ControlTickStyle(
                              color: m.Colors.transparent),
                          glowColor: m.Colors.transparent,
                          backgroundColor: m.Color(0xffdde6e8),
                          shadowColor: m.Color(0xffd4d6dd)),
                      pointerStyle: PointerStyle(color: blue),
                      minorTickStyle: MinorTickStyle(
                          color: m.Color(0xffaaadba),
                          length: 6),
                      majorTickStyle: MajorTickStyle(
                          color: m.Color(0xffaaadba),
                          length: 6),
                    ),
                  ),
                ),
              ),
            ),
            const m.SizedBox(
              height: 10,
            ),
            m.Text(sv.toString()),
          ],
    );
       }
     ), (){
            lightAct();
            m.Navigator.pop(buildContext);
        });
  }

  relay3knob() {
    endMin = 0;
    sv = deviceStatus.getR3.humMin.isNotEmpty ? int.parse(deviceStatus.getR3.humMin) : 5;
    ev = deviceStatus.getR3.humMin.isNotEmpty ? int.parse(deviceStatus.getR3.humMax) : 9;
    start = KnobController(
        minimum: 5, //0
        maximum: 95, //95
        initial:
        endMin!.clamp(deviceStatus.getR3.humMin.isNotEmpty? double.parse(deviceStatus.getR3.humMin) : 5, 95));
    end = KnobController(
        minimum: 9, //5 endmin+4 or 9
        maximum: 95, //95
        initial:
        endMin!.clamp(deviceStatus.getR3.humMax.isNotEmpty? double.parse(deviceStatus.getR3.humMax) : 9, 95));

    dialog('Set humidity', m.StatefulBuilder(
      builder: (context, setState) {
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
        return m.Row(
          children: [
            knob(start!, sv!),
            knob(end!, ev!),
          ],
        );}), () {
      humudityAct();
      m.Navigator.pop(buildContext);
    });
      }

  m.Widget knob(KnobController controller, int value) {
    return m.Expanded(
      child: m.Column(
        children: [
          m.Padding(
            padding: const m.EdgeInsets.all(5),
            child: m.SizedBox(
              width: 150,
              height: 150,
              child: Knob(
                controller: controller,
                style: const KnobStyle(
                  labelStyle: m.TextStyle(
                      color: m.Colors.transparent),
                  controlStyle: ControlStyle(
                      tickStyle: ControlTickStyle(
                          color: m.Colors.transparent),
                      glowColor: m.Colors.transparent,
                      backgroundColor: m.Color(0xffdde6e8),
                      shadowColor: m.Color(0xffd4d6dd)),
                  pointerStyle: PointerStyle(color: blue),
                  minorTickStyle: MinorTickStyle(
                      color: m.Color(0xffaaadba),
                      length: 6),
                  majorTickStyle: MajorTickStyle(
                      color: m.Color(0xffaaadba),
                      length: 6),
                ),
              ),
            ),
          ),
          const m.SizedBox(
            height: 10,
          ),
          m.Text(value.toString()),
        ],
    ));
  }
}
