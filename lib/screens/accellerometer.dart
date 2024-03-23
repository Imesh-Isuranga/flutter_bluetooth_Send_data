import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_chat/main.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Accellerometer extends StatefulWidget {
  const Accellerometer({super.key});

  @override
  State<Accellerometer> createState() => _AccellerometerState();
}

class _AccellerometerState extends State<Accellerometer> {
  final messageController = TextEditingController();

  // List to store accelerometer data
  List<AccelerometerEvent> _accelerometerValues = [];

  // StreamSubscription for accelerometer events
  late StreamSubscription<AccelerometerEvent> _accelerometerSubscription;

  @override
  void initState() {
    super.initState();
    // Subscribe to accelerometer events
    _accelerometerSubscription =
        accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        // Update the _accelerometerValues list with the latest event
        _accelerometerValues = [event];
        List<String> _accelerometerValuesList = [];
        _accelerometerValuesList
            .add(_accelerometerValues[0].x.toStringAsFixed(2));
        _accelerometerValuesList
            .add(_accelerometerValues[0].y.toStringAsFixed(2));
        _accelerometerValuesList
            .add(_accelerometerValues[0].z.toStringAsFixed(2));
        String msg = _accelerometerValues[0].x.toStringAsFixed(2) +
            '/' +
            _accelerometerValues[0].y.toStringAsFixed(2) +
            '/' +
            _accelerometerValues[0].z.toStringAsFixed(2);
        allBluetooth.sendMessage(msg);
        messageController.clear();
      });
    });
  }

  @override
  void dispose() {
    // Cancel the accelerometer event subscription to prevent memory leaks
    _accelerometerSubscription.cancel();
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accelerometer Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Accelerometer Data:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            if (_accelerometerValues.isNotEmpty)
              Text(
                'X: ${_accelerometerValues[0].x.toStringAsFixed(2)}, '
                'Y: ${_accelerometerValues[0].y.toStringAsFixed(2)}, '
                'Z: ${_accelerometerValues[0].z.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 16),
              )
            else
              const Text('No data available', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
