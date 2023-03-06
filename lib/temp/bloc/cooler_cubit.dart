import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../temp_screen.dart';

part 'cooler_state.dart';

class CoolerCubit extends Cubit<CoolerState> {
  CoolerCubit() : super(CoolerInitial());


  void status() {
    automatic = !automatic;
    emit(CoolerInitial());
  }

  void loop() {
    infinity = !infinity;
    emit(CoolerInitial());
  }

  void update(datetime) {
    // endTime = datetime;
    emit(CoolerInitial());
  }

}
