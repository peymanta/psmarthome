import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
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

  changeSecurityState () async{
    var securityStateVar = !securityState;

    sendSMS('Security ${securityStateVar ? 'on' : 'off'}', onPressed: () async{
      securityState = securityStateVar;
      pir1 = securityState;
      pir2 = securityState;

      deviceStatus.getPublicReport.securitySystem = securityState ? 'active' : 'deactive';
      deviceBox.put('info', deviceStatus);

      await Hive.box('const').put('pir1', securityState ? 'active' : 'deactive');
      await Hive.box('const').put('pir2', securityState ? 'active' : 'deactive');

      emit(SecurityInitial());

      mainController.updateMain();
    });
  }
}
