import 'package:alpha/core/constants/route_constants.dart';
import 'package:alpha/features/welcome/pages/onboard.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case welcomeRoute:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => WelcomePage()
      );

    default:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => Scaffold(
                appBar: AppBar(),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: Text("Not found picture"),
                      ),
                      const Text("Screen does not exist."),
                    ],
                  ),
                ),
              ));
  }
}
