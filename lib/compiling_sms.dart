import 'main.dart';
import 'models/status.dart';


sendSMS(sms) {
  print('simulation sending sms: $sms');

  showMessage('operation completed');
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
// S:D
// L1n2n
// L:Ni
// d:N
// E:H
// P:C
// r:A
// WP#1:C-2:C
// CU:1:DA,3:DA,6:DA
// V:D
// Ti#38
// TO#26
// H#27
// i#16
// F:0
// C:a
// 30min
// WC:C.''';

var sms = '''Cooler:
11/11/11-00:06
11/11/11-23:56
TEMP SET:20~25

WP1UP: ON,Ra,Ta
11/11/11-16:30
11/11/11-23:55

WP1DN: ON,Ra,Td
11/11/11-00:00
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
  model.setOutBoxTemp = lines[5].substring(3).split(',')[0];
  model.setTemp = lines[5].substring(3).split(',')[1];
  model.setOutBoxHumidity = lines[6].substring(3);
  model.setBattery = lines[7].contains('L')? 'low' : 'normal';
  model.setPower = lines[8].contains('N') ? 'normal' : lines[8].contains('B') ? 'burnt' : lines[8].contains('b') ? 'backup' : lines[8].contains('S') ? 'short circuit': 'short circuit in main board';
  model.setPower5 = lines[9].contains('N') ? 'normal' : 'disconnect';
  model.setP4Volt = lines[10].contains('N') ? 'normal' : 'abnormal';
  model.setMicroPower = lines[11].contains('N') ? 'normal' : 'abnormal';
  model.setPowerDiode = lines[12].contains('N') ? 'normal' : 'burnt';
  model.setSecuritySystem = lines[13].contains('d') ? 'disconnect' : lines[13].contains('A') ? 'active' : 'deactive';
  model.setWaterLeakagePlug1 = lines[14][2]=='n'? 'dry' : lines[14][2]=='d'? 'disconnect connector' : lines[14][2]=='y'? 'yes' : lines[14][2]=='D'? 'deactived by key' : 'no info';
  model.setWaterLeakagePlug2 = lines[14][4]=='n'? 'dry' : lines[14][4]=='d'? 'disconnect connector' : lines[14][4]=='y'? 'yes' : lines[14][4]=='D'? 'deactived by key' : 'no info';
  model.setDayNight = lines[15].contains('Dy') ? 'day':'night';
  model.setCaseDoor = lines[16].contains('C') ? 'close' : 'open';
  model.setExcuteTask = lines[17].contains('H') ? 'home' : lines[17].contains('R') ? 'resting' : 'sleep';
  model.setPlug = lines[18].contains('C') ? 'connect' : 'disconnect';
  model.setHeaterRest = lines[19].contains('A') ? 'active' : 'deactive';
  model.setCoolerRest = lines[19].contains('A') ? 'active' : 'deactive';
  model.setWirelessPlug1 = lines[20][5] == 'C' ? 'connect' : lines[20][5] == 'D' ? 'disconnect' : 'remove';
  model.setWirelessPlug2 = lines[20][9] == 'C' ? 'connect' : lines[20][9] == 'D' ? 'disconnect' : 'remove';
  model.setCurrentSensor1 = lines[21].substring(5, 7) == 'DA'? 'deactive' : lines[21].substring(5, 7) == 'AC'? 'active' : lines[21].substring(5, 7) == 'NO'? 'normal' : lines[21].substring(5, 7) == 'ND'? 'no device' : lines[21].substring(5, 7) == 'OF'? 'off' : 'overload';
  model.setCurrentSensor3 = lines[21].substring(10, 12) == 'DA'? 'deactive' : lines[21].substring(10, 12) == 'AC'? 'active' : lines[21].substring(10, 12) == 'NO'? 'normal' : lines[21].substring(10, 12) == 'ND'? 'no device' : lines[21].substring(10, 12) == 'OF'? 'off' : 'overload';
  model.setCurrentSensor6 = lines[21].substring(15) == 'DA'? 'deactive' : lines[21].substring(15) == 'AC'? 'active' : lines[21].substring(15) == 'NO'? 'normal' : lines[21].substring(15) == 'ND'? 'no device' : lines[21].substring(15) == 'OF'? 'off' : 'overload';
  model.setView = lines[22].contains('D') ? 'deactive' : 'active';
  model.setInboxTempFromFirstDay = lines[23].substring(3);
  model.setOutboxTempFromFirstDay = lines[24].substring(3);
  model.setOutboxHumidityFromFirstDay = lines[25].substring(2);
  model.gsmSignalPower = lines[26].substring(2);
  model.fanCount = lines[27].substring(2);

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
  if(sms.contains('WH:D')) model.wirelessHeater = 'deactive';
  if(sms.contains('WH:C')) model.wirelessHeater = 'active';

  ///saving data
  deviceStatus.setPublicReport = model;

}

compileSms(sms) {
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
    }
    //public report
    if(sms.contains('PR OF')) {
      deviceStatus.setPublicReport = 'off';
    } else {
      deviceStatus.setPublicReport = sms.split('\n')[11].substring(1);
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