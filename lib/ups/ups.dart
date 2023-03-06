import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:shome/colors.dart';
import 'package:shome/ups/bloc/ups_cubit.dart';

UpsCubit? _cubit;
String _image1 = 'assets/icons/question.png', _image2 = 'assets/icons/question.png', _image3 = 'assets/icons/question.png';
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
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(backgroundColor: background,
            shadowColor: Colors.transparent,
            iconTheme: IconThemeData(color: Colors.black),),
            body: Container(padding: const EdgeInsets.all(20),
              color: background,
              child: Column(
                  children: [
                Expanded(child: ListTile(leading: NeumorphicSwitch(), title: SizedBox(width:100, height:100, child: Image.asset(_image1)),)),
                Expanded(child: ListTile(leading: NeumorphicSwitch(), title: SizedBox(width:100, height:100, child: Image.asset(_image2),))),
                Expanded(child: ListTile(leading: NeumorphicSwitch(), title: SizedBox(width:100, height:100, child: Image.asset(_image3),))),
              ]),
            ),
          )
    );
  }
}
