
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart' as m;
import 'package:meta/meta.dart';
import 'package:shome/compiling_sms.dart';
import 'package:shome/main.dart';
import 'package:shome/ups/ups.dart';

import '../../icon/icon.dart';

part 'ups_state.dart';

class UpsCubit extends Cubit<UpsState> {
  UpsCubit() : super(UpsInitial());
  init() {
    camera = deviceStatus.getPublicReport.securitySystem == 'active';
    telephone = deviceStatus.upsTel == 'on';
    modem = deviceStatus.upsModem == 'on';

    emit(UpsInitial());
  }

  updateUI() => emit(UpsInitial());

  icon(int number) {
    iconKey = number==1 ? 'IUPS1' : number==2? 'IUPS2': 'IUPS3';
    m.Navigator.push(buildContext!, m.MaterialPageRoute(builder: (context) => Icon()));
  }

  setCameraState() {
    sendSMS('hello', onPressed: () {
      camera = !camera!;

      emit(UpsInitial());
    });
  }
  setTelephoneState() {
    var telephoneVar = !telephone!;

    sendSMS('UPS:TELL:${telephoneVar ? 'on' : 'off'}', onPressed: () {
      telephone = telephoneVar;
      deviceStatus.upsTel = telephone! ? 'on' : 'off';
      deviceBox.put('info', deviceStatus);

      emit(UpsInitial());
    });
  }
  setModemState() {
    var modemVar = !modem!;

    sendSMS('UPS:MODM:${modemVar ? 'on' : 'off'}', onPressed: () {
      modem = modemVar;
      deviceStatus.upsModem = modem! ? 'on' : 'off';
      deviceBox.put('info', deviceStatus);

      emit(UpsInitial());
    });
  }
}
