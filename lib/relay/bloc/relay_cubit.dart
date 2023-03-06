import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shome/relay/relay.dart';

part 'relay_state.dart';

enum Status {
  sw, timer, sensor //sensor for r3 = humidity
}
class RelayCubit extends Cubit<RelayState> {
  RelayCubit() : super(RelayInitial());

  changeStatus(Status status) {
    statusOfRelay = status;
    emit(RelayInitial());
  }

  loop() {
    infinity = !infinity;
    emit(RelayInitial());
  }
}
