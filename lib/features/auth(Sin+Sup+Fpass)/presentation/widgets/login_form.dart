import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class LoginForm extends StatefulWidget {
  final bool loading;

  const LoginForm({super.key, required this.loading});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    context.read<LoginBloc>().add(
      LoginRequested(
        email: _emailPhoneController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AppTextField(
            label: "Email Address / Phone Number",
            controller: _emailPhoneController,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Email or phone number is required";
              }
              if (!value.contains("@") && value.length < 10) {
                return "Enter a valid email or phone number";
              }
              return null;
            },
          ),

          AppPasswordField(
            label: "Password",
            controller: _passwordController,
            validator: AppValidators.validatePassword,
          ),

          Align(
            alignment: Alignment.centerRight,
            child: AuthLinkText(
              text: "Forgot Password?",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ForgotPasswordScreen(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          AuthButton(
            text: "Sign In",
            loading: widget.loading,
            onPressed: _handleLogin,
          ),
        ],
      ),
    );
  }
}
