import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shome/colors.dart';
import 'package:shome/ups/bloc/ups_cubit.dart';

import '../main.dart';

UpsCubit? upsCubit;
bool? camera, modem, telephone;

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
    upsCubit = UpsCubit();
    upsCubit!.init();
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
          bloc: upsCubit,
          builder: (context, state) {
            if (state is UpsInitial) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  color: background,
                  child: Column(children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Row(
                          children: [
                            Expanded(
                                child: MaterialButton(
                              child: Column(
                                children: [
                                  Icon(Icons.edit, color: primary),
                                  Text(
                                    'Icon 1',
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                              onPressed: () => upsCubit!.icon(1),
                            )),Expanded(
                                child: MaterialButton(
                              child: Column(
                                children: [
                                  Icon(Icons.edit, color: primary),
                                  Text(
                                    'Icon 2',
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                              onPressed: () => upsCubit!.icon(2),
                            )),Expanded(
                                child: MaterialButton(
                              child: Column(
                                children: [
                                  Icon(Icons.edit, color: primary),
                                  Text(
                                    'Icon 3',
                                    style: TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                              onPressed: () => upsCubit!.icon(3),
                            )),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: ListTile(
                      onTap: () => upsCubit!.setTelephoneState(),
                      leading: NeumorphicSwitch(
                          value: telephone!,
                          onChanged: (v) => upsCubit!.setTelephoneState()),
                      title: SizedBox(
                          width: 100,
                          height: 100,
                          child: Image.asset(constants.get('IUPS1') ??
                              'assets/icons/question.png')),
                    )),
                    Expanded(
                        child: ListTile(
                            onTap: () => upsCubit!.setModemState(),
                            leading: NeumorphicSwitch(
                                value: modem!,
                                onChanged: (v) => upsCubit!.setModemState()),
                            title: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(constants.get('IUPS2') ??
                                  'assets/icons/question.png'),
                            ))),
                    Expanded(
                        child: ListTile(
                            onTap: () => upsCubit!.setCameraState(),
                            leading: NeumorphicSwitch(
                              value: camera!,
                              onChanged: (v) => upsCubit!.setCameraState(),
                            ),
                            title: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(constants.get('IUPS3') ??
                                  'assets/icons/question.png'),
                            ))),
                  ]),
                ),
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
