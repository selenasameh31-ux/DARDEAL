import 'package:flutter/material.dart';
import 'package:graduation_project_flutter/core/styles/app_colors.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'الشروط والأحكام' : 'Terms & Conditions',
          style: TextStyle(color: context.titleColor),
        ),
        backgroundColor: context.scaffoldBgColor,
        iconTheme: IconThemeData(color: context.titleColor),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context,
              title: isAr ? 'قبول الشروط' : 'Acceptance of Terms',
              content: isAr
                  ? 'باستخدام تطبيق Dardeal، فإنك توافق على الالتزام بهذه الشروط والأحكام. إذا كنت لا توافق على أي جزء من هذه الشروط، يرجى عدم استخدام التطبيق.'
                  : 'By using the Dardeal application, you agree to be bound by these Terms & Conditions. If you do not agree with any part of these terms, please do not use the application.',
            ),
            _buildSection(
              context,
              title: isAr ? 'الحسابات والأمان' : 'Accounts and Security',
              content: isAr
                  ? '• أنت مسؤول عن الحفاظ على سرية بيانات تسجيل الدخول الخاصة بك.\n• يجب أن تكون المعلومات التي تقدمها دقيقة وكاملة.\n• أنت مسؤول عن جميع الأنشطة التي تحدث تحت حسابك.\n• يجب إخطارنا فوراً بأي استخدام غير مصرح به لحسابك.'
                  : '• You are responsible for maintaining the confidentiality of your login credentials.\n• The information you provide must be accurate and complete.\n• You are responsible for all activities that occur under your account.\n• You must immediately notify us of any unauthorized use of your account.',
            ),
            _buildSection(
              context,
              title: isAr ? 'العقارات والعروض' : 'Properties and Offers',
              content: isAr
                  ? '• العقارات المضافة يجب أن تكون قانونية وتتبع القوانين المحلية.\n• العروض المقدمة تكون ملزمة وفقاً للشروط المتفق عليها.\n• نحن نتحقق من دقة المعلومات ولكن لا نضمن خلوها من الأخطاء.\n• يحق لنا إزالة أي محتوى مخالف للقوانين أو للشروط.'
                  : '• Properties added must be legal and comply with local laws.\n• Offers submitted are binding according to the agreed terms.\n• We verify the accuracy of information but do not guarantee it is error-free.\n• We reserve the right to remove any content that violates laws or these terms.',
            ),
            _buildSection(
              context,
              title: isAr ? 'الدفع والرسوم' : 'Payments and Fees',
              content: isAr
                  ? '• قد يتم تطبيق رسوم على بعض الخدمات (مثل إدراج العقارات المميزة).\n• جميع المعاملات المالية آمنة ومشفرة.\n• سياسة الاسترداد: غير قابلة للاسترداد ما لم ينص على خلاف ذلك.\n• أنت توافق على دفع جميع الرسوم المفروضة على حسابك.'
                  : '• Fees may apply to certain services (e.g., premium property listings).\n• All financial transactions are secure and encrypted.\n• Refund policy: non-refundable unless otherwise stated.\n• You agree to pay all fees charged to your account.',
            ),
            _buildSection(
              context,
              title: isAr ? 'السلوك المحظور' : 'Prohibited Conduct',
              content: isAr
                  ? '• لا يجوز استخدام التطبيق في أنشطة غير قانونية.\n• لا يجوز التحرش أو إساءة معاملة المستخدمين الآخرين.\n• لا يجوز نشر معلومات مضللة أو احتيالية.\n• لا يجوز انتهاك حقوق الملكية الفكرية للآخرين.'
                  : '• You may not use the application for illegal activities.\n• You may not harass or abuse other users.\n• You may not post misleading or fraudulent information.\n• You may not violate the intellectual property rights of others.',
            ),
            _buildSection(
              context,
              title: isAr ? 'إخلاء المسؤولية' : 'Disclaimer of Warranties',
              content: isAr
                  ? 'التطبيق يتم توفيره "كما هو" و "كما هو متاح". نحن لا نقدم أي ضمانات صريحة أو ضمنية بشأن دقة المحتوى أو توفر الخدمة. استخدام التطبيق هو على مسؤوليتك الشخصية.'
                  : 'The application is provided "as is" and "as available". We make no express or implied warranties regarding the accuracy of content or availability of the service. Use of the application is at your own risk.',
            ),
            _buildSection(
              context,
              title: isAr ? 'تحديد المسؤولية' : 'Limitation of Liability',
              content: isAr
                  ? 'في حدود القانون المسموح به، نحن غير مسؤولين عن أي أضرار غير مباشرة أو عرضية أو خاصة ناتجة عن استخدامك للتطبيق أو عدم قدرتك على استخدامه.'
                  : 'To the extent permitted by law, we are not liable for any indirect, incidental, or special damages arising from your use of the application or inability to use it.',
            ),
            _buildSection(
              context,
              title: isAr ? 'تعديل الشروط' : 'Modification of Terms',
              content: isAr
                  ? 'قد نقوم بتعديل هذه الشروط في أي وقت. سنخطرك بالتغييرات الهامة. استمرارك في استخدام التطبيق بعد التعديل يعني قبولك للشروط الجديدة.'
                  : 'We may modify these terms at any time. We will notify you of material changes. Your continued use of the application after modification constitutes acceptance of the new terms.',
            ),
            _buildSection(
              context,
              title: isAr ? 'القانون الحاكم' : 'Governing Law',
              content: isAr
                  ? 'تخضع هذه الشروط لقوانين جمهورية مصر العربية. أي نزاع ينشأ عنها يحال إلى المحاكم المختصة في القاهرة.'
                  : 'These terms are governed by the laws of the Arab Republic of Egypt. Any dispute arising from them shall be referred to the competent courts in Cairo.',
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                isAr
                    ? 'نشكرك على استخدام Dardeal'
                    : 'Thank you for using Dardeal',
                style: textTheme.bodyMedium?.copyWith(
                  color: context.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required String content,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: context.titleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(color: context.bodyColor, height: 1.5),
          ),
        ],
      ),
    );
  }
}
