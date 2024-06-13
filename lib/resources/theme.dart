import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData get theme {
    var typography = Typography.material2021(platform: defaultTargetPlatform);
    var textTheme = typography.black.apply(
      fontFamily: 'ReadexPro',
      bodyColor: Colors.black,
      displayColor: Colors.black,
    );

    var titleLarge = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      fontFamily: 'ReadexPro',
      color: Colors.black,
      height: 30 / 24,
      letterSpacing: 0,
    );

    var titleMedium = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'ReadexPro',
      color: Colors.black,
      height: 16 / 14,
      letterSpacing: 0,
    );

    var titleSmall = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      fontFamily: 'ReadexPro',
      height: 14 / 12,
      letterSpacing: 0,
      color: Colors.black.withOpacity(0.7),
    );

    var headlineMedium = const TextStyle(
      fontSize: 18,
      fontFamily: 'ReadexPro',
      fontWeight: FontWeight.w600,
      height: 24 / 18,
      color: Colors.black,
      letterSpacing: 0,
      fontStyle: FontStyle.normal,
    );

    var headlineSmall = const TextStyle(
      fontSize: 20,
      fontFamily: 'ReadexPro',
      fontWeight: FontWeight.w600,
      height: 26 / 20,
      color: Colors.black,
      letterSpacing: 0,
      fontStyle: FontStyle.normal,
    );

    var displaySmall = const TextStyle(
      fontSize: 16,
      fontFamily: 'ReadexPro',
      fontWeight: FontWeight.w600,
      height: 20 / 16,
      color: Colors.black,
      letterSpacing: 0,
      fontStyle: FontStyle.normal,
    );

    var displayMedium = const TextStyle(
      fontSize: 14,
      fontFamily: 'ReadexPro',
      fontWeight: FontWeight.w500,
      height: 18 / 14,
      color: Colors.black,
      letterSpacing: 0,
      fontStyle: FontStyle.normal,
    );

    var bodyLarge = const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      fontFamily: 'ReadexPro',
      height: 18 / 14,
      letterSpacing: 0,
      color: Colors.black,
    );

    var bodyMedium = const TextStyle(
      fontSize: 14,
      fontFamily: 'ReadexPro',
      height: 18 / 14,
      color: Colors.black,
      letterSpacing: 0,
      fontWeight: FontWeight.w600,
    );

    var bodySmall = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontFamily: 'ReadexPro',
      height: 16 / 12,
      letterSpacing: 0,
      color: Colors.black.withOpacity(0.5),
    );

    var labelLarge = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: 'ReadexPro',
      height: 20 / 16,
      color: Colors.white,
      letterSpacing: 0,
    );

    var labelSmall = const TextStyle(
      fontSize: 10,
      fontFamily: 'ReadexPro',
      fontWeight: FontWeight.w400,
      height: 12 / 10,
      color: Colors.black,
      letterSpacing: 0,
    );

    textTheme = textTheme.copyWith(
      titleLarge: titleLarge,
      headlineSmall: headlineSmall,
      headlineMedium: headlineMedium,
      displayMedium: displayMedium,
      displaySmall: displaySmall,
      bodyMedium: bodyMedium,
      titleSmall: titleSmall,
      bodyLarge: bodyLarge,
      titleMedium: titleMedium,
      bodySmall: bodySmall,
      labelLarge: labelLarge,
      labelSmall: labelSmall,
    );

    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: MyColors.divider.withOpacity(0.5),
        width: 1,
      ),
    );

    return ThemeData(
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.black,
        selectionColor: primaryColor.withOpacity(0.3),
        selectionHandleColor: primaryColor,
      ),
      primaryColor: primaryColor,
      indicatorColor: primaryColor,
      canvasColor: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      typography: typography,
      cardTheme: CardTheme(
        elevation: 0,
        margin: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        clipBehavior: Clip.antiAlias,
      ),
      appBarTheme: AppBarTheme(
        elevation: 4,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        titleTextStyle: headlineMedium,
        toolbarTextStyle: textTheme.bodySmall,
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: const EdgeInsets.all(16),
        buttonColor: primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          foregroundColor: Colors.white,
          // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: displaySmall.copyWith(fontSize: 14),
          fixedSize: const Size(140, 50),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.zero,
          textStyle: displaySmall.copyWith(fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          side: BorderSide(width: 1, color: primaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: displaySmall,
          fixedSize: const Size(100, 50),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(color: MyColors.divider, width: 1),
        ),
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        iconSize: 32,
        elevation: 0,
        disabledElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 8,
        ),
        // border: border
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black.withOpacity(0.1)),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: primaryColor.withOpacity(0.7),
            width: 1.5,
          ),
        ),
        labelStyle: bodySmall.copyWith(
          fontStyle: FontStyle.normal,
          color: Colors.black.withOpacity(0.5),
          fontSize: 12,
          height: 25 / 12,
        ),
        hintStyle: bodySmall.copyWith(color: Colors.black.withOpacity(0.3)),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.black, size: 24),
      dividerTheme: const DividerThemeData(
        thickness: 1,
        space: 1,
        color: MyColors.divider,
      ),
      checkboxTheme: CheckboxThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashRadius: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        side: MaterialStateBorderSide.resolveWith(
          (states) =>
              const BorderSide(width: 1, color: MyColors.secondaryColor),
        ),
        checkColor: MaterialStateProperty.all(MyColors.primaryColor),
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return const Color(0xFFFFFFFF);
        }),
        overlayColor: MaterialStateProperty.all(const Color(0xFFFFFFFF)),
      ),
      radioTheme: RadioThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          } else {
            return const Color(0xFFB5B5B5);
          }
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white,
        disabledColor: Colors.grey[400],
        selectedColor: primaryColor,
        secondarySelectedColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        labelStyle: bodyLarge.copyWith(height: 1.2, color: Colors.black),
        secondaryLabelStyle: bodyLarge.copyWith(
          height: 1.2,
          color: Colors.white,
        ),
        brightness: Brightness.dark,
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        activeTickMarkColor: primaryColor,
        thumbColor: primaryColor,
        inactiveTrackColor: primaryColor.withOpacity(.2),
      ),
      tabBarTheme: TabBarTheme(
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: MyColors.cerulean,
        unselectedLabelColor: Colors.black.withOpacity(0.7),
        labelStyle: bodyLarge.copyWith(
          fontWeight: FontWeight.w400,
          color: MyColors.cerulean,
          fontSize: 14,
        ),
        unselectedLabelStyle: bodySmall.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: primaryColor,
        onSecondary: Colors.white,
        brightness: Brightness.light,
      ).copyWith(background: Colors.white),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return null;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.disabled)) {
            return null;
          }
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return null;
        }),
      ),
    );
  }

  static Color primaryColor = MyColors.primaryColor;
  static Color secondaryColor = MyColors.secondaryColor;
}
