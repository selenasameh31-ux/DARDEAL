import 'package:dartz/dartz.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import '../repositories/chat_repository.dart';

class UploadMediaUseCase {
  final ChatRepository repository;

  UploadMediaUseCase(this.repository);

  Future<Either<Failure, dynamic>> call(int chatId, String filePath) async {
    return await repository.uploadMedia(chatId, filePath);
  }
}
