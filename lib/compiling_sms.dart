import 'package:flutter/cupertino.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:telephony/telephony.dart';
import 'main.dart';
import 'models/status.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:background_sms/background_sms.dart';


sendSMS(sms, {showDialog = false}) async{
  await [Permission.sms].request(); //request permission

  if(await  Permission.sms.isGranted && showDialog) {
    dialog('Verify', Text('Do you agree with the operation?'), () {
    //   BackgroundSms.sendMessage(
    //       phoneNumber: constants.get('deviceNumber'), message: sms);
     showMessage('operation completed');
    });
  } else {
    // BackgroundSms.sendMessage(
    //     phoneNumber: constants.get('deviceNumber'), message: sms);
    showMessage('operation completed');
  }

print(sms);
}
compile(String sms) async{
//   var sms = '''1210 01:04
// s:A
// U:A
// M:N
// Ti:42
// TO:27,10
// HO:26
// B:N
// 12EN
// 5RN
// 4GN
// 5MN
// D1N
// S:A
// L1n2n
// L:Ni
// d:N
// E:H
// P:C
// r:A
// WP#1:C-2:R
// CU:1:DA,3:DA,6:DA
// V:D
// Ti#38
// TO#26
// H#27
// i#16
// F:0
// C:a
// 30min
// WC:D.''';

var sms = '''Cooler:
11/11/11-00:06
11/11/18-23:56
TEMP SET:20~25

WP1UP: OFF,Ra,Ta
11/11/11-16:30
11/11/11-23:55

WP1DN: ON,Ra,Td
11/11/13-00:00
11/11/11-23:55''';

// var sms = '''R1:
// OFF,Rd,Td,
// 11/11/11-00:01
// 11/11/11-23:55
//
// R2:
// ON ,Rd,Td
// 96/01/01-00:00
// 96/01/01-00:00
//
// R5:
// OFF,Rd,Td
// 96/01/01-00:00
// 96/01/01-00:00''';

// var sms = '''R3:
// OFF,Rd,Td,HU d
// 11/11/11-10:00
// 11/11/11-23:57
// HUM SET:15~70
//
// R6:
// OF,Rd,Td
// 11/11/11-18:15
// 11/11/11-23:55
//
// R7:
// OF,Rd,Td,LU d
// 11/11/11-00:01
// 11/11/11-01:20
// LU35''';

// var sms = '''WP2UP: ON,Rd,Ta
// 11/11/11-00:00
// 11/11/11-23:55
//
// WP2DN: OFF,Ra,Ta
// 11/11/11-00:01
// 11/11/11-23:55
//
// RM:A
// SR:m
// R:2
// P2000
// 9120232465
// 2144168346
// TFMN''';

// var sms = '''Disable the device first
//
// 101/5/19 22:47:33''';

  if(sms.split('\n')[1].contains('s:')) {
    compilePublicReport(sms);
  } else {
    compileSms(sms);
  }

  await deviceBox.put('info', deviceStatus);
}

