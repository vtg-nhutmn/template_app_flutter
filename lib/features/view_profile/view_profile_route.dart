import 'package:flutter/material.dart';

import 'view_profile_page.dart';

class ViewProfileRoute {
  ViewProfileRoute._();

  static const String path = '/profile';

  static Map<String, WidgetBuilder> get definitions => {
    path: (_) => const ViewProfilePage(),
  };
}
