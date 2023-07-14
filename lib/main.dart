import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:product_app/UI/post/Product%20Screen/confirmed.dart';
import 'package:product_app/UI/post/Product%20Screen/carousel_slider.dart';
import 'package:product_app/UI/post/Cart/cart_provider.dart';
import 'package:product_app/UI/post/Cart/cart_screen.dart';
import 'package:product_app/UI/post/Product%20Screen/product_screen.dart';
import 'package:product_app/UI/splash_screen.dart';
import 'package:provider/provider.dart';
import 'fireBase_services/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => CartProvider(),
    child: Builder(builder: (BuildContext context){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Palette.kPurple,
        ),
        home: const SplashScreen(),
      );
    }),
    );
  }
}
