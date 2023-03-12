// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rec4trav/Models/appTheme.dart';
import 'package:flutter/services.dart';
import 'package:rec4trav/Widgets/widget_tree.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // ignore: deprecated_member_use
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter',
      darkTheme: darkThemeData(context),
      theme: lightThemeData(context),
      themeMode: ThemeMode.system,
      //initialBinding: InitialBinding(),
      //getPages: [GetPage(name: Routes.SPLASH_SCREEN, page: () => SplashPage())],
      //initialRoute: Routes.SPLASH_SCREEN,
      home: const WidgetTree(),
    );
  }
}

class Routes {
  // ignore: constant_identifier_names
  static const String SPLASH_SCREEN = "/";
}
