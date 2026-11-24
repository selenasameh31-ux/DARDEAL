import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:graduation_project_flutter/core/styles/theme_cubit.dart';
import 'package:graduation_project_flutter/core/localization/locale_cubit.dart';
import 'package:graduation_project_flutter/core/localization/app_strings.dart';
import 'package:graduation_project_flutter/core/database/api/end_points.dart';
import 'package:graduation_project_flutter/features/setting/presentation/widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);

    return Scaffold(
      backgroundColor: context.scaffoldBgColor,
      appBar: AppBar(
        title: Text(
          s.settings,
          style: TextStyle(
            color: context.titleColor,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.font,
          ),
        ),
        backgroundColor: context.scaffoldBgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        iconTheme: IconThemeData(color: context.titleColor),
      ),
      body: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, sessionState) {
          String name = '';
          String email = '';
          Widget? avatar;

          if (sessionState is SessionAuthenticated) {
            name = sessionState.user.name;
            email = sessionState.user.email;

            // ── الأولوية: imageUrl (من السيرفر) ← profileImagePath ← profileImage (ملف محلي)
            String? netUrl = (sessionState.imageUrl != null && sessionState.imageUrl!.isNotEmpty)
                ? sessionState.imageUrl
                : sessionState.user.profileImagePath.isNotEmpty
                    ? sessionState.user.profileImagePath
                    : null;

            if (netUrl != null && netUrl.isNotEmpty && !netUrl.startsWith('http')) {
              netUrl = '${EndPoints.baseUrl}$netUrl';
            }

            if (netUrl != null) {
              avatar = Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    netUrl,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                    headers: {
                      'Authorization': 'Bearer ${sl<CacheHelper>().getToken()}'
                    },
                    errorBuilder: (_, __, ___) => Container(
                      color: context.primaryColor.withValues(alpha: 0.1),
                      child: Icon(Icons.person, size: 30, color: context.primaryColor),
                    ),
                  ),
                ),
              );
            } else if (sessionState.profileImage != null) {
              avatar = Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: context.primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: ClipOval(
                  child: Image.file(
                    sessionState.profileImage!,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                ),
              );
            }
          }

          avatar ??= Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.primaryColor.withValues(alpha: 0.1),
            ),
            child: Icon(Icons.person, size: 30, color: context.primaryColor),
          );

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Profile Header ──
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Row(
                    children: [
                      avatar,
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name.isNotEmpty ? name : s.profile,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: context.titleColor,
                                fontFamily: AppFonts.font,
                              ),
                            ),
                            if (email.isNotEmpty)
                              Text(
                                email,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: context.hintColor,
                                  fontFamily: AppFonts.font,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),
                const SizedBox(height: 8),

                // ── Preferences ──
                _buildSectionHeader(context, s.preferences.toUpperCase()),

                // Theme Dropdown ✅
                SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: s.theme,
                  trailing: BlocBuilder<ThemeCubit, ThemeMode>(
                    builder: (context, themeMode) {
                      final s2 = AppStrings.of(context);
                      return DropdownButton2<ThemeMode>(
                        value: themeMode,
                        underline: const SizedBox(),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 150,
                          offset: const Offset(0, -4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: context.scaffoldBgColor,
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: context.hintColor,
                          ),
                        ),
                        style: TextStyle(
                          color: context.bodyColor,
                          fontSize: 14,
                          fontFamily: AppFonts.font,
                        ),
                        onChanged: (ThemeMode? newValue) {
                          if (newValue != null) {
                            context.read<ThemeCubit>().setTheme(newValue);
                          }
                        },
                        items: [
                          DropdownMenuItem<ThemeMode>(
                            value: ThemeMode.system,
                            child: Text(s2.system),
                          ),
                          DropdownMenuItem<ThemeMode>(
                            value: ThemeMode.light,
                            child: Text(s2.light),
                          ),
                          DropdownMenuItem<ThemeMode>(
                            value: ThemeMode.dark,
                            child: Text(s2.dark),
                          ),
                        ],
                      );
                    },
                  ),
                  onTap: () {},
                ),

                // Language Dropdown ✅
                SettingsTile(
                  icon: Icons.language_outlined,
                  title: s.language,
                  trailing: BlocBuilder<LocaleCubit, Locale>(
                    builder: (context, locale) {
                      final s2 = AppStrings.of(context);
                      return DropdownButton2<String>(
                        value: locale.languageCode,
                        underline: const SizedBox(),
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 120,
                          offset: const Offset(0, -4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: context.scaffoldBgColor,
                          ),
                        ),
                        iconStyleData: IconStyleData(
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: context.hintColor,
                          ),
                        ),
                        style: TextStyle(
                          color: context.bodyColor,
                          fontSize: 14,
                          fontFamily: AppFonts.font,
                        ),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            context.read<LocaleCubit>().setLanguage(newValue);
                          }
                        },
                        items: [
                          DropdownMenuItem<String>(
                            value: 'en',
                            child: Text(s2.english),
                          ),
                          DropdownMenuItem<String>(
                            value: 'ar',
                            child: Text(s2.arabic),
                          ),
                        ],
                      );
                    },
                  ),
                  onTap: () {},
                ),

                SettingsTile(
                  icon: Icons.notifications_none_outlined,
                  title: s.notifications,
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.notifications),
                ),

                const SizedBox(height: 8),

                // ── Support & About ──
                _buildSectionHeader(context, s.supportAndAbout.toUpperCase()),
                SettingsTile(
                  icon: Icons.help_outline,
                  title: s.helpCenter,
                  onTap: () => Navigator.pushNamed(context, Routes.helpCenter),
                ),
                SettingsTile(
                  icon: Icons.privacy_tip_outlined,
                  title: s.privacyPolicy,
                  onTap: () =>
                      Navigator.pushNamed(context, Routes.privacyPolicy),
                ),
                SettingsTile(
                  icon: Icons.article_outlined,
                  title: s.termsAndConditions,
                  onTap: () => Navigator.pushNamed(context, Routes.terms),
                ),

                const SizedBox(height: 16),

                // ── Logout ──
                SettingsTile(
                  icon: Icons.logout,
                  iconColor: Colors.redAccent,
                  textColor: Colors.redAccent,
                  title: s.logout,
                  trailing: const SizedBox(),
                  onTap: () => _showLogoutDialog(context),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: context.hintColor,
          letterSpacing: 1.4,
          fontFamily: AppFonts.font,
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final s = AppStrings.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: context.scaffoldBgColor,
        title: Text(
          s.logout,
          style: TextStyle(
            color: context.titleColor,
            fontWeight: FontWeight.bold,
            fontFamily: AppFonts.font,
          ),
        ),
        content: Text(
          s.logoutConfirmation,
          style: TextStyle(color: context.bodyColor, fontFamily: AppFonts.font),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              s.cancel,
              style: TextStyle(
                color: context.hintColor,
                fontFamily: AppFonts.font,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SessionCubit>().logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.authOptions,
                (route) => false,
              );
            },
            child: Text(
              s.logout,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.font,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
