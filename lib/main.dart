import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kiosk_mode/kiosk_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  startKioskMode();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () async {
                await startKioskMode();
              },
              child: const Text("Start"),
            ),
            ElevatedButton(
              onPressed: () async {
                await stopKioskMode();
              },
              child: const Text("Stop"),
            ),
            MaterialButton(
              color: Colors.blue,
              onPressed: () => getKioskMode().then(
                (value) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                    'Kiosk mode: $value',
                    style: const TextStyle(color: Colors.white),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //  //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    //    //   startKioskMode();
    //     },
    //     tooltip: 'Increment',
    //     child: const Icon(Icons.add),
    //   ),
    );
  }
}
