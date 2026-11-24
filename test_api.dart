import 'package:dio/dio.dart';

void main() async {
  final dio = Dio();
  final token = ''; // User's token is needed but wait, without a token we get 401. A 400 means syntax error!
  
  try {
    final response = await dio.get(
      "https://dardeal.runasp.net/api/v1/Offers/my?page=1&pageSize=20",
    );
    print(response.data);
  } catch (e) {
    if (e is DioException) {
      print("Status: ${e.response?.statusCode}");
      print("Data: ${e.response?.data}");
    } else {
      print(e);
    }
  }
}
