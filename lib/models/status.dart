import 'package:hive/hive.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

import '../main.dart';

part 'status.g.dart';

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

// Cooler:
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
//
// WP2UP: ON,Ra,Td
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

@HiveType(typeId: 1)
class DeviceStatus {
  @HiveField(1)
  late var staticRouting = '';
  @HiveField(0)
  late var remote = '';
  @HiveField(2)
  late var resetCount = '';
  @HiveField(3)
  late var publicReport = PublicReport();
  @HiveField(4)
  late var number1 = '';
  @HiveField(5)
  late var number2 = '';
  @HiveField(6)
  late var number3Const = '';
  @HiveField(7)
  late var upsModem = '';
  @HiveField(8)
  late var upsTel = '';
  @HiveField(9)
  late var r1 = Relay();
  @HiveField(10)
  late var r2 = Relay();
  @HiveField(11)
  late var r3 = Relay();
  @HiveField(12)
  late var r4 = Relay();
  @HiveField(13)
  late var r5 = Relay();
  @HiveField(14)
  late var r6 = Relay();
  @HiveField(15)
  late var r7 = Relay();
  @HiveField(16)
  late var cooler = Relay();
  @HiveField(17)
  late var heater = Relay();
  @HiveField(18)
  late var plug1 = Plug();
  @HiveField(19)
  late var plug2 = Plug();
  @HiveField(20)
  late var remoteStatus = '';
  @HiveField(21)
  late var staticRoutingStatus = '';

  DeviceStatus();

  set setR1(relay) => r1 = relay;
  set setR2(relay) => r2 = relay;
  set setR3(relay) => r3 = relay;
  set setR4(relay) => r4 = relay;
  set setR5(relay) => r5 = relay;
  set setR6(relay) => r6 = relay;
  set setR7(relay) => r7 = relay;

  set setCooler(cooler) => this.cooler = cooler;
  set setHeater(heater) => this.heater = heater;
  set setPlug1(plug) => plug1 = plug;
  set setPlug2(plug) => plug2 = plug;

  set setStaticRoutingStatus(status) => staticRoutingStatus = status;
  set setRemote(remote) => remoteStatus = remote;

  set setRemoteStatus(remote) => this.remote = remote;
  set setStaticRouting(sr) => staticRouting = sr;
  set setResetCount(count) => resetCount = count;
  set setPublicReport(status) => publicReport = status;
  set setNumber1(number) => number1 = number;
  set setNumber2(number) => number2 = number;
  set setNumber3Const(number) => number3Const = number;
  set setUpsModemStatus(status) => upsModem = status;
  set setUpsTelStatus(status) => upsTel = status;

  Relay get getR1 => r1 ?? Relay();
  Relay get getR2 => r2 ?? Relay();
  Relay get getR3 => r3 ?? Relay();
  Relay get getR4 => r4 ?? Relay();
  Relay get getR5 => r5 ?? Relay();
  Relay get getR6 => r6 ?? Relay();
  Relay get getR7 => r7 ?? Relay();
  Relay get getCooler => cooler ?? Relay();
  Relay get getHeater => heater ?? Relay();
  Plug get getPLug1 => plug1 ?? Plug();
  Plug get getPlug2 => plug2 ?? Plug();
  get getRemote => remoteStatus ?? '';
  get getStaticRoutingStatus => staticRoutingStatus ?? '';

  get getRemoteStatus => remote ?? '';
  get getStaticRouting => staticRouting ?? '';
  get getResetCount => resetCount ?? '';
  PublicReport get getPublicReport => publicReport ?? PublicReport();
  get getNumber1 => number1 ?? '';
  get getNumber2 => number2 ?? '';
  get getNumber3Const => number3Const ?? '';
  get getUPSModemStatus => upsModem ?? '';
  get getUPSTelStatus => upsTel ?? '';
}

@HiveType(typeId: 2)
class Relay extends HiveObject {
  Relay();
  // your fields and methods here
  @HiveField(1)
  var status = '';
  @HiveField(2)
  var relay = '';
  @HiveField(3)
  var timer = '';
  @HiveField(4)
  var startDate = '';
  @HiveField(5)
  var startClock = '';
  @HiveField(6)
  var endDate = '';
  @HiveField(7)
  var endClock = '';
  @HiveField(8)
  var humStatus = '';
  @HiveField(9)
  var humMax = '';
  @HiveField(10)
  var humMin = '';
  @HiveField(11)
  var light = '';
  @HiveField(12)
  var lux = '';
  @HiveField(13)
  var tempMin = '';
  @HiveField(14)
  var tempMax = '';
  @override
  void adaptToHive(Map<String, dynamic> fields) {
    status = fields[1] as String;
    relay = fields[2] as String;
    timer = fields[3] as String;
    startDate = fields[4] as String;
    startClock = fields[5] as String;
    endDate = fields[6] as String;
    endClock = fields[7] as String;
    humStatus = fields[8] as String;
    humMax = fields[9] as String;
    humMin = fields[10] as String;
    light = fields[11] as String;
    lux = fields[12] as String;
    tempMin = fields[13] as String;
    tempMax = fields[14] as String;
  }

