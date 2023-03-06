import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../settings.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsInitial());

  changeTask(newTask) {
    task = newTask;
    emit(SettingsInitial());
  }
}
