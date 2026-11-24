import 'package:dartz/dartz.dart';
import 'package:graduation_project_flutter/core/errors/exceptions.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import '../../domain/entities/chat_entity.dart';
import '../../domain/entities/chat_message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Map<String, dynamic>>> getChats({int page = 1, int pageSize = 20}) async {
    try {
      final result = await remoteDataSource.getChats(page: page, pageSize: pageSize);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> getChatDetails(int chatId) async {
    try {
      final result = await remoteDataSource.getChatDetails(chatId);
      return Right<Failure, ChatEntity>(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getChatMessages(int chatId, {int page = 1, int pageSize = 50}) async {
    try {
      final result = await remoteDataSource.getChatMessages(chatId, page: page, pageSize: pageSize);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> sendMessage(int chatId, {String? text, String? messageType, String? attachmentsJson}) async {
    try {
      final result = await remoteDataSource.sendMessage(chatId, text: text, messageType: messageType, attachmentsJson: attachmentsJson);
      return Right<Failure, ChatMessageEntity>(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageEntity>> editMessage(int messageId, String text) async {
    try {
      final result = await remoteDataSource.editMessage(messageId, text);
      return Right<Failure, ChatMessageEntity>(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markChatAsRead(int chatId) async {
    try {
      await remoteDataSource.markChatAsRead(chatId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    try {
      final count = await remoteDataSource.getUnreadCount();
      return Right(count);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatEntity>> createOrGetChat(int propertyId, int ownerId) async {
    try {
      final result = await remoteDataSource.createOrGetChat(propertyId, ownerId);
      return Right<Failure, ChatEntity>(result);
    } on ServerException catch (_) {
      return Left(ServerFailure("Server error. Please try again later."));
    } on UnauthorizedException catch (e) {
      // Differentiate 401 and 403 based on message or exception type if possible. 
      // Assuming 403 might come as UnauthorizedException or ForbiddenException.
      if (e.message.toLowerCase().contains("forbidden") || e.message.toLowerCase().contains("403")) {
        return Left(UnauthorizedFailure("You are not allowed to start this chat."));
      }
      return Left(UnauthorizedFailure("Please log in again."));
    } on NotFoundException catch (_) {
      return Left(NotFoundFailure("Property not found."));
    } catch (e) {
      if (e.toString().contains("SocketException") || e.toString().contains("DioException") || e.toString().contains("connection")) {
         return Left(ServerFailure("Check your internet connection."));
      }
      return Left(ServerFailure("Server error. Please try again later."));
    }
  }

  @override
  Future<Either<Failure, dynamic>> uploadMedia(int chatId, String filePath) async {
    try {
      final result = await remoteDataSource.uploadMedia(chatId, filePath);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> blockUser(int userId) async {
    try {
      await remoteDataSource.blockUser(userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> unblockUser(int userId) async {
    try {
      await remoteDataSource.unblockUser(userId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> reportUser(int userId, String complaintType, String description) async {
    try {
      await remoteDataSource.reportUser(userId, complaintType, description);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMessage(int messageId) async {
    try {
      await remoteDataSource.deleteMessage(messageId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
