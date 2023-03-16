import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shome/compiling_sms.dart';
import 'package:shome/relay/bloc/relay_cubit.dart';
import 'package:shome/relay/relay.dart' as r;
import 'package:sms/sms.dart';

import '../main.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());
  init() async{
    securityState = deviceStatus.getPublicReport.securitySystem == 'active';

    ///help dialog
    if (constants.get('initial') == null) {
      Future.delayed(Duration.zero).then((value) {
        TextEditingController controller = TextEditingController();
        return dialog(
            'Welcome',
            Column(children: [
              Text('''Hello, welcome to our app.
For the initial launch of the app, we need some information about your device.
Please enter the SIM card number in your device'''),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: controller,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: '0912XXXXXXX'),
              )
            ]),
                () {
              constants.put('deviceNumber', controller.text);
              deviceBox.put('info', deviceStatus);

              sendSMS('Report FULL');

              constants.put('initial', 'true');
              Navigator.pop(buildContext);
            }, cancellable: false, removeCancel: true);
      });
      emit(MainInitial());
    }

    smsReceiver!.onSmsReceived.listen((SmsMessage? s){
      if(s!.address == '+98'+constants.get('deviceNumber').substring(1)) {
        print(s!.body);
        compile(s!.body);
        updateMain();
      }
    });
    Future.delayed(Duration.zero).then((value) => showDialog(context: buildContext, builder: (context)=>AlertDialog(title: Text('test'), content: Text('نسخه تستی ارسال شده توسط فریلنسر جهت تایید کارفرما'),)));
  }

  updateMain() {
    emit(MainInitial());
    print(123);
  }
}
