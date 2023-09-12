import 'package:flutter_riverpod/flutter_riverpod.dart';

final activeThemeProvider = StateProvider<Themes>((ref) => Themes.dark);

enum Themes {
  light,
  dark,
}
