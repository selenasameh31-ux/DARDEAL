import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/verification_repository.dart';
import 'verification_state.dart';

class VerificationCubit extends Cubit<VerificationState> {
  final VerificationRepository repository;

  // Track the status seen during the last POLL tick only.
  String? _lastPolledStatus;

  // Throttle: prevent API calls more frequently than every 8 seconds.
  // This avoids duplicate calls from initState + didChangeAppLifecycleState.
  DateTime? _lastFetchTime;
  static const _throttleDuration = Duration(seconds: 8);

  bool get _isThrottled {
    if (_lastFetchTime == null) return false;
    return DateTime.now().difference(_lastFetchTime!) < _throttleDuration;
  }

  VerificationCubit({required this.repository}) : super(const VerificationInitial());

  // ─────────────────────────────────────────────────────────────────────────
  // Reset – called by the screen in initState() to guarantee a clean slate
  // even if the same Cubit instance is somehow reused.
  // ─────────────────────────────────────────────────────────────────────────
  void reset() {
    _lastPolledStatus = null;
    _lastFetchTime = null;
    emit(const VerificationInitial());
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Create a new Didit session.
  // Only call from UI when documents.isEmpty OR status = rejected.
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> createSession() async {
    emit(const VerificationLoading());

    final result = await repository.createVerificationSession();

    result.fold(
      (failure) => emit(VerificationError(failure.message)),
      (session) => emit(VerificationSessionCreated(session)),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Initial load – always shows the spinner and always emits the fresh result.
  // Called ONCE in initState() after reset().
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> loadStatus() async {
    emit(const VerificationLoading());
    _lastPolledStatus = null;
    _lastFetchTime = DateTime.now(); // mark fetch time

    final result = await repository.getVerificationStatus();

    result.fold(
      (failure) => emit(VerificationError(failure.message)),
      (documents) {
        final loaded = VerificationStatusLoaded(List.from(documents));
        _lastPolledStatus = loaded.latestDoc?.status.trim().toLowerCase();
        emit(loaded);
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Silent polling – NEVER emits Loading.
  // Emits VerificationStatusLoaded ONLY when the status actually changed.
  // Called by the Timer every 10 s and on app-resume.
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> pollStatus() async {
    // Throttle: skip if a fetch happened less than 8 seconds ago.
    if (_isThrottled) return;
    _lastFetchTime = DateTime.now();

    final result = await repository.getVerificationStatus();

    result.fold(
      (failure) {
        // Silently swallow polling errors – do NOT disrupt the current UI.
      },
      (documents) {
        final loaded = VerificationStatusLoaded(List.from(documents));
        final newStatus = loaded.latestDoc?.status.trim().toLowerCase();

        // Skip rebuild ONLY if we are already showing VerificationStatusLoaded
        // AND the status string hasn't changed.
        // If we are showing VerificationSessionCreated, we MUST emit so the UI updates.
        if (state is VerificationStatusLoaded && newStatus == _lastPolledStatus) {
          return;
        }

        _lastPolledStatus = newStatus;
        emit(loaded);
      },
    );
  }
}
