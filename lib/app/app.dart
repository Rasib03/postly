import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:postly/app/app_colors.dart';
import 'package:postly/app/app_strings.dart';
import 'package:postly/app/routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppPages.initial,
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgDeep,
        // Wipe out all default text decorations — no yellow underlines
        textTheme: Typography.material2021().black.apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
          decorationColor: Colors.transparent,
        ),
        colorScheme: ColorScheme.light(
          primary: AppColors.accentSecondary,
          surface: AppColors.bgDeep,
        ),
      ),
      getPages: AppPages.routes,
    );
  }
}
