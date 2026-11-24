import 'package:graduation_project_flutter/core/routing/routes_export.dart';
//OnboardingScreen يشغل BlocBuilder اللي بي listen للـ Cubit
// لما تغيري الصفحة في الـ PageView → يستدعي changePage() → UI يتحدث

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0); // واقفة فأنهي صفحة

  void changePage(int index) {
    emit(index); // بيعمل ايميت لرقم الصفحة الجديد
  }
}
