import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:meta/meta.dart';
import 'package:shome/compiling_sms.dart';
import 'package:shome/main.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import '../settings.dart';
part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  init() {
    buzzer = deviceStatus.getPublicReport.buzzer == 'active';
    view = deviceStatus.getPublicReport.view == 'active';
    publicReport = constants.get('publicreport') != 'off';
    task = deviceStatus.publicReport.excuteTask == 'home'
        ? TaskEnum.Home
        : deviceStatus.publicReport.excuteTask == 'sleep'
            ? TaskEnum.Sleep
            : TaskEnum.Rest;
    remoteControl = deviceStatus.getRemote == 'active';
    num1 = deviceStatus.number1 ?? '';
    num2 = deviceStatus.number2 ?? '';
    num3 = deviceStatus.number3Const ?? '';
  }

  setTime() {
    timeDialog();
  }

  setTimeNTP() {
    timeDialog(ntp: true);
  }

  setBuzzer() {
    buzzer = !buzzer!;
    deviceStatus.getPublicReport.setBuzzer = buzzer! ? 'active' : 'deactive';
    deviceBox.put('info', deviceStatus);

    sendSMS('Buzer ${buzzer! ? 'on' : 'off'}');
    emit(SettingsInitial());
  }

  setRemoteControl() {
    remoteControl = !remoteControl!;
    deviceStatus.setRemote = remoteControl! ? 'active' : 'deactive';
    deviceBox.put('info', deviceStatus);

    sendSMS('remote:${remoteControl! ? 'a' : 'd'}');
    emit(SettingsInitial());
  }

  setView() {
    view = !view!;
    deviceStatus.getPublicReport.setView = view! ? 'active' : 'deactive';
    deviceBox.put('info', deviceStatus);

    sendSMS('View ${view! ? 'on' : 'off'}');
    emit(SettingsInitial());
  }

  setHome() {
    task = TaskEnum.Home;
    deviceStatus.getPublicReport.setExcuteTask = 'home';
    deviceBox.put('info', deviceStatus);

    sendSMS('Home:a');
    emit(SettingsInitial());
  }

  setSleep() {
    task = TaskEnum.Sleep;
    deviceStatus.getPublicReport.setExcuteTask = 'sleep';
    deviceBox.put('info', deviceStatus);

    sendSMS('Sleep');
    emit(SettingsInitial());
  }

  setResting() {
    task = TaskEnum.Rest;
    deviceStatus.getPublicReport.setExcuteTask = 'resting';
    deviceBox.put('info', deviceStatus);

    sendSMS('Resting');
    emit(SettingsInitial());
  }

  setDefaultSetting() {
    sendSMS('Default 2');
    emit(SettingsInitial());
  }

  restGSM() {
    sendSMS('GSMREST');
    emit(SettingsInitial());
  }

  setPublicReport() {
    publicReport = !publicReport!;
    constants.put('publicreport', publicReport! ? 'on' : 'off');

    sendSMS('Pu: ${publicReport! ? 'on' : 'off'}#');
    emit(SettingsInitial());
  }

  submitClock() {
    constants.put(
        'publicreportTimer',
        'P' +
            selectedTime!.hour.toString().padLeft(2, '0') +
            selectedTime!.minute.toString().padLeft(2, '0'));

    sendSMS(
        'Pu:${selectedTime!.hour.toString().padLeft(2, '0') + selectedTime!.minute.toString().padLeft(2, '0')}#');
    emit(SettingsInitial());
  }

  setLog() {
    sendSMS('View LOG');
    emit(SettingsInitial());
  }

  getNumber(number) {
    TextEditingController controller = new TextEditingController();

    if (number == 1) {
      controller.text = deviceStatus.number1 ?? '';
    } else if (number == 2) {
      controller.text = deviceStatus.number2 ?? '';
    } else if (number == 3) {
      controller.text = deviceStatus.number3Const ?? '';
    }

    dialog(
        'Insert Number $number',
        TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: '0912XXXXXXX'),
        ), () {
      if (number == 1) {
        deviceStatus.number1 = controller.text;
        num1 = controller.text;
      } else if (number == 2) {
        deviceStatus.number2 = controller.text;
        num2 = controller.text;
      } else if (number == 3) {
        deviceStatus.number3Const = controller.text;
        num3 = controller.text;
      }

      sendSMS(
          'Number,$number,${number == 1 ? num1 : number == 2 ? num2 : num3}#');

      deviceBox.put('info', deviceStatus);
      Navigator.pop(buildContext!);
      emit(SettingsInitial());
    });
  }

  timeDialog({ntp = false}) {
    DateTime? time;
    dialog(
        'Set Timer',
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TimePickerSpinner(
                isForce2Digits: true,
                is24HourMode: true,
                onTimeChange: (v) => time = v,
                time: ntp
                    ? DateTime.now()
                    : DateTime(
                        0,
                        0,
                        int.parse(
                            deviceStatus.getPublicReport.clock.split(':')[0]),
                        int.parse(
                            deviceStatus.getPublicReport.clock.split(':')[1]),
                      )),
          ],
        ), () {
      if (!ntp) {
        deviceStatus.publicReport.clock =
            time!.hour.toString().padLeft(2, '0') +
                ":" +
                time!.minute.toString().padLeft(2, '0');

        sendSMS('');
      }
    });
  }

  dialog(title, contents, onConfirm) {
    showDialog(
        context: buildContext,
        builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              elevation: 0,
              backgroundColor: Color(0xFFDFE1E6),
              insetPadding: EdgeInsets.all(20.0),
              child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    contents,
                    SizedBox(height: 40.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: MaterialButton(
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                        SizedBox(width: 20.0),
                        Expanded(
                          child: MaterialButton(
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                              onPressed: onConfirm),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }

  changeTask(newTask) {
    task = newTask;
    emit(SettingsInitial());
  }
}
