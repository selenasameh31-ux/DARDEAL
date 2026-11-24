import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:graduation_project_flutter/core/localization/app_strings.dart';
import 'package:graduation_project_flutter/core/utils/top_snack_bar.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   File? _profileImage;

//   void _updateProfileImage(File? newImage) {
//     setState(() {
//       _profileImage = newImage;
//     });
//   }

//   Future<void> _navigateToEditProfile() async {
//     final result = await Navigator.push<File?>(
//       context,
//       MaterialPageRoute(
//         builder: (_) => EditProfileScreen(currentImage: _profileImage),
//       ),
//     );
//     if (result != null) {
//       _updateProfileImage(result);
//     }
//   }

//   void _navigateToPage(BuildContext context, String pageName) {
//     print('Navigating to: $pageName');
//     switch (pageName) {
//       case 'My Listings':
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const MyListingsScreen()),
//         );
//         break;
//       case 'Offers':
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const MyOffersScreen()),
//         );
//         break;
//       case 'Favorites':
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Opening Favorites')));
//         break;
//       case 'Active Rentals':
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const ActiveRentalsScreen()),
//         );
//         break;
//       case 'Notifications':
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Opening Notifications')));
//         break;
//       case 'Offer Requests':
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const OfferRequestsScreen()),
//         );
//         break;
//       case 'Rental Management':
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const RentalManagementScreen()),
//         );
//         break;
//       case 'Edit Profile':
//         _navigateToEditProfile();
//         break;
//       case 'Settings':
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(const SnackBar(content: Text('Opening Settings')));
//         break;
//       case 'Verification & Documents':
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => const DocumentTypeScreen()),
//         );
//         break;
//       case 'Payment Methods':
//         break;
//       case 'Log Out':
//         _showLogoutDialog(context);
//         break;
//       default:
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Opening $pageName')));
//     }
//   }

