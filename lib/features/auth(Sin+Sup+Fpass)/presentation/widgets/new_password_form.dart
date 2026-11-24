import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class NewPasswordForm extends StatefulWidget {
  final String resetToken;

  const NewPasswordForm({super.key, required this.resetToken});

  @override
  State<NewPasswordForm> createState() => _NewPasswordFormState();
}

class _NewPasswordFormState extends State<NewPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _pass = TextEditingController();
  final _confirm = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ForgotPasswordBloc>().add(
      ResetPasswordRequested(
        resetToken: widget.resetToken,
        newPassword: _pass.text.trim(),
        confirmPassword: _confirm.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ResetPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password Updated Successfully")),
          );

          Navigator.popUntil(context, (route) => route.isFirst);
        }

        if (state is ForgotPasswordError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },

      builder: (context, state) {
        final loading = state is ForgotPasswordLoading;

        return Form(
          key: _formKey,
          child: Column(
            children: [
              /// New Password
              AppPasswordField(
                label: "New Password",
                controller: _pass,
                validator: AppValidators.validatePassword,
              ),

              const SizedBox(height: 20),

              /// Confirm Password
              AppPasswordField(
                label: "Confirm Password",
                controller: _confirm,
                validator: (value) =>
                    AppValidators.confirmPassword(value, _pass.text),
              ),

              const SizedBox(height: 30),

              /// Update Button
              AuthButton(
                text: "Update Password",
                loading: loading,
                onPressed: _submit,
              ),
            ],
          ),
        );
      },
    );
  }
}
