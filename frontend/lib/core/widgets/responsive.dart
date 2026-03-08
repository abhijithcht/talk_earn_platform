import 'package:flutter/material.dart';

import 'package:frontend/core/theme/design_constants.dart';

class Responsive extends StatelessWidget {
  const Responsive({required this.mobile, required this.desktop, super.key, this.tablet});
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < DesignConstants.mobileLimit;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= DesignConstants.mobileLimit &&
      MediaQuery.sizeOf(context).width < DesignConstants.tabletLimit;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= DesignConstants.tabletLimit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= DesignConstants.tabletLimit) {
          return desktop;
        } else if (constraints.maxWidth >= DesignConstants.mobileLimit) {
          return tablet ?? mobile;
        } else {
          return mobile;
        }
      },
    );
  }
}
