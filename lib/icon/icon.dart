import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shome/colors.dart';
import 'package:shome/icon/bloc/icon_cubit.dart';

List listIcons = [];
IconCubit? _cubit;
String iconKey = "";

class Icon extends StatefulWidget {
  const Icon({Key? key}) : super(key: key);

  @override
  State<Icon> createState() => _IconState();
}

class _IconState extends State<Icon> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = IconCubit();
    _cubit!.getIcons();
  }

  @override
  Widget build(BuildContext context) {
    print('1233' + iconKey.contains('UPS').toString() );
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(title: Text('Select Icon for ${iconKey.contains('UPS') ? 'UPS Item' : 'Relay'} ${iconKey.contains('UPS') ? iconKey.substring(4) : iconKey}', style: TextStyle(color: Colors.black),),
        backgroundColor: background,
        shadowColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<IconCubit, IconState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state is IconInitial) {
            return
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                    itemCount: listIcons.length,
                    itemBuilder: (context, index) {
                      print(listIcons.length);
                  return MaterialButton(
                    onPressed: ()=> _cubit!.change(iconKey, listIcons[index]),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        listIcons[index],
                        width: 200,
                        height: 200,
                      ),
                    ),
                  );
                });

          } else {
            return Container();
          }
        },
      ),
    );
  }
}
