// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:rec4trav/Models/appTheme.dart';
import 'package:flutter/services.dart';
import 'package:rec4trav/Widgets/widget_tree.dart';

import 'Provider/UserProvider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // ignore: deprecated_member_use
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return riverpod.ProviderScope(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
        ],
        child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Rec4Trav',
          darkTheme: lightThemeData(context),
          theme: lightThemeData(context),
          themeMode: ThemeMode.system,
          home: const WidgetTree(),
        ),
      ),
    );
  }
}

// class Routes {
//   // ignore: constant_identifier_names
//   static const String SPLASH_SCREEN = "/";
// }
