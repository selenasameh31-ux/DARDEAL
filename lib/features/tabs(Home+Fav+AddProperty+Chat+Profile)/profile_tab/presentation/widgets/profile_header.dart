import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// class ProfileHeaderWidget extends StatelessWidget {
//   final File? imageFile;
//   final String userName;
//   final String bio;
//   final String address;
//   final bool isGuest;
//   final VoidCallback? onEdit;
//   final VoidCallback? onSignUp;

//   const ProfileHeaderWidget({
//     super.key, 
//     this.imageFile, 
//     required this.userName,
//     this.bio = '',
//     this.address = 'Your Address',
//     this.isGuest = false,
//     this.onEdit,
//     this.onSignUp,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Avatar
//             Container(
//               width: 60,
//               height: 60,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: context.primaryColor.withValues(alpha: 0.2),
//                   width: 1,
//                 ),
//               ),
//               child: ClipOval(
//                 child: imageFile != null
//                     ? Image.file(
//                         imageFile!,
//                         fit: BoxFit.cover,
//                         width: 60,
//                         height: 60,
//                       )
//                     : Container(
//                         color: context.primaryColor.withValues(alpha: 0.1),
//                         child: Icon(
//                           Icons.person,
//                           size: 35,
//                           color: context.primaryColor,
//                         ),
//                       ),
//               ),
//             ),
//             const SizedBox(width: 15),

//             // Name, Status and Location
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     isGuest ? "Welcome, Guest" : userName,
//                     style: TextStyle(
//                       fontSize: 17,
//                       fontWeight: FontWeight.bold,
//                       color: context.titleColor,
//                       fontFamily: AppFonts.font,
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   if (bio.isNotEmpty)
//                     Text(
//                       bio,
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         color: context.hintColor,
//                         fontFamily: AppFonts.font,
//                         fontSize: 12,
//                       ),
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       if (!isGuest) ...[
//                         Icon(
//                           Icons.location_on,
//                           size: 14,
//                           color: context.primaryColor,
//                         ),
//                         const SizedBox(width: 4),
//                         Flexible(
//                           child: Text(
//                             address,
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: context.hintColor,
//                               fontFamily: AppFonts.font,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ],
//               ),
//             ),

//             // Edit / Sign Up Button
//             GestureDetector(
//               onTap: isGuest ? onSignUp : onEdit,
//               child: Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 6,
//                 ),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: context.primaryColor),
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(
//                       isGuest ? Icons.login : Icons.edit,
//                       size: 16,
//                       color: context.primaryColor,
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       isGuest ? 'Sign Up' : 'Edit',
//                       style: TextStyle(
//                         color: context.primaryColor,
//                         fontFamily: AppFonts.font,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//}





import 'package:flutter/foundation.dart';
import 'package:graduation_project_flutter/core/database/api/end_points.dart';
import 'package:graduation_project_flutter/core/localization/app_strings.dart';
class ProfileHeaderWidget extends StatelessWidget {
  final File? imageFile;
  final String? imageUrl;
  final String userName;
  final String bio;
  final String address;
  final bool isGuest;
  final VoidCallback? onEdit;
  final VoidCallback? onSignUp;

  const ProfileHeaderWidget({
    super.key, 
    this.imageFile, 
    this.imageUrl,
    required this.userName,
    this.bio = '',
    this.address = 'Your Address',
    this.isGuest = false,
    this.onEdit,
    this.onSignUp,
  });

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      child: Icon(
        Icons.person,
        size: 35,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Builder(builder: (context) {
              String? fullImageUrl = imageUrl;
              if (fullImageUrl != null && fullImageUrl.isNotEmpty && !fullImageUrl.startsWith('http')) {
                fullImageUrl = '${EndPoints.baseUrl}$fullImageUrl';
              }
              
              return Container(
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
                  child: imageFile != null
                      ? Image.file(
                          imageFile!,
                          fit: BoxFit.cover,
                          width: 60,
                          height: 60,
                        )
                      : (fullImageUrl != null && fullImageUrl.isNotEmpty)
                          ? Image.network(
                              fullImageUrl,
                              fit: BoxFit.cover,
                              width: 60,
                              height: 60,
                              headers: {
                                'Authorization': 'Bearer ${sl<CacheHelper>().getToken()}'
                              },
                              errorBuilder: (_, __, ___) => _buildPlaceholder(context),
                            )
                          : _buildPlaceholder(context),
                ),
              );
            }),
            const SizedBox(width: 15),

            // Name, Status and Location
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isGuest ? AppStrings.of(context).guest : userName,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: context.titleColor,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                  const SizedBox(height: 2),
                  if (bio.isNotEmpty)
                    Text(
                      bio,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: context.hintColor,
                        fontFamily: AppFonts.font,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (!isGuest) ...[
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: context.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            address,
                            style: TextStyle(
                              fontSize: 13,
                              color: context.hintColor,
                              fontFamily: AppFonts.font,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Edit / Sign Up Button
            GestureDetector(
              onTap: isGuest ? onSignUp : onEdit,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: context.primaryColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isGuest ? Icons.login : Icons.edit,
                      size: 16,
                      color: context.primaryColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isGuest ? AppStrings.of(context).signUp : AppStrings.of(context).edit,
                      style: TextStyle(
                        color: context.primaryColor,
                        fontFamily: AppFonts.font,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
