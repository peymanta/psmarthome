import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../temp_screen.dart';

part 'heater_state.dart';

class HeaterCubit extends Cubit<HeaterState> {
  HeaterCubit() : super(HeaterInitial());


  void status() {
    automatic = !automatic;
    emit(HeaterInitial());
  }

  void loop() {
    infinity = !infinity;
    emit(HeaterInitial());
  }

  void update(datetime) {
    // endTime = datetime;
    emit(HeaterInitial());
  }
}
