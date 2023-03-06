import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'ups_state.dart';

class UpsCubit extends Cubit<UpsState> {
  UpsCubit() : super(UpsInitial());
}
