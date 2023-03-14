import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shome/compiling_sms.dart';
import 'package:shome/main.dart';
import 'package:shome/report/notification.dart';

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());

  report() => sendSMS('Report');
  fullReport() => sendSMS('Report FULL');
  version() => sendSMS('Version');
  notifications() => Navigator.push(buildContext, MaterialPageRoute(builder: (context)=> Notifications()));
}
