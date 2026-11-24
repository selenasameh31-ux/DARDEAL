import 'package:graduation_project_flutter/core/routing/routes_export.dart'
    hide ChatMessageEntity;

import '../../domain/entities/chat_message_entity.dart';

class ChatMessageBubble extends StatefulWidget {
  final ChatMessageEntity message;
  final String senderName;
  final bool isMe;
  final Function(ChatMessageEntity)? onEdit;
  final Function(ChatMessageEntity)? onDelete;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.senderName = 'Ahmed Mohamed',
    this.isMe = false,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble>
    with SingleTickerProviderStateMixin {
  Offset _tapPosition = Offset.zero;
  double _swipeOffset = 0.0;
  bool _isReplyTriggered = false;

  void _storePosition(TapDownDetails details) {
    _tapPosition = details.globalPosition;
  }

  bool _isMenuShowing = false;

  void _showOptions(BuildContext context) async {
    if (_isMenuShowing) return;
    _isMenuShowing = true;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = context.primaryColor;
    final txtColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final chatBloc = context.read<ChatBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) {
        _isMenuShowing = false;
        return;
      }

      final overlay =
          Overlay.of(context).context.findRenderObject() as RenderBox;
      final button = context.findRenderObject() as RenderBox;
      final value = await showMenu<String>(
        context: context,
        position: RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(Offset.zero, ancestor: overlay),
            button.localToGlobal(
              button.size.bottomRight(Offset.zero),
              ancestor: overlay,
            ),
          ),
          Offset.zero & overlay.size,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: isDark ? DarkColors.darkTextFieldColor : Colors.white,
        elevation: 4,
        items: [
          if (widget.message.messageText.isNotEmpty)
            PopupMenuItem(
              value: 'copy',
              child: Row(
                children: [
                  Icon(
                    Icons.copy_rounded,
                    color: txtColor.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Copy',
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: txtColor,
                    ),
                  ),
                ],
              ),
            ),
          if (widget.isMe && widget.message.messageType == 'text')
            PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(
                    Icons.edit_rounded,
                    color: txtColor.withValues(alpha: 0.6),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Edit',
                    style: TextStyle(
                      fontFamily: AppFonts.font,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: txtColor,
                    ),
                  ),
                ],
              ),
            ),
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                const Icon(
                  Icons.delete_outline_rounded,
                  color: Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Delete',
                  style: TextStyle(
                    fontFamily: AppFonts.font,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      );

      _isMenuShowing = false;

      if (value == 'copy') {
        await Clipboard.setData(
          ClipboardData(text: widget.message.messageText),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Message copied',
                style: TextStyle(fontFamily: AppFonts.font),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } else if (value == 'edit') {
        widget.onEdit?.call(widget.message);
      } else if (value == 'delete') {
        widget.onDelete?.call(widget.message);
      }
    });
  }

  TextAlign _getTextAlign(String text) {
    if (text.isEmpty) return TextAlign.start;
    final firstChar = text.trim().characters.first;
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(firstChar);
    return isArabic ? TextAlign.right : TextAlign.left;
  }

  TextDirection _getTextDirection(String text) {
    if (text.isEmpty) return TextDirection.ltr;
    final firstChar = text.trim().characters.first;
    final isArabic = RegExp(r'[\u0600-\u06FF]').hasMatch(firstChar);
    return isArabic ? TextDirection.rtl : TextDirection.ltr;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = context.primaryColor;
    final otherBgColor = isDark
        ? DarkColors.darkTextFieldColor
        : const Color(0xFFD4EAEF);
    final otherTxtColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final timeColor = isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;

    return GestureDetector(
      onTapDown: _storePosition,
      onLongPress: () => _showOptions(context),
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0 || _swipeOffset > 0) {
          setState(() {
            _swipeOffset += details.delta.dx * 0.5;
            if (_swipeOffset > 80) _swipeOffset = 80;
            if (_swipeOffset < 0) _swipeOffset = 0;

            if (_swipeOffset >= 60 && !_isReplyTriggered) {
              _isReplyTriggered = true;
              HapticFeedback.lightImpact();
            }
          });
        }
      },
      onHorizontalDragEnd: (details) {
        setState(() {
          _swipeOffset = 0;
          _isReplyTriggered = false;
        });
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (_swipeOffset > 10)
            Positioned(
              left: -30 + (_swipeOffset * 0.4),
              top: 0,
              bottom: 24,
              child: Center(
                child: AnimatedScale(
                  scale: _swipeOffset >= 60 ? 1.2 : 0.8,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.reply_rounded,
                    color: _swipeOffset >= 60 ? primary : Colors.grey,
                    size: 24,
                  ),
                ),
              ),
            ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            transform: Matrix4.translationValues(_swipeOffset, 0, 0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Row(
                mainAxisAlignment: widget.isMe
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!widget.isMe) ...[
                    ChatAvatar(name: widget.senderName, radius: 16),
                    const SizedBox(width: 8),
                  ],
                  Flexible(
                    child: Column(
                      crossAxisAlignment: widget.isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: widget.isMe ? null : otherBgColor,
                            gradient: widget.isMe
                                ? LinearGradient(
                                    colors: [
                                      primary,
                                      primary.withOpacity(0.85),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : null,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(widget.isMe ? 20 : 6),
                              bottomRight: Radius.circular(
                                widget.isMe ? 6 : 20,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.message.messageText.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    widget.message.messageText,
                                    textAlign: _getTextAlign(
                                      widget.message.messageText,
                                    ),
                                    textDirection: _getTextDirection(
                                      widget.message.messageText,
                                    ),
                                    style: TextStyle(
                                      fontFamily: AppFonts.font,
                                      fontSize: 14,
                                      height: 1.4,
                                      color: widget.isMe
                                          ? Colors.white
                                          : otherTxtColor,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.message.isEdited)
                              Text(
                                'Edited  ',
                                style: TextStyle(
                                  fontFamily: AppFonts.font,
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                  color: timeColor.withOpacity(0.7),
                                ),
                              ),
                            Text(
                              '${widget.message.timestamp.hour}:${widget.message.timestamp.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(
                                fontFamily: AppFonts.font,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: timeColor,
                              ),
                            ),
                            if (widget.isMe) ...[
                              const SizedBox(width: 4),
                              Icon(Icons.check, size: 14, color: timeColor),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (widget.isMe) const SizedBox(width: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openGallery(
    BuildContext context,
    List<File> allMedia,
    List<File> videos,
    int initialIndex,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaGalleryScreen(
          allMedia: allMedia,
          videos: videos,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  Widget _buildMediaGrid({
    required List<File> images,
    required List<File> videos,
  }) {
    final allMedia = [...images, ...videos];
    final totalCount = allMedia.length;

    // Improved detection: Check path AND extension
    bool checkIsVideo(File file) {
      final isPathMatch = videos.any((v) => v.path == file.path);
      if (isPathMatch) return true;
      final ext = file.path.split('.').last.toLowerCase();
      return ['mp4', 'mov', 'avi', 'mkv', '3gp'].contains(ext);
    }

    if (totalCount == 1) {
      return GestureDetector(
        onTap: () => _openGallery(context, allMedia, videos, 0),
        child: _buildMediaItem(
          allMedia[0],
          isVideo: checkIsVideo(allMedia[0]),
          height: 250,
        ),
      );
    }
    if (totalCount == 2) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _openGallery(context, allMedia, videos, 0),
              child: _buildMediaItem(
                allMedia[0],
                isVideo: checkIsVideo(allMedia[0]),
                height: 180,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _openGallery(context, allMedia, videos, 1),
              child: _buildMediaItem(
                allMedia[1],
                isVideo: checkIsVideo(allMedia[1]),
                height: 180,
              ),
            ),
          ),
        ],
      );
    }
    if (totalCount == 3) {
      return Column(
        children: [
          GestureDetector(
            onTap: () => _openGallery(context, allMedia, videos, 0),
            child: _buildMediaItem(
              allMedia[0],
              isVideo: checkIsVideo(allMedia[0]),
              height: 150,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _openGallery(context, allMedia, videos, 1),
                  child: _buildMediaItem(
                    allMedia[1],
                    isVideo: checkIsVideo(allMedia[1]),
                    height: 100,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _openGallery(context, allMedia, videos, 2),
                  child: _buildMediaItem(
                    allMedia[2],
                    isVideo: checkIsVideo(allMedia[2]),
                    height: 100,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        final file = allMedia[index];
        final isVideo = checkIsVideo(file);
        if (index == 3 && totalCount > 4) {
          return GestureDetector(
            onTap: () => _openGallery(context, allMedia, videos, 3),
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildMediaItem(file, isVideo: isVideo, height: 120),
                Container(
                  color: Colors.black45,
                  child: Center(
                    child: Text(
                      '+${totalCount - 4}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return GestureDetector(
          onTap: () => _openGallery(context, allMedia, videos, index),
          child: _buildMediaItem(file, isVideo: isVideo, height: 120),
        );
      },
    );
  }

  Widget _buildMediaItem(File file, {required bool isVideo, double? height}) {
    if (isVideo) return VideoThumbnailWidget(videoFile: file, height: height);
    return Image.file(
      file,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: height,
        color: context.textFieldBgColor,
        child: Icon(Icons.broken_image, color: Colors.grey),
      ),
    );
  }
}

class VideoThumbnailWidget extends StatefulWidget {
  final File videoFile;
  final double? height;
  const VideoThumbnailWidget({super.key, required this.videoFile, this.height});
  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.videoFile)
      ..initialize().then((_) {
        if (mounted) setState(() => _isInitialized = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 200,
      width: double.infinity,
      color: Colors.black,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (_isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.play_arrow_rounded,
              color: Colors.white,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class MediaGalleryScreen extends StatefulWidget {
  final List<File> allMedia;
  final List<File> videos;
  final int initialIndex;
  const MediaGalleryScreen({
    super.key,
    required this.allMedia,
    required this.videos,
    required this.initialIndex,
  });
  @override
  State<MediaGalleryScreen> createState() => _MediaGalleryScreenState();
}

class _MediaGalleryScreenState extends State<MediaGalleryScreen> {
  late PageController _pageController;
  late int _currentIndex;
  // Tracking all active controllers to ensure speed works on the current one
  final Map<int, VideoPlayerController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _updateSpeed(double speed) {
    final activeController = _controllers[_currentIndex];
    if (activeController != null && activeController.value.isInitialized) {
      activeController.setPlaybackSpeed(speed);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Speed: ${speed}x',
            style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold),
          ),
          duration: const Duration(milliseconds: 800),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFF0C6B6B),
        ),
      );
      setState(() {}); // To update checkmark in menu if needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentFile = widget.allMedia[_currentIndex];
    final currentExt = currentFile.path.split('.').last.toLowerCase();
    final isCurrentVideo =
        widget.videos.any((v) => v.path == currentFile.path) ||
        ['mp4', 'mov', 'avi', 'mkv', '3gp'].contains(currentExt);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.allMedia.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final file = widget.allMedia[index];
              final ext = file.path.split('.').last.toLowerCase();
              final isVideo =
                  widget.videos.any((v) => v.path == file.path) ||
                  ['mp4', 'mov', 'avi', 'mkv', '3gp'].contains(ext);

              if (isVideo) {
                return FullScreenVideoPlayer(
                  videoFile: file,
                  onControllerInitialized: (controller) {
                    _controllers[index] = controller;
                  },
                );
              }
              return InteractiveViewer(
                child: Image.file(file, fit: BoxFit.contain),
              );
            },
          ),

          // Custom Top Overlay
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 8,
                left: 8,
                right: 8,
                bottom: 20,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_currentIndex + 1} of ${widget.allMedia.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Spacer(),
                  if (isCurrentVideo)
                    PopupMenuButton<double>(
                      icon: Icon(Icons.more_vert, color: Colors.white),
                      color: const Color(0xFF252525),
                      offset: const Offset(0, 45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      onSelected: _updateSpeed,
                      itemBuilder: (context) {
                        final currentSpeed =
                            _controllers[_currentIndex]?.value.playbackSpeed ??
                            1.0;
                        return [
                          const PopupMenuItem(
                            enabled: false,
                            child: Text(
                              'Playback Speed',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const PopupMenuDivider(),
                          _buildSpeedItem(0.5, currentSpeed),
                          _buildSpeedItem(1.0, currentSpeed),
                          _buildSpeedItem(1.5, currentSpeed),
                          _buildSpeedItem(2.0, currentSpeed),
                        ];
                      },
                    ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PopupMenuItem<double> _buildSpeedItem(double speed, double activeSpeed) {
    final isSelected = speed == activeSpeed;
    return PopupMenuItem<double>(
      value: speed,
      child: Row(
        children: [
          Icon(
            Icons.speed_rounded,
            color: isSelected ? const Color(0xFF0C6B6B) : Colors.white70,
            size: 18,
          ),
          const SizedBox(width: 12),
          Text(
            '${speed}x',
            style: TextStyle(
              color: Colors.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(Icons.check, color: Color(0xFF0C6B6B), size: 16),
          ],
        ],
      ),
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final File videoFile;
  final Function(VideoPlayerController)? onControllerInitialized;
  const FullScreenVideoPlayer({
    super.key,
    required this.videoFile,
    this.onControllerInitialized,
  });
  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.file(widget.videoFile);
    await _videoPlayerController.initialize();

    // Notify parent about the controller
    widget.onControllerInitialized?.call(_videoPlayerController);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      allowPlaybackSpeedChanging: false, // Hide default speed menu
      showOptions: false, // Hide the three dots at the bottom
      materialProgressColors: ChewieProgressColors(
        playedColor: const Color(0xFF0C6B6B),
        handleColor: const Color(0xFF0C6B6B),
        backgroundColor: Colors.white24,
        bufferedColor: Colors.white38,
      ),
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized
          ? Chewie(controller: _chewieController!)
          : const CircularProgressIndicator(),
    );
  }
}