compilePublicReport(String sms) {
  PublicReport model = new PublicReport();
  List<String> lines = sms.split('\n');

  model.setClock = lines[0].split(' ')[1];
  model.setDate = lines[0].split(' ')[0];
  model.setShortReport = lines[1].contains('A') ? 'active' : 'deactive';
  model.setBuzzer = lines[2].contains('A') ? 'active' : 'deactive';
  model.setMotionSensor = lines[3].contains('A') ? 'alarm' : 'normal';
  model.setInboxTemp = lines[4].substring(3);
  //chart
  chartsObject.inBoxTemps.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(lines[4].substring(3))));

  model.setOutBoxTemp = lines[5].substring(3).split(',')[0];
  //chart
  chartsObject.outBoxTemps.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(lines[5].substring(3).split(',')[0])));

  model.setTemp = lines[5].substring(3).split(',')[1];
  model.setOutBoxHumidity = lines[6].substring(3);
  //chart
  chartsObject.outBoxHumiditys.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(lines[6].substring(3))));

  model.setBattery = lines[7].contains('L')? 'low' : 'normal';
  model.setPower = lines[8].contains('N') ? 'normal' : lines[8].contains('B') ? 'burnt' : lines[8].contains('b') ? 'backup' : lines[8].contains('S') ? 'short circuit': 'short circuit in main board';
  model.setPower5 = lines[9].contains('N') ? 'normal' : 'disconnect';
  model.setP4Volt = lines[10].contains('N') ? 'normal' : 'abnormal';
  model.setMicroPower = lines[11].contains('N') ? 'normal' : 'abnormal';
  model.setPowerDiode = lines[12].contains('N') ? 'normal' : 'burnt';
  model.setSecuritySystem = lines[13].contains('d') ? 'disconnect' : lines[13].contains('A') ? 'active' : 'deactive';
  if(lines[13].contains('A')) { ///setting pir values
    constants.put('pir1', 'active');
    constants.put('pir2', 'active');
  }
  model.setWaterLeakagePlug1 = lines[14][2]=='n'? 'dry' : lines[14][2]=='d'? 'disconnect connector' : lines[14][2]=='y'? 'yes' : lines[14][2]=='D'? 'deactived by key' : 'no info';
  model.setWaterLeakagePlug2 = lines[14][4]=='n'? 'dry' : lines[14][4]=='d'? 'disconnect connector' : lines[14][4]=='y'? 'yes' : lines[14][4]=='D'? 'deactived by key' : 'no info';
  model.setDayNight = lines[15].contains('Dy') ? 'day':'night';
  model.setCaseDoor = lines[16].contains('C') ? 'close' : 'open';
  model.setExcuteTask = lines[17].contains('H') ? 'home' : lines[17].contains('R') ? 'resting' : 'sleep';
  model.setPlug = lines[18].contains('C') ? 'connect' : 'disconnect';
  //chart
  chartsObject.electricalIssuses.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), model.plug == 'connect'? 1 : 0));

  model.setHeaterRest = lines[19].contains('A') ? 'active' : 'deactive';
  model.setCoolerRest = lines[19].contains('A') ? 'active' : 'deactive';
  model.setWirelessPlug1 = lines[20][5] == 'C' ? 'connect' : lines[20][5] == 'D' ? 'disconnect' : 'remove';
  //chart
  chartsObject.onePlugs.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), (model.wirelessPlug1 == 'connect'? 1.0 : 0.0)));

  model.setWirelessPlug2 = lines[20][9] == 'C' ? 'connect' : lines[20][9] == 'D' ? 'disconnect' : 'remove';
  //chart
  chartsObject.twoPlugs.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), (model.wirelessPlug2 == 'connect'? 1.0 : 0.0)));

  model.setCurrentSensor1 = lines[21].substring(5, 7) == 'DA'? 'deactive' : lines[21].substring(5, 7) == 'AC'? 'active' : lines[21].substring(5, 7) == 'NO'? 'normal' : lines[21].substring(5, 7) == 'ND'? 'no device' : lines[21].substring(5, 7) == 'OF'? 'off' : 'overload';
  model.setCurrentSensor3 = lines[21].substring(10, 12) == 'DA'? 'deactive' : lines[21].substring(10, 12) == 'AC'? 'active' : lines[21].substring(10, 12) == 'NO'? 'normal' : lines[21].substring(10, 12) == 'ND'? 'no device' : lines[21].substring(10, 12) == 'OF'? 'off' : 'overload';
  model.setCurrentSensor6 = lines[21].substring(15) == 'DA'? 'deactive' : lines[21].substring(15) == 'AC'? 'active' : lines[21].substring(15) == 'NO'? 'normal' : lines[21].substring(15) == 'ND'? 'no device' : lines[21].substring(15) == 'OF'? 'off' : 'overload';
  model.setView = lines[22].contains('D') ? 'deactive' : 'active';
  model.setInboxTempFromFirstDay = lines[23].substring(3);
  model.setOutboxTempFromFirstDay = lines[24].substring(3);
  model.setOutboxHumidityFromFirstDay = lines[25].substring(2);
  model.gsmSignalPower = lines[26].substring(2);
  //chart
  chartsObject.mobileSignals.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(lines[26].substring(2))));

  model.fanCount = lines[27].substring(2);
  //chart
  chartsObject.fanCounts.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(lines[27].substring(2))));


  if(sms.contains('C:a')) model.setAutoCooler = 'auto-active';
  if(sms.contains('C:d')) model.setAutoCooler = 'auto-deactive';
  if(sms.contains('H:a')) model.setAutoHeater = 'auto-active';
  if(sms.contains('H:d')) model.setAutoHeater = 'auto-deactive';
  if(sms.contains('HC?')) {
    model.setAutoCooler = 'deactive';
    model.setAutoHeater = 'deactive';
  }
  if(sms.contains('HCR')) {
    model.setAutoCooler = 'removed';
    model.setAutoHeater = 'removed';
  }
  if(sms.contains('CRe')) {
    model.setAutoCooler = 'remote';
  }
  if(sms.contains('HRe')) {
    model.setAutoHeater = 'remote';
  }
  if(sms.contains('min')) {
    var minRest = sms.substring(sms.indexOf('min') -3 , sms.indexOf('min')).trim();
    model.setCoolerRest = minRest;
    model.setHeaterRest = minRest;
  }
  if(sms.contains('WC:D')) model.wirelessCooler = 'deactive';
  if(sms.contains('WC:C')) model.wirelessCooler = 'active';
  //chart
  chartsObject.coolers.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), (model.wirelessCooler=='active' ? 1.0 : 0.0)));

  if(sms.contains('WH:D')) model.wirelessHeater = 'deactive';
  if(sms.contains('WH:C')) model.wirelessHeater = 'active';
  print(model.wirelessHeater=='active');
