import 'package:flutter/material.dart';
import 'package:graduation_project_flutter/core/styles/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = Localizations.localeOf(context).languageCode == 'ar';
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isAr ? 'مركز المساعدة' : 'Help Center',
          style: TextStyle(color: context.titleColor),
        ),
        backgroundColor: context.scaffoldBgColor,
        iconTheme: IconThemeData(color: context.titleColor),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // قسم الترحيب
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: context.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.support_agent,
                    size: 48,
                    color: context.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isAr ? 'كيف يمكننا مساعدتك؟' : 'How can we help you?',
                    style: textTheme.titleLarge?.copyWith(
                      color: context.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isAr
                        ? 'اختر أحد الأقسام أدناه لمعرفة المزيد'
                        : 'Choose one of the sections below to learn more',
                    style: textTheme.bodyMedium?.copyWith(
                      color: context.bodyColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // قسم الأسئلة الشائعة (FAQ)
            Text(
              isAr ? 'الأسئلة الشائعة' : 'Frequently Asked Questions',
              style: textTheme.titleMedium?.copyWith(
                color: context.titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildFaqSection(context, isAr),

            const SizedBox(height: 24),

            // قسم طرق التواصل
            Text(
              isAr ? 'تواصل معنا' : 'Contact Us',
              style: textTheme.titleMedium?.copyWith(
                color: context.titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildContactSection(context, isAr),

            const SizedBox(height: 24),

            // قسم روابط مفيدة (مع وظيفة فتح الروابط)
            Text(
              isAr ? 'روابط مفيدة' : 'Useful Links',
              style: textTheme.titleMedium?.copyWith(
                color: context.titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildUsefulLinks(context, isAr),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context, bool isAr) {
    final faqs = isAr
        ? [
            {
              'question': 'كيف يمكنني إنشاء حساب جديد؟',
              'answer':
                  'يمكنك إنشاء حساب جديد بالضغط على "Sign Up" من شاشة تسجيل الدخول، ثم إدخال بياناتك الشخصية مثل الاسم والبريد الإلكتروني ورقم الهاتف وكلمة المرور.',
            },
            {
              'question': 'كيف يمكنني إضافة عقار جديد؟',
              'answer':
                  'بعد تسجيل الدخول، انتقل إلى تبويب "Add Property" وقم بملء جميع المعلومات المطلوبة عن العقار مثل الموقع، السعر، المساحة، الصور، ثم اضغط "Submit".',
            },
            {
              'question': 'كيف يمكنني مراجعة العروض التي أرسلتها أو استلمتها؟',
              'answer':
                  'اذهب إلى تبويب "Profile" ثم اختر "My Listings" لمشاهدة العروض التي تلقيتها على عقاراتك، أو "Offers" لمشاهدة العروض التي أرسلتها.',
            },
            {
              'question': 'كيف يمكنني تغيير كلمة المرور؟',
              'answer':
                  'من شاشة البروفايل، اضغط على "Settings" ثم اختر "Change Password"، ثم أدخل كلمة المرور الحالية والجديدة.',
            },
            {
              'question': 'هل يمكنني تغيير اللغة؟',
              'answer':
                  'نعم، من الإعدادات يمكنك التبديل بين اللغة العربية والإنجليزية بسهولة.',
            },
          ]
        : [
            {
              'question': 'How do I create a new account?',
              'answer':
                  'You can create a new account by clicking "Sign Up" on the login screen, then entering your personal details such as name, email, phone number, and password.',
            },
            {
              'question': 'How do I add a new property?',
              'answer':
                  'After logging in, go to the "Add Property" tab and fill in all required information about the property such as location, price, area, photos, then click "Submit".',
            },
            {
              'question': 'How can I review offers I sent or received?',
              'answer':
                  'Go to the "Profile" tab and select "My Listings" to view offers you received on your properties, or "Offers" to view offers you sent.',
            },
            {
              'question': 'How do I change my password?',
              'answer':
                  'On the profile screen, click "Settings" then choose "Change Password", then enter your current and new password.',
            },
            {
              'question': 'Can I change the language?',
              'answer':
                  'Yes, from the settings you can easily switch between Arabic and English.',
            },
          ];

    return Container(
      decoration: BoxDecoration(
        color: context.textFieldBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: faqs.map((faq) {
          return ExpansionTile(
            title: Text(
              faq['question']!,
              style: TextStyle(
                color: context.titleColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  faq['answer']!,
                  style: TextStyle(color: context.bodyColor),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildContactSection(BuildContext context, bool isAr) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.textFieldBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildContactTile(
            context,
            icon: Icons.email_outlined,
            title: isAr ? 'البريد الإلكتروني' : 'Email',
            value: 'support@dardeal.com',
            onTap: () => _launchUrl('mailto:support@dardeal.com'),
          ),
          const Divider(height: 1),
          _buildContactTile(
            context,
            icon: Icons.phone_outlined,
            title: isAr ? 'رقم الهاتف' : 'Phone Number',
            value: '+20 123 456 7890',
            onTap: () => _launchUrl('tel:+201234567890'),
          ),
          const Divider(height: 1),
          _buildContactTile(
            context,
            icon: Icons.chat_outlined,
            title: isAr ? 'الدردشة المباشرة' : 'Live Chat',
            value: isAr
                ? 'متاح من الأحد إلى الخميس 9ص - 5م'
                : 'Available Sun-Thu 9AM - 5PM',
            onTap: () {
              // يمكن فتح صفحة ويب للدعم أو رابط واتساب
              _launchUrl('https://wa.me/201234567890');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: context.primaryColor),
      title: Text(
        title,
        style: TextStyle(
          color: context.titleColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(value, style: TextStyle(color: context.bodyColor)),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: context.hintColor,
      ),
      onTap: onTap,
    );
  }

  Widget _buildUsefulLinks(BuildContext context, bool isAr) {
    // يمكنك تغيير هذه الروابط إلى الروابط الفعلية لسياسة الخصوصية وشروط الاستخدام
    final String privacyUrl = 'https://yourwebsite.com/privacy-policy';
    final String termsUrl = 'https://yourwebsite.com/terms-of-use';
    final String faqUrl = 'https://yourwebsite.com/faq';
    final String reportUrl = 'https://yourwebsite.com/report-issue';

    final links = isAr
        ? [
            {
              'title': 'سياسة الخصوصية',
              'icon': Icons.privacy_tip_outlined,
              'url': privacyUrl,
            },
            {
              'title': 'شروط الاستخدام',
              'icon': Icons.description_outlined,
              'url': termsUrl,
            },
            {
              'title': 'الأسئلة الشائعة المتقدمة',
              'icon': Icons.quiz_outlined,
              'url': faqUrl,
            },
            {
              'title': 'بلاغ عن مشكلة',
              'icon': Icons.report_problem_outlined,
              'url': reportUrl,
            },
          ]
        : [
            {
              'title': 'Privacy Policy',
              'icon': Icons.privacy_tip_outlined,
              'url': privacyUrl,
            },
            {
              'title': 'Terms of Use',
              'icon': Icons.description_outlined,
              'url': termsUrl,
            },
            {
              'title': 'Advanced FAQ',
              'icon': Icons.quiz_outlined,
              'url': faqUrl,
            },
            {
              'title': 'Report an Issue',
              'icon': Icons.report_problem_outlined,
              'url': reportUrl,
            },
          ];

    return Container(
      decoration: BoxDecoration(
        color: context.textFieldBgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: links.map((link) {
          return ListTile(
            leading: Icon(
              link['icon'] as IconData,
              color: context.primaryColor,
            ),
            title: Text(
              link['title'] as String,
              style: TextStyle(color: context.titleColor),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: context.hintColor,
            ),
            onTap: () => _launchUrl(link['url'] as String),
          );
        }).toList(),
      ),
    );
  }
}
