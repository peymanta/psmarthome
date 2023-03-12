
import 'package:flutter/material.dart';
import 'package:knob_widget/knob_widget.dart';

class DualKnob extends StatefulWidget {
  @override
  _DualKnobState createState() => _DualKnobState();
}

class _DualKnobState extends State<DualKnob> {
  final knob2Controller = KnobController(
    minimum: 0,
    maximum: 100,
    initial: 25,
  );
  final knob1Controller = KnobController(
    minimum: 0,
    maximum: 100,
    initial: 50,
  );



  final value = ValueNotifier<double>(25);

  @override
  Widget build(BuildContext context) {
  //   knob2Controller.addOnValueChangedListener((p0) {
  // knob2Controller.value = p0;
  // setState(() {
  // this.value.value = p0;
  // });
  // });
    return Scaffold(
      appBar: AppBar(
        title: Text('Dual Knob'),
      ),
      body: Center(
        child: Stack(
          children: [
            Knob(
              width: 100,
              height: 100,
              controller: knob1Controller,

            ),
            Positioned(
              left: 150,
              top: 50,
              child: Knob(
                width: 100,
                height: 100,
                controller: knob2Controller,
                // initialValueNotifier: value,
                // showValueText: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}