import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bentz_stocks/constants.dart';
import 'package:bentz_stocks/providers/auth.dart';
import 'package:bentz_stocks/providers/connectivity_provider.dart';
import 'package:bentz_stocks/screens/auth_screen/auth_screen.dart';
import 'package:bentz_stocks/screens/no_internet.dart';
import 'package:bentz_stocks/screens/profile_screen/about_us.dart';
import 'package:bentz_stocks/screens/profile_screen/personal_data.dart';
import 'package:provider/provider.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await Firebase.initializeApp();

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ConnectivityProvider(),
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (consumerContext, model, child) {
        if (model.isOnline != null) {
          return model.isOnline ? const App() : const NoInternet();
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>(create: (_) => Auth(FirebaseAuth.instance)),
        StreamProvider(
          create: (ctx) => ctx.read<Auth>().authStateChanges,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bentz Stocks',
        theme: ThemeData(
          primaryColor: kPrimaryColor,
          accentColor: kAccentColor,
          unselectedWidgetColor: Colors.white,
          fontFamily: 'OpenSans',
        ),
        home: const AuthScreen(),
        routes: {
          PersonalData.routeName: (ctx) => const PersonalData(),
          AboutUs.routeName: (ctx) => const AboutUs(),
        },
      ),
    );
  }
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

bool isInteger(num value) => value is int || value == value.roundToDouble();

String returnPriceString(double price) {
  return isInteger(price) ? price.toStringAsFixed(0) : price.toStringAsFixed(2);
}
