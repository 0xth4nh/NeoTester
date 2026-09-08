import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../widgets/app_scaffold.dart';

/// Shown on first launch with no connection, when there are no downloaded
/// tests to fall back on.
class ReconnectPage extends StatelessWidget {
  const ReconnectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'WardTester', showBack: false),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 88,
                  height: 88,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.errorSurface,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.errorBorder),
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    size: 38,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'You are offline',
                  textAlign: TextAlign.center,
                  style: AppText.display.copyWith(
                    fontSize: 26,
                    height: 32 / 26,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Connect to the internet so WardTester can download your '
                  'test files for the first time.',
                  textAlign: TextAlign.center,
                  style: AppText.bodyText.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
