/// 4px-based spacing scale used across the app so paddings/gaps stay
/// consistent between screens. Values are logical pixels, meant to be
/// wrapped with `.w`/`.h` (ScreenUtil) at the call site when the layout
/// needs to scale with screen size.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
  static const double xxxl = 64;
}

/// Corner-radius scale. Piggy Bank favors very rounded corners to feel
/// soft and approachable for children.
abstract final class AppRadii {
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double pill = 999;
}
