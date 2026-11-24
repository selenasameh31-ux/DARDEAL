import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class ChatbotInputArea extends StatefulWidget {
  final ValueChanged<String> onSend;

  const ChatbotInputArea({super.key, required this.onSend});

  @override
  State<ChatbotInputArea> createState() => _ChatbotInputAreaState();
}

class _ChatbotInputAreaState extends State<ChatbotInputArea> {
  final TextEditingController _controller = TextEditingController();
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  bool _speechEnabled = false;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onError: (error) => debugPrint('Speech error: $error'),
        onStatus: (status) {
          if (status == 'notListening' && mounted) {
            setState(() => _isListening = false);
          }
        },
      );
    } catch (e) {
      debugPrint('Speech initialization failed: $e');
      _speechEnabled = false;
    }
    if (mounted) setState(() {});
  }

  Future<bool> _ensureMicPermission() async {
    var status = await Permission.microphone.status;

    if (status.isGranted) return true;

    if (status.isDenied) {
      status = await Permission.microphone.request();
      return status.isGranted;
    }

    if (status.isPermanentlyDenied) {
      if (mounted) {
        AppSnackBar.error(
          context,
          'Microphone permission is blocked. Please enable it from app settings.',
        );
      }
      return false;
    }

    return false;
  }

  Future<void> _handleMicPress() async {
    if (_isListening) {
      await _stopListening();
      return;
    }

    final hasPermission = await _ensureMicPermission();
    if (!hasPermission) {
      if (mounted) {
        AppSnackBar.error(
          context,
          'Microphone permission is required for voice input.',
        );
      }
      return;
    }

    if (!_speechEnabled) {
      await _initSpeech();
    }

    if (!_speechEnabled) {
      if (mounted) {
        AppSnackBar.error(
          context,
          'Speech recognition is not available on this device.',
        );
      }
      return;
    }

    await _startListening();
  }

  Future<void> _startListening() async {
    try {
      await _speechToText.listen(
        onResult: (result) {
          if (!mounted) return;
          setState(() {
            _controller.text = result.recognizedWords;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          });
        },
      );
      if (mounted) setState(() => _isListening = true);
    } catch (e) {
      debugPrint('Speech listening failed: $e');
      if (mounted) {
        AppSnackBar.error(
          context,
          'Failed to start speech recognition.',
        );
      }
    }
  }

  Future<void> _stopListening() async {
    try {
      await _speechToText.stop();
    } catch (e) {
      debugPrint('Speech stop failed: $e');
    }
    if (mounted) setState(() => _isListening = false);
  }

  void _handleSend() {
    if (_isListening) {
      _stopListening();
    }
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _speechToText.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isListening
                      ? const Color(0xFFF17C21)
                      : Colors.grey.withValues(alpha: 0.3),
                  width: _isListening ? 2.0 : 1.0,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: _isListening
                    ? [
                        BoxShadow(
                          color: const Color(0xFFF17C21).withValues(alpha: 0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<TextEditingValue>(
                      valueListenable: _controller,
                      builder: (context, value, _) {
                        // Auto-detect direction based on first character
                        final text = value.text;
                        TextDirection direction = TextDirection.rtl; // Default to RTL for Arabic
                        if (text.isNotEmpty) {
                          final firstChar = text.trimLeft();
                          if (firstChar.isNotEmpty) {
                            final codeUnit = firstChar.codeUnitAt(0);
                            // If it's a Latin character, switch to LTR
                            if ((codeUnit >= 0x0041 && codeUnit <= 0x005A) || // A-Z
                                (codeUnit >= 0x0061 && codeUnit <= 0x007A)) { // a-z
                              direction = TextDirection.ltr;
                            }
                          }
                        }
                        return TextField(
                          controller: _controller,
                          textDirection: direction,
                          cursorColor: const Color(0xff235265),
                          style: const TextStyle(
                            fontFamily: AppFonts.font,
                            fontSize: 14,
                          ),
                          decoration: InputDecoration(
                            hintText: _isListening
                                ? 'جاري الاستماع...'
                                : 'اكتب رسالتك...',
                            hintStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontFamily: AppFonts.font,
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                          ),
                          onSubmitted: (_) => _handleSend(),
                        );
                      },
                    ),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 1.0, end: _isListening ? 1.2 : 1.0),
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: IconButton(
                          icon: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            color: _isListening
                                ? const Color(0xFFF17C21)
                                : Colors.grey,
                          ),
                          onPressed: _handleMicPress,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _handleSend,
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Color(0xFFF17C21),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
