import 'package:find_my_bus/screens/passenger/homePageUser.dart';
import 'package:flutter/material.dart';
import 'package:find_my_bus/constant/constants.dart';
import 'package:find_my_bus/screens/passenger/loginPageUser.dart';
import 'package:find_my_bus/screens/welcomePage.dart';
import 'package:find_my_bus/screens/passenger/signupUser.dart';
import 'package:find_my_bus/screens/passenger/forgotPassword.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';
import 'screens/conductor/loginPageConductor.dart';
import 'screens/conductor/signupPageConductor.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//       options: FirebaseOptions(
//     apiKey: "AIzaSyCATyiQjGcaK_nAeDS-7L6bPFjTN-ZHwZc",
//     appId: "1:882912661675:web:e3b4869c01053a0f3ea7ee",
//     messagingSenderId: "882912661675",
//     projectId: "findmybus-9310b",
//     storageBucket: "findmybus-9310b.appspot.com",
//   ));
//   runApp(const MyApp());
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCATyiQjGcaK_nAeDS-7L6bPFjTN-ZHwZc",
        appId: "1:882912661675:web:e3b4869c01053a0f3ea7ee",
        messagingSenderId: "882912661675",
        projectId: "findmybus-9310b",
        storageBucket: "findmybus-9310b.appspot.com",
      ),
    );
  } catch (e) {
    if (e is FirebaseException && e.code == 'duplicate-app') {
      // Firebase has already been initialized, so you can ignore this error.
      // Optionally, you can handle this case if needed.
      print('Firebase is already initialized.');
    } else {
      rethrow;
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Location location = new Location();
  Future<dynamic> _getPermission() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.enableBackgroundMode(enable: true);
  }

  @override
  void initState() {
    super.initState();
    _getPermission();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Live Location',
      theme: ThemeData(
        primaryColor: MyTheme.kPrimaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.orange)
            .copyWith(secondary: MyTheme.kAccentColor),
      ),
      // home: Scaffold(
      //   body: HomePage(email: 'raghav@gmail.com'),
      // ),
      initialRoute: WelcomePage.id,
      routes: {
        WelcomePage.id: (context) => WelcomePage(),
        LoginPage.id: (context) => LoginPage(),
        LoginPageConductor.id: (context) => LoginPageConductor(),
        SignupPage.id: (context) => SignupPage(),
        SignupPageConductor.id: (context) => SignupPageConductor(),
        ForgotPage.id: (context) => ForgotPage(),
      },
    );
  }
}
