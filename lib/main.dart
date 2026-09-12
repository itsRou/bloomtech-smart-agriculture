import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // ✅ ضروري لـ flutter_gen
import 'Pages/services_pages/farmers_page.dart';
import 'Pages/services_pages/machines_page.dart';
import 'Pages/services_pages/seeds_page.dart';
import 'Pages/services_pages/services_page.dart';
import 'Pages/services_pages/tools_page.dart';
import 'admin_provider.dart';
import 'cart_provider.dart';
import 'Pages/auth_pages/HomePage.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Locale savedLocale = await getSavedLocale();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => AdminProvider()),
    ],
    child: MyApp(savedLocale: savedLocale),
  ));
}

Future<Locale> getSavedLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? langCode = prefs.getString('language');
  return Locale(langCode ?? 'en');
}

class MyApp extends StatefulWidget {
  final Locale savedLocale;
  const MyApp({Key? key, required this.savedLocale}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale _locale;

  @override
  void initState() {
    super.initState();
    _locale = widget.savedLocale;
  }

  void setLocale(Locale newLocale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', newLocale.languageCode);

    setState(() {
      _locale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        for (var locale in supportedLocales) {
          if (deviceLocale != null &&
              locale.languageCode == deviceLocale.languageCode) {
            return deviceLocale;
          }
        }
        return const Locale('en');
      },
      home: HomePage(setLocale: setLocale), // ✅ مررنا setLocale هنا
      // routes: {
      //   '/': (context) => const ServicesPage(),
      //   '/farmers': (context) => const FarmersPage(),
      //   '/tools': (context) => const ToolsPage(),
      //   '/machines': (context) => const MachinesPage(),
      //   '/seeds': (context) => const SeedsPage(),
      // },
    );
  }
}
