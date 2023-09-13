import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mash/helpers/internet_provider.dart';
import 'package:mash/data_base/sign_in_provider.dart';
import 'package:mash/firebase_options.dart';
import 'package:mash/screens/splash_screen.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => SignInProvider())),
        ChangeNotifierProvider(create: ((context) => InternetProvider()))
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: SplashScreen(),
      ),
    );
  }
}

var basicColor = Color(0xff6850a4);
