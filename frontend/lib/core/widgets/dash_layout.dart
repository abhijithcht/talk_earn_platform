import 'package:flutter/material.dart';
import 'package:frontend/core/theme/design_constants.dart';
import 'package:frontend/core/widgets/responsive.dart';

class DashLayout extends StatelessWidget {
  const DashLayout({required this.main, super.key, this.sidebar, this.maxContentWidth = 1440});
  final Widget? sidebar;
  final Widget main;
  final double maxContentWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxContentWidth),
        padding: EdgeInsets.symmetric(
          horizontal: Responsive.isMobile(context) ? DesignConstants.pM : DesignConstants.pXL,
          vertical: DesignConstants.pM,
        ),
        child: Responsive(
          mobile: _MobileLayout(main: main, sidebar: sidebar),
          tablet: _TabletLayout(main: main, sidebar: sidebar),
          desktop: _DesktopLayout(main: main, sidebar: sidebar),
        ),
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.main, this.sidebar});

  final Widget main;
  final Widget? sidebar;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (sidebar != null) ...[sidebar!, const SizedBox(height: 24)],
          main,
        ],
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout({required this.main, this.sidebar});

  final Widget main;
  final Widget? sidebar;

  @override
  Widget build(BuildContext context) {
    return _DesktopLayout(main: main, sidebar: sidebar);
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({required this.main, this.sidebar});

  final Widget main;
  final Widget? sidebar;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sidebar != null) Flexible(flex: 3, child: sidebar!),
        if (sidebar != null) const SizedBox(width: DesignConstants.pXL),
        Expanded(flex: 7, child: main),
      ],
    );
  }
}
