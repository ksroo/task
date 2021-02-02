//
//  App settings
//
import 'package:flutter/material.dart';
import '../db/models.dart';

class App {
  static bool loggedIn = true;
  static ModelUser mUser = ModelUser();
  static String loginUserid = "";
  static String loginService = "";
  static String loginEmail = "";
  static String pendingLoginEmail = "";

  static double screenHeight = 850;
  static double screenWidth = 450;

  static String baseUrl = "http://tenfins.com/public/";
  static String webserverRootUrl = "";
  static bool isFlutterWeb = false;

  static Color accentColor;
  static BuildContext defaultContext;
  static goto(String route, {BuildContext context: null, String title: ''}) {
    App.currentPageTitle = title;
    Navigator.pushNamed(context == null ? App.defaultContext : context, route);
  }

  static String currentRoute;
  static String currentPageTitle = '';
  static int mainScreen_page = 0;
  static String emailLoginUrl;
  static Widget MainScreen;

  static Color textPrimaryColor = Colors.white70;
  static Color backgroundColor;
  static Color mainColor;
  static int mainTabIndex = 0;
}
