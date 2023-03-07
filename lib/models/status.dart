//R1:
// OFF,Rd,Td,
// 11/11/11-00:00
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
// 96/01/01-00:00

//R3:
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
// LU35

//Cooler:
// 11/11/11-00:06
// 11/11/11-23:56
// TEMP SET:20~25
//
// WP1UP: ON,Ra,Ta
// 11/11/11-16:30
// 11/11/11-23:55
//
// WP1DN: ON,Ra,Td
// 11/11/11-00:00
// 11/11/11-23:55

//WP2UP: ON,Ra,Td
// 11/11/11-00:00
// 11/11/11-23:55
//
// WP2DN: ON,Ra,Ta
// 11/11/11-00:01
// 11/11/11-23:55
//
// RM:A
// SR:m
// R:2
// P2000
// 9120232465
// 2144168346
// TFMN
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


}
class DeviceStatus {
  var relay1;
  var remote, staticRouting, resetCount, publicReport, number1, number2, number3Const, upsModem, upsTel;
  DeviceStatus.fromSMS() {
    var sms = '''1210 01:04
s:A
U:A
M:N
Ti:42
TO:27,26
HO:26
B:N
12EN
5RN
4GN
5MN
D1N
S:D
L1n2n
L:Ni
d:N
E:H
P:C
r:A
WP#1:C-2:C
CU:1:DA,3:DA,6:DA
V:D
Ti#38
TO#26
H#27
i#16
F:0
C:a
30min
WC:C.''';

    if (sms.contains('R1')) {
      Relay relay = Relay();
      List<String> list = sms.split('\n');

      if (list[1].contains('OFF')) {
        relay.setStatus = 'OFF';
      } else {
        relay.setStatus = 'ON';
      }

      if (list[1].contains('Rd')) {
        relay.setRelayStatus = 'deactive';
      } else {
        relay.setRelayStatus = 'active';
      }

      if (list[1].contains('Td')) {
        relay.setTimerStatus = 'deactive';
      } else {
        relay.setTimerStatus = 'active';
      }
      //start
      if(list[2].split('-')[0].isNotEmpty) relay.setStartDate = list[2].split('-')[0];
      if(list[2].split('-')[1].isNotEmpty) relay.setStartTime = list[2].split('-')[1];
      //end
      if(list[3].split('-')[0].isNotEmpty) relay.setEndDate = list[3].split('-')[0];
      if(list[3].split('-')[1].isNotEmpty) relay.setEndTime = list[3].split('-')[1];
      print(list[3].split('-')[1]);
    }

    if (sms.contains('R2')) {
      Relay relay = Relay();
      List<String> list = sms.split('\n');

      if (list[6].contains('OFF')) {
        relay.setStatus = 'OFF';
      } else {
        relay.setStatus = 'ON';
      }

      if (list[6].contains('Rd')) {
        relay.setRelayStatus = 'deactive';
      } else {
        relay.setRelayStatus = 'active';
      }

      if (list[6].contains('Td')) {
        relay.setTimerStatus = 'deactive';
      } else {
        relay.setTimerStatus = 'active';
      }
      //start
      if(list[7].split('-')[0].isNotEmpty) relay.setStartDate = list[7].split('-')[0];
      if(list[7].split('-')[1].isNotEmpty) relay.setStartTime = list[7].split('-')[1];
      //end
      if(list[8].split('-')[0].isNotEmpty) relay.setEndDate = list[8].split('-')[0];
      if(list[8].split('-')[1].isNotEmpty) relay.setEndTime = list[8].split('-')[1];
      print(list[6]);
    }

    if (sms.contains('R5')) {
      Relay relay = Relay();
      List<String> list = sms.split('\n');

      if (list[11].contains('OFF')) {
        relay.setStatus = 'OFF';
      } else {
        relay.setStatus = 'ON';
      }

      if (list[11].contains('Rd')) {
        relay.setRelayStatus = 'deactive';
      } else {
        relay.setRelayStatus = 'active';
      }

      if (list[11].contains('Td')) {
        relay.setTimerStatus = 'deactive';
      } else {
        relay.setTimerStatus = 'active';
      }
      //start
      if(list[12].split('-')[0].isNotEmpty) relay.setStartDate = list[12].split('-')[0];
      if(list[12].split('-')[1].isNotEmpty) relay.setStartTime = list[12].split('-')[1];
      //end
      if(list[13].split('-')[0].isNotEmpty) relay.setEndDate = list[13].split('-')[0];
      if(list[13].split('-')[1].isNotEmpty) relay.setEndTime = list[13].split('-')[1];
      print(list[6]);
    }

    //sms 2
    if (sms.contains('R3')) {
      Relay relay = Relay();
      List<String> list = sms.split('\n');

      if (list[1].contains('OFF')) {
        relay.setStatus = 'OFF';
      } else {
        relay.setStatus = 'ON';
      }

      if (list[1].contains('Rd')) {
        relay.setRelayStatus = 'deactive';
      } else {
        relay.setRelayStatus = 'active';
      }

      if (list[1].contains('Td')) {
        relay.setTimerStatus = 'deactive';
      } else {
        relay.setTimerStatus = 'active';
      }

      if (list[1].contains('HU')) {
        if(list[1].contains('HU d')) {
        relay.setHumidityStatus = 'deactive';
      } else {
        relay.setHumidityStatus = 'active';
      }

        var setVal = list[4].split(':')[1];
        var min = setVal.split('~')[0];
        var max = setVal.split('~')[1];

        relay.setHumidityMax = max;
        relay.setHumidityMin = min;
    }

      //start
      if(list[2].split('-')[0].isNotEmpty) relay.setStartDate = list[2].split('-')[0];
      if(list[2].split('-')[1].isNotEmpty) relay.setStartTime = list[2].split('-')[1];
      //end
      if(list[3].split('-')[0].isNotEmpty) relay.setEndDate = list[3].split('-')[0];
      if(list[3].split('-')[1].isNotEmpty) relay.setEndTime = list[3].split('-')[1];
      print(list[6]);
    }

    if (sms.contains('R6')) {
      Relay relay = Relay();
      List<String> list = sms.split('\n');

      if (list[7].contains('OF')) { //OF is correct
        relay.setStatus = 'OFF';
      } else {
        relay.setStatus = 'ON';
      }

      if (list[7].contains('Rd')) {
        relay.setRelayStatus = 'deactive';
      } else {
        relay.setRelayStatus = 'active';
      }

      if (list[7].contains('Td')) {
        relay.setTimerStatus = 'deactive';
      } else {
        relay.setTimerStatus = 'active';
      }
      //start
      if(list[8].split('-')[0].isNotEmpty) relay.setStartDate = list[8].split('-')[0];
      if(list[8].split('-')[1].isNotEmpty) relay.setStartTime = list[8].split('-')[1];
      //end
      if(list[9].split('-')[0].isNotEmpty) relay.setEndDate = list[9].split('-')[0];
      if(list[9].split('-')[1].isNotEmpty) relay.setEndTime = list[9].split('-')[1];

    }

    if (sms.contains('R7')) {
      Relay relay = Relay();
      List<String> list = sms.split('\n');

      if (list[12].contains('OF')) { //OF is correct
        relay.setStatus = 'OFF';
      } else {
        relay.setStatus = 'ON';
      }

      if (list[12].contains('Rd')) {
        relay.setRelayStatus = 'deactive';
      } else {
        relay.setRelayStatus = 'active';
      }

      if (list[12].contains('Td')) {
        relay.setTimerStatus = 'deactive';
      } else {
        relay.setTimerStatus = 'active';
      }

      if (list[12].contains('LU')) {
        if (list[12].contains('LU d')) {
          relay.setLightStatus = 'deactive';
        } else {
          relay.setLightStatus = 'active';
        }

        // print(list[15].substring(2, list[15].length));
        relay.setLux = list[15].substring(2, list[15].length);
      }
      //start
      if(list[13].split('-')[0].isNotEmpty) relay.setStartDate = list[13].split('-')[0];
      if(list[13].split('-')[1].isNotEmpty) relay.setStartTime = list[13].split('-')[1];
      //end
      if(list[14].split('-')[0].isNotEmpty) relay.setEndDate = list[14].split('-')[0];
      if(list[14].split('-')[1].isNotEmpty) relay.setEndTime = list[14].split('-')[1];

    }

    //sms3
    ///cooler AND heater
    if(sms.contains('Cooler')) {
      Relay relay = Relay();
      List<String> list = sms.split('\n');

      if(list[1].split('-')[0].isNotEmpty) relay.setStartDate = list[1].split('-')[0];
      if(list[1].split('-')[1].isNotEmpty) relay.setStartTime = list[1].split('-')[1];

      if(list[2].split('-')[0].isNotEmpty) relay.setEndDate = list[2].split('-')[0];
      if(list[2].split('-')[1].isNotEmpty) relay.setEndTime = list[2].split('-')[1];

      relay.setTempMin = list[3].split(':')[1].split('~')[0];
      relay.setTempMax = list[3].split(':')[1].split('~')[1];
    }
    if(sms.contains('Heater')) {
      Relay relay = Relay();
      List<String> list = sms.split('\n');

      if(list[1].split('-')[0].isNotEmpty) relay.setStartDate = list[1].split('-')[0];
      if(list[1].split('-')[1].isNotEmpty) relay.setStartTime = list[1].split('-')[1];

      if(list[2].split('-')[0].isNotEmpty) relay.setEndDate = list[2].split('-')[0];
      if(list[2].split('-')[1].isNotEmpty) relay.setEndTime = list[2].split('-')[1];

      relay.setTempMin = list[3].split(':')[1].split('~')[0];
      relay.setTempMax = list[3].split(':')[1].split('~')[1];
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
      //endUP
      if(list[2].split('-')[0].isNotEmpty) plug.setUPEndDate = list[2].split('-')[0];
      if(list[2].split('-')[1].isNotEmpty) plug.setUPEndClock = list[2].split('-')[1];
      //endDown
      if(list[6].split('-')[0].isNotEmpty) plug.setUPEndDate = list[6].split('-')[0];
      if(list[6].split('-')[1].isNotEmpty) plug.setUPEndClock = list[6].split('-')[1];

    }
    if(sms.contains('RM')) {
      if(sms.contains('RM:A')) {
        setRemoteStatus = 'active';
      } else {
        setRemoteStatus = 'deactive';
      }
    }
    if(sms.contains('SR')){
      if(sms.contains('SR:H')) {
        setStaticRouting = 'hub';
      } else {
        setStaticRouting = 'main';
      }
//reset counts
      if(sms.split('\n')[10].contains('R')) {
        var resetCounts = sms.split('\n')[10].split(':')[1];
        setResetCount = resetCounts;
      }
      //public report
      if(sms.contains('PR OF')) {
        setPublicReport = 'off';
      } else {
        setPublicReport = sms.split('\n')[11].substring(1);
      }

      setNumber2 = sms.split('\n')[12];
      setNumber3Const = sms.split('\n')[13];

      //ups
      if(sms.split('\n')[14].substring(0,2).contains('TF')){
        setUpsTelStatus = 'off';
      } else {
        setUpsTelStatus = 'on';
      }
      if(sms.split('\n')[14].substring(2,4).contains('MN')){
        setUpsModemStatus = 'on';
      } else {
        setUpsModemStatus = 'off';
      }
    }
    compilePublicReport(sms);
  }

