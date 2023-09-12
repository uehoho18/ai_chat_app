import 'package:flutter/material.dart';

// lightThemeは、明るいテーマを定義する変数です。
final lightTheme = ThemeData(
  // ThemeData.light()は、Flutterが提供する明るいテーマの基本設定を利用します。
  colorScheme: ThemeData.light().colorScheme.copyWith(
        // primaryは、アプリの主要な色です。ここでは白色に設定しています。
        primary: Colors.white,
        // onPrimaryは、主要な色（primary）の上に表示されるテキストやアイコンの色です。ここでは黒色に設定しています。
        onPrimary: Colors.black,
        // secondaryは、アプリの補助色です。ここではColor(0xFF4A5568)に設定しています。
        secondary: const Color(0xFF4A5568),
        // onSecondaryは、補助色（secondary）の上に表示されるテキストやアイコンの色です。ここでは白色に設定しています。
        onSecondary: Colors.white,
      ),
);

// darkThemeは、暗いテーマを定義する変数です。
final darkTheme = ThemeData.dark().copyWith(
  // ThemeData.dark()は、Flutterが提供する暗いテーマの基本設定を利用します。
  colorScheme: ThemeData.dark().colorScheme.copyWith(
        // primaryは、アプリの主要な色です。ここでは黒色に設定しています。
        primary: Colors.black,
        // onPrimaryは、主要な色（primary）の上に表示されるテキストやアイコンの色です。ここでは白色に設定しています。
        onPrimary: Colors.white,
        // secondaryは、アプリの補助色です。ここではColor(0xFF4A5568)に設定しています。
        secondary: const Color(0xFF4A5568),
        // onSecondaryは、補助色（secondary）の上に表示されるテキストやアイコンの色です。ここでは白色に設定しています。
        onSecondary: Colors.white,
      ),
);