//   void _showLogoutDialog(BuildContext context) {
//     final theme = Theme.of(context);

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Text(
//             'Log Out',
//             style: theme.textTheme.titleLarge?.copyWith(
//               fontWeight: FontWeight.bold,
//               color: context.titleColor,
//             ),
//           ),
//           content: Text(
//             'Are you sure you want to log out?',
//             style: theme.textTheme.bodyMedium?.copyWith(
//               color: context.hintColor,
//               fontSize: 14,
//             ),
//           ),
//           actionsAlignment: MainAxisAlignment.spaceBetween,
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: Text(
//                 'Cancel',
//                 style: TextStyle(
//                   fontFamily: AppFonts.font,
//                   color: context.hintColor,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//             AppPrimaryButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 context.read<SessionCubit>().logout();
//                 Navigator.pushNamedAndRemoveUntil(
//                   context,
//                   Routes.authOptions,
//                   (route) => false,
//                 );
//               },
//               text: 'Log Out',
//               buttonColor: Colors.red,
//               textColor: Colors.white,
//               borderRadius: 12,
//               // Overriding width for dialog context
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final screenWidth = MediaQuery.of(context).size.width;
//     final cardWidth = (screenWidth - 48) / 2;
//     final cardHeight = cardWidth * 0.67;

//     return Scaffold(
//       backgroundColor: context.scaffoldBgColor,
//       body: SafeArea(
//         child: BlocBuilder<SessionCubit, SessionState>(
//           builder: (context, state) {
//             String userName = "Guest";
//             File? profileImage;
//             bool isGuest = state is SessionGuest;

//             if (state is SessionAuthenticated) {
//               userName = state.user.name;
//               profileImage = state.profileImage;
//             }

//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   GestureDetector(
//                     onTap: () => Navigator.pop(context),
//                     child: Padding(
//                       padding: const EdgeInsets.only(bottom: 8),
//                       child: Icon(
//                         Icons.arrow_back_ios_new,
//                         size: 20,
//                         color: context.titleColor,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),

//                   // Header
//                   ProfileHeaderWidget(
//                     imageFile: profileImage ?? _profileImage,
//                     userName: userName,
//                     bio: (state is SessionAuthenticated) 
//                         ? state.user.bio
//                         : '',
//                     address: (state is SessionAuthenticated) 
//                         ? state.user.displayAddress
//                         : 'Your Address',
//                     isGuest: isGuest,
//                     onEdit: _navigateToEditProfile,
//                     onSignUp: () {
//                       Navigator.pushNamed(context, Routes.signUp);
//                     },
//                   ),
//               const SizedBox(height: 30),

//               // Stats Cards
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildStatCard(
//                       context: context,
//                       title: "Offers",
//                       value: "3",
//                       imagePath: "assets/images/black-shop-tag.png",
//                       height: cardHeight,
//                       imageSize: 20,
//                       onTap: () => _navigateToPage(context, 'Offers'),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _buildStatCard(
//                       context: context,
//                       title: "Favorites",
//                       value: "15",
//                       imagePath: "assets/images/heart.png",
//                       height: cardHeight,
//                       imageSize: 25,
//                       onTap: () => _navigateToPage(context, 'Favorites'),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Row(
//                 children: [
//                   Expanded(
//                     child: _buildStatCard(
//                       context: context,
//                       title: "Active Rentals",
//                       value: "2",
//                       imagePath: "assets/images/key.png",
//                       height: cardHeight,
//                       imageSize: 20,
//                       onTap: () => _navigateToPage(context, 'Active Rentals'),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: _buildStatCard(
//                       context: context,
//                       title: "Notifications",
//                       value: "8",
//                       imagePath: "assets/images/notification.png",
//                       height: cardHeight,
//                       imageSize: 22,
//                       onTap: () => _navigateToPage(context, 'Notifications'),
//                     ),
//                   ),
//                 ],
//               ),

//               // ❌ تم حذف قسم Wallet بالكامل
//               const SizedBox(height: 32),

//               Text(
//                 "Property Management",
//                 style: theme.textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: context.titleColor,
//                   fontFamily: AppFonts.font,
//                   fontSize: 20,
//                 ),
//               ),
//               const SizedBox(height: 12),

//               Container(
//                 decoration: BoxDecoration(
//                   color: context.textFieldBgColor,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   children: [
//                     ProfileMenuTile(
//                       title: "My Listings",
//                       icon: Icons.home_work_outlined,
//                       onTap: () => _navigateToPage(context, 'My Listings'),
//                     ),
//                     ProfileMenuTile(
//                       title: "Offer Requests",
//                       icon: Icons.mail_outline,
//                       onTap: () => _navigateToPage(context, 'Offer Requests'),
//                     ),
//                     ProfileMenuTile(
//                       title: "Rental Management",
//                       icon: Icons.key_outlined,
//                       onTap: () =>
//                           _navigateToPage(context, 'Rental Management'),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 32),

//               Text(
//                 "Account Settings",
//                 style: theme.textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: context.titleColor,
//                   fontFamily: AppFonts.font,
//                   fontSize: 20,
//                 ),
//               ),
//               const SizedBox(height: 12),

//               Container(
//                 decoration: BoxDecoration(
//                   color: context.textFieldBgColor,
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 child: Column(
//                   children: [
//                     ProfileMenuTile(
//                       title: "Setting",
//                       icon: Icons.settings_outlined,
//                       onTap: () => _navigateToPage(context, 'Setting'),
//                     ),
//                     ProfileMenuTile(
//                       title: "Verification & Documents",
//                       icon: Icons.verified_user_outlined,
//                       onTap: () =>
//                           _navigateToPage(context, 'Verification & Documents'),
//                     ),
//                     if (!isGuest)
//                       ProfileMenuTile(
//                         title: "Log Out",
//                         icon: Icons.logout,
//                         isLogout: true,
//                         onTap: () => _navigateToPage(context, 'Log Out'),
//                       ),
//                   ],
//                 ),
//               ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildStatCard({
//     required BuildContext context,
//     required String title,
//     required String value,
//     required String imagePath,
//     required double height,
//     double imageSize = 22,
//     required VoidCallback? onTap,
//   }) {
//     final theme = Theme.of(context);

//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(12),
//         splashFactory: InkRipple.splashFactory,
//         splashColor: context.primaryColor.withValues(alpha: 0.1),
//         highlightColor: context.primaryColor.withValues(alpha: 0.05),
//         child: Container(
//           height: height,
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: context.textFieldBgColor,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: theme.shadowColor.withValues(alpha: 0.05),
//                 blurRadius: 10,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       title,
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         fontWeight: FontWeight.w600,
//                         color: context.titleColor,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(imageSize > 30 ? 8 : 4),
//                     child: Image.asset(
//                       imagePath,
//                       width: imageSize,
//                       height: imageSize,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => Container(
//                         width: imageSize,
//                         height: imageSize,
//                         color: context.textFieldBgColor,
//                         child: Icon(
//                           Icons.image_not_supported,
//                           size: imageSize - 4,
//                           color: context.hintColor,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               Text(
//                 value,
//                 style: theme.textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: context.titleColor,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }









class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;

  void _updateProfileImage(File? newImage) {
    setState(() {
      _profileImage = newImage;
    });
  }

  Future<void> _navigateToEditProfile([File? currentImage]) async {
    final result = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(currentImage: currentImage),
      ),
    );
    if (result != null) {
      _updateProfileImage(result);
    }
  }

  void _navigateToPage(BuildContext context, String pageName) {
    print('Navigating to: $pageName');
    switch (pageName) {
      case 'My Listings':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => sl<MyListingCubit>(),
              child: const MyListingsScreen(),
            ),
          ),
        );
        break;
      case 'My Contracts':
        Navigator.pushNamed(context, Routes.myContracts);
        break;
      case 'Offers':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MyOffersScreen()),
        );
        break;
      case 'Favorites':
        showTopSnackBar(context, 'Opening Favorites');
        break;
      case 'Active Rentals':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ActiveRentalsScreen()),
        );
        break;
      case 'Notifications':
        showTopSnackBar(context, 'Opening Notifications');
        break;
      case 'Offer Requests':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OfferRequestsScreen()),
        );
        break;
      case 'Rental Management':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (_) => sl<RentalManagementCubit>()..loadRentals(),
              child: const RentalManagementScreen(),
            ),
          ),
        );
        break;
      case 'Edit Profile':
        _navigateToEditProfile();
        break;
      case 'Settings':
        Navigator.pushNamed(context, Routes.settings);
        break;
      case 'Verification & Documents':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VerificationStatusScreen()),
        );
        break;
      case 'Payment Methods':
        break;
      case 'Log Out':
        _showLogoutDialog(context);
        break;
      default:
        showTopSnackBar(context, 'Opening $pageName');
    }
  }

  void _showLogoutDialog(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        title: Text(
            s.logOut,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.titleColor,
            ),
          ),
          content: Text(
            s.logOutConfirm,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: context.hintColor,
              fontSize: 14,
            ),
          ),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                s.cancel,
                style: TextStyle(
                  fontFamily: AppFonts.font,
                  color: context.hintColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            AppPrimaryButton(
              onPressed: () async {
                Navigator.pop(context); // Close the logout dialog

                // Show a loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      const Center(child: CircularProgressIndicator()),
                );

                try {
                  context.read<SessionCubit>().logout();
                  await sl<AuthRepository>().logout();
                  if (context.mounted) {
                    Navigator.pop(context); // Close loading dialog
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Routes.authOptions,
                      (route) => false,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(s.loggedOutSuccess),
                        backgroundColor: context.primaryColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    Navigator.pop(context); // Close loading dialog
                    showTopSnackBar(context, 'Logout failed: $e', isError: true);
                  }
                }
              },
              text: 'Log Out',
              buttonColor: Colors.red,
              textColor: Colors.white,
              borderRadius: 12,
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) / 2;
    final cardHeight = cardWidth * 0.67;

    return BlocProvider(
      create: (context) => sl<ProfileCubit>()..fetchProfileData(),
      child: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, sessionState) {
          String userName = "Guest";
          File? profileImage;
          bool isGuest = sessionState is SessionGuest;
          String bio = '';
          String address = 'Your Address';

          if (sessionState is SessionAuthenticated) {
            userName = sessionState.user.name;
            profileImage = sessionState.profileImage;
            bio = sessionState.user.bio;
            address = sessionState.user.displayAddress;
          }

          return Scaffold(
            backgroundColor: context.scaffoldBgColor,
            body: SafeArea(
              child: BlocBuilder<SessionCubit, SessionState>(
                builder: (context, state) {
                  String userName = AppStrings.of(context).guest;
                  File? profileImage;
                  String? profileImageUrl;
                  bool isGuest = state is SessionGuest;
                  String bio = '';
                  String address = 'Your Address';

                  if (state is SessionAuthenticated) {
                    userName = state.user.name;
                    profileImage = state.profileImage;
                    profileImageUrl = state.user.profileImagePath;
                    bio = state.user.bio;
                    address = state.user.displayAddress;
                  }

                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // Header
                        ProfileHeaderWidget(
                          imageFile: profileImage ?? _profileImage,
                          imageUrl: profileImageUrl,
                          userName: userName,
                          bio: bio,
                          address: address,
                          isGuest: isGuest,
                          onEdit: () => _navigateToEditProfile(
                            profileImage ?? _profileImage,
                          ),
                          onSignUp: () {
                            Navigator.pushNamed(context, Routes.signUp);
                          },
                        ),
                        const SizedBox(height: 30),

                        // Stats Cards
                        BlocBuilder<ProfileCubit, ProfileState>(
                          builder: (context, profileState) {
                            final stats = profileState is ProfileLoaded
                                ? profileState.stats
                                : <String, dynamic>{};
                            final offersCount =
                                stats['offersCount']?.toString() ?? '0';
                            final favsCount =
                                stats['favoritesCount']?.toString() ?? '0';
                            final activeRentalsCount =
                                stats['activeRentalsCount']?.toString() ?? '0';
                            final notificationsCount =
                                stats['notificationsCount']?.toString() ?? '0';
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        context: context,
                                        title: AppStrings.of(context).offers,
                                        value: offersCount,
                                        imagePath:
                                            "assets/images/black-shop-tag.png",
                                        height: cardHeight,
                                        imageSize: 20,
                                        onTap: () =>
                                            _navigateToPage(context, 'Offers'),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildStatCard(
                                        context: context,
                                        title: AppStrings.of(context).favorites,
                                        value: favsCount,
                                        imagePath: "assets/images/heart.png",
                                        height: cardHeight,
                                        imageSize: 25,
                                        onTap: () => _navigateToPage(
                                          context,
                                          'Favorites',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildStatCard(
                                        context: context,
                                        title: AppStrings.of(context).activeRentals,
                                        value: activeRentalsCount,
                                        imagePath: "assets/images/key.png",
                                        height: cardHeight,
                                        imageSize: 20,
                                        onTap: () => _navigateToPage(
                                          context,
                                          'Active Rentals',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildStatCard(
                                        context: context,
                                        title: AppStrings.of(context).notifications,
                                        value: notificationsCount,
                                        imagePath:
                                            "assets/images/notification.png",
                                        height: cardHeight,
                                        imageSize: 22,
                                        onTap: () => _navigateToPage(
                                          context,
                                          'Notifications',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 32),

                        Text(
                          AppStrings.of(context).propertyManagement,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.titleColor,
                            fontFamily: AppFonts.font,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Container(
                          decoration: BoxDecoration(
                            color: context.textFieldBgColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              ProfileMenuTile(
                                title: AppStrings.of(context).myListings,
                                icon: Icons.home_work_outlined,
                                onTap: () =>
                                    _navigateToPage(context, 'My Listings'),
                              ),
                              ProfileMenuTile(
                                title: AppStrings.of(context).offerRequests,
                                icon: Icons.mail_outline,
                                onTap: () =>
                                    _navigateToPage(context, 'Offer Requests'),
                              ),
                              ProfileMenuTile(
                                title: AppStrings.of(context).rentalManagement,
                                icon: Icons.key_outlined,
                                onTap: () => _navigateToPage(
                                  context,
                                  'Rental Management',
                                ),
                              ),
                              ProfileMenuTile(
                                title: AppStrings.of(context).myContracts,
                                icon: Icons.description_outlined,
                                onTap: () => _navigateToPage(context, 'My Contracts'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        Text(
                          AppStrings.of(context).accountSettings,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.titleColor,
                            fontFamily: AppFonts.font,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Container(
                          decoration: BoxDecoration(
                            color: context.textFieldBgColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              ProfileMenuTile(
                                title: AppStrings.of(context).settings,
                                icon: Icons.settings_outlined,
                                onTap: () => _navigateToPage(context, 'Settings'),
                              ),
                              ProfileMenuTile(
                                title: AppStrings.of(context).verificationAndDocs,
                                icon: Icons.verified_user_outlined,
                                onTap: () => _navigateToPage(
                                  context,
                                  'Verification & Documents',
                                ),
                              ),

                              if (!isGuest)
                                ProfileMenuTile(
                                  title: "Log Out",
                                  icon: Icons.logout,
                                  isLogout: true,
                                  onTap: () =>
                                      _navigateToPage(context, 'Log Out'),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required String imagePath,
    required double height,
    double imageSize = 22,
    required VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashFactory: InkRipple.splashFactory,
        splashColor: context.primaryColor.withValues(alpha: 0.1),
        highlightColor: context.primaryColor.withValues(alpha: 0.05),
        child: Container(
          height: height,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.textFieldBgColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: context.titleColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(imageSize > 30 ? 8 : 4),
                    child: Image.asset(
                      imagePath,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: imageSize,
                        height: imageSize,
                        color: context.textFieldBgColor,
                        child: Icon(
                          Icons.image_not_supported,
                          size: imageSize - 4,
                          color: context.hintColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.titleColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
