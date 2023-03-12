import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../compiling_sms.dart';
import '../../main.dart';
import '../temp_screen.dart';

part 'temp_state.dart';

class TempCubit extends Cubit<TempState> {
  TempCubit() : super(TempInitial());

  void init() {
    if(isCooler!) {
      automatic = deviceStatus.getPublicReport.autoCooler == 'auto-active';
infinity = deviceStatus.getCooler.startDate == '11/11/11';
      endMin = 16;
      sv = int.parse(constants.get('tempMin'));
      ev = int.parse(constants.get('tempMax'));
      if(deviceStatus.getCooler.startClock.contains(new RegExp(r'[0-9]'))) {
        startTime = Jalali(1234, 2, 2, int.parse(deviceStatus.getCooler.startClock.split(':')[0]), int.parse(deviceStatus.getCooler.startClock.split(':')[1]));
        selectedStartDate = 'تاریخ شروع: ${deviceStatus.getCooler.startDate == '11/11/11' ? 'حلقه تکرار' : deviceStatus.getCooler.startDate}';
      } else {
        startTime = Jalali.now();
      }
      if(deviceStatus.getCooler.endClock.contains(new RegExp(r'[0-9]'))) {
        endTime   = Jalali(1234, 2, 2, int.parse(deviceStatus.getCooler.endClock.split(':')[0]),   int.parse(deviceStatus.getCooler.endClock.split(':')[1]));
        selectedEndDate   = 'تاریخ پایان: ${deviceStatus.getCooler.endDate == '11/11/11' ? 'حلقه تکرار' :  deviceStatus.getCooler.endDate}';
      } else {
        endTime = Jalali.now();
      }
      rest = deviceStatus.getPublicReport.coolerRest == 'active';
    } else {
      automatic = deviceStatus.getPublicReport.autoHeater == 'auto-active';
      endMin = 16;
      sv = int.parse(constants.get('tempMin'));
      ev = int.parse(constants.get('tempMax'));
      infinity = deviceStatus.getHeater.startDate == '11/11/11';


      if(deviceStatus.getHeater.startClock.contains(new RegExp(r'[0-9]'))) {
        startTime = Jalali(1234, 2, 2, int.parse(deviceStatus.getHeater.startClock.split(':')[0]), int.parse(deviceStatus.getHeater.startClock.split(':')[1]));
        selectedStartDate = 'تاریخ شروع: ${deviceStatus.getHeater.startDate == '11/11/11' ? 'حلقه تکرار' : deviceStatus.getHeater.startDate}';
      } else {
        startTime = Jalali.now();
      }
      if(deviceStatus.getHeater.endClock.contains(new RegExp(r'[0-9]'))) {
        endTime   = Jalali(1234, 2, 2, int.parse(deviceStatus.getHeater.endClock.split(':')[0]),   int.parse(deviceStatus.getHeater.endClock.split(':')[1]));
        selectedEndDate   = 'تاریخ پایان: ${deviceStatus.getHeater.endDate == '11/11/11' ? 'حلقه تکرار' :  deviceStatus.getHeater.endDate}';
      } else {
        endTime = Jalali.now();
      }

      rest = deviceStatus.getPublicReport.heaterRest == 'active';
    }
    emit(TempInitial());
  }

