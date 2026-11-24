import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class OtpCodeField extends StatefulWidget {
  final int length;
  final ValueChanged<String> onCompleted;

  const OtpCodeField({super.key, this.length = 6, required this.onCompleted});

  @override
  State<OtpCodeField> createState() => _OtpCodeFieldState();
}

class _OtpCodeFieldState extends State<OtpCodeField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (var c in _controllers) c.dispose();
    for (var f in _focusNodes) f.dispose();
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < widget.length - 1) {
      FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }

    String code = _controllers.map((c) => c.text).join();
    if (code.length == widget.length) {
      widget.onCompleted(code);
    }
  }

  Widget _buildDigitBox(int index, double boxWidth) {
    final theme = Theme.of(context);

    return Container(
      width: boxWidth,
      height: boxWidth,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(
          color: theme.dividerColor, //  ديناميك
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        maxLength: 1,

        cursorColor: Theme.of(context).brightness == Brightness.dark
            ? DarkColors.darkmainColor
            : LightColors.lightmaincolor,

        style: theme.textTheme.titleLarge?.copyWith(
          fontFamily: AppFonts.font,
          fontWeight: FontWeight.normal,
        ), //  ديناميك

        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),

        onChanged: (value) => _onChanged(value, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // حساب عرض كل مربع تلقائيًا حسب الشاشة وعدد الخانات
    double screenWidth =
        MediaQuery.of(context).size.width - 40; // 24 padding على كل جنب
    double spacing = 8; // المسافة بين المربعات
    double boxWidth =
        (screenWidth - spacing * (widget.length - 1)) / widget.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        widget.length,
        (index) => _buildDigitBox(index, boxWidth),
      ),
    );
  }
}
