// register_form.dart
import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class RegisterForm extends StatefulWidget {
  final bool loading;

  const RegisterForm({super.key, required this.loading});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String? _selectedGender;

  void _handleRegister() {
    if (!_formKey.currentState!.validate()) return;

    final genderInt = _selectedGender == "Male" ? 0 : 1;

    print("name: ${_fullNameController.text.trim()}");
    print("email: ${_emailController.text.trim()}");
    print("phone: ${_phoneController.text.trim()}");
    print("password: ${_passwordController.text.trim()}");
    print("gender: $genderInt");

    context.read<RegisterBloc>().add(
      RegisterRequested(
        name: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
        gender: genderInt,
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
            label: "Full Name",
            controller: _fullNameController,
            validator: AppValidators.validateName,
          ),
          AppTextField(
            label: "Email Address",
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: AppValidators.validateEmail,
          ),
          AppTextField(
            label: "Phone Number",
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            validator: AppValidators.validatePhone,
          ),
          AppPasswordField(
            label: "Password",
            controller: _passwordController,
            validator: AppValidators.validatePassword,
          ),
          AppPasswordField(
            label: "Confirm Password",
            controller: _confirmPasswordController,
            validator: (value) =>
                AppValidators.confirmPassword(value, _passwordController.text),
          ),
          AppDropdownField(
            label: "Gender",
            value: _selectedGender,
            items: const ["Male", "Female"],
            onChanged: (value) => setState(() => _selectedGender = value),
            validator: (value) =>
                value == null ? "Please select your gender" : null,
          ),
          const SizedBox(height: 20),
          AuthButton(
            text: "Create Account",
            loading: widget.loading,
            onPressed: _handleRegister,
          ),
        ],
      ),
    );
  }
}
