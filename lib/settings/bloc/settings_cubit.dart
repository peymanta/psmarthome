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
    increaseClock = deviceStatus.getPublicReport.increaseClock == 'active';
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
    // timeDialog();
    sendSMS('Tsms');
  }

  setTimeNTP() {
   // timeDialog(ntp: true);
    sendSMS('CNTP');
  }

  setBuzzer() {
    var buzzerVar = !buzzer!;

    sendSMS('Buzer ${buzzerVar ? 'on' : 'off'}', onPressed: () {
      buzzer = buzzerVar;
      deviceStatus.getPublicReport.setBuzzer = buzzer! ? 'active' : 'deactive';
      deviceBox.put('info', deviceStatus);

      emit(SettingsInitial());
    });
  }

  setIncreaseClock() {
    var increaseClockVar = !increaseClock!;

    sendSMS('Increaseclock:${increaseClockVar ? 'on' : 'of'}', onPressed: () {
      increaseClock = increaseClockVar;
      deviceStatus.getPublicReport.setIncreaseClock = increaseClock! ? 'active' : 'deactive';
      deviceBox.put('info', deviceStatus);

      emit(SettingsInitial());
    });
  }

  setRemoteControl() {
    var remoteControlVar = !remoteControl!;

    sendSMS('remote:${remoteControlVar! ? 'a' : 'd'}', onPressed: (){
      remoteControl = remoteControlVar;
      deviceStatus.setRemote = remoteControl! ? 'active' : 'deactive';
      deviceBox.put('info', deviceStatus);

      emit(SettingsInitial());
    });
  }

  setView() {
    var viewVar = !view!;

    sendSMS('View ${viewVar ? 'on' : 'off'}', onPressed: () {
      view = viewVar;
      deviceStatus.getPublicReport.setView = view! ? 'active' : 'deactive';
      deviceBox.put('info', deviceStatus);

      emit(SettingsInitial());
    });
  }

  setHome() {

    sendSMS('Home:a', onPressed:(){
      task = TaskEnum.Home;
      deviceStatus.getPublicReport.setExcuteTask = 'home';
      deviceBox.put('info', deviceStatus);

      emit(SettingsInitial());
    });
  }

  setSleep() {

    sendSMS('Sleep', onPressed: (){
      task = TaskEnum.Sleep;
      deviceStatus.getPublicReport.setExcuteTask = 'sleep';
      deviceBox.put('info', deviceStatus);

      emit(SettingsInitial());
    });
  }

  setResting() {

    sendSMS('Resting', onPressed: (){
      task = TaskEnum.Rest;
      deviceStatus.getPublicReport.setExcuteTask = 'resting';
      deviceBox.put('info', deviceStatus);

      emit(SettingsInitial());
    });
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
    var publicReportVar = !publicReport!;

    sendSMS('Pu: ${publicReportVar ? 'on' : 'off'}#', onPressed: () {

      publicReport = publicReportVar;
      constants.put('publicreport', publicReport! ? 'on' : 'off');
      emit(SettingsInitial());
    });

  }

  submitClock() {

    sendSMS(
        'Pu:${selectedTime!.hour.toString().padLeft(2, '0') + selectedTime!.minute.toString().padLeft(2, '0')}#',
    onPressed: (){
      constants.put(
          'publicreportTimer',
          'P${selectedTime!.hour.toString().padLeft(2, '0')}${selectedTime!.minute.toString().padLeft(2, '0')}');
      emit(SettingsInitial());
    });

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
          'Number,$number,${number == 1 ? num1 : number == 2 ? num2 : num3}#', onPressed:(){


        deviceBox.put('info', deviceStatus);
        Navigator.pop(buildContext!);
        emit(SettingsInitial());
          });

    });
  }

  timeDialog({ntp = false}) {
    DateTime? time;
    dialog(
        'Set Time',
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


  changeTask(newTask) {
    task = newTask;
    emit(SettingsInitial());
  }
}