  set setRemoteStatus(remote) => this.remote = remote;
  set setStaticRouting(sr) => staticRouting = sr;
  set setResetCount(count) => resetCount = count;
  set setPublicReport(status) => publicReport = status;
  set setNumber1(number) => number1 = number;
  set setNumber2(number) => number2 = number;
  set setNumber3Const(number) => number3Const = number;
  set setUpsModemStatus(status) => upsModem = status;
  set setUpsTelStatus(status) => upsTel = status;

  get getRemoteStatus => remote;
  get getStaticRouting => staticRouting;
  get getResetCount => resetCount;
  get getPublicReport => publicReport;
  get getNumber1 => number1;
  get getNumber2 => number2;
  get getNumber3Const => number3Const;
  get getUPSModemStatus => upsModem;
  get getUPSTelStatus => upsTel;
}




class Relay {
  var status, relay, timer, startDate, startClock, endDate, endClock;

  var humStatus, humMax, humMin;
  var light, lux;
  var tempMin, tempMax;

  Relay({status, relay, timer, date, clock,
        humStatus, humMax, humMIn});

  set setStatus(String status) => this.status = status;
  set setRelayStatus(String status) => relay = status;
  set setTimerStatus(String status) => timer = status;
  set setStartDate(String date) => startDate = date;
  set setStartTime(String time) => startClock = time;
  set setEndDate(String date) => endDate = date;
  set setEndTime(String time) => endClock = time;

