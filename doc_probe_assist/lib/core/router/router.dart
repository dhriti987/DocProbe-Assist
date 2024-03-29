// import 'package:flutter/material.dart';

import 'package:doc_probe_assist/features/about_us/UI/about_us_page.dart';
import 'package:doc_probe_assist/features/admin/UI/admin_page.dart';
import 'package:doc_probe_assist/features/chat/UI/chat_page.dart';
import 'package:doc_probe_assist/features/home/UI/home_page.dart';
import 'package:doc_probe_assist/features/login/UI/login_page.dart';
import 'package:doc_probe_assist/features/settings/UI/settings_page.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppRouter {
  final SharedPreferences pref;
  bool isAuthenticated = false;
  bool isAdmin = false;

  AppRouter({required this.pref});

  // bool checkIsAuthenticated() {
  //   return pref.getString('token') != null;
  // }

  GoRouter getRouter() {
    GoRouter router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: 'Home',
          builder: (context, state) => HomePage(),
        ),
        GoRoute(
          path: '/login',
          name: 'Login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/about-us',
          name: 'AboutUs',
          builder: (context, state) => const AboutUsPage(),
        ),
        GoRoute(
          path: '/chat',
          name: 'Chat',
          builder: (context, state) => const ChatPage(),
        ),
        GoRoute(
          path: '/admin',
          name: 'Admin',
          builder: (context, state) => const AdminPage(),
        ),
        GoRoute(
          path: '/settings',
          name: 'Settings',
          builder: (context, state) => const SettingPage(),
        ),
        // GoRoute(
        //   path: '/book_reader',
        //   name: 'BookReader',
        //   builder: (context, state) {
        //     BookModel data = state.extra as BookModel;
        //     return BookReader(book: data);
        //   },
        // ),
      ],
      // redirect: (context, state) {
      //   // if (isAuthenticated == false) return "/login";
      //   return "/";
      // },
    );
    return router;
  }
}
