import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shome/compiling_sms.dart';
import 'package:shome/main.dart';
import 'package:shome/ups/ups.dart';

part 'ups_state.dart';

class UpsCubit extends Cubit<UpsState> {
  UpsCubit() : super(UpsInitial());
  init() {
    camera = deviceStatus.getPublicReport.securitySystem == 'active';
    telephone = deviceStatus.upsTel == 'on';
    modem = deviceStatus.upsModem == 'on';

    emit(UpsInitial());
  }

  setCameraState() {
    camera = !camera!;
    sendSMS('hello');
    emit(UpsInitial());
  }
  setTelephoneState() {
    telephone = !telephone!;
    deviceStatus.upsTel = telephone! ? 'on' : 'off';
    deviceBox.put('info', deviceStatus);
    sendSMS('UPS:TELL:${telephone! ? 'on' : 'off'}');
    emit(UpsInitial());
  }
  setModemState() {
    modem = !modem!;
    deviceStatus.upsModem = modem! ? 'on' : 'off';
    deviceBox.put('info', deviceStatus);
    sendSMS('UPS:MODM:${modem! ? 'on' : 'off'}');
    emit(UpsInitial());
  }
}