  @override
  Map<String, dynamic> adaptFromHive() {
    return {
      '1': status,
      '2': relay,
      '3': timer,
      '4': startDate,
      '5': startClock,
      '6': endDate,
      '7': endClock,
      '8': humStatus,
      '9': humMax,
      '10': humMin,
      '11': light,
      '12': lux,
      '13': tempMin,
      '14': tempMax
    };
  }
}
// @HiveType(typeId: 2)
// class Relay {
//   @HiveField(1)
//   var status = '';
//   @HiveField(2)
//   var relay = '';
//   @HiveField(3)
//   var timer = '';
//   @HiveField(4)
//   var startDate = '';
//   @HiveField(5)
//   var startClock = '';
//   @HiveField(6)
//   var endDate = '';
//   @HiveField(7)
//   var endClock = '';
//   @HiveField(8)
//   var humStatus = '';
//   @HiveField(9)
//   var humMax = '';
//   @HiveField(10)
//   var humMin = '';
//   @HiveField(11)
//   var light = '';
//   @HiveField(12)
//   var lux = '';
//   @HiveField(13)
//   var tempMin = '';
//   @HiveField(14)
//   var tempMax = '';
//
//   Relay({status, relay, timer, date, clock,
//         humStatus, humMax, humMIn});
//
//   set setStatus(String statusw) => this.status = statusw;
//   set setRelayStatus(String status) => relay = status;
//   set setTimerStatus(String status) => timer = status;
//   set setStartDate(String date) => startDate = date;
//   set setStartTime(String time) => startClock = time;
//   set setEndDate(String date) => endDate = date;
//   set setEndTime(String time) => endClock = time;
//
//   set setHumidityStatus(String status) => humStatus = status;
//   set setHumidityMax(String max) => humMax = max;
//   set setHumidityMin(String min) => humMin = min;
//
//   set setLightStatus(String status) => light = status;
//   set setLux(String lux) => this.lux = lux;
//
//   set setTempMin(String temp) => tempMin = temp;
//   set setTempMax(String temp) => tempMax = temp;
//
//   get Status => status;
//   get RelayStatus => relay;
//   get Timer => timer;
//   get getStartDate => startDate;
//   get getStartClock => startClock;
//   get getEndDate => endDate;
//   get getEndClock => endClock;
//
//   get humidityStatus => humStatus;
//   get humidityMax => humMax;
//   get humidityMin => humMin;
//
//   get lightStatus => light;
//   get getLux => lux;
//
//   get getTempMax => tempMax;
//   get getTempMin => tempMin;
// }

