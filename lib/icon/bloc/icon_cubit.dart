import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shome/ups/ups.dart';

import '../../main.dart';
import '../icon.dart';

part 'icon_state.dart';

class IconCubit extends Cubit<IconState> {
  IconCubit() : super(IconInitial());

  Future getIcons() async {
    // >> To get paths you need these 2 lines
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    listIcons = manifestMap.keys
    .where((String key) => key.contains('selectable-icons/'))
        .where((String key) => key.contains('.png'))
        .toList();

    emit(IconInitial());
  }

  change(key, newIcon) {
    constants.put(key, newIcon);
    showMessage('operation completed');

    if(iconKey.contains('UPS')) upsCubit!.updateUI();
    else mainController.updateMain();

    Navigator.pop(buildContext);
  }
}
