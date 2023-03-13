import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../colors.dart';
import '../main.dart';
import '../outlet/OutletPage.dart';
import 'bloc/security_cubit.dart';

SecurityCubit? _cubit;
bool pir1 = true, pir2 = false;

class Security extends StatefulWidget {
  const Security({Key? key}) : super(key: key);

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = SecurityCubit();
    _cubit!.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: background,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black)),
      body: BlocBuilder<SecurityCubit, SecurityState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is SecurityInitial) {
            return Container(
              color: background,
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height-50,
              child: Scaffold(
                body:
                  Container(
                    color: background,
                    child: Center(
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: MaterialButton(
                          onPressed: () => _cubit!.changeSecurityState(),
                          child: Image.asset(
                            securityState
                                ? 'assets/icons/shield-active.png'
                                : 'assets/icons/shield-inactive.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                  bottomNavigationBar:
                  
                  Container(
                    color: background,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                  children: [
                    divider(),
                    Row(children: [
                      Expanded(child: Container(alignment: Alignment.centerLeft, child: Text('PIR 1'),),),
                      Expanded(child: Container(alignment: Alignment.center, child: SizedBox(
                          width: 30, height: 30,
                          child: Image.asset(pir1? 'assets/icons/led-on.png' : 'assets/icons/led.png')),),),
                    ],),
                    SizedBox(height: 10,),
                    Row(children: [
                      Expanded(child: Container(alignment: Alignment.centerLeft, child: Text('PIR 2'),),),
                      Expanded(child: Container(alignment: Alignment.center, child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Image.asset(pir2? 'assets/icons/led-on.png' : 'assets/icons/led.png')),),),
                    ],)
                  ],
                    ),
                  )
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
