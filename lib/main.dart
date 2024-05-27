import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:examen_final_sureda/screens/screens.dart';
import 'package:examen_final_sureda/services/services.dart';
import 'package:provider/provider.dart';
import 'package:examen_final_sureda/preferences/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await Firebase.initializeApp();
  await Preferences.init();
  runApp(AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PlatoService(),
        ),
        /*ChangeNotifierProvider(
          create: (_) => LoginService(),
        )*/
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Examen App',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'home': (_) => HomeScreen(),
        'detail': (_) => DetailScreen(),
        'mapa': (_) => MapaScreen(),
      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
      ),
    );
  }
}