  set setHumidityStatus(String status) => humStatus = status;
  set setHumidityMax(String max) => humMax = max;
  set setHumidityMin(String min) => humMin = min;

  set setLightStatus(String status) => light = status;
  set setLux(String lux) => this.lux = lux;

  set setTempMin(String temp) => tempMin = temp;
  set setTempMax(String temp) => tempMax = temp;

  get Status => status;
  get RelayStatus => relay;
  get Timer => timer;
  get getStartDate => startDate;
  get getStartClock => startClock;
  get getEndDate => endDate;
  get getEndClock => endClock;

  get humidityStatus => humStatus;
  get humidityMax => humMax;
  get humidityMin => humMin;

  get lightStatus => light;
  get getLux => lux;

  get getTempMax => tempMax;
  get getTempMin => tempMin;
}

class Plug {
  late bool up;
  var upStatus, upRelayStatus, upTimerStatus, upStartDate, upStartClock, upEndDate, upEndClock;
  var downStatus, downRelayStatus, downTimerStatus, downStartDate, downStartClock, downEndDate, downEndClock;

  Plug();
  
  set setUPStatus(String status) => upStatus = status;
  set setUPRelayStatus(String relayStatus) => upRelayStatus = relayStatus;
  set setUPTimerStatus(String status) => upTimerStatus = status;
  set setUPStartDate(String startDate) => upStartDate = startDate;
  set setUPStartClock(String startClock) => upStartClock = startClock;
  set setUPEndDate(String endDate) => upEndDate = endDate;
  set setUPEndClock(String endClock) => upEndClock = endClock;  
  
