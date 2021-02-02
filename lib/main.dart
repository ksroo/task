import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:profile/ui/profile/profilePage.dart';
import 'package:device_info/device_info.dart';
import 'dart:io' as Dartio show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:profile/util/const.dart';
import 'app/app.dart';
import 'firebase/auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Auth().init();
  Auth().loginOnSimulator('bertbeck@gmail.com');

  // walid firebase

  //var _ref = FirebaseDatabase.instance.reference().child("preferred-comps");

  // final String url = "https://task1-11546-default-rtdb.firebaseio.com/preferred-comps.json";
  // http.post(url,body: json.encode({
  //   "preferred-comps": [
  //     {
  //       "id": "1",
  //       "name": "Champagne"
  //     },
  //     {
  //       "id": "2",
  //       "name": "Martini"
  //     },
  //     {
  //       "id": "3",
  //       "name": "Red Wine"
  //     },
  //     {
  //       "id": "4",
  //       "name": "White Wine"
  //     },
  //     {
  //       "id": "5",
  //       "name": "Draft Beer"
  //     },
  //     {
  //       "id": "6",
  //       "name": "Imported Beer"
  //     },
  //     {
  //       "id": "7",
  //       "name": "Shrimp Cocktail"
  //     },
  //     {
  //       "id": "8",
  //       "name": "Steak Dinner"
  //     },
  //     {
  //       "id": "9",
  //       "name": "Chocolate Cake"
  //     },
  //     {
  //       "id": "10",
  //       "name": "Cheescake"
  //     },
  //     {
  //       "id": "11",
  //       "name": "Strip Steak Dinner"
  //     }
  //   ]
  // }));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<dynamic> init() async {
    // For all platforms:
    // Initialize firebase and authentication

    //   await Firebase.initializeApp();
    //   await Auth().init();

    //  Running on the web

    // if (kIsWeb) {
    //   App.isFlutterWeb = true;
    //   // check if we're running on localhost
    //   App.webserverRootUrl = window.location.href;
    //   int i = window.location.href.indexOf('/#');
    //   App.webserverRootUrl = window.location.href.substring(0, i);
    //   if (App.webserverRootUrl.contains('localhost')) {
    //     App.emailLoginUrl = '${App.webserverRootUrl}/confirmLogin.html';
    //   } else {
    //     App.emailLoginUrl = 'http://tenfins.com/comped/confirmLogin.html';
    //   }
    //   App.baseUrl = "";
    // }

    // else

    //  Running on IOS
    if (Dartio.Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Running on IOS device ${iosInfo.utsname.machine}'); //
      if (iosInfo.isPhysicalDevice == false)
        Auth().loginOnSimulator('bertbeck@gmail.com');
      App.emailLoginUrl = 'https://tenfins.page.link/6SuK';
    } else
    // Running on Android
    if (Dartio.Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Running on Android device ${androidInfo.model}'); //
      if (androidInfo.isPhysicalDevice == false)
        Auth().loginOnSimulator('bertbeck@gmail.com');
      App.emailLoginUrl = 'https://tenfins.page.link/6SuK';
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData.dark(),
            darkTheme: Constants.darkTheme,
            home: ProfilePage(),
          );
        });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
