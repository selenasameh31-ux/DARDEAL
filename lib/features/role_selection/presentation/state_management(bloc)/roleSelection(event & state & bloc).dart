import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:graduation_project_flutter/features/role_selection/domain/usecases/roleSelection_usecase.dart';

// ==================== EVENTS ====================
abstract class RoleSelectionEvent {}

class RoleSelectionRequested extends RoleSelectionEvent {
  final String role; // "Seeker" | "Owner" | "Seeker_Owner"

  RoleSelectionRequested({required this.role});
}

// ==================== STATES ====================
abstract class RoleSelectionState {}

class RoleSelectionInitial extends RoleSelectionState {}

class RoleSelectionLoading extends RoleSelectionState {}

class RoleSelectionSuccess extends RoleSelectionState {
  final AuthEntity auth;
  RoleSelectionSuccess(this.auth);
}

class RoleSelectionFailure extends RoleSelectionState {
  final String error;
  RoleSelectionFailure(this.error);
}

// ==================== BLOC ====================
class RoleSelectionBloc extends Bloc<RoleSelectionEvent, RoleSelectionState> {
  final SelectRoleUseCase selectRoleUseCase;

  RoleSelectionBloc(this.selectRoleUseCase) : super(RoleSelectionInitial()) {
    on<RoleSelectionRequested>(_onRoleSelectionRequested);
  }

  Future<void> _onRoleSelectionRequested(
    RoleSelectionRequested event,
    Emitter<RoleSelectionState> emit,
  ) async {
    emit(RoleSelectionLoading());
    try {
      final result = await selectRoleUseCase(role: event.role);
      emit(RoleSelectionSuccess(result));
    } catch (e) {
      emit(RoleSelectionFailure(e.toString()));
    }
  }
}
