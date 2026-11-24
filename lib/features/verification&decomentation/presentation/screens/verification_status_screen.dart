import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:url_launcher/url_launcher.dart';
import '../state_management(bloc)/verification_cubit.dart';
import '../state_management(bloc)/verification_state.dart';

class VerificationStatusScreen extends StatefulWidget {
  const VerificationStatusScreen({super.key});

  @override
  State<VerificationStatusScreen> createState() =>
      _VerificationStatusScreenState();
}

class _VerificationStatusScreenState extends State<VerificationStatusScreen>
    with WidgetsBindingObserver {
  // ─────────────────────────────────────────────────────────────────────────
  // State fields
  // ─────────────────────────────────────────────────────────────────────────

  late final VerificationCubit _cubit;
  Timer? _pollingTimer;

  // ─────────────────────────────────────────────────────────────────────────
  // Lifecycle
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _cubit = sl<VerificationCubit>();
    WidgetsBinding.instance.addObserver(this);
    // Reset guarantees VerificationInitial state even if the factory somehow
    // returned a warm instance, and clears the poll-status cache.
    _cubit.reset();
    // Initial load: always fetches fresh data from the API.
    _cubit.loadStatus();
  }

  @override
  void dispose() {
    _stopPolling(); // always stop on page exit
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      // User returned from browser / another app → poll immediately.
      _cubit.pollStatus();
      // _startPolling() is a no-op if the timer is already running.
      _startPolling();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Polling helpers
  // ─────────────────────────────────────────────────────────────────────────

  void _startPolling() {
    // Guard: never run two timers at once.
    if (_pollingTimer != null && _pollingTimer!.isActive) return;
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) _cubit.pollStatus();
    });
  }

  void _stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // URL launcher
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open verification link')),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: context.scaffoldBgColor,
        appBar: AppBar(
          backgroundColor: context.scaffoldBgColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: context.hintColor, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocConsumer<VerificationCubit, VerificationState>(
          listener: _handleStateChange,
          builder: _buildBody,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BlocConsumer callbacks
  // ─────────────────────────────────────────────────────────────────────────

  void _handleStateChange(BuildContext ctx, VerificationState state) {
    if (state is VerificationSessionCreated) {
      // Auto-open URL exactly ONCE when the session is first created.
      _openUrl(state.session.verificationUrl);
      
      // Start polling immediately so the status updates in the background.
      _startPolling();
    } else if (state is VerificationStatusLoaded) {
      final doc = state.latestDoc;
      final status = doc?.status.trim().toLowerCase() ?? '';

      if (_isPending(status)) {
        _startPolling();
      } else {
        // Terminal state (approved / rejected) – stop polling.
        _stopPolling();
      }
    } else if (state is VerificationError) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }


  Widget _buildBody(BuildContext ctx, VerificationState state) {
    // ── First load only shows a spinner ──────────────────────────────────
    if (state is VerificationLoading || state is VerificationInitial) {
      return const Center(child: CircularProgressIndicator());
    }

    // ── Session just created → transition to pending immediately ──────────
    if (state is VerificationSessionCreated) {
      return _buildPending(ctx);
    }

    // ── Status loaded ─────────────────────────────────────────────────────
    if (state is VerificationStatusLoaded) {
      final documents = state.documents;

      if (documents.isEmpty) {
        return _buildNoSession(ctx);
      }

      // Use the session with the most recent submittedAt.
      final doc = state.latestDoc;
      if (doc == null) return _buildNoSession(ctx);

      final status = doc.status.trim().toLowerCase();

      if (_isPending(status)) {
        return _buildPending(ctx);
      }

      switch (status) {
        case 'approved':
        case 'verified':
        case 'success':
          return _buildSuccess(ctx);

        case 'rejected':
        case 'failed':
          return _buildRejected(
            ctx,
            reason: doc.rejectionReason,
          );

        default:
          return _buildUnknown(ctx, status);
      }
    }

    return const SizedBox.shrink();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Helpers
  // ─────────────────────────────────────────────────────────────────────────

  bool _isPending(String status) =>
      status == 'pending' || status == 'created' || status == 'started';

  // ─────────────────────────────────────────────────────────────────────────
  // Screen variants
  // ─────────────────────────────────────────────────────────────────────────

  /// No session found – user can start one.
  Widget _buildNoSession(BuildContext context) {
    return _centered(
      context,
      children: [
        Icon(Icons.verified_user_outlined, size: 80, color: context.primaryColor),
        const SizedBox(height: 24),
        _title(context, 'Identity Verification'),
        const SizedBox(height: 16),
        _subtitle(
          context,
          'Verify your identity to access all features. Tap below to begin the process with Didit.',
        ),
        const SizedBox(height: 32),
        _primaryButton(
          context,
          label: 'Start Verification',
          onPressed: () => _cubit.createSession(),
        ),
      ],
    );
  }

  // Removed _buildOpenVerification as it's no longer needed

  /// Status is pending / created / started – polling is active.
  Widget _buildPending(BuildContext context) {
    return _centered(
      context,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.orange.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.hourglass_empty, size: 80, color: Colors.orange),
        ),
        const SizedBox(height: 32),
        _title(context, 'Verification in Progress'),
        const SizedBox(height: 16),
        _subtitle(
          context,
          'We are reviewing your documents. Status updates automatically.',
        ),
        const SizedBox(height: 20),
        _pollingIndicator(context),
      ],
    );
  }

  /// Status is approved.
  Widget _buildSuccess(BuildContext context) {
    return _centered(
      context,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
        ),
        const SizedBox(height: 32),
        _title(context, 'Verification Successful'),
        const SizedBox(height: 16),
        _subtitle(context, 'Your identity has been successfully verified.'),
      ],
    );
  }

  /// Status is rejected.
  Widget _buildRejected(BuildContext context, {String? reason}) {
    return _centered(
      context,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.error_outline, size: 80, color: Colors.red),
        ),
        const SizedBox(height: 32),
        _title(context, 'Verification Rejected'),
        const SizedBox(height: 16),
        _subtitle(
          context,
          reason ?? 'Your verification was rejected. Please try again.',
        ),
        const SizedBox(height: 32),
        _primaryButton(
          context,
          label: 'Try Again',
          onPressed: () {
            _cubit.createSession();
          },
        ),
      ],
    );
  }

  /// Unknown / unexpected status.
  Widget _buildUnknown(BuildContext context, String status) {
    return _centered(
      context,
      children: [
        Icon(Icons.info_outline, size: 80, color: context.primaryColor),
        const SizedBox(height: 32),
        _title(context, 'Status: $status'),
        const SizedBox(height: 16),
        _subtitle(context, 'Please wait for further updates.'),
        const SizedBox(height: 20),
        _pollingIndicator(context),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Reusable micro-widgets
  // ─────────────────────────────────────────────────────────────────────────

  Widget _centered(BuildContext context, {required List<Widget> children}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              kToolbarHeight -
              MediaQuery.of(context).padding.top,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }

  Widget _title(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.titleColor,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _subtitle(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: context.hintColor, height: 1.6, fontSize: 15),
    );
  }

  Widget _primaryButton(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
    Color? color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? context.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _pollingIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: context.hintColor,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Checking status automatically…',
          style: TextStyle(color: context.hintColor, fontSize: 13),
        ),
      ],
    );
  }
}
