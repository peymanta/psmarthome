import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shome/colors.dart';
import 'package:shome/ups/bloc/ups_cubit.dart';

UpsCubit? _cubit;
bool? camera, modem, telephone;
String _image1 = 'assets/icons/question.png',
    _image2 = 'assets/icons/question.png',
    _image3 = 'assets/icons/question.png';

class UPS extends StatefulWidget {
  const UPS({Key? key}) : super(key: key);

  @override
  State<UPS> createState() => _UPSState();
}

class _UPSState extends State<UPS> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = UpsCubit();
    _cubit!.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: background,
          shadowColor: Colors.transparent,
          title: Text(
            'UPS',
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: BlocBuilder<UpsCubit, UpsState>(
          bloc: _cubit,
          builder: (context, state) {
            if (state is UpsInitial)
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: background,
                  child: Column(children: [
                    Expanded(
                        child: ListTile(
                      onTap: () => _cubit!.setTelephoneState(),
                      leading: NeumorphicSwitch(
                          value: telephone!,
                          onChanged: (v) => _cubit!.setTelephoneState()),
                      title: SizedBox(
                          width: 100, height: 100, child: Image.asset(_image1)),
                    )),
                    Expanded(
                        child: ListTile(
                            onTap: () => _cubit!.setModemState(),
                            leading: NeumorphicSwitch(
                                value: modem!,
                                onChanged: (v) => _cubit!.setModemState()),
                            title: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(_image2),
                            ))),
                    Expanded(
                        child: ListTile(
                            onTap: () => _cubit!.setCameraState(),
                            leading: NeumorphicSwitch(
                              value: camera!,
                              onChanged: (v) => _cubit!.setCameraState(),
                            ),
                            title: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(_image3),
                            ))),
                  ]),
                ),
              );
            else
              return Container();
          },
        ));
  }
}
