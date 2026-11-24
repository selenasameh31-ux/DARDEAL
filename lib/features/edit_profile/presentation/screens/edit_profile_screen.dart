import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// class EditProfileScreen extends StatefulWidget {
//   final File? currentImage;
//   const EditProfileScreen({super.key, this.currentImage});

//   @override
//   State<EditProfileScreen> createState() => _EditProfileScreenState();
// }

// class _EditProfileScreenState extends State<EditProfileScreen> {
//   late File? _avatarImage;
//   final ImagePicker _picker = ImagePicker();

//   final _formKey = GlobalKey<FormState>();
//   final _fullNameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _phoneController = TextEditingController();
//   final _altPhoneController = TextEditingController();
//   String _selectedGender = 'Male';
//   DateTime _selectedDate = DateTime(2000, 1, 1);
//   final _addressController = TextEditingController();
//   final _bioController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     final sessionCubit = context.read<SessionCubit>();
//     if (sessionCubit.state is SessionAuthenticated) {
//       final authState = sessionCubit.state as SessionAuthenticated;
//       final user = authState.user;
//       _fullNameController.text = user.name;
//       _emailController.text = user.email;
//       _phoneController.text = user.phone;
//       _avatarImage = widget.currentImage ?? authState.profileImage;

//       // Load gender
//       if (user.gender.isNotEmpty) {
//         _selectedGender = user.gender;
//       }

//       // Load date of birth
//       if (user.dateOfBirth.isNotEmpty) {
//         try {
//           _selectedDate = DateTime.parse(user.dateOfBirth);
//         } catch (_) {}
//       }

//       // Load address
//       if (user.address.isNotEmpty) {
//         _addressController.text = user.address;
//       }

//       // Load bio
//       if (user.bio.isNotEmpty) {
//         _bioController.text = user.bio;
//       }
//     } else {
//       _avatarImage = widget.currentImage;
//     }
//   }

//   @override
//   void dispose() {
//     _fullNameController.dispose();
//     _emailController.dispose();
//     _phoneController.dispose();
//     _altPhoneController.dispose();
//     _addressController.dispose();
//     _bioController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Theme.of(context).colorScheme.surface,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (ctx) => SafeArea(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: Icon(
//                 Icons.photo_library,
//                 color: context.primaryColor,
//               ),
//               title: Text(
//                 "Choose from Gallery",
//                 style: TextStyle(fontFamily: AppFonts.font),
//               ),
//               onTap: () async {
//                 Navigator.pop(ctx);
//                 final XFile? image = await _picker.pickImage(
//                   source: ImageSource.gallery,
//                 );
//                 if (image != null)
//                   setState(() => _avatarImage = File(image.path));
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.photo_camera, color: context.primaryColor),
//               title: Text(
//                 "Take a Photo",
//                 style: TextStyle(fontFamily: AppFonts.font),
//               ),
//               onTap: () async {
//                 Navigator.pop(ctx);
//                 final XFile? image = await _picker.pickImage(
//                   source: ImageSource.camera,
//                 );
//                 if (image != null)
//                   setState(() => _avatarImage = File(image.path));
//               },
//             ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.cancel, color: Colors.red),
//               title: Text(
//                 "Cancel",
//                 style: TextStyle(fontFamily: AppFonts.font, color: Colors.red),
//               ),
//               onTap: () => Navigator.pop(ctx),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) return 'Email is required';
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
//     return null;
//   }

//   String? _validatePhone(String? value) {
//     if (value == null || value.isEmpty) return 'Phone number is required';
//     final phoneRegex = RegExp(r'^[\+\d\s\-\(\)]{8,}$');
//     if (!phoneRegex.hasMatch(value)) return 'Enter a valid phone number';
//     return null;
//   }

//   String? _validateName(String? value) {
//     if (value == null || value.isEmpty) return 'Full name is required';
//     return null;
//   }