  submitData() {
    if(isCooler!) {
      constants.put('tempMin', sv.toString());
      constants.put('tempMax', ev.toString());

      deviceStatus.getCooler.startClock = '${startTime!.hour}:${startTime!.minute}';
      deviceStatus.getCooler.endClock = '${endTime!.hour}:${endTime!.minute}';
      if(infinity) {
        deviceStatus.getCooler.startDate = '11/11/11';
        deviceStatus.getCooler.endDate = '11/11/11';
      } else {
        deviceStatus.getCooler.startDate = '${startdate!.year}/${startdate!.month}/${startdate!.day}';
        deviceStatus.getCooler.endDate = '${enddate!.year}/${enddate!.month}/${enddate!.day}';
        ///send sms
        var sdate = deviceStatus.getCooler.startDate.split('/')[0].padLeft(2, '0').substring(2) + deviceStatus.getCooler.startDate.split('/')[1].padLeft(2, '0') + deviceStatus.getCooler.startDate.split('/')[2].padLeft(2, '0');
        var edate = deviceStatus.getCooler.endDate.split('/')[0].padLeft(2, '0').substring(2) + deviceStatus.getCooler.endDate.split('/')[1].padLeft(2, '0') + deviceStatus.getCooler.endDate.split('/')[2].padLeft(2, '0');
        var sclock = deviceStatus.getCooler.startClock.split(':')[0].padLeft(2, '0') + deviceStatus.getCooler.startClock.split(':')[1].padLeft(2, '0');
        var eclock = deviceStatus.getCooler.endClock.split(':')[0].padLeft(2, '0') + deviceStatus.getCooler.endClock.split(':')[1].padLeft(2, '0');
        sendSMS('C/H:$sdate,$sclock-$edate,$eclock#');
        sendSMS('T-min:$sv,max:$ev#');}

    deviceBox.put('info', deviceStatus);
    }
    else {
      constants.put('tempMin', sv.toString());
      constants.put('tempMax', ev.toString());

      deviceStatus.getHeater.startClock = '${startTime!.hour}:${startTime!.minute}';
      deviceStatus.getHeater.endClock = '${endTime!.hour}:${endTime!.minute}';
      if(infinity) {
        deviceStatus.getHeater.startDate = '11/11/11';
        deviceStatus.getHeater.endDate = '11/11/11';
      } else {
        deviceStatus.getHeater.startDate = '${startdate!.year}/${startdate!.month}/${startdate!.day}';
        deviceStatus.getHeater.endDate = '${enddate!.year}/${enddate!.month}/${enddate!.day}';
        ///send sms
        var sdate = deviceStatus.getHeater.startDate.split('/')[0].padLeft(2, '0').substring(2) + deviceStatus.getHeater.startDate.split('/')[1].padLeft(2, '0') + deviceStatus.getHeater.startDate.split('/')[2].padLeft(2, '0');
        var edate = deviceStatus.getHeater.endDate.split('/')[0].padLeft(2, '0').substring(2) + deviceStatus.getHeater.endDate.split('/')[1].padLeft(2, '0') + deviceStatus.getHeater.endDate.split('/')[2].padLeft(2, '0');
        var sclock = deviceStatus.getHeater.startClock.split(':')[0].padLeft(2, '0') + deviceStatus.getHeater.startClock.split(':')[1].padLeft(2, '0');
        var eclock = deviceStatus.getHeater.endClock.split(':')[0].padLeft(2, '0') + deviceStatus.getHeater.endClock.split(':')[1].padLeft(2, '0');
        sendSMS('C/H:$sdate,$sclock-$edate,$eclock#');
        sendSMS('T-min:$sv,max:$ev#');}

    }

    deviceBox.put('info', deviceStatus);
    emit(TempInitial());
  }
  void status() {
    automatic = !automatic;
    if(isCooler!) {
      deviceStatus.getPublicReport.autoCooler = automatic ? 'auto-active' : 'auto-deactive';
      sendSMS('Cooler:${automatic ? 'a' : 'd'}#');
      sendSMS('Heater:${automatic ? 'd' : 'a'}#');
    } else {
      deviceStatus.getPublicReport.autoHeater = automatic ? 'auto-active' : 'auto-deactive';
      sendSMS('Heater:${automatic ? 'a' : 'd'}#');
      sendSMS('Cooler:${automatic ? 'd' : 'a'}#');
    }
    deviceBox.put('info', deviceStatus);


    emit(TempInitial());
  }

  void changeRest() {
    rest = !rest!;
    if(isCooler!) {
      deviceStatus.getPublicReport.coolerRest = rest! ? 'active' : 'deactive';
    } else {
      deviceStatus.getPublicReport.heaterRest = rest! ? 'active' : 'deactive';
    }
    deviceBox.put('info', deviceStatus);

    sendSMS('C-H-${rest! ? 'Active' : 'Deactive'} Rest');
    emit(TempInitial());
  }
  void loop() {
    infinity = !infinity;
    selectedStartDate = infinity ? 'حلقه تکرار' : '';
    selectedEndDate = '';
    emit(TempInitial());
  }

  void update(datetime) {
    // endTime = datetime;
    emit(TempInitial());
  }

  addDevice() {
    if(!constants.values.toList().contains(isCooler!? 'cooler' : 'heater')) {
      constants.add(isCooler!? 'cooler' : 'heater');
    }

    if(isCooler!) {
      sendSMS('Device,ADD,Cooler');
    } else {
      sendSMS('Device,ADD,Heater');
    }

    emit(TempInitial());
  }

  removeDevice() {
    for (int i = 0 ; i < constants.values.length; i++) {
      if(constants.values.toList()[i]==(isCooler!? 'cooler' : 'heater')) {
        constants.deleteAt(i);
      }
    }

    if(isCooler!) {
      sendSMS('Device,RMV,Cooler');
    } else {
      sendSMS('Device,RMV,Heater');
    }

    emit(TempInitial());
  }
}
