import 'package:flutter/material.dart';
import 'package:graduation_project_flutter/core/styles/app_colors.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'سياسة الخصوصية' : 'Privacy Policy',
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
              title: isAr ? 'مقدمة' : 'Introduction',
              content: isAr
                  ? 'في Dardeal، نحن ملتزمون بحماية خصوصيتك وضمان أمان بياناتك الشخصية. توضح سياسة الخصوصية هذه كيفية جمع معلوماتك واستخدامها وحمايتها عند استخدام تطبيقنا.'
                  : 'At Dardeal, we are committed to protecting your privacy and ensuring the security of your personal data. This Privacy Policy explains how we collect, use, and protect your information when you use our application.',
            ),
            _buildSection(
              context,
              title: isAr ? 'المعلومات التي نجمعها' : 'Information We Collect',
              content: isAr
                  ? '• معلومات الحساب: الاسم، البريد الإلكتروني، رقم الهاتف.\n• معلومات الملف الشخصي: الصورة الشخصية، العنوان، الموقع.\n• معلومات العقارات: تفاصيل العقارات التي تضيفها أو تبحث عنها.\n• معلومات الدفع: بيانات الدفع اللازمة لإتمام المعاملات (لا نخزن تفاصيل البطاقات الكاملة).\n• بيانات الاستخدام: كيفية تفاعلك مع التطبيق.'
                  : '• Account information: name, email, phone number.\n• Profile information: profile picture, address, location.\n• Property information: details of properties you add or search for.\n• Payment information: necessary payment details to complete transactions (we do not store full card details).\n• Usage data: how you interact with the application.',
            ),
            _buildSection(
              context,
              title: isAr
                  ? 'كيف نستخدم معلوماتك'
                  : 'How We Use Your Information',
              content: isAr
                  ? '• تقديم وتحسين خدمات التطبيق.\n• تسهيل التواصل بين المستخدمين (المشترين والبائعين).\n• معالجة العروض والمدفوعات.\n• إرسال إشعارات مهمة متعلقة بالحساب أو العروض.\n• تحسين تجربة المستخدم بناءً على التحليلات.'
                  : '• Provide and improve application services.\n• Facilitate communication between users (buyers and sellers).\n• Process offers and payments.\n• Send important notifications related to your account or offers.\n• Improve user experience based on analytics.',
            ),
            _buildSection(
              context,
              title: isAr ? 'مشاركة المعلومات' : 'Sharing Information',
              content: isAr
                  ? 'لا نبيع أو نؤجر معلوماتك الشخصية لأطراف ثالثة. قد نشارك معلوماتك مع:\n• مزودي الخدمة الذين يساعدوننا في تشغيل التطبيق.\n• السلطات القانونية عند الضرورة.\n• مستخدمين آخرين فقط عندما يكون ذلك ضرورياً لإتمام معاملة عقارية (مثل مشاركة عرض سعر).'
                  : 'We do not sell or rent your personal information to third parties. We may share your information with:\n• Service providers who help us operate the application.\n• Legal authorities when required.\n• Other users only when necessary to complete a real estate transaction (e.g., sharing an offer).',
            ),
            _buildSection(
              context,
              title: isAr ? 'أمان البيانات' : 'Data Security',
              content: isAr
                  ? 'نستخدم تدابير أمنية تقنية وإدارية مناسبة لحماية معلوماتك من الوصول غير المصرح به أو التعديل أو الإفصاح أو التدمير. ومع ذلك، لا يوجد نظام أمان مثالي، ونحن نشجعك على حماية بيانات اعتماد حسابك.'
                  : 'We use appropriate technical and administrative security measures to protect your information from unauthorized access, alteration, disclosure, or destruction. However, no security system is perfect, and we encourage you to protect your account credentials.',
            ),
            _buildSection(
              context,
              title: isAr ? 'حقوقك' : 'Your Rights',
              content: isAr
                  ? '• الوصول إلى بياناتك الشخصية.\n• تصحيح البيانات غير الدقيقة.\n• حذف حسابك وبياناتك.\n• إلغاء الاشتراك في رسائل التسويق.\nللقيام بذلك، يرجى الاتصال بنا عبر قسم المساعدة في التطبيق.'
                  : '• Access your personal data.\n• Correct inaccurate data.\n• Delete your account and data.\n• Unsubscribe from marketing messages.\nTo do so, please contact us via the Help Center in the application.',
            ),
            _buildSection(
              context,
              title: isAr ? 'تحديثات سياسة الخصوصية' : 'Privacy Policy Updates',
              content: isAr
                  ? 'قد نقوم بتحديث هذه السياسة من وقت لآخر. سنخطرك بأي تغييرات جوهرية من خلال التطبيق أو البريد الإلكتروني. تاريخ آخر تحديث: 15 يونيو 2026.'
                  : 'We may update this policy from time to time. We will notify you of any material changes via the application or email. Last updated: June 15, 2026.',
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                isAr
                    ? 'شكراً لثقتك بـ Dardeal'
                    : 'Thank you for trusting Dardeal',
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