  set setDownStatus(String status) => downStatus = status;
  set setDownRelayStatus(String relayStatus) => downRelayStatus = relayStatus;
  set setDownTimerStatus(String status) => downTimerStatus = status;
  set setDownStartDate(String startDate) => downStartDate = startDate;
  set setDownStartClock(String startClock) => downStartClock = startClock;
  set setDownEndDate(String endDate) => downEndDate = endDate;
  set setDownEndClock(String endClock) => downEndClock = endClock;
  
  get getUPStatus => upStatus;
  get getUPRelayStatus => upRelayStatus;
  get getUPTimerStatus => upTimerStatus;
  get getUPStartDate => upStartDate;
  get getUPStartClock => upStartClock;
  get getUPEndDate => upEndDate;
  get getUPEndClock => upEndClock;
  
  get getDownStatus => downStatus;
  get getDownRelayStatus => downRelayStatus;
  get getDownTimerStatus => downTimerStatus;
  get getDownStartDate => downStartDate;
  get getDownStartClock => downStartClock;
  get getDownEndDate => downEndDate;
  get getDownEndClock => downEndClock;
}

class PublicReport {
  var clock, date, shortReport, buzzer, motionSensor, inBoxTemp, outBoxTemp, outBoxHumidity, battery,
  power, power5, p4volt, microPower, powerDiode, securitySystem, waterLeakagePlug1, waterLeakagePlug2, daynight, caseDoor, excuteTask, plug,
  heaterRest, coolerRest, wirelessPlug1, wirelessPlug2, currentSensor1, currentSensor3, currentSensor6, view, activeTasks, deactiveTasks,
  inBoxTempFromFirstDay, outBoxTempFromFirstDay, outBoxHumidityFromFirstDay, gsmSignalPower, fanCount,
  autoCooler, autoHeater, wirelessCooler, wirelessHeater, temp;

