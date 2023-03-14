import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shome/main.dart';
import 'package:shome/report/bloc/notification_cubit.dart';

import '../colors.dart';
import '../outlet/OutletPage.dart';

NotificationCubit? _cubit;
List notifications = [];
class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _cubit = NotificationCubit();
    _cubit!.init();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      bloc: _cubit,
  builder: (context, state) {
    return Scaffold(
      appBar: AppBar(backgroundColor: background,
      shadowColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black),
      actions: [IconButton(onPressed: ()=>_cubit!.clear(), icon: Icon(Icons.delete,))],),
      body: Container(
        color: background,
        padding: EdgeInsets.all(20),
        child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index){
          return Container(
            width: double.infinity,
            alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(7),
              child: Column(
                children: [
                  Text(notifications[index], style: TextStyle(color: Colors.black),),
                  divider()
                ],
              ));
        }),
      )
    );
  },
);
  }
}
