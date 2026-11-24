import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  void _simulateScan(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.qr_code_scanner, size: 80),
              const SizedBox(height: 16),
              const Text(
                "Scan QR Code",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "Point your camera at a QR code to pay or transfer",
                textAlign: TextAlign.center,
                style: TextStyle(color: context.hintColor),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('QR scanned (demo) - payment initiated'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.attentionColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text("Simulate Scan"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: context.scaffoldBgColor,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: colors.surface,
        elevation: 0,
        centerTitle: true,
        leadingWidth: 56,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20,
            color: context.titleColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Scan",
          style: theme.textTheme.titleLarge?.copyWith(
            color: context.titleColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        actions: const [],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner, size: 120, color: context.primaryColor),
            const SizedBox(height: 24),
            Text(
              "Ready to scan",
              style: theme.textTheme.titleLarge?.copyWith(
                color: context.titleColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Tap the button below to open scanner",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: context.hintColor,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _simulateScan(context),
              icon: Icon(Icons.qr_code_scanner),
              label: const Text("Start Scanning"),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.attentionColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
