import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shome/outlet/OutletPage.dart';

part 'outlet_state.dart';

class OutletCubit extends Cubit<OutletState> {
  OutletCubit() : super(OutletInitial());

  void status() {
    timer = !timer;
    emit(OutletInitial());
  }

  void loop() {
    infinity = !infinity;
    emit(OutletInitial());
  }

  void update(datetime) {
    endTime = datetime;
    emit(OutletInitial());
  }
}