//chart
  chartsObject.heaters.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), (model.wirelessHeater=='active' ? 1.0 : 0.0)));
  
  
  ///saving data
  deviceStatus.setPublicReport = model;
  chartsBox.put('object', chartsObject);

}

compileSms(sms) {
  compileInteractiveSMS(sms);

  if (sms.contains('R1')) {
    Relay relay = Relay();
    List<String> list = sms.split('\n');

    if (list[1].contains('OFF')) {
      relay.status = 'OFF';
    } else {
      relay.status = 'ON';
    }

    if (list[1].contains('Rd')) {
      relay.relay = 'deactive';
    } else {
      relay.relay = 'active';
    }

    if (list[1].contains('Td')) {
      relay.timer = 'deactive';
    } else {
      relay.timer = 'active';
    }
    //start
    if(list[2].split('-')[0].isNotEmpty) relay.startDate = list[2].split('-')[0];
    if(list[2].split('-')[1].isNotEmpty) relay.startClock = list[2].split('-')[1];
    //end
    if(list[3].split('-')[0].isNotEmpty) relay.endDate = list[3].split('-')[0];
    if(list[3].split('-')[1].isNotEmpty) relay.endClock = list[3].split('-')[1];

    ///saving data
    deviceStatus.setR1 = relay;
  }

  if (sms.contains('R2')) {
    Relay relay = Relay();
    List<String> list = sms.split('\n');

    if (list[6].contains('OFF')) {
      relay.status = 'OFF';
    } else {
      relay.status = 'ON';
    }

    if (list[6].contains('Rd')) {
      relay.relay = 'deactive';
    } else {
      relay.relay = 'active';
    }

    if (list[6].contains('Td')) {
      relay.timer = 'deactive';
    } else {
      relay.timer = 'active';
    }
    //start
    if(list[7].split('-')[0].isNotEmpty) relay.startDate = list[7].split('-')[0];
    if(list[7].split('-')[1].isNotEmpty) relay.startClock = list[7].split('-')[1];
    //end
    if(list[8].split('-')[0].isNotEmpty) relay.endDate = list[8].split('-')[0];
    if(list[8].split('-')[1].isNotEmpty) relay.endClock = list[8].split('-')[1];

    ///saving data
    deviceStatus.setR2 = relay;
  }

  if (sms.contains('R5')) {
    Relay relay = Relay();
    List<String> list = sms.split('\n');

    if (list[11].contains('OFF')) {
      relay.status = 'OFF';
    } else {
      relay.status = 'ON';
    }

    if (list[11].contains('Rd')) {
      relay.relay = 'deactive';
    } else {
      relay.relay = 'active';
    }

    if (list[11].contains('Td')) {
      relay.timer = 'deactive';
    } else {
      relay.timer = 'active';
    }
    //start
    if(list[12].split('-')[0].isNotEmpty) relay.startDate = list[12].split('-')[0];
    if(list[12].split('-')[1].isNotEmpty) relay.startClock = list[12].split('-')[1];
    //end
    if(list[13].split('-')[0].isNotEmpty) relay.endDate = list[13].split('-')[0];
    if(list[13].split('-')[1].isNotEmpty) relay.endClock = list[13].split('-')[1];

    ///saving data
    deviceStatus.setR5 = relay;
  }

  //sms 2
  if (sms.contains('R3')) {
    Relay relay = Relay();
    List<String> list = sms.split('\n');

    if (list[1].contains('OFF')) {
      relay.status = 'OFF';
    } else {
      relay.status = 'ON';
    }

    if (list[1].contains('Rd')) {
      relay.relay = 'deactive';
    } else {
      relay.relay = 'active';
    }

    if (list[1].contains('Td')) {
      relay.timer = 'deactive';
    } else {
      relay.timer = 'active';
    }

    if (list[1].contains('HU')) {
      if(list[1].contains('HU d')) {
        relay.humStatus = 'deactive';
      } else {
        relay.humStatus = 'active';
      }

      var setVal = list[4].split(':')[1];
      var min = setVal.split('~')[0];
      var max = setVal.split('~')[1];

      relay.humMax = max;
      relay.humMin = min;
    }

    //start
    if(list[2].split('-')[0].isNotEmpty) relay.startDate = list[2].split('-')[0];
    if(list[2].split('-')[1].isNotEmpty) relay.startClock = list[2].split('-')[1];
    //end
    if(list[3].split('-')[0].isNotEmpty) relay.endDate = list[3].split('-')[0];
    if(list[3].split('-')[1].isNotEmpty) relay.endClock = list[3].split('-')[1];

    ///saving data
    deviceStatus.setR3 = relay;
  }

  if (sms.contains('R6')) {
    Relay relay = Relay();
    List<String> list = sms.split('\n');

    if (list[7].contains('OF')) { //OF is correct
      relay.status = 'OFF';
    } else {
      relay.status = 'ON';
    }

    if (list[7].contains('Rd')) {
      relay.relay = 'deactive';
    } else {
      relay.relay = 'active';
    }

    if (list[7].contains('Td')) {
      relay.timer = 'deactive';
    } else {
      relay.timer = 'active';
    }
    //start
    if(list[8].split('-')[0].isNotEmpty) relay.startDate = list[8].split('-')[0];
    if(list[8].split('-')[1].isNotEmpty) relay.startClock = list[8].split('-')[1];
    //end
    if(list[9].split('-')[0].isNotEmpty) relay.endDate = list[9].split('-')[0];
    if(list[9].split('-')[1].isNotEmpty) relay.endClock = list[9].split('-')[1];

    ///saving data
    deviceStatus.setR6 = relay;
  }

  if (sms.contains('R7')) {
    Relay relay = Relay();
    List<String> list = sms.split('\n');

    if (list[12].contains('OF')) { //OF is correct
      relay.status = 'OFF';
    } else {
      relay.status = 'ON';
    }

    if (list[12].contains('Rd')) {
      relay.relay = 'deactive';
    } else {
      relay.relay = 'active';
    }

    if (list[12].contains('Td')) {
      relay.timer = 'deactive';
    } else {
      relay.timer = 'active';
    }

    if (list[12].contains('LU')) {
      if (list[12].contains('LU d')) {
        relay.light = 'deactive';
      } else {
        relay.light = 'active';
      }

      // print(list[15].substring(2, list[15].length));
      relay.lux = list[15].substring(2, list[15].length);
    }
    //start
    if(list[13].split('-')[0].isNotEmpty) relay.startDate = list[13].split('-')[0];
    if(list[13].split('-')[1].isNotEmpty) relay.startClock = list[13].split('-')[1];
    //end
    if(list[14].split('-')[0].isNotEmpty) relay.endDate = list[14].split('-')[0];
    if(list[14].split('-')[1].isNotEmpty) relay.endClock = list[14].split('-')[1];

    ///saving data
    deviceStatus.setR7 = relay;
  }

  //sms3
  ///cooler AND heater
  if(sms.contains('Cooler')) {
    Relay relay = Relay();
    List<String> list = sms.split('\n');

    if(list[1].split('-')[0].isNotEmpty) relay.startDate = list[1].split('-')[0];
    if(list[1].split('-')[1].isNotEmpty) relay.startClock = list[1].split('-')[1];

    if(list[2].split('-')[0].isNotEmpty) relay.endDate = list[2].split('-')[0];
    if(list[2].split('-')[1].isNotEmpty) relay.endClock = list[2].split('-')[1];

    constants.put('tempMin', list[3].split(':')[1].split('~')[0]);
    constants.put('tempMax', list[3].split(':')[1].split('~')[1]);

    ///saving data
    deviceStatus.setCooler = relay;
  }
  if(sms.contains('Heater')) {
    Relay relay = Relay();
    List<String> list = sms.split('\n');

    if(list[1].split('-')[0].isNotEmpty) relay.startDate = list[1].split('-')[0];
    if(list[1].split('-')[1].isNotEmpty) relay.startClock = list[1].split('-')[1];

    if(list[2].split('-')[0].isNotEmpty) relay.endDate = list[2].split('-')[0];
    if(list[2].split('-')[1].isNotEmpty) relay.endClock = list[2].split('-')[1];

    constants.put('tempMin', list[3].split(':')[1].split('~')[0]);
    constants.put('tempMax', list[3].split(':')[1].split('~')[1]);

    ///saving data
    deviceStatus.setHeater = relay;
  }
  if(sms.contains('WP1')) {
    Plug plug = Plug();
    List<String> list = sms.split('\n');

    if (list[5].contains('ON')) {
      plug.setUPStatus = 'ON';
    } else {
      plug.setUPStatus = 'OFF';
    }
    //down
    if (list[9].contains('ON')) {
      plug.setDownStatus = 'ON';
    } else {
      plug.setDownStatus = 'OFF';
    }

    if (list[5].contains('Rd')) {
      plug.setUPRelayStatus = 'deactive';
    } else {
      plug.setUPRelayStatus = 'active';
    }
    //down
    if (list[9].contains('Rd')) {
      plug.setDownRelayStatus = 'deactive';
    } else {
      plug.setDownRelayStatus = 'active';
    }

    if (list[5].contains('Td')) {
      plug.setUPTimerStatus = 'deactive';
    } else {
      plug.setUPTimerStatus = 'active';
    }
    //down
    if (list[9].contains('Td')) {
      plug.setDownTimerStatus = 'deactive';
    } else {
      plug.setDownTimerStatus = 'active';
    }
    //startUP
    if(list[6].split('-')[0].isNotEmpty) plug.setUPStartDate = list[6].split('-')[0];
    if(list[6].split('-')[1].isNotEmpty) plug.setUPStartClock = list[6].split('-')[1];
    //startDown
    if(list[10].split('-')[0].isNotEmpty) plug.setDownStartDate = list[10].split('-')[0];
    if(list[10].split('-')[1].isNotEmpty) plug.setDownStartClock = list[10].split('-')[1];

    //endUP
    if(list[7].split('-')[0].isNotEmpty) plug.setUPEndDate = list[7].split('-')[0];
    if(list[7].split('-')[1].isNotEmpty) plug.setUPEndClock = list[7].split('-')[1];
    //endDown
    if(list[11].split('-')[0].isNotEmpty) plug.setUPEndDate = list[11].split('-')[0];
    if(list[11].split('-')[1].isNotEmpty) plug.setUPEndClock = list[11].split('-')[1];

    ///saving data
    deviceStatus.setPlug1 = plug;
  }

  //sms4
  if(sms.contains('WP2')) {
    Plug plug = Plug();
    List<String> list = sms.split('\n');

    if (list[0].contains('ON')) {
      plug.setUPStatus = 'ON';
    } else {
      plug.setUPStatus = 'OFF';
    }
    //down
    if (list[4].contains('ON')) {
      plug.setDownStatus = 'ON';
    } else {
      plug.setDownStatus = 'OFF';
    }

    if (list[0].contains('Rd')) {
      plug.setUPRelayStatus = 'deactive';
    } else {
      plug.setUPRelayStatus = 'active';
    }
    //down
    if (list[4].contains('Rd')) {
      plug.setDownRelayStatus = 'deactive';
    } else {
      plug.setDownRelayStatus = 'active';
    }

    if (list[0].contains('Td')) {
      plug.setUPTimerStatus = 'deactive';
    } else {
      plug.setUPTimerStatus = 'active';
    }
    //down
    if (list[4].contains('Td')) {
      plug.setDownTimerStatus = 'deactive';
    } else {
      plug.setDownTimerStatus = 'active';
    }
    //startUP
    if(list[1].split('-')[0].isNotEmpty) plug.setUPStartDate = list[1].split('-')[0];
    if(list[1].split('-')[1].isNotEmpty) plug.setUPStartClock = list[1].split('-')[1];
    //startDown
    if(list[5].split('-')[0].isNotEmpty) plug.setDownStartDate = list[5].split('-')[0];
    if(list[5].split('-')[1].isNotEmpty) plug.setDownStartClock = list[5].split('-')[1];
    print(list[1].split('-'));
    //endUP
    if(list[2].split('-')[0].isNotEmpty) plug.setUPEndDate = list[2].split('-')[0];
    if(list[2].split('-')[1].isNotEmpty) plug.setUPEndClock = list[2].split('-')[1];
    //endDown
    if(list[6].split('-')[0].isNotEmpty) plug.setUPEndDate = list[6].split('-')[0];
    if(list[6].split('-')[1].isNotEmpty) plug.setUPEndClock = list[6].split('-')[1];

    ///saving data
    deviceStatus.setPlug2 = plug;
  }
  if(sms.contains('RM')) {
    if(sms.contains('RM:A')) {
      deviceStatus.setRemoteStatus = 'active';
    } else {
      deviceStatus.setRemoteStatus = 'deactive';
    }
  }
  if(sms.contains('SR')){
    if(sms.contains('SR:H')) {
      deviceStatus.setStaticRouting = 'hub';
    } else {
      deviceStatus.setStaticRouting = 'main';
    }
//reset counts
    if(sms.split('\n')[10].contains('R')) {
      var resetCounts = sms.split('\n')[10].split(':')[1];
      deviceStatus.setResetCount = resetCounts;
      //chart
      chartsObject.deviceResets.add(ChartData('12/28', 12));
      chartsObject.deviceResets.add(ChartData('12/30', 14));
      chartsObject.deviceResets.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(resetCounts)));
      chartsBox.put('object', chartsObject);
    }
    //public report
    if(sms.contains('PR OF')) {
      // deviceStatus.setPublicReport = 'off';
      constants.put('publicreport', 'off');
    } else {
      // deviceStatus.setPublicReport = sms.split('\n')[11].substring(1);
      constants.put('publicreportTimer', sms.split('\n')[11].toString());
    }

    deviceStatus.setNumber2 = sms.split('\n')[12];
    deviceStatus.setNumber3Const = sms.split('\n')[13];

    //ups
    if(sms.split('\n')[14].substring(0,2).contains('TF')){
      deviceStatus.setUpsTelStatus = 'off';
    } else {
      deviceStatus.setUpsTelStatus = 'on';
    }
    if(sms.split('\n')[14].substring(2,4).contains('MN')){
      deviceStatus.setUpsModemStatus = 'on';
    } else {
      deviceStatus.setUpsModemStatus = 'off';
    }
  }

}

