import 'package:find_my_bus/screens/passenger/homePageUser.dart';
import 'package:flutter/material.dart';
import 'package:find_my_bus/constant/constants.dart';
import 'package:find_my_bus/screens/passenger/loginPageUser.dart';
import 'package:find_my_bus/screens/welcomePage.dart';
import 'package:find_my_bus/screens/passenger/signupUser.dart';
import 'package:find_my_bus/screens/passenger/forgotPassword.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:location/location.dart';
import 'screens/conductor/loginPageConductor.dart';
import 'screens/conductor/signupPageConductor.dart';

void main() async {
  await dotenv.load();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['apiKey']!,
        appId: dotenv.env['appId']!,
        messagingSenderId: dotenv.env['messagingSenderId']!,
        projectId: dotenv.env['projectId']!,
        storageBucket: dotenv.env['storageBucket'],
      ),
    );
  } catch (e) {
    if (e is FirebaseException && e.code == 'duplicate-app') {
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
