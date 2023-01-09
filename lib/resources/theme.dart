import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData get theme {
    var typography = Typography.material2021(platform: defaultTargetPlatform);
    var textTheme = typography.black.apply(
      fontFamily: 'Poppins',
      bodyColor: Colors.black,
      displayColor: Colors.black,
    );
    var headline6 = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontFamily: 'Poppins',
      color: Colors.black,
      height: 26 / 16,
      letterSpacing: 0,
    );
    var headline5 = const TextStyle(
      fontSize: 14,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w600,
      height: 21 / 14,
      color: Colors.black,
      letterSpacing: 0,
      fontStyle: FontStyle.normal,
    );
    var subtitle2 = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      fontFamily: 'Poppins',
      height: 20 / 13,
      letterSpacing: 0,
      color: Colors.black,
    );
    var subtitle1 = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      fontFamily: 'Montserrat',
      color: Colors.black.withOpacity(0.5),
      height: 20 / 13,
      letterSpacing: 0,
    );
    var bodyText2 = TextStyle(
      fontSize: 14,
      fontFamily: 'Poppins',
      height: 22 / 14,
      color: Colors.black.withOpacity(0.7),
      letterSpacing: 0,
      fontWeight: FontWeight.w500,
    );
    var bodyText1 = const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      fontFamily: 'Poppins',
      height: 20 / 13,
      letterSpacing: 0,
      color: Colors.black,
    );
    var button = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      fontFamily: 'Poppins',
      height: 19 / 15,
      color: Colors.white,
      letterSpacing: 0,
    );
    var caption = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      fontFamily: 'Poppins',
      height: 16 / 13,
      letterSpacing: 0,
      color: Colors.black.withOpacity(0.5),
    );

    var overline = const TextStyle(
      fontSize: 17,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      height: 44 / 17,
      color: Colors.black,
      letterSpacing: 0,
    );

    textTheme = textTheme.copyWith(
      headline5: headline5,
      headline6: headline6,
      subtitle1: subtitle1,
      subtitle2: subtitle2,
      bodyText1: bodyText1,
      bodyText2: bodyText2,
      caption: caption,
      button: button,
      overline: overline,
    );

    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: MyColors.divider, width: 1),
    );
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: primaryColor,
        onSecondary: Colors.white,
        brightness: Brightness.light,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Colors.black,
        selectionColor: primaryColor.withOpacity(0.3),
        selectionHandleColor: primaryColor,
      ),
      primaryColor: primaryColor,
      indicatorColor: primaryColor,
      toggleableActiveColor: primaryColor,
      canvasColor: Colors.white,
      backgroundColor: Colors.white,
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
          statusBarColor: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: false,
        titleTextStyle: headline6,
        toolbarTextStyle: textTheme.caption,
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(16),
        buttonColor: primaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          primary: secondaryColor,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: headline5,
          fixedSize: const Size(140, 60),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          primary: secondaryColor,
          padding: EdgeInsets.zero,
          textStyle: headline5.copyWith(fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            primary: secondaryColor,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: primaryColor),
              borderRadius: BorderRadius.circular(15),
            ),
            side: BorderSide(width: 1, color: primaryColor),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: headline5,
            fixedSize: const Size(250, 50)),
      ),
      popupMenuTheme: PopupMenuThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
          side: const BorderSide(color: MyColors.divider, width: 1),
        ),
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        iconSize: 22,
        elevation: 0,
        disabledElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: border,
        enabledBorder: border,
        focusedBorder: border,
        labelStyle: caption.copyWith(
          fontStyle: FontStyle.normal,
          color: Colors.black.withOpacity(0.5),
          fontSize: 14,
          height: 44 / 14,
        ),
        hintStyle: bodyText1.copyWith(
          fontStyle: FontStyle.normal,
          color: Colors.black.withOpacity(0.5),
          fontSize: 13,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
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
        backgroundColor: MyColors.card,
        disabledColor: Colors.grey,
        selectedColor: primaryColor,
        secondarySelectedColor: primaryColor,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        labelStyle: bodyText1.copyWith(height: 1.2, color: Colors.black),
        secondaryLabelStyle: bodyText1.copyWith(
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
        labelColor: MyColors.primaryColor,
        unselectedLabelColor: Colors.black.withOpacity(0.7),
        labelStyle: headline6.copyWith(
          fontWeight: FontWeight.w700,
          color: MyColors.primaryColor,
          // fontSize: 14,
        ),
        unselectedLabelStyle: caption.copyWith(
          fontWeight: FontWeight.w400,
          // fontSize: 14,
        ),
      ),
    );
  }

  static Color primaryColor = MyColors.primaryColor;
  static Color secondaryColor = MyColors.secondaryColor;
}
