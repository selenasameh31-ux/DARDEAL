import 'package:dartz/dartz.dart';
import 'package:graduation_project_flutter/core/errors/exceptions.dart';
import 'package:graduation_project_flutter/core/errors/failure.dart';
import '../../domain/entities/verification_document_entity.dart';
import '../../domain/entities/didit_session_entity.dart';
import '../../domain/repositories/verification_repository.dart';
import '../datasources/verification_remote_data_source.dart';

class VerificationRepositoryImpl implements VerificationRepository {
  final VerificationRemoteDataSource remoteDataSource;

  VerificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DiditSessionEntity>> createVerificationSession() async {
    try {
      final response = await remoteDataSource.createVerificationSession();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ConflictException catch (e) {
      return Left(ConflictFailure(e.message));
    } on TooManyRequestsException catch (e) {
      return Left(TooManyRequestsFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<VerificationDocumentEntity>>> getVerificationStatus() async {
    try {
      final response = await remoteDataSource.getVerificationStatus();
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ConflictException catch (e) {
      return Left(ConflictFailure(e.message));
    } on TooManyRequestsException catch (e) {
      return Left(TooManyRequestsFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
