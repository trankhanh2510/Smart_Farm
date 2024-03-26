// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_farm/views/home_page.dart';
import 'package:smart_farm/views/start_page.dart';
import 'package:smart_farm/widgets/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await GetStorage.init();
  Get.config(
    enableLog: false,
    defaultTransition: Transition.native,
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  runApp(Phoenix(child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('vi'),
        Locale('en'),
        Locale('fr'),
      ],
      locale: const Locale('vi'),
      debugShowCheckedModeBanner: false,
      enableLog: false,
      theme: ThemeApp.light(),
      initialRoute: "/",
      getPages: [
        GetPage(
          name: "/",
          page: () => const StartPage(),
        ),
        // GetPage(
        //     name: "/login",
        //     page: () => const LoginPage(),
        //     binding: InitialBindings(),
        //     transition: Transition.noTransition),
        GetPage(
            name: "/home",
            page: () => const Home(),
            transition: Transition.noTransition),
        // GetPage(
        //   name: "/sale_order",
        //   page: () => const SaleOrderView(),
        // ),
      ],
    );
  }
}