@HiveType(typeId: 3)
class Plug {
  @HiveField(1)
  late bool up = true;
  @HiveField(2)
  var upStatus = '';
  @HiveField(3)
  var upRelayStatus = '';
  @HiveField(4)
  var upTimerStatus = '';
  @HiveField(5)
  var upStartDate = '';
  @HiveField(6)
  var upStartClock = '';
  @HiveField(7)
  var upEndDate = '';
  @HiveField(8)
  var upEndClock = '';
  @HiveField(9)
  var downStatus = '';
  @HiveField(10)
  var downRelayStatus = '';
  @HiveField(11)
  var downTimerStatus = '';
  @HiveField(12)
  var downStartDate = '';
  @HiveField(13)
  var downStartClock = '';
  @HiveField(14)
  var downEndDate = '';
  @HiveField(15)
  var downEndClock = '';

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

@HiveType(typeId: 4)
class PublicReport {
  @HiveField(1)
  var clock = '';
  @HiveField(2)
  var date = '';
  @HiveField(3)
  var shortReport = '';
  @HiveField(4)
  var buzzer = '';
  @HiveField(5)
  var motionSensor = '';
  @HiveField(6)
  var inBoxTemp = '';
  @HiveField(7)
  var outBoxTemp = '';
  @HiveField(8)
  var outBoxHumidity = '';
  @HiveField(9)
  var battery = '';
  @HiveField(10)
  var power = '';
  @HiveField(11)
  var power5 = '';
  @HiveField(12)
  var p4volt = '';
  @HiveField(13)
  var microPower = '';
  @HiveField(14)
  var powerDiode = '';
  @HiveField(15)
  var securitySystem = '';
  @HiveField(16)
  var waterLeakagePlug1 = '';
  @HiveField(17)
  var waterLeakagePlug2 = '';
  @HiveField(18)
  var daynight = '';
  @HiveField(19)
  var caseDoor = '';
  @HiveField(20)
  var excuteTask = '';
  @HiveField(21)
  var plug = '';
  @HiveField(22)
  var heaterRest = '';
  @HiveField(23)
  var coolerRest = '';
  @HiveField(24)
  var wirelessPlug1 = '';
  @HiveField(25)
  var wirelessPlug2 = '';
  @HiveField(26)
  var currentSensor1 = '';
  @HiveField(27)
  var currentSensor3 = '';
  @HiveField(28)
  var currentSensor6 = '';
  @HiveField(29)
  var view = '';
  @HiveField(30)
  var activeTasks = '';
  @HiveField(31)
  var deactiveTasks = '';
  @HiveField(32)
  var inBoxTempFromFirstDay = '';
  @HiveField(33)
  var outBoxTempFromFirstDay = '';
  @HiveField(34)
  var outBoxHumidityFromFirstDay = '';
  @HiveField(35)
  var gsmSignalPower = '';
  @HiveField(36)
  var fanCount = '';
  @HiveField(37)
  var autoCooler = '';
  @HiveField(38)
  var autoHeater = '';
  @HiveField(39)
  var wirelessCooler = '';
  @HiveField(40)
  var wirelessHeater = '';
  @HiveField(41)
  var temp = '';

  PublicReport();

  set setClock(clock) => this.clock = clock;
  set setDate(date) => this.date = date;
  set setShortReport(shortReport) => this.shortReport = shortReport;
  set setMotionSensor(motionSensor) => this.motionSensor = motionSensor;
  set setBuzzer(buzzer) => this.buzzer = buzzer;
  set setTemp(temp) {
    this.temp = temp;
    print(Jalali.now().toString());
    tempBox.add(ChartData(
        Jalali.now().month.toString() + '/' + Jalali.now().day.toString(),
        double.parse(temp)));
  }

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
  set setWaterLeakagePlug1(waterLeakage) =>
      this.waterLeakagePlug1 = waterLeakage;
  set setWaterLeakagePlug2(waterLeakage) =>
      this.waterLeakagePlug2 = waterLeakage;
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
  set setOutboxTempFromFirstDay(outboxTemp) =>
      outBoxHumidityFromFirstDay = outboxTemp;
  set setOutboxHumidityFromFirstDay(outboxHum) =>
      outBoxHumidityFromFirstDay = outboxHum;
  set setGsmSignalPower(signalPower) => gsmSignalPower = signalPower;
  set setFanCount(fanCount) => this.fanCount = fanCount;
  set setAutoCooler(autoCooler) => this.autoCooler = autoCooler;
  set setAutoHeater(autoHeater) => this.autoHeater = autoHeater;
  set setWirelessCooler(wireless) => this.wirelessCooler = wireless;
  set setWirelessHeater(wireless) => this.wirelessHeater = wireless;
  set setView(view) => this.view = view;
}

@HiveType(typeId: 5)
class ChartData {
  ChartData(this.x, this.y);
  @HiveField(1)
  late String x;
  @HiveField(2)
  late double y;
}

@HiveType(typeId: 6)
class Charts {
  Charts();
  @HiveField(1)
  List<ChartData> inBoxTemps = [];
  @HiveField(2)
  List<ChartData> outBoxTemps = [];
  @HiveField(3)
  List<ChartData> outBoxHumiditys = [];
  @HiveField(4)
  List<ChartData> fanCounts = [];
  @HiveField(5)
  List<ChartData> mobileSignals = [];
  @HiveField(6)
  List<ChartData> batteryVoltages = [];
  @HiveField(7)
  List<ChartData> electricalIssuses = [];
  @HiveField(8)
  List<ChartData> onePlugs = [];
  @HiveField(9)
  List<ChartData> twoPlugs = [];
  @HiveField(10)
  List<ChartData> heaters = [];
  @HiveField(11)
  List<ChartData> coolers = [];
  @HiveField(12)
  List<ChartData> deviceResets = [];

  set capVoltage(capVolt) => batteryVoltages = capVolt;
}
@HiveType(typeId: 7)
class Log {
  @HiveField(1)
  late int id;
  @HiveField(2)
  late String msg;
}