import 'package:flutter/material.dart';

/// Central translation helper for the app.
/// Usage: AppStrings.of(context).messages
class AppStrings {
  final bool isAr;
  const AppStrings._(this.isAr);

  static AppStrings of(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    return AppStrings._(lang == 'ar');
  }

  // ── Common ──────────────────────────────────────────────
  String get cancel => isAr ? 'إلغاء' : 'Cancel';
  String get logOut => isAr ? 'تسجيل الخروج' : 'Log Out';
  String get logOutConfirm =>
      isAr ? 'هل أنت متأكد أنك تريد تسجيل الخروج؟' : 'Are you sure you want to log out?';
  String get loggedOutSuccess =>
      isAr ? 'تم تسجيل الخروج بنجاح' : 'Logged out successfully';
  String get notifications => isAr ? 'الإشعارات' : 'Notifications';
  String get settings => isAr ? 'الإعدادات' : 'Settings';
  String get search => isAr ? 'بحث' : 'Search';

  // ── Chat Screen ─────────────────────────────────────────
  String get messages => isAr ? 'الرسائل' : 'Messages';
  String get searchConversations =>
      isAr ? 'ابحث في المحادثات...' : 'Search conversations...';
  String get noConversations =>
      isAr ? 'لا توجد محادثات بعد.' : 'No conversations yet.';

  // ── Profile Screen ──────────────────────────────────────
  String get guest => isAr ? 'ضيف' : 'Guest';
  String get edit => isAr ? 'تعديل' : 'Edit';
  String get signUp => isAr ? 'إنشاء حساب' : 'Sign Up';
  String get offers => isAr ? 'العروض' : 'Offers';
  String get favorites => isAr ? 'المفضلة' : 'Favorites';
  String get activeRentals => isAr ? 'الإيجارات النشطة' : 'Active Rentals';
  String get propertyManagement =>
      isAr ? 'إدارة العقارات' : 'Property Management';
  String get myListings => isAr ? 'قوائمي' : 'My Listings';
  String get offerRequests => isAr ? 'طلبات العروض' : 'Offer Requests';
  String get rentalManagement => isAr ? 'إدارة الإيجار' : 'Rental Management';
  String get myContracts => isAr ? 'عقودي' : 'My Contracts';
  String get accountSettings => isAr ? 'إعدادات الحساب' : 'Account Settings';
  String get verificationAndDocs =>
      isAr ? 'التحقق والوثائق' : 'Verification & Documents';

  // ── Settings Screen ─────────────────────────────────────
  String get profile => isAr ? 'الملف الشخصي' : 'Profile';
  String get editProfile => isAr ? 'تعديل الملف' : 'Edit Profile';
  String get account => isAr ? 'الحساب' : 'Account';
  String get verificationStatus => isAr ? 'حالة التحقق' : 'Verification Status';
  String get preferences => isAr ? 'التفضيلات' : 'Preferences';
  String get theme => isAr ? 'المظهر' : 'Theme';
  String get language => isAr ? 'اللغة' : 'Language';
  String get supportAndAbout =>
      isAr ? 'الدعم وحول التطبيق' : 'Support & About';
  String get helpCenter => isAr ? 'مركز المساعدة' : 'Help Center';
  String get privacyPolicy => isAr ? 'سياسة الخصوصية' : 'Privacy Policy';
  String get termsAndConditions =>
      isAr ? 'الشروط والأحكام' : 'Terms & Conditions';
  String get logout => isAr ? 'تسجيل الخروج' : 'Logout';
  String get logoutConfirmation =>
      isAr ? 'هل أنت متأكد أنك تريد تسجيل الخروج؟' : 'Are you sure you want to logout?';
  String get system => isAr ? 'النظام' : 'System';
  String get light => isAr ? 'فاتح' : 'Light';
  String get dark => isAr ? 'داكن' : 'Dark';
  String get english => isAr ? 'الإنجليزية' : 'English';
  String get arabic => isAr ? 'العربية' : 'Arabic';
}
