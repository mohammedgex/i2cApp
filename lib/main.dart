import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/Global/sharedPref.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/splash_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // The academy uses Egyptian pounds across all catalog and checkout screens.
  await SharedPrefUtil.put('currency_code', 'EGP');
  await SharedPrefUtil.put('currency_name', 'الجنيه المصري');
  await SharedPrefUtil.put('language_code', 'ar');
  await SharedPrefUtil.put('text_direction', 'rtl');

  // Setup FCM + local notifications
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  // await PushNotificationsService.instance.init();

  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SharedPrefUtil.get('isLoggedin', false).then((value) => print(value));
    SharedPrefUtil.get('token', "").then((value) => print(value));
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          builder: (context, widget) {
            final mediaQueryData = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQueryData.copyWith(textScaleFactor: 1.14),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: widget ?? const SizedBox.shrink(),
              ),
            );
          },
          theme: ThemeData(
            fontFamily: 'BalooBhaijaan2',
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryColor,
              brightness: Brightness.light,
              primary: AppColors.primaryColor,
              secondary: AppColors.secondaryColor,
            ),
            primaryColor: AppColors.primaryColor,
            scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
            cardColor: AppColors.cardBackgroundColor,
            appBarTheme: AppBarTheme(
              backgroundColor: AppColors.scaffoldBackgroundColor,
              foregroundColor: AppColors.titleTextColor,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: AppColors.cardBackgroundColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 15,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.textFieldBorderColor),
              ),
            ),
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: AppColors.primaryColor,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(0, 48),
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                textStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: AppColors.primaryColor),
              ),
            ),
          ),
          locale: const Locale('ar'),
          supportedLocales: const [Locale('ar')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: SplashScreen(),
        );
      },
    );
  }
}
