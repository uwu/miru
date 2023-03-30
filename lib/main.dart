import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

import 'package:miru/home.dart';

void main() {
  runApp(const Miru(title: "Miru"));
}

const Color _brandBlue = Color(0xFF6750A4);

class Miru extends StatefulWidget {
  const Miru({super.key, required this.title});
  final String title;

  @override
  State<Miru> createState() => MiruState();
}

class MiruState extends State<Miru> {
  ThemeMode _themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        ColorScheme lightColorScheme;
        ColorScheme darkColorScheme;

        if (lightDynamic != null && darkDynamic != null) {
          // On Android S+ devices, use the provided dynamic color scheme.
          lightColorScheme = lightDynamic.harmonized();
          // Repeat for the dark color scheme.
          darkColorScheme = darkDynamic.harmonized();
        } else {
          // Otherwise, use fallback schemes.
          lightColorScheme = ColorScheme.fromSeed(
            seedColor: _brandBlue,
          );
          darkColorScheme = ColorScheme.fromSeed(
            seedColor: _brandBlue,
            brightness: Brightness.dark,
          );
        }

        return MaterialApp(
          themeMode: _themeMode,
          theme: ThemeData(
            splashFactory: InkSparkle.splashFactory,
            useMaterial3: true,
            colorScheme: lightColorScheme,
          ),
          darkTheme: ThemeData(
            splashFactory: InkSparkle.splashFactory,
            useMaterial3: true,
            colorScheme: darkColorScheme,
          ),
          home: MiruHome(onBrightessChange: () {
            setState(() {
              _themeMode = _themeMode == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            });
          }),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
