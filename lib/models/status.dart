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
class DeviceStatus {
  var relay1;
  var remote, staticRouting, resetCount, publicReport, number1, number2, number3Const, upsModem, upsTel;
  DeviceStatus.fromSMS() {
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
  var clock, date, shortReport, buzzer, motionSensor, inBoxTemp, outBoxTemp, outBoxHumidity, battery;

}