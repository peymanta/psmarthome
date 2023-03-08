import 'package:bloc/bloc.dart';
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
  sensor //sensor for r3 = humidity
}

class RelayCubit extends Cubit<RelayState> {
  RelayCubit() : super(RelayInitial());

  initRelay() {
    if (currentPage == Page.Relay1) {
      relayStatus = deviceStatus.getR1.relay == 'active' ? true : false;
      sw = deviceStatus.getR1.status == 'ON' ? true : false;
      sensor = deviceStatus.getPublicReport.currentSensor1 == 'AC' ? true : false;

      start = Jalali.now();
      end = Jalali.now();
    }
  }

  changeMode(Status status) {
    statusOfRelay = status;
    emit(RelayInitial());
  }

  changeStatus() async {
    if (currentPage == Page.Relay1) {
      model.Relay newRelayState = deviceStatus.getR1;
//relay
      if (statusOfRelay == Status.sw) {
        newRelayState.relay = relayStatus == false ? 'deactive' : 'active';

        deviceStatus.setR1 = newRelayState;

        sendSMS(relayStatus == false? '1:off#' : '1:on#');
      }
      else if (statusOfRelay == Status.timer) {
        //in r1 else = timer
        newRelayState.startClock = '${start!.hour}:${start!.minute}';
        newRelayState.endClock = '${end!.hour}:${end!.minute}';
        if(infinity) { //set infinity loop for timer
          newRelayState.startDate = '11/11/11';
          newRelayState.endDate = '11/11/11';
//sms send
          sendSMS('1:111111,${start!.hour.toString().padLeft(2, '0')}${start!.minute.toString().padLeft(2, '0')}-111111,${end!.hour.toString().padLeft(2, '0')}${end!.minute.toString().padLeft(2, '0')}#');
        } else {
          newRelayState.startDate = '${startdate!.year.toString().substring(2)}/${startdate!.month}/${startdate!.day}';
          newRelayState.endDate = '${enddate!.year.toString().substring(2)}/${enddate!.month}/${enddate!.day}';
//sms send
          sendSMS('1:${newRelayState.startDate.replaceAll('/', '')},${start!.hour.toString().padLeft(2, '0')}${start!.minute.toString().padLeft(2, '0')}-${newRelayState.endDate.replaceAll('/', '')},${end!.hour.toString().padLeft(2, '0')}${end!.minute.toString().padLeft(2, '0')}#');
        }
        print(newRelayState.startDate);
        print(newRelayState.endDate);
      }
      else {//sensor
        deviceStatus.getPublicReport.currentSensor1 = sensor! ? 'active' : 'deactive';
        sendSMS(sensor! ? '1:CA#' : '1:CD#');
      }
      //current sensor

    }
    await deviceBox.put('info', deviceStatus);
    emit(RelayInitial());
  }

  switchMode() async{
    sw = !sw!;

    if(currentPage == Page.Relay1){
      model.Relay newRelayState = deviceStatus.getR1;
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

  loop() {
    infinity = !infinity;
    emit(RelayInitial());

    if(infinity) {
      selectedStartDate = 'حلقه تکرار';
      selectedEndDate = '';
    } else {
      selectedStartDate ='';
      selectedEndDate = '';
    }
  }
}