//   void _saveChanges() {
//     if (_formKey.currentState!.validate()) {
//       final sessionCubit = context.read<SessionCubit>();
//       if (sessionCubit.state is SessionAuthenticated) {
//         final currentUser = (sessionCubit.state as SessionAuthenticated).user;
//         final updatedUser = currentUser.copyWith(
//           name: _fullNameController.text.trim(),
//           email: _emailController.text.trim(),
//           phone: _phoneController.text.trim(),
//           gender: _selectedGender,
//           dateOfBirth: _selectedDate.toIso8601String(),
//           address: _addressController.text.trim(),
//           bio: _bioController.text.trim(),
//         );
//         sessionCubit.updateProfile(updatedUser, profileImage: _avatarImage);
//       }
//       Navigator.pop(context, _avatarImage);
//     }
//   }

//   void _cancel() => Navigator.pop(context);

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final colors = theme.colorScheme;

//     return Scaffold(
//       backgroundColor: context.scaffoldBgColor,
//       appBar: AppBar(
//         surfaceTintColor: Colors.transparent,
//         scrolledUnderElevation: 0.0,
//         backgroundColor: context.scaffoldBgColor,
//         elevation: 0,
//         centerTitle: true,
//         leadingWidth: 56,
//         leading: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new,
//             size: 18,
//             color: context.titleColor,
//           ),
//           onPressed: () => Navigator.pop(context),
//         ),
//         title: Text(
//           "Edit Profile",
//           style: TextStyle(
//             color: context.titleColor,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             fontFamily: AppFonts.font,
//           ),
//         ),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Avatar
//               Center(
//                 child: Stack(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: context.primaryColor.withValues(alpha: 0.1),
//                       backgroundImage: _avatarImage != null
//                           ? FileImage(_avatarImage!)
//                           : null,
//                       child: _avatarImage == null
//                           ? Icon(Icons.person, size: 60, color: context.primaryColor)
//                           : null,
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       right: 0,
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: context.primaryColor,
//                           shape: BoxShape.circle,
//                           border: Border.all(color: colors.surface, width: 2),
//                         ),
//                         child: IconButton(
//                           icon: Icon(
//                             Icons.camera_alt,
//                             size: 18,
//                             color: Colors.white,
//                           ),
//                           onPressed: _pickImage,
//                           padding: const EdgeInsets.all(6),
//                           constraints: const BoxConstraints(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 32),

//               Text(
//                 "Personal Information",
//                 style: theme.textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                   color: context.titleColor,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               EditProfileTextField(
//                 label: "Full Name",
//                 controller: _fullNameController,
//                 hint: "Enter your full name",
//                 prefixIcon: Icons.person_outline,
//                 validator: _validateName,
//               ),
//               const SizedBox(height: 16),

//               EditProfileTextField(
//                 label: "Email",
//                 controller: _emailController,
//                 hint: "your@email.com",
//                 keyboardType: TextInputType.emailAddress,
//                 prefixIcon: Icons.email_outlined,
//                 validator: _validateEmail,
//               ),
//               const SizedBox(height: 16),

//               EditProfileTextField(
//                 label: "Phone Number",
//                 controller: _phoneController,
//                 hint: "+1 (555) 000-0000",
//                 keyboardType: TextInputType.phone,
//                 prefixIcon: Icons.phone_outlined,
//                 validator: _validatePhone,
//               ),
//               const SizedBox(height: 16),

//               EditProfileTextField(
//                 label: "Alternative Phone",
//                 controller: _altPhoneController,
//                 hint: "+1 (555) 000-0000",
//                 keyboardType: TextInputType.phone,
//                 isOptional: true,
//                 prefixIcon: Icons.phone_android_outlined,
//               ),
//               const SizedBox(height: 16),

//               EditProfileGenderDropdown(
//                 selectedGender: _selectedGender,
//                 onChanged: (value) => setState(() => _selectedGender = value),
//               ),
//               const SizedBox(height: 16),

//               EditProfileDatePicker(
//                 label: "Date of Birth",
//                 selectedDate: _selectedDate,
//                 onDateChanged: (newDate) =>
//                     setState(() => _selectedDate = newDate),
//               ),
//               const SizedBox(height: 24),

//               Text(
//                 "Address Details",
//                 style: theme.textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                   color: context.titleColor,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               EditProfileTextField(
//                 label: "Full Address",
//                 controller: _addressController,
//                 hint: "Governorate / City - Neighborhood",
//                 maxLines: 2,
//                 prefixIcon: Icons.location_on_outlined,
//               ),
//               const SizedBox(height: 24),

