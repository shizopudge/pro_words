/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class $AssetsAnimationsGen {
  const $AssetsAnimationsGen();

  /// File path: assets/animations/error.json
  String get error => 'assets/animations/error.json';

  /// File path: assets/animations/loading.json
  String get loading => 'assets/animations/loading.json';

  /// List of all assets
  List<String> get values => [error, loading];
}

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/PlusJakartaSans-Bold.ttf
  String get plusJakartaSansBold => 'assets/fonts/PlusJakartaSans-Bold.ttf';

  /// File path: assets/fonts/PlusJakartaSans-BoldItalic.ttf
  String get plusJakartaSansBoldItalic =>
      'assets/fonts/PlusJakartaSans-BoldItalic.ttf';

  /// File path: assets/fonts/PlusJakartaSans-ExtraBold.ttf
  String get plusJakartaSansExtraBold =>
      'assets/fonts/PlusJakartaSans-ExtraBold.ttf';

  /// File path: assets/fonts/PlusJakartaSans-ExtraBoldItalic.ttf
  String get plusJakartaSansExtraBoldItalic =>
      'assets/fonts/PlusJakartaSans-ExtraBoldItalic.ttf';

  /// File path: assets/fonts/PlusJakartaSans-ExtraLight.ttf
  String get plusJakartaSansExtraLight =>
      'assets/fonts/PlusJakartaSans-ExtraLight.ttf';

  /// File path: assets/fonts/PlusJakartaSans-ExtraLightItalic.ttf
  String get plusJakartaSansExtraLightItalic =>
      'assets/fonts/PlusJakartaSans-ExtraLightItalic.ttf';

  /// File path: assets/fonts/PlusJakartaSans-Italic.ttf
  String get plusJakartaSansItalic => 'assets/fonts/PlusJakartaSans-Italic.ttf';

  /// File path: assets/fonts/PlusJakartaSans-Light.ttf
  String get plusJakartaSansLight => 'assets/fonts/PlusJakartaSans-Light.ttf';

  /// File path: assets/fonts/PlusJakartaSans-LightItalic.ttf
  String get plusJakartaSansLightItalic =>
      'assets/fonts/PlusJakartaSans-LightItalic.ttf';

  /// File path: assets/fonts/PlusJakartaSans-Medium.ttf
  String get plusJakartaSansMedium => 'assets/fonts/PlusJakartaSans-Medium.ttf';

  /// File path: assets/fonts/PlusJakartaSans-MediumItalic.ttf
  String get plusJakartaSansMediumItalic =>
      'assets/fonts/PlusJakartaSans-MediumItalic.ttf';

  /// File path: assets/fonts/PlusJakartaSans-Regular.ttf
  String get plusJakartaSansRegular =>
      'assets/fonts/PlusJakartaSans-Regular.ttf';

  /// File path: assets/fonts/PlusJakartaSans-SemiBold.ttf
  String get plusJakartaSansSemiBold =>
      'assets/fonts/PlusJakartaSans-SemiBold.ttf';

  /// File path: assets/fonts/PlusJakartaSans-SemiBoldItalic.ttf
  String get plusJakartaSansSemiBoldItalic =>
      'assets/fonts/PlusJakartaSans-SemiBoldItalic.ttf';

  /// List of all assets
  List<String> get values => [
        plusJakartaSansBold,
        plusJakartaSansBoldItalic,
        plusJakartaSansExtraBold,
        plusJakartaSansExtraBoldItalic,
        plusJakartaSansExtraLight,
        plusJakartaSansExtraLightItalic,
        plusJakartaSansItalic,
        plusJakartaSansLight,
        plusJakartaSansLightItalic,
        plusJakartaSansMedium,
        plusJakartaSansMediumItalic,
        plusJakartaSansRegular,
        plusJakartaSansSemiBold,
        plusJakartaSansSemiBoldItalic
      ];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/microphone.svg
  SvgGenImage get microphone =>
      const SvgGenImage('assets/icons/microphone.svg');

  /// List of all assets
  List<SvgGenImage> get values => [microphone];
}

class Assets {
  Assets._();

  static const $AssetsAnimationsGen animations = $AssetsAnimationsGen();
  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(this._assetName);

  final String _assetName;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme theme = const SvgTheme(),
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    return SvgPicture.asset(
      _assetName,
      key: key,
      matchTextDirection: matchTextDirection,
      bundle: bundle,
      package: package,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      theme: theme,
      colorFilter: colorFilter,
      color: color,
      colorBlendMode: colorBlendMode,
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
