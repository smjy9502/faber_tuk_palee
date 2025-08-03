import 'dart:html' as html;
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'screens/palee.dart';
import 'screens/error_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? _showPaleeScreen; // null=로딩, true=정상진입, false=에러
  bool _isMobile = false;

  @override
  void initState() {
    super.initState();
    _checkAccessLogic();
  }

  void _checkAccessLogic() {
    bool access = false;
    bool mobile = false;

    if (foundation.kIsWeb) {
      final uri = Uri.parse(html.window.location.href);

      // 모바일 or 태블릿 식별 (유저에이전트)
      final userAgent = html.window.navigator.userAgent.toLowerCase();
      mobile = userAgent.contains('mobile') ||
          userAgent.contains('android') ||
          userAgent.contains('iphone');

      if (!mobile) {
        // 모바일이 아니면 무조건 에러
        access = false;
      } else {
        // 모바일에서만 인증 로직
        if (uri.queryParameters.isNotEmpty) {
          // 첫 진입: 파라미터 저장 + 주소창 정리
          final paramString = uri.queryParameters.entries.map((e) => '${e.key}=${e.value}').join('&');
          html.window.sessionStorage['params'] = paramString;

          // 주소창에서 파라미터 제거
          final cleanUrl = uri.removeFragment().replace(queryParameters: {}).toString();
          html.window.history.replaceState(null, '', cleanUrl);

          access = true;
        } else {
          // 파라미터 없을 때 세션스토리지 확인
          final storedParams = html.window.sessionStorage['params'];
          if (storedParams != null && storedParams.isNotEmpty) {
            access = true;
          }
        }
      }
    }
    setState(() {
      _showPaleeScreen = access;
      _isMobile = mobile;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 아직 체크 중이면 로딩 화면
    if (_showPaleeScreen == null) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator(color: Colors.white)),
        ),
      );
    }

    // 허용된 모바일, 정상 접근: 팔이 화면
    if (_showPaleeScreen == true && _isMobile) {
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PaleeScreen(),
      );
    } else {
      // 그 외: 에러 화면
      return const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ErrorScreen(),
      );
    }
  }
}