  PublicReport();

  set setClock(clock) => this.clock = clock;
  set setDate(date) => this.date = date;
  set setShortReport(shortReport) => this.shortReport = shortReport;
  set setMotionSensor(motionSensor) => this.motionSensor = motionSensor;
  set setBuzzer(buzzer) => this.buzzer = buzzer;
  set setTemp(temp) => this.temp = temp;
  set setInboxTemp(inBoxTemp) => this.inBoxTemp = inBoxTemp;
  set setOutBoxTemp(outBoxTemp) => this.outBoxTemp = outBoxTemp;
  set setOutBoxHumidity(outBoxHumidity) => this.outBoxHumidity = outBoxHumidity;
  set setBattery(battery) => this.battery = battery;
  set setPower(power) => this.power = power;
  set setPower5(power) => this.power5 = power;
  set setP4Volt(p4volt) => this.p4volt = p4volt;
  set setMicroPower(microPower) => this.microPower = microPower;
  set setPowerDiode(powerDiode) => this.powerDiode = powerDiode;
  set setSecuritySystem(securitySystem) => this.securitySystem = securitySystem;
  set setWaterLeakagePlug1(waterLeakage) => this.waterLeakagePlug1 = waterLeakage;
  set setWaterLeakagePlug2(waterLeakage) => this.waterLeakagePlug2 = waterLeakage;
  set setDayNight(dayNight) => this.daynight = dayNight;
  set setCaseDoor(caseDoor) => this.caseDoor = caseDoor;
  set setExcuteTask(excuteTask) => this.excuteTask = excuteTask;
  set setPlug(plug) => this.plug = plug;
  set setHeaterRest(heaterRest) => this.heaterRest = heaterRest;
  set setCoolerRest(coolerRest) => this.coolerRest = coolerRest;
  set setWirelessPlug1(wirelessPlug) => this.wirelessPlug1 = wirelessPlug;
  set setWirelessPlug2(wirelessPlug) => this.wirelessPlug2 = wirelessPlug;
  set setCurrentSensor1(currentSensor) => this.currentSensor1 = currentSensor;
  set setCurrentSensor3(currentSensor) => this.currentSensor3 = currentSensor;
  set setCurrentSensor6(currentSensor) => this.currentSensor6 = currentSensor;
  set setActiveTasks(active) => activeTasks = active;
  set setDeactiveTasks(deactive) => deactiveTasks = deactive;
  set setInboxTempFromFirstDay(inboxTemp) => inBoxTempFromFirstDay = inboxTemp;
  set setOutboxTempFromFirstDay(outboxTemp) => outBoxHumidityFromFirstDay = outboxTemp;
  set setOutboxHumidityFromFirstDay(outboxHum) => outBoxHumidityFromFirstDay = outboxHum;
  set setGsmSignalPower(signalPower) => gsmSignalPower = signalPower;
  set setFanCount(fanCount) => this.fanCount = fanCount;
  set setAutoCooler(autoCooler) => this.autoCooler = autoCooler;
  set setAutoHeater(autoHeater) => this.autoHeater = autoHeater;
  set setWirelessCooler(wireless) => this.wirelessCooler = wireless;
  set setWirelessHeater(wireless) => this.wirelessHeater = wireless;
  set setView(view) => this.view = view;





}