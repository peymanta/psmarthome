import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shome/security/security.dart';

import '../../compiling_sms.dart';
import '../../main.dart';

part 'security_state.dart';

class SecurityCubit extends Cubit<SecurityState> {
  SecurityCubit() : super(SecurityInitial());

  init() {
    securityState =  deviceStatus.getPublicReport.securitySystem == 'active';
    pir1 = constants.get('pir1') == 'active';
    pir2 = constants.get('pir2') == 'active';

  }

  changeSecurityState () {
    securityState = !securityState;

    pir1 = securityState;
    pir2 = securityState;

    deviceStatus.getPublicReport.securitySystem = securityState ? 'active' : 'deactive';
    deviceBox.put('info', deviceStatus);

    constants.put('pir1', securityState ? 'active' : 'deactive');
    constants.put('pir2', securityState ? 'active' : 'deactive');

    sendSMS('Security ${securityState ? 'on' : 'off'}');
    emit(SecurityInitial());

    mainController.updateMain();
  }
}