//               Text(
//                 "About",
//                 style: theme.textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.w600,
//                   color: context.titleColor,
//                 ),
//               ),
//               const SizedBox(height: 16),

//               EditProfileTextField(
//                 label: "Bio",
//                 controller: _bioController,
//                 hint: "Tell us about yourself...",
//                 maxLines: 4,
//                 prefixIcon: Icons.description_outlined,
//               ),
//               const SizedBox(height: 32),

//               EditProfileActionButtons(onSave: _saveChanges, onCancel: _cancel),
//               const SizedBox(height: 16),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






import 'package:graduation_project_flutter/features/edit_profile/presentation/state_management(bloc)/edit_profile_cubit.dart';
import 'package:graduation_project_flutter/features/edit_profile/presentation/state_management(bloc)/edit_profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  final File? currentImage;
  const EditProfileScreen({super.key, this.currentImage});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late File? _avatarImage;
  bool _isSaving = false;
  String? _networkImageUrl;
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  String _selectedGender = 'Male';
  DateTime _selectedDate = DateTime(2000, 1, 1);
  final _addressController = TextEditingController();
  final _bioController = TextEditingController();

  int _districtId = 0;
  int _cityId = 0;
  int _governorateId = 0;

  @override
  void initState() {
    super.initState();
    // Do not pre-fill from session cubit anymore, we wait for EditProfileLoaded
    _avatarImage = widget.currentImage;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _altPhoneController.dispose();
    _addressController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                Icons.photo_library,
                color: context.primaryColor,
              ),
              title: Text(
                "Choose from Gallery",
                style: TextStyle(fontFamily: AppFonts.font),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  setState(() => _avatarImage = File(image.path));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_camera, color: context.primaryColor),
              title: Text(
                "Take a Photo",
                style: TextStyle(fontFamily: AppFonts.font),
              ),
              onTap: () async {
                Navigator.pop(ctx);
                final XFile? image = await _picker.pickImage(
                  source: ImageSource.camera,
                );
                if (image != null) {
                  setState(() => _avatarImage = File(image.path));
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.red),
              title: Text(
                "Cancel",
                style: TextStyle(fontFamily: AppFonts.font, color: Colors.red),
              ),
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    final phoneRegex = RegExp(r'^[\+\d\s\-\(\)]{8,}$');
    if (!phoneRegex.hasMatch(value)) return 'Enter a valid phone number';
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Full name is required';
    return null;
  }


  void _saveChanges(BuildContext blocContext) {
    if (_formKey.currentState!.validate()) {
      blocContext.read<EditProfileCubit>().submitProfileChanges(
            name: _fullNameController.text.trim(),
            gender: _selectedGender,
            birthDate: _selectedDate.toIso8601String(),
            address: _addressController.text.trim(),
            districtId: _districtId,
            cityId: _cityId,
            governorateId: _governorateId,
            image: _avatarImage != widget.currentImage ? _avatarImage : null,
          );
    }
  }

  void _cancel() => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocProvider(
      create: (context) => sl<EditProfileCubit>()..loadProfile(),
      child: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileLoaded) {
            final profile = state.profile;
            // Use setState so the rebuilt widget picks up new values
            setState(() {
              _fullNameController.text = profile.name ?? '';
              _emailController.text = profile.email ?? '';
              _phoneController.text = profile.phoneNumber ?? '';
              _addressController.text = profile.address ?? '';
              if (profile.gender != null && profile.gender!.isNotEmpty) {
                _selectedGender = profile.gender!;
              }
              if (profile.birthDate != null && profile.birthDate!.isNotEmpty) {
                try {
                  _selectedDate = DateTime.parse(profile.birthDate!);
                } catch (_) {}
              }
              _districtId = profile.districtId ?? 0;
              _cityId = profile.cityId ?? 0;
              _governorateId = profile.governorateId ?? 0;
              
              if (profile.profilePhoto != null && profile.profilePhoto!.isNotEmpty) {
                _networkImageUrl = profile.profilePhoto;
                if (!_networkImageUrl!.startsWith('http')) {
                  _networkImageUrl = 'https://dardeal.runasp.net$_networkImageUrl';
                }
              }
            });
          } else if (state is EditProfileSuccess) {
            AppSnackBar.success(context, state.message);
            Navigator.pop(context, _avatarImage);
          } else if (state is EditProfileError) {
            AppSnackBar.error(context, state.message);
            if (state.isUnauthorized) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                Routes.authOptions,
                (route) => false,
              );
            }
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: context.scaffoldBgColor,
                appBar: AppBar(
                  surfaceTintColor: Colors.transparent,
                  scrolledUnderElevation: 0.0,
                  backgroundColor: context.scaffoldBgColor,
                  elevation: 0,
                  centerTitle: true,
                  leadingWidth: 56,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: context.titleColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: context.titleColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppFonts.font,
                    ),
                  ),
                ),
                body: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: context.primaryColor.withValues(alpha: 0.1),
                                ),
                                child: ClipOval(
                                  child: _avatarImage != null
                                      ? Image.file(
                                          _avatarImage!,
                                          fit: BoxFit.cover,
                                          width: 100,
                                          height: 100,
                                        )
                                      : (_networkImageUrl != null
                                          ? Image.network(
                                              _networkImageUrl!,
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
                                              headers: {
                                                'Authorization': 'Bearer ${sl<CacheHelper>().getToken()}'
                                              },
                                              errorBuilder: (_, __, ___) => Icon(
                                                Icons.person,
                                                size: 60,
                                                color: context.primaryColor,
                                              ),
                                            )
                                          : Icon(
                                              Icons.person,
                                              size: 60,
                                              color: context.primaryColor,
                                            )),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: context.primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: colors.surface, width: 2),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    onPressed: _pickImage,
                                    padding: const EdgeInsets.all(6),
                                    constraints: const BoxConstraints(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        Text(
                          "Personal Information",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.titleColor,
                          ),
                        ),
                        const SizedBox(height: 16),

                        EditProfileTextField(
                          label: "Full Name",
                          controller: _fullNameController,
                          hint: "Enter your full name",
                          prefixIcon: Icons.person_outline,
                          validator: _validateName,
                        ),
                        const SizedBox(height: 16),

                        EditProfileTextField(
                          label: "Email",
                          controller: _emailController,
                          hint: "your@email.com",
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: _validateEmail,
                        ),
                        const SizedBox(height: 16),

                        EditProfileTextField(
                          label: "Phone Number",
                          controller: _phoneController,
                          hint: "+1 (555) 000-0000",
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                          validator: _validatePhone,
                        ),
                        const SizedBox(height: 16),

                        EditProfileTextField(
                          label: "Alternative Phone",
                          controller: _altPhoneController,
                          hint: "+1 (555) 000-0000",
                          keyboardType: TextInputType.phone,
                          isOptional: true,
                          prefixIcon: Icons.phone_android_outlined,
                        ),
                        const SizedBox(height: 16),

                        EditProfileGenderDropdown(
                          selectedGender: _selectedGender,
                          onChanged: (value) => setState(() => _selectedGender = value),
                        ),
                        const SizedBox(height: 16),

                        EditProfileDatePicker(
                          label: "Date of Birth",
                          selectedDate: _selectedDate,
                          onDateChanged: (newDate) =>
                              setState(() => _selectedDate = newDate),
                        ),
                        const SizedBox(height: 24),

                        Text(
                          "Address Details",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.titleColor,
                          ),
                        ),
                        const SizedBox(height: 16),

                        EditProfileTextField(
                          label: "Full Address",
                          controller: _addressController,
                          hint: "Governorate / City - Neighborhood",
                          maxLines: 2,
                          prefixIcon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 24),

                        Text(
                          "About",
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.titleColor,
                          ),
                        ),
                        const SizedBox(height: 16),

                        EditProfileTextField(
                          label: "Bio",
                          controller: _bioController,
                          hint: "Tell us about yourself...",
                          maxLines: 4,
                          prefixIcon: Icons.description_outlined,
                        ),
                        const SizedBox(height: 32),

                        EditProfileActionButtons(
                          onSave: () => _saveChanges(context),
                          onCancel: _cancel,
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),

              if (state is EditProfileLoading)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
