import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ForgotPasswordForm extends StatefulWidget {
  final bool loading;

  const ForgotPasswordForm({super.key, required this.loading});

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = TextEditingController();

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ForgotPasswordBloc>().add(
      ForgotPasswordRequested(_controller.text.trim()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /// Email / Phone Field
          AppTextField(
            label: "Email Address / Phone Number",
            controller: _controller,
            validator: AppValidators.validateEmailOrPhone,
          ),

          const SizedBox(height: 20),

          AuthButton(text: "Send", loading: widget.loading, onPressed: _submit),
        ],
      ),
    );
  }
}