compileInteractiveSMS(String sms) {
  print(1);
  if(sms.contains('Security System is Active, Now!')) {
    PublicReport model = deviceStatus.getPublicReport;
    model.securitySystem = 'active';
     ///setting pir values
      constants.put('pir1', 'active');
      constants.put('pir2', 'active');

      logBox.add(sms);
      deviceBox.put('info', deviceStatus);
  }

  if(sms.contains('Security System is Not Active')) {
    PublicReport model = deviceStatus.getPublicReport;
    model.securitySystem = 'deactive';
     ///setting pir values
      constants.put('pir1', 'deactive');
      constants.put('pir2', 'deactive');

      logBox.add(sms);
      deviceBox.put('info', deviceStatus);
  }
  if(sms.contains('Electricity has been Connected')) {
    PublicReport model = deviceStatus.getPublicReport;
    model.setPlug = 'connect';

    String volt = sms.split('\n')[2].split('~')[1].substring(0, sms.split('\n')[2].split('~')[1].indexOf('V')).trim();

    chartsObject.electricalIssuses.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), model.plug == 'connect'? 1 : 0));
    chartsObject.batteryVoltages.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(volt)));
    logBox.add(sms);

    if(sms.contains('Connect all of Power RLs')){
      deviceStatus.getR1.status = 'ON';
      deviceStatus.getR2.status = 'ON';
      deviceStatus.getR3.status = 'ON';
      deviceStatus.getR4.status = 'ON';
      deviceStatus.getR5.status = 'ON';
      deviceStatus.getR6.status = 'ON';
      deviceStatus.getR7.status = 'ON';
    } else {
      deviceStatus.getR1.status = 'OFF';
      deviceStatus.getR2.status = 'OFF';
      deviceStatus.getR3.status = 'OFF';
      deviceStatus.getR4.status = 'OFF';
      deviceStatus.getR5.status = 'OFF';
      deviceStatus.getR6.status = 'OFF';
      deviceStatus.getR7.status = 'OFF';
    }
    deviceBox.put('info', deviceStatus);
  }
  if(sms.contains('Electricity has been Cut Off or The Fuse is Burnt')) {
    PublicReport model = deviceStatus.getPublicReport;
    model.setPlug = 'disconnect';

    String volt = sms.split('\n')[2].split('~')[1].substring(0, sms.split('\n')[2].split('~')[1].indexOf('V')).trim();

    chartsObject.electricalIssuses.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), model.plug == 'connect'? 1 : 0));
    chartsObject.batteryVoltages.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(volt)));
    logBox.add(sms);
    deviceBox.put('info', deviceStatus);

  }
  if(sms.contains('Water Leakage')) {
    if(sms.contains('PLUG1')) {
      if(sms.contains('Dry')) deviceStatus.getPublicReport.waterLeakagePlug1 = 'dry';
      if(sms.contains('Yes')) deviceStatus.getPublicReport.waterLeakagePlug1 = 'yes';
      if(sms.contains('Disconnect')) deviceStatus.getPublicReport.waterLeakagePlug1 = 'disconnect';
      if(sms.contains('Deactive')) deviceStatus.getPublicReport.waterLeakagePlug1 = 'deactive';
    } else {
      if(sms.contains('Dry')) deviceStatus.getPublicReport.waterLeakagePlug2 = 'dry';
      if(sms.contains('Yes')) deviceStatus.getPublicReport.waterLeakagePlug2 = 'yes';
      if(sms.contains('Disconnect')) deviceStatus.getPublicReport.waterLeakagePlug2 = 'disconnect';
      if(sms.contains('Deactive')) deviceStatus.getPublicReport.waterLeakagePlug2 = 'deactive';
    }
    logBox.add(sms);
    deviceBox.put('info', deviceStatus);
  }
  if(sms.contains('Case Door is OPEN')) {
    deviceStatus.getPublicReport.setCaseDoor = 'open';
    logBox.add(sms);
    deviceBox.put('info', deviceStatus);
  }
  if(sms.contains('Wireless-C/H')) {
    if(sms.contains('Normal - Packet Loss = 0')) {
      deviceStatus.getPublicReport.wirelessCooler = 'active';
      deviceStatus.getPublicReport.wirelessHeater = 'active';
    }
    if(sms.contains('No Message Received - Packet Loss = 100')) {
      deviceStatus.getPublicReport.wirelessCooler = 'deactive';
      deviceStatus.getPublicReport.wirelessHeater = 'deactive';
    }
    logBox.add(sms);
    deviceBox.put('info', deviceStatus);
  }

  if(sms.contains('Wireless-PLUG 1')) {
    if(sms.contains('Normal - Packet Loss = 0')) {
      deviceStatus.getPublicReport.wirelessPlug1 = 'active';
    }
    if(sms.contains('No Message Received - Packet Loss = 100')) {
      deviceStatus.getPublicReport.wirelessPlug1 = 'deactive';
    }
    logBox.add(sms);
    deviceBox.put('info', deviceStatus);
  }
  if(sms.contains('Wireless-PLUG 2')) {
    if(sms.contains('Normal - Packet Loss = 0')) {
      deviceStatus.getPublicReport.wirelessPlug2 = 'active';
    }
    if(sms.contains('No Message Received - Packet Loss = 100')) {
      deviceStatus.getPublicReport.wirelessPlug2 = 'deactive';
    }
    logBox.add(sms);
    deviceBox.put('info', deviceStatus);
  }
  if(sms.contains('Version :')) {
    String volt = sms.split('\n')[2].split('~')[1].substring(0, sms.split('\n')[2].split('~')[1].indexOf('V')).trim();
    chartsObject.batteryVoltages.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(volt)));

    dialog('version', Text(sms.split('\n')[0]), ()=>Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('LOW Battery')) {
    String volt = sms.split('\n')[2].split('~')[1].substring(0, sms.split('\n')[2].split('~')[1].indexOf('V')).trim();
    chartsObject.batteryVoltages.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(volt)));

    ///disable relays
    deviceStatus.getR1.status = 'OFF';
    deviceStatus.getR2.status = 'OFF';
    deviceStatus.getR3.status = 'OFF';
    deviceStatus.getR4.status = 'OFF';
    deviceStatus.getR5.status = 'OFF';
    deviceStatus.getR6.status = 'OFF';
    deviceStatus.getR7.status = 'OFF';

    logBox.add(sms);
    deviceBox.put('info', deviceStatus);
  }
  if(sms.contains('After LOW Battery')) {
    String volt = sms.split('\n')[2].split('~')[1].substring(0, sms.split('\n')[2].split('~')[1].indexOf('V')).trim();
    chartsObject.batteryVoltages.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(volt)));

    if(sms.contains('Normal Battery Voltage and Connect all of RLs')) {
      deviceStatus.getR1.status = 'ON';
      deviceStatus.getR2.status = 'ON';
      deviceStatus.getR3.status = 'ON';
      deviceStatus.getR4.status = 'ON';
      deviceStatus.getR5.status = 'ON';
      deviceStatus.getR6.status = 'ON';
      deviceStatus.getR7.status = 'ON';
    } else {
      deviceStatus.getR1.status = 'OFF';
      deviceStatus.getR2.status = 'OFF';
      deviceStatus.getR3.status = 'OFF';
      deviceStatus.getR4.status = 'OFF';
      deviceStatus.getR5.status = 'OFF';
      deviceStatus.getR6.status = 'OFF';
      deviceStatus.getR7.status = 'OFF';
    }


    deviceBox.put('info', deviceStatus);
  }
  if(sms.contains('Please Check the Time&Date')) {
    dialog('Please check Time', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('PIR 1')) {
    dialog('PIR 1', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('PIR 2')) {
    dialog('PIR 2', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('Charging is not Enough')) {
    dialog('Charging', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('1N5408 is Burnt')) {
    dialog('', Text('1N5408 is Burnt'), ()=> Navigator.pop(buildContext), removeCancel: true);

    String volt = sms.split('\n')[2].split('~')[1].substring(0, sms.split('\n')[2].split('~')[1].indexOf('V')).trim();
    chartsObject.batteryVoltages.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(volt)));


    logBox.add(sms);
  }
  if(sms.contains('LM7812CV (EX Board&FAN) is Burnt')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);

    String volt = sms.split('\n')[2].split('~')[1].substring(0, sms.split('\n')[2].split('~')[1].indexOf('V')).trim();
    chartsObject.batteryVoltages.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(volt)));

    deviceStatus.getPublicReport.setPower = 'backup';
    deviceBox.put('info', deviceStatus);

    logBox.add(sms);
  }
  if(sms.contains('Short Circuit in the EX Board or FAN')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);

    String volt = sms.split('\n')[2].split('~')[1].substring(0, sms.split('\n')[2].split('~')[1].indexOf('V')).trim();
    chartsObject.batteryVoltages.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(volt)));

    deviceStatus.getPublicReport.setPower = 'short circuit';
    deviceBox.put('info', deviceStatus);

    logBox.add(sms);
  }
  if(sms.contains('Short Circuit in the Main Board')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);

    String volt = sms.split('\n')[2].split('~')[1].substring(0, sms.split('\n')[2].split('~')[1].indexOf('V')).trim();
    chartsObject.batteryVoltages.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(volt)));

    deviceStatus.getPublicReport.setPower = 'short circuit in main board';
    deviceBox.put('info', deviceStatus);

    logBox.add(sms);
  }
  if(sms.contains('GSM Power has become Abnormal')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('There is probably a similar device on the same freq.Ch!')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('Disable the device first')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('The Last Device, Successfully Removed')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('Device Successfully Added to bottom of list')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('Device not Added Successfully')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('Table Analyze')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('There is no Device')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('Time Out')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('The heat removal system has barely kept the temperature of the heat sink normal')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    logBox.add(sms);
  }
  if(sms.contains('RL6: Over Load')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);

    deviceStatus.getPublicReport.currentSensor6 = 'overload';
    deviceBox.put('info', deviceStatus);

    logBox.add(sms);
  }
  if(sms.contains('RL1: Over Load')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);

    deviceStatus.getPublicReport.currentSensor1 = 'overload';
    deviceBox.put('info', deviceStatus);

    logBox.add(sms);
  }
  if(sms.contains('RL3: Over Load')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);

    deviceStatus.getPublicReport.currentSensor3 = 'overload';
    deviceBox.put('info', deviceStatus);

    logBox.add(sms);
  }
  ///current sensor relay 1, 3, 6
  if(sms.contains('The Device dose not Work')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);

    deviceBox.put('info', deviceStatus);

    logBox.add(sms);
  }
  if(sms.contains('High TEMP ')) {
    dialog('', Text(sms), ()=> Navigator.pop(buildContext), removeCancel: true);
    if(sms.contains('After High TEMP')) {

      if(sms.contains('TEMP(IN) is NORMAL and Connect all of RLs Likely')) {
        deviceStatus.getR1.status = 'ON';
        deviceStatus.getR2.status = 'ON';
        deviceStatus.getR3.status = 'ON';
        deviceStatus.getR4.status = 'ON';
        deviceStatus.getR5.status = 'ON';
        deviceStatus.getR6.status = 'ON';
        deviceStatus.getR7.status = 'ON';
      } else {
        deviceStatus.getR1.status = 'OFF';
        deviceStatus.getR2.status = 'OFF';
        deviceStatus.getR3.status = 'OFF';
        deviceStatus.getR4.status = 'OFF';
        deviceStatus.getR5.status = 'OFF';
        deviceStatus.getR6.status = 'OFF';
        deviceStatus.getR7.status = 'OFF';
      }

    } else{
      if(sms.contains('Disconnect all of RLs & GSM & EX Board')) {
        deviceStatus.getR1.status = 'OFF';
        deviceStatus.getR2.status = 'OFF';
        deviceStatus.getR3.status = 'OFF';
        deviceStatus.getR4.status = 'OFF';
        deviceStatus.getR5.status = 'OFF';
        deviceStatus.getR6.status = 'OFF';
        deviceStatus.getR7.status = 'OFF';
      }
    }deviceBox.put('info', deviceStatus);
  }
  // if(sms.contains('Electricity has been Cut Off or The Fuse is Burnt')) {
  //   PublicReport model = deviceStatus.getPublicReport;
  //   model.setPlug = 'disconnect';
  //
  //   String volt = sms.split('\n')[2].split('~')[1].substring(0, sms.split('\n')[2].split('~')[1].indexOf('V')).trim();
  //
  //   chartsObject.electricalIssuses.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), model.plug == 'connect'? 1 : 0));
  //   chartsObject.batteryVoltages.add(ChartData(Jalali.now().month.toString() + '/' + Jalali.now().day.toString(), double.parse(volt)));
  //   logBox.add(sms);
  //   deviceBox.put('info', deviceStatus);
  // }
}