import 'package:fa_notes/page/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Notes",
      home: HomePage(),
      theme: ThemeData(
        fontFamily: GoogleFonts.lato().fontFamily,
      ),
    );
  }
}
