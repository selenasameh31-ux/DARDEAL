class ErrorModel {
  final String message;
  final List<dynamic>? errors;
  final int? statusCode;

  ErrorModel({required this.message, this.errors, this.statusCode});

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      message: json['message'] ?? 'Unexpected error occurred',
      errors: json['errors'],
      statusCode: json['statusCode'],
    );
  }
}
