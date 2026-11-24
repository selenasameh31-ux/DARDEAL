import 'package:graduation_project_flutter/core/routing/routes_export.dart';

//الانيميشن الخاص بالشكل البيضاوي فالجناب

class MovingEllipse extends StatefulWidget {
  final Gradient gradient;
  final double width;
  final double height;
  final bool isLeft; // true = على الشمال، false = على اليمين
  final double top;
  final double
  startVisibleFraction; // نسبة ظهور البداية (قد إيه من الشكل يكون ظاهر من الأول)
  final double
  endVisibleFraction; // نسبة ظهور النهاية (الشكل هيظهر لحد فين وهو بيتحرك)
  final int delay; // زمن تأخير بداية الحركة لكل شكل بيضاوي
  final Duration duration; // مدة الحركة لكل شكل (سرعة الحركة ذهاب و عودة)

  const MovingEllipse({
    Key? key,
    required this.gradient,
    required this.width,
    required this.height,
    required this.top,
    required this.isLeft,
    this.startVisibleFraction = 0.0,
    this.endVisibleFraction = 0.5,
    this.delay = 0,
    this.duration = const Duration(seconds: 4),
  }) : super(key: key);

  @override
  State<MovingEllipse> createState() => _MovingEllipseState();
}

class _MovingEllipseState extends State<MovingEllipse>
    with SingleTickerProviderStateMixin {
  late final AnimationController
  _controller; // كنترولر يتحكم في الأنيميشن (يكرر، يوقف، يشغل...)
  late final Animation<double>
  _posAnimation; // الأنيميشن اللي هيغيّر موضع الشكل في الاتجاه الافقي (يمين او شمال)

  /* دالة بتحسب مقدار الجزء المختفي في الشكل على حسب نسبة الظهور
   يعني لو نسبة ظهور 0 يبقى الشكل مختفي تمامًا
   لو نسبة ظهور 0.5 يبقى نصف الشكل ظاهر، وهكذا */

  double _hiddenOffsetFor(double visibleFraction) {
    final v = visibleFraction.clamp(0.0, 1.0);
    return -widget.width * (1.0 - v);
  }

  @override
  void initState() {
    super.initState();

    // حساب نقطة البداية والنهاية لحركة الشكل
    final double startOff = _hiddenOffsetFor(widget.startVisibleFraction);
    final double endOff = _hiddenOffsetFor(widget.endVisibleFraction);

    // إنشاء الكنترولر للأنيميشن لمدة الحركة المرسلة
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // عمل Tween من نقطة البداية لنقطة النهاية مع منحنى حركة ناعم
    _posAnimation = Tween<double>(begin: startOff, end: endOff).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // الحركة تمشي وتبطأ بشكل ناعم
      ),
    );

    // لو مفيش تأخير يبقى يبدأ الحركة عالطول ويروح وييجي تلقائي
    if (widget.delay <= 0) {
      _controller.repeat(reverse: true);
    }
    // اما لو فيه تأخير يبقى نستنى الأول وبعدين نبدأالحركة
    else {
      Future.delayed(Duration(milliseconds: widget.delay), () {
        if (mounted) _controller.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    // لازم نعمل dispose للكنترولر عشان نقلّل استخدام الذاكرة
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          _posAnimation, // بيعيد بناء الويدجيت كل ما قيمة الأنيميشن تتغير
      builder: (context, child) {
        return Positioned(
          top: widget.top, // وضع الشكل من أعلى
          left: widget.isLeft
              ? _posAnimation.value
              : null, // لو على الشمال يبقى استخدم left
          right: widget.isLeft
              ? null
              : _posAnimation.value, // لو على اليمين يبقى استخدم right
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              gradient: widget.gradient, // تدريجة اللون للشكل
              borderRadius: BorderRadius.circular(
                widget.height,
              ), // يخليه بيضاوي
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25), // ظل خفيف تحت الشكل
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
