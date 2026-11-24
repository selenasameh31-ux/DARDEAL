import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hintText;
  final TextEditingController? controller;
  final String? initialValue;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final ValueChanged<String>? onChanged;

  // Variant
  final AppInputVariant variant;

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.controller,
    this.initialValue,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.onChanged,
    this.variant = AppInputVariant.standard,
  }) : assert(
         initialValue == null || controller == null,
         'Cannot provide both a controller and an initial value.',
       );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppInputStyles.getMargin(variant),
      decoration: AppInputStyles.getContainerDecoration(
        context,
        variant: variant,
      ),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        validator: validator,
        onChanged: onChanged,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        cursorColor: Theme.of(context).brightness == Brightness.dark
            ? DarkColors.darkmainColor
            : LightColors.lightmaincolor,
        style: AppInputStyles.getTextStyle(context),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: AppInputStyles.contentPadding,
          labelText: label,
          hintText: hintText,
          labelStyle: AppInputStyles.getHintStyle(context),
          hintStyle: AppInputStyles.getHintStyle(context),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
