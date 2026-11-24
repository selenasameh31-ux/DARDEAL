class ApiDataExtractor {
  /// Safely extracts the data payload from a standard API response.
  /// Expects the response to be typically wrapped in `{ success: bool, data: dynamic, message: String? }`.
  /// If the API does not wrap the response, it will return the response as is.
  static dynamic extract(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      // Check if it's a standard success wrapper
      if (responseData.containsKey('success')) {
        if (responseData['success'] == true || responseData['success'] == 'true') {
          return responseData['data'];
        } else {
          throw Exception(responseData['message'] ?? 'API request failed');
        }
      } 
      // If it has 'data' but no 'success' flag, assume 'data' is the payload
      else if (responseData.containsKey('data')) {
        return responseData['data'];
      }
    }
    
    // If it's a list or a map without a wrapper, return it directly
    return responseData;
  }
}
