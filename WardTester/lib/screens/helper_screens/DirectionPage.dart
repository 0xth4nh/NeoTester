import 'package:flutter/material.dart';
import 'LoadingPage.dart';
import 'ReconnectPage.dart';
import '../HomePage.dart';
import '../../main.dart';

class DirectionPage extends StatefulWidget {
  const DirectionPage({Key? key}) : super(key: key);

  @override
  State<DirectionPage> createState() => _DirectionPageState();
}

class _DirectionPageState extends State<DirectionPage> {
  @override
  Widget build(BuildContext context) {
    return initialPage == "ReconnectPage"
        ? const ReconnectPage()
        : initialPage == "UpdatePage"
            ? const LoadingPage()
            : const HomePage();
  }
}
