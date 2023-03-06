import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../main.dart';

part 'security_state.dart';

class SecurityCubit extends Cubit<SecurityState> {
  SecurityCubit() : super(SecurityInitial());

  changeSecurityState () {
    securityState = !securityState;
    emit(SecurityInitial());
  }
}
