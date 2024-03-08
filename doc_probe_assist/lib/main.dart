import 'package:doc_probe_assist/core/router/router.dart';
import 'package:doc_probe_assist/core/theme/common_theme.dart';
import 'package:doc_probe_assist/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  setup();
  sl.allReady().then((value) {
    runApp(const MyApp());
  });
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: sl.get<AppRouter>().getRouter(),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
    );
  }
}
