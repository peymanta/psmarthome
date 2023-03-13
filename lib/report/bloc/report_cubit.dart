import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shome/compiling_sms.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());

  report() => sendSMS('Report');
  fullReport() => sendSMS('Report FULL');
  version() => sendSMS('Version');
}
