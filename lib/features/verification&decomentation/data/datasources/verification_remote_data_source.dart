import 'package:graduation_project_flutter/core/database/api/api_consumer.dart';
import 'package:graduation_project_flutter/core/database/api/end_points.dart';
import 'package:graduation_project_flutter/core/utils/api_response_helper.dart';
import '../models/verification_document_model.dart';
import '../models/didit_session_model.dart';

abstract class VerificationRemoteDataSource {
  Future<DiditSessionModel> createVerificationSession();

  Future<List<VerificationDocumentModel>> getVerificationStatus();
}

class VerificationRemoteDataSourceImpl implements VerificationRemoteDataSource {
  final ApiConsumer api;

  VerificationRemoteDataSourceImpl({required this.api});

  @override
  Future<DiditSessionModel> createVerificationSession() async {
    final response = await api.post(EndPoints.verificationDocuments);
    final data = ApiDataExtractor.extract(response.data);
    
    if (data is Map<String, dynamic>) {
      return DiditSessionModel.fromJson(data);
    }
    
    throw Exception('Failed to create verification session: Invalid data format');
  }

  @override
  Future<List<VerificationDocumentModel>> getVerificationStatus() async {
    final response = await api.get(EndPoints.verificationDocuments);
    final data = ApiDataExtractor.extract(response.data);
    
    if (data is List) {
      return data.map((e) => VerificationDocumentModel.fromJson(e)).toList();
    }
    
    return [];
  }
}
