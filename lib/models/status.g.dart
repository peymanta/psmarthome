// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DeviceStatusAdapter extends TypeAdapter<DeviceStatus> {
  @override
  final int typeId = 1;

  @override
  DeviceStatus read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeviceStatus()
      ..staticRouting = fields[1] as String
      ..remote = fields[0] as String
      ..resetCount = fields[2] as String
      ..publicReport = fields[3] as PublicReport
      ..number1 = fields[4] as String
      ..number2 = fields[5] as String
      ..number3Const = fields[6] as String
      ..upsModem = fields[7] as String
      ..upsTel = fields[8] as String
      ..r1 = fields[9] as Relay
      ..r2 = fields[10] as Relay
      ..r3 = fields[11] as Relay
      ..r4 = fields[12] as Relay
      ..r5 = fields[13] as Relay
      ..r6 = fields[14] as Relay
      ..r7 = fields[15] as Relay
      ..cooler = fields[16] as Relay
      ..heater = fields[17] as Relay
      ..plug1 = fields[18] as Plug
      ..plug2 = fields[19] as Plug
      ..remoteStatus = fields[20] as String
      ..staticRoutingStatus = fields[21] as String;
  }

  @override
  void write(BinaryWriter writer, DeviceStatus obj) {
    writer
      ..writeByte(22)
      ..writeByte(1)
      ..write(obj.staticRouting)
      ..writeByte(0)
      ..write(obj.remote)
      ..writeByte(2)
      ..write(obj.resetCount)
      ..writeByte(3)
      ..write(obj.publicReport)
      ..writeByte(4)
      ..write(obj.number1)
      ..writeByte(5)
      ..write(obj.number2)
      ..writeByte(6)
      ..write(obj.number3Const)
      ..writeByte(7)
      ..write(obj.upsModem)
      ..writeByte(8)
      ..write(obj.upsTel)
      ..writeByte(9)
      ..write(obj.r1)
      ..writeByte(10)
      ..write(obj.r2)
      ..writeByte(11)
      ..write(obj.r3)
      ..writeByte(12)
      ..write(obj.r4)
      ..writeByte(13)
      ..write(obj.r5)
      ..writeByte(14)
      ..write(obj.r6)
      ..writeByte(15)
      ..write(obj.r7)
      ..writeByte(16)
      ..write(obj.cooler)
      ..writeByte(17)
      ..write(obj.heater)
      ..writeByte(18)
      ..write(obj.plug1)
      ..writeByte(19)
      ..write(obj.plug2)
      ..writeByte(20)
      ..write(obj.remoteStatus)
      ..writeByte(21)
      ..write(obj.staticRoutingStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RelayAdapter extends TypeAdapter<Relay> {
  @override
  final int typeId = 2;

  @override
  Relay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Relay()
      ..status = fields[1] as String
      ..relay = fields[2] as String
      ..timer = fields[3] as String
      ..startDate = fields[4] as String
      ..startClock = fields[5] as String
      ..endDate = fields[6] as String
      ..endClock = fields[7] as String
      ..humStatus = fields[8] as String
      ..humMax = fields[9] as String
      ..humMin = fields[10] as String
      ..light = fields[11] as String
      ..lux = fields[12] as String
      ..tempMin = fields[13] as String
      ..tempMax = fields[14] as String;
  }

  @override
  void write(BinaryWriter writer, Relay obj) {
    writer
      ..writeByte(14)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.relay)
      ..writeByte(3)
      ..write(obj.timer)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.startClock)
      ..writeByte(6)
      ..write(obj.endDate)
      ..writeByte(7)
      ..write(obj.endClock)
      ..writeByte(8)
      ..write(obj.humStatus)
      ..writeByte(9)
      ..write(obj.humMax)
      ..writeByte(10)
      ..write(obj.humMin)
      ..writeByte(11)
      ..write(obj.light)
      ..writeByte(12)
      ..write(obj.lux)
      ..writeByte(13)
      ..write(obj.tempMin)
      ..writeByte(14)
      ..write(obj.tempMax);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RelayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlugAdapter extends TypeAdapter<Plug> {
  @override
  final int typeId = 3;

  @override
  Plug read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Plug()
      ..up = fields[1] as bool
      ..upStatus = fields[2] as String
      ..upRelayStatus = fields[3] as String
      ..upTimerStatus = fields[4] as String
      ..upStartDate = fields[5] as String
      ..upStartClock = fields[6] as String
      ..upEndDate = fields[7] as String
      ..upEndClock = fields[8] as String
      ..downStatus = fields[9] as String
      ..downRelayStatus = fields[10] as String
      ..downTimerStatus = fields[11] as String
      ..downStartDate = fields[12] as String
      ..downStartClock = fields[13] as String
      ..downEndDate = fields[14] as String
      ..downEndClock = fields[15] as String;
  }

  @override
  void write(BinaryWriter writer, Plug obj) {
    writer
      ..writeByte(15)
      ..writeByte(1)
      ..write(obj.up)
      ..writeByte(2)
      ..write(obj.upStatus)
      ..writeByte(3)
      ..write(obj.upRelayStatus)
      ..writeByte(4)
      ..write(obj.upTimerStatus)
      ..writeByte(5)
      ..write(obj.upStartDate)
      ..writeByte(6)
      ..write(obj.upStartClock)
      ..writeByte(7)
      ..write(obj.upEndDate)
      ..writeByte(8)
      ..write(obj.upEndClock)
      ..writeByte(9)
      ..write(obj.downStatus)
      ..writeByte(10)
      ..write(obj.downRelayStatus)
      ..writeByte(11)
      ..write(obj.downTimerStatus)
      ..writeByte(12)
      ..write(obj.downStartDate)
      ..writeByte(13)
      ..write(obj.downStartClock)
      ..writeByte(14)
      ..write(obj.downEndDate)
      ..writeByte(15)
      ..write(obj.downEndClock);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlugAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PublicReportAdapter extends TypeAdapter<PublicReport> {
  @override
  final int typeId = 4;

  @override
  PublicReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PublicReport()
      ..clock = fields[1] as String
      ..date = fields[2] as String
      ..shortReport = fields[3] as String
      ..buzzer = fields[4] as String
      ..motionSensor = fields[5] as String
      ..inBoxTemp = fields[6] as String
      ..outBoxTemp = fields[7] as String
      ..outBoxHumidity = fields[8] as String
      ..battery = fields[9] as String
      ..power = fields[10] as String
      ..power5 = fields[11] as String
      ..p4volt = fields[12] as String
      ..microPower = fields[13] as String
      ..powerDiode = fields[14] as String
      ..securitySystem = fields[15] as String
      ..waterLeakagePlug1 = fields[16] as String
      ..waterLeakagePlug2 = fields[17] as String
      ..daynight = fields[18] as String
      ..caseDoor = fields[19] as String
      ..excuteTask = fields[20] as String
      ..plug = fields[21] as String
      ..heaterRest = fields[22] as String
      ..coolerRest = fields[23] as String
      ..wirelessPlug1 = fields[24] as String
      ..wirelessPlug2 = fields[25] as String
      ..currentSensor1 = fields[26] as String
      ..currentSensor3 = fields[27] as String
      ..currentSensor6 = fields[28] as String
      ..view = fields[29] as String
      ..activeTasks = fields[30] as String
      ..deactiveTasks = fields[31] as String
      ..inBoxTempFromFirstDay = fields[32] as String
      ..outBoxTempFromFirstDay = fields[33] as String
      ..outBoxHumidityFromFirstDay = fields[34] as String
      ..gsmSignalPower = fields[35] as String
      ..fanCount = fields[36] as String
      ..autoCooler = fields[37] as String
      ..autoHeater = fields[38] as String
      ..wirelessCooler = fields[39] as String
      ..wirelessHeater = fields[40] as String
      ..temp = fields[41] as String;
  }

  @override
  void write(BinaryWriter writer, PublicReport obj) {
    writer
      ..writeByte(41)
      ..writeByte(1)
      ..write(obj.clock)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.shortReport)
      ..writeByte(4)
      ..write(obj.buzzer)
      ..writeByte(5)
      ..write(obj.motionSensor)
      ..writeByte(6)
      ..write(obj.inBoxTemp)
      ..writeByte(7)
      ..write(obj.outBoxTemp)
      ..writeByte(8)
      ..write(obj.outBoxHumidity)
      ..writeByte(9)
      ..write(obj.battery)
      ..writeByte(10)
      ..write(obj.power)
      ..writeByte(11)
      ..write(obj.power5)
      ..writeByte(12)
      ..write(obj.p4volt)
      ..writeByte(13)
      ..write(obj.microPower)
      ..writeByte(14)
      ..write(obj.powerDiode)
      ..writeByte(15)
      ..write(obj.securitySystem)
      ..writeByte(16)
      ..write(obj.waterLeakagePlug1)
      ..writeByte(17)
      ..write(obj.waterLeakagePlug2)
      ..writeByte(18)
      ..write(obj.daynight)
      ..writeByte(19)
      ..write(obj.caseDoor)
      ..writeByte(20)
      ..write(obj.excuteTask)
      ..writeByte(21)
      ..write(obj.plug)
      ..writeByte(22)
      ..write(obj.heaterRest)
      ..writeByte(23)
      ..write(obj.coolerRest)
      ..writeByte(24)
      ..write(obj.wirelessPlug1)
      ..writeByte(25)
      ..write(obj.wirelessPlug2)
      ..writeByte(26)
      ..write(obj.currentSensor1)
      ..writeByte(27)
      ..write(obj.currentSensor3)
      ..writeByte(28)
      ..write(obj.currentSensor6)
      ..writeByte(29)
      ..write(obj.view)
      ..writeByte(30)
      ..write(obj.activeTasks)
      ..writeByte(31)
      ..write(obj.deactiveTasks)
      ..writeByte(32)
      ..write(obj.inBoxTempFromFirstDay)
      ..writeByte(33)
      ..write(obj.outBoxTempFromFirstDay)
      ..writeByte(34)
      ..write(obj.outBoxHumidityFromFirstDay)
      ..writeByte(35)
      ..write(obj.gsmSignalPower)
      ..writeByte(36)
      ..write(obj.fanCount)
      ..writeByte(37)
      ..write(obj.autoCooler)
      ..writeByte(38)
      ..write(obj.autoHeater)
      ..writeByte(39)
      ..write(obj.wirelessCooler)
      ..writeByte(40)
      ..write(obj.wirelessHeater)
      ..writeByte(41)
      ..write(obj.temp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PublicReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChartDataAdapter extends TypeAdapter<ChartData> {
  @override
  final int typeId = 5;

  @override
  ChartData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChartData(
      fields[1] as String,
      fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ChartData obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.x)
      ..writeByte(2)
      ..write(obj.y);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ChartsAdapter extends TypeAdapter<Charts> {
  @override
  final int typeId = 6;

  @override
  Charts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Charts()
      ..inBoxTemps = (fields[1] as List).cast<ChartData>()
      ..outBoxTemps = (fields[2] as List).cast<ChartData>()
      ..outBoxHumiditys = (fields[3] as List).cast<ChartData>()
      ..fanCounts = (fields[4] as List).cast<ChartData>()
      ..mobileSignals = (fields[5] as List).cast<ChartData>()
      ..batteryVoltages = (fields[6] as List).cast<ChartData>()
      ..electricalIssuses = (fields[7] as List).cast<ChartData>()
      ..onePlugs = (fields[8] as List).cast<ChartData>()
      ..twoPlugs = (fields[9] as List).cast<ChartData>()
      ..heaters = (fields[10] as List).cast<ChartData>()
      ..coolers = (fields[11] as List).cast<ChartData>()
      ..deviceResets = (fields[12] as List).cast<ChartData>();
  }

  @override
  void write(BinaryWriter writer, Charts obj) {
    writer
      ..writeByte(12)
      ..writeByte(1)
      ..write(obj.inBoxTemps)
      ..writeByte(2)
      ..write(obj.outBoxTemps)
      ..writeByte(3)
      ..write(obj.outBoxHumiditys)
      ..writeByte(4)
      ..write(obj.fanCounts)
      ..writeByte(5)
      ..write(obj.mobileSignals)
      ..writeByte(6)
      ..write(obj.batteryVoltages)
      ..writeByte(7)
      ..write(obj.electricalIssuses)
      ..writeByte(8)
      ..write(obj.onePlugs)
      ..writeByte(9)
      ..write(obj.twoPlugs)
      ..writeByte(10)
      ..write(obj.heaters)
      ..writeByte(11)
      ..write(obj.coolers)
      ..writeByte(12)
      ..write(obj.deviceResets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LogAdapter extends TypeAdapter<Log> {
  @override
  final int typeId = 7;

  @override
  Log read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Log()
      ..id = fields[1] as int
      ..msg = fields[2] as String;
  }

  @override
  void write(BinaryWriter writer, Log obj) {
    writer
      ..writeByte(2)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.msg);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
