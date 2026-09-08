import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../back_end/utils.dart';
import '../../main.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../HomePage.dart';
import 'NameSetPage.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  LoadingPageState createState() => LoadingPageState();
}

class LoadingPageState extends State<LoadingPage> {
  /// Started once in initState. The previous version kicked this off from
  /// build(), so every rebuild fired another download.
  late final Future<Set<String>> _update;

  @override
  void initState() {
    super.initState();
    _update = updateTestFile();
    loadNameFile().then((String value) {
      if (mounted) setState(() => studentName = value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Set<String>>(
      future: _update,
      builder: (BuildContext context, AsyncSnapshot<Set<String>> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const _LoadingScreen();
        }
        if (snapshot.hasData) {
          courseList = snapshot.data;
        }
        return studentName.toString().isEmpty
            ? const NameSetPage()
            : const HomePage();
      },
    );
  }
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.brand700,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 132,
                  height: 132,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Image.asset(
                    'assets/LaunchImageHR.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  'Updating your tests',
                  textAlign: TextAlign.center,
                  style: AppText.display.copyWith(
                    fontSize: 24,
                    height: 30 / 24,
                    color: AppColors.surface,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Downloading the latest questions for your courses.',
                  textAlign: TextAlign.center,
                  style: AppText.bodyText.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.brand200,
                  ),
                ),
                const SizedBox(height: 36),
                const SpinKitThreeBounce(size: 22, color: AppColors.surface),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
