// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:skill_grow/core/colors/app_colors.dart';
import 'package:skill_grow/features/mulit_langual_data/controller/multi_langual_data_controller.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

class OnboardingTitleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;

  const OnboardingTitleText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.textDirection,
    this.softWrap = true,
    this.overflow,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
  });

  // Default TextStyle
  static TextStyle defaultStyle = TextStyle(
    fontWeight: FontWeight.w800, // Weight
    fontSize: 24.sp, // Size in px
    height: 29.05.sp / 24.sp, // Line height (line height / font size)
    letterSpacing: 0.01.sp * 24.sp, // Letter spacing (1% of font size)
    color: AppColors.onboardingTitleTextColor, // Default color
  );

  @override
  Widget build(BuildContext context) {
    return GlobalText(
      text: text,
      style: defaultStyle.merge(style), // Merge the default and custom styles
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
    );
  }
}

class OnboardingSubtitleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final bool softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;

  const OnboardingSubtitleText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.textDirection,
    this.softWrap = true,
    this.overflow,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
  });

  // Default TextStyle
  static TextStyle defaultStyle = TextStyle(
    fontWeight: FontWeight.w400, // Weight
    fontSize: 12.sp, // Size in px
    height: 16.sp / 12.sp, // Line height (line height / font size)
    letterSpacing: 0.01.sp * 24.sp, // Letter spacing (1% of font size)
    color: AppColors.onboardingSubtitleTextColor, // Default color
  );

  @override
  Widget build(BuildContext context) {
    return GlobalText(
      text: text,
      style: defaultStyle.merge(style), // Merge the default and custom styles
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
      locale: locale,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis,
    );
  }
}

// ignore: must_be_immutable
class GlobalText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final double? textScaleFactor;

  GlobalText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.softWrap = true,
    this.overflow = TextOverflow.fade,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textScaleFactor,
  });

  MultiLangualDataController multiLangualDataController =
      Get.put(MultiLangualDataController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final translatedText =
          multiLangualDataController.multiLangualData[text] ?? text;

      return Text(
        translatedText,
        style: style,
        textAlign: textAlign,
        textDirection: TextDirection.rtl,
        softWrap: softWrap,
        overflow: overflow,
        maxLines: maxLines,
        locale: locale,
        strutStyle: strutStyle,
        textWidthBasis: textWidthBasis,
        textScaleFactor: textScaleFactor,
      );
    });
  }
}

class HtmlGlobalText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final bool softWrap;
  final TextOverflow? overflow;
  final int? maxLines;
  final Locale? locale;
  final StrutStyle? strutStyle;
  final TextWidthBasis? textWidthBasis;
  final double? textScaleFactor;

  HtmlGlobalText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    required this.softWrap,
    this.overflow = TextOverflow.fade,
    this.maxLines,
    this.locale,
    this.strutStyle,
    this.textWidthBasis,
    this.textScaleFactor,
  });

  final MultiLangualDataController multiLangualDataController =
      Get.find<MultiLangualDataController>();

  @override
  Widget build(BuildContext context) {
    // Parse and clean the text for translation
    dom.Document document = parse(text);
    String cleanText = document.body?.text ?? '';
    String translatedText =
        multiLangualDataController.multiLangualData[cleanText] ?? cleanText;

    // Use the translated text as HTML content
    return Html(
      data: translatedText,
      style: {
        "body": Style(
          direction: multiLangualDataController.isLTR.value
              ? TextDirection.ltr
              : TextDirection.rtl,
          fontSize: FontSize(style?.fontSize ?? 12),
          fontWeight: style?.fontWeight,
          color: style?.color,
          fontFamily: "BalooBhaijaan2",
          textAlign: textAlign ?? TextAlign.start,
        ),
      },
    );
  }
}
