import 'package:backgroundtask/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:switcher_button/switcher_button.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool notification = false;
  int counter = 0;

  Future<void> _increaseCounter() async {
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      counter += 1;
      FirebaseFirestore.instance
          .collection("Data")
          .doc("$counter")
          .set({"value": "$counter"});
    });
    if (notification) {
      await _increaseCounter();
    }
  }

  Future<void> triggerLocationUpdate(bool value) async {
    if (value == true) {
      setState(() {
        notification = true;
      });
      await startLocationUpdates();
    } else {
      setState(() {
        notification = false;
      });
      await stopLocationUpdates();
    }
  }

  Future<void> startLocationUpdates() async {
    // await Geolocator.requestPermission();
    var channel = const MethodChannel("flutter_channel");
    await channel.invokeMethod("getLocation");

    await _increaseCounter();
  }

  Future<void> stopLocationUpdates() async {
    var channel = const MethodChannel("flutter_channel");
    await channel.invokeMethod("stopLocation");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Every 5 seconds this counter will increase by 1 : $counter',
            ),
            Container(
              padding: const EdgeInsets.all(1),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10000.0)),
                  color: Colors.black),
              child: SwitcherButton(
                value: notification,
                onColor: Colors.green,
                offColor: Colors.white,
                onChange: (value) {
                  triggerLocationUpdate(value);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
