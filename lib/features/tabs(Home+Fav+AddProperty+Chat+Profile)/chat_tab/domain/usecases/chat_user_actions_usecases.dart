import 'package:dartz/dartz.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import '../repositories/chat_repository.dart';

class BlockUserUseCase {
  final ChatRepository repository;
  BlockUserUseCase(this.repository);
  Future<Either<Failure, void>> call(int userId) async {
    return await repository.blockUser(userId);
  }
}

class UnblockUserUseCase {
  final ChatRepository repository;
  UnblockUserUseCase(this.repository);
  Future<Either<Failure, void>> call(int userId) async {
    return await repository.unblockUser(userId);
  }
}

class ReportUserUseCase {
  final ChatRepository repository;
  ReportUserUseCase(this.repository);
  Future<Either<Failure, void>> call(int userId, String complaintType, String description) async {
    return await repository.reportUser(userId, complaintType, description);
  }
}
