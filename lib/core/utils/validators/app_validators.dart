class AppValidators {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Full name is required";
    }

    // name validation
    final nameRegex = RegExp(r'^[a-zA-Z ]+$');

    if (!nameRegex.hasMatch(value.trim())) {
      return "Name must contain only letters";
    }

    if (value.trim().length < 3) {
      return "Name must be at least 3 characters";
    }

    return null;
  }

  // Email validation (liwercase only)

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }

    // Check lowercase
    if (value.contains(RegExp(r'[A-Z]'))) {
      return "Email must be lowercase only";
    }

    // Simple email pattern
    final emailRegex = RegExp(r'^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return "Enter a valid email address";
    }

    return null;
  }

  // Phone validation
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Phone number is required";
    }

    // لازم يبدأ بـ 010 أو 011 أو 012 أو 015 ,يبقى متكون من 11 رقم
    final phoneRegex = RegExp(r'^(010|011|012|015)[0-9]{8}$');

    if (!phoneRegex.hasMatch(value.trim())) {
      return "Enter a valid Egyptian phone number";
    }

    return null;
  }

  // Email OR Phone  Validation (Used in Forgot Password)

  static String? validateEmailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is required";
    }

    if (value.contains("@")) {
      return validateEmail(value);
    } else {
      return validatePhone(value);
    }
  }

  // Strong Password

  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Password is required";
    }

    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password must contain at least one uppercase letter";
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password must contain at least one lowercase letter";
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password must contain at least one number";
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Password must contain at least one special character";
    }

    return null;
  }

  // Confirm Password

  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.trim().isEmpty) {
      return "Confirm your password";
    }

    if (value != originalPassword) {
      return "Passwords do not match";
    }

    return null;
  }

  // Generic Required Field

  static String? requiredField(String? value, {String fieldName = "Field"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  // Text Validation (For descriptions, addresses, etc.)
  static String? validateText(
    String? value, {
    bool isRequired = true,
    int minLength = 5,
    String fieldName = "Field",
  }) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? "$fieldName is required" : null;
    }
    if (value.trim().length < minLength) {
      return "$fieldName must be at least $minLength characters";
    }
    return null;
  }

  // Numeric Validation (Used for Prices, Areas, etc.)
  static String? validateNumeric(
    String? value, {
    bool isRequired = true,
    int minLength = 1,
  }) {
    if (value == null || value.trim().isEmpty) {
      return isRequired ? "Required" : null;
    }
    final cleanVal = value.replaceAll(',', '').trim();
    if (cleanVal.startsWith('0') &&
        cleanVal.length > 1 &&
        !cleanVal.startsWith('0.')) {
      return "No leading zeros allowed";
    }

    if (cleanVal.replaceAll('.', '').length < minLength) {
      return "Must be at least $minLength digits";
    }

    final parsed = double.tryParse(cleanVal);
    if (parsed == null) return "Numbers only";
    if (parsed <= 0) return "Must be greater than 0";

    return null;
  }
}
