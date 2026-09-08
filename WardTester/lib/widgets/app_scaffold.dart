import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// The app bar used on every screen: an optional back button, a title with an
/// optional subtitle, and optional trailing actions.
///
/// Back navigation pops rather than pushing a new route. The previous screens
/// each pushed a fresh copy of the destination, so the navigation stack grew
/// without bound as you moved around.
class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = true,
    this.onBack,
    this.actions = const <Widget>[],
    this.bottom,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final VoidCallback? onBack;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        AppSizes.appBar + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final bool compact = subtitle != null;

    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: showBack ? 0 : AppSpacing.gutter,
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.chevron_left_rounded, size: 28),
              color: AppColors.textPrimary,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: onBack ?? () => Navigator.of(context).maybePop(),
            )
          : null,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            style: compact ? AppText.appBarTitleCompact : AppText.appBarTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: AppText.appBarSubtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
      actions: actions,
      bottom: bottom == null
          ? const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(height: 1),
            )
          : bottom,
    );
  }
}

/// A 44x44 icon button — the minimum tap target.
class AppIconAction extends StatelessWidget {
  const AppIconAction({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 22),
      color: AppColors.textSecondary,
      tooltip: tooltip,
      constraints: const BoxConstraints(
        minWidth: AppSizes.tapTarget,
        minHeight: AppSizes.tapTarget,
      ),
      onPressed: onPressed,
    );
  }
}

/// The tab bar under an app bar. Sized to the 44px tap target.
class AppTabBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTabBar({super.key, required this.tabs});

  final List<String> tabs;

  @override
  Size get preferredSize => const Size.fromHeight(AppSizes.tab + 1);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          height: AppSizes.tab,
          child: TabBar(
            tabs: <Widget>[
              for (final String label in tabs)
                Tab(height: AppSizes.tab, text: label),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }
}
