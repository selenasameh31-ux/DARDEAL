import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class EditProfileActionButtons extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EditProfileActionButtons({
    super.key,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppPrimaryButton(
            onPressed: onCancel,
            text: "Cancel",
            isPrimary: false,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AppPrimaryButton(
            onPressed: onSave,
            text: "Save Changes",
            isPrimary: true,
          ),
        ),
      ],
    );
  }
}
