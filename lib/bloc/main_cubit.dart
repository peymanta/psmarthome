import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../main.dart';

part 'main_state.dart';

class MainCubit extends Cubit<MainState> {
  MainCubit() : super(MainInitial());
  init() {
    securityState = deviceStatus.getPublicReport.securitySystem == 'active';

    emit(MainInitial());
  }

  updateMain() {
    emit(MainInitial());
    print(123);
  }
}
