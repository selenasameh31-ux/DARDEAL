import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:google_sign_in/google_sign_in.dart' as google_auth;

// ================= EVENTS =================
abstract class GoogleAuthEvent {}

class SignInWithGoogleEvent extends GoogleAuthEvent {}

class LinkGoogleEvent extends GoogleAuthEvent {}

class UnlinkGoogleEvent extends GoogleAuthEvent {}

// ================= STATES =================
abstract class GoogleAuthState {}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthLoading extends GoogleAuthState {}

class GoogleAuthSuccess extends GoogleAuthState {
  final AuthEntity? user; // Nullable for unlink/link
  GoogleAuthSuccess({this.user});
}

class GoogleAuthFailure extends GoogleAuthState {
  final String error;
  GoogleAuthFailure(this.error);
}

// ================= BLOC =================
class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  final GoogleSignInUseCase googleSignInUseCase;
  final AuthRepository repository; // Used for link/unlink directly if needed
  final google_auth.GoogleSignIn _googleSignIn = google_auth.GoogleSignIn.instance;

  GoogleAuthBloc({required this.googleSignInUseCase, required this.repository})
      : super(GoogleAuthInitial()) {
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<LinkGoogleEvent>(_onLinkGoogle);
    on<UnlinkGoogleEvent>(_onUnlinkGoogle);
  }

  bool _isInitialized = false;

  Future<void> _initGoogleSignIn() async {
    if (!_isInitialized) {
      await _googleSignIn.initialize(
        // TODO: ضع هنا الـ Web Client ID الخاص بك من Google Cloud Console
        // لازم يكون الـ Web Client ID مش الـ Android Client ID عشان يرجعلك idToken
        serverClientId: 'YOUR_WEB_CLIENT_ID_HERE.apps.googleusercontent.com', 
      );
      _isInitialized = true;
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<GoogleAuthState> emit,
  ) async {
    emit(GoogleAuthLoading());
    try {
      await _initGoogleSignIn();
      // 1. Authenticate with Google
      final google_auth.GoogleSignInAccount? googleUser =
          await _googleSignIn.authenticate();
      if (googleUser == null) {
        // User canceled the sign-in
        emit(GoogleAuthFailure("Google Sign In was canceled."));
        return;
      }

      // 2. Obtain auth details
      final google_auth.GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        emit(GoogleAuthFailure("Failed to get Google ID token."));
        return;
      }

      // 3. Send token to backend
      final user = await googleSignInUseCase(idToken);

      // Save token locally if required
      // You can add your own cache logic here using sl<CacheHelper>() if needed

      emit(GoogleAuthSuccess(user: user));
    } catch (e) {
      emit(GoogleAuthFailure(e.toString()));
    }
  }

  Future<void> _onLinkGoogle(
    LinkGoogleEvent event,
    Emitter<GoogleAuthState> emit,
  ) async {
    emit(GoogleAuthLoading());
    try {
      await _initGoogleSignIn();
      final google_auth.GoogleSignInAccount? googleUser =
          await _googleSignIn.authenticate();
      if (googleUser == null) {
        emit(GoogleAuthFailure("Google Sign In was canceled."));
        return;
      }

      final google_auth.GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        emit(GoogleAuthFailure("Failed to get Google ID token."));
        return;
      }

      await repository.linkGoogle(idToken: idToken);
      emit(GoogleAuthSuccess());
    } catch (e) {
      emit(GoogleAuthFailure(e.toString()));
    }
  }

  Future<void> _onUnlinkGoogle(
    UnlinkGoogleEvent event,
    Emitter<GoogleAuthState> emit,
  ) async {
    emit(GoogleAuthLoading());
    try {
      await repository.unlinkGoogle();
      // Optionally sign out locally from google:
      await _googleSignIn.signOut();
      emit(GoogleAuthSuccess());
    } catch (e) {
      emit(GoogleAuthFailure(e.toString()));
    }
  }
}
