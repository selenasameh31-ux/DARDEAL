import 'package:graduation_project_flutter/core/routing/routes_export.dart' hide ChatMessageEntity;
import 'package:graduation_project_flutter/core/utils/top_snack_bar.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/domain/entities/chat_entity.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/domain/entities/chat_message_entity.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/domain/entities/participant_entity.dart';
import 'package:image_cropper/image_cropper.dart' as ic;

class ChatDetailsScreen extends StatefulWidget {
  final int chatId;
  const ChatDetailsScreen({super.key, required this.chatId});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> with WidgetsBindingObserver {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatBloc _chatBloc;
  int? _editingMessageId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _chatBloc = sl<ChatBloc>();
    _chatBloc.add(FetchMessagesEvent(widget.chatId));
    _chatBloc.add(MarkChatReadEvent(widget.chatId));
    _chatBloc.add(StartPollingEvent(widget.chatId));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Immediately refresh chat and presence when app comes to foreground
      _chatBloc.add(FetchMessagesEvent(widget.chatId, isPolling: true));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _chatBloc.add(StopPollingEvent());
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ──────────────────── Image Picker & Cropper ────────────────────

  Future<void> _cropImage(String path) async {
    final croppedFile = await ic.ImageCropper().cropImage(
      sourcePath: path,
      uiSettings: [
        ic.AndroidUiSettings(
            toolbarTitle: 'Edit Image',
            toolbarColor: Colors.deepPurple,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: ic.CropAspectRatioPreset.original,
            lockAspectRatio: false,
            aspectRatioPresets: [
              ic.CropAspectRatioPreset.square,
              ic.CropAspectRatioPreset.ratio3x2,
              ic.CropAspectRatioPreset.original,
              ic.CropAspectRatioPreset.ratio4x3,
              ic.CropAspectRatioPreset.ratio16x9
            ]
        ),
        ic.IOSUiSettings(
          title: 'Edit Image',
          aspectRatioPresets: [
            ic.CropAspectRatioPreset.square,
            ic.CropAspectRatioPreset.ratio3x2,
            ic.CropAspectRatioPreset.original,
            ic.CropAspectRatioPreset.ratio4x3,
            ic.CropAspectRatioPreset.ratio16x9
          ]
        ),
      ],
    );

    if (croppedFile != null) {
      _chatBloc.add(UploadMediaEvent(
        chatId: widget.chatId,
        filePath: croppedFile.path,
        messageType: 'Image',
      ));
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) {
      await _cropImage(picked.path);
    }
  }

  Future<void> _pickFromCamera() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 85);
    if (picked != null) {
      await _cropImage(picked.path);
    }
  }

  // ──────────────────── Send Text ────────────────────

  // ──────────────────── Edit Message ────────────────────

  void _startEditing(ChatMessageEntity message) {
    setState(() {
      _editingMessageId = message.id;
      _messageController.text = message.messageText;
    });
    _messageController.selection = TextSelection.fromPosition(TextPosition(offset: _messageController.text.length));
  }

  void _cancelEditing() {
    setState(() {
      _editingMessageId = null;
      _messageController.clear();
    });
  }

  // ──────────────────── Send Text ────────────────────

  void _sendTextMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    
    if (_editingMessageId != null) {
      _chatBloc.add(EditMessageEvent(messageId: _editingMessageId!, text: text));
      _cancelEditing();
    } else {
      _chatBloc.add(SendMessageEvent(chatId: widget.chatId, text: text));
      _messageController.clear();
    }
  }

  // ──────────────────── Block / Report ────────────────────

  void _showBlockDialog(BuildContext ctx, int userId, String userName) {
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    final txtColor = isDark ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: isDark ? DarkColors.darkTextFieldColor : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          const Icon(Icons.block, color: Colors.red),
          const SizedBox(width: 10),
          Text('Block $userName', style: TextStyle(fontFamily: AppFonts.font, fontSize: 16, fontWeight: FontWeight.bold, color: txtColor)),
        ]),
        content: Text(
          'Are you sure you want to block $userName?',
          style: TextStyle(fontFamily: AppFonts.font, color: txtColor.withOpacity(0.8)),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Cancel', style: TextStyle(color: txtColor.withOpacity(0.6), fontFamily: AppFonts.font))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              Navigator.pop(ctx);
              _chatBloc.add(BlockUserEvent(userId));
            },
            child: const Text('Block', style: TextStyle(color: Colors.white, fontFamily: AppFonts.font)),
          ),
        ],
      ),
    );
  }

  void _showReportDialog(BuildContext ctx, int userId) {
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    final txtColor = isDark ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;
    final reasonController = TextEditingController();
    String selectedReason = 'Spam or misleading';
    final reasons = ['Spam or misleading', 'Inappropriate content', 'Scam or fraud', 'Harassment', 'Other'];

    showDialog(
      context: ctx,
      builder: (_) => StatefulBuilder(
        builder: (ctx2, setDlgState) => AlertDialog(
          backgroundColor: isDark ? DarkColors.darkTextFieldColor : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(children: [
            Icon(Icons.report_problem_outlined, color: LightColors.lightAttentionText),
            const SizedBox(width: 10),
            Text('Report User', style: TextStyle(fontFamily: AppFonts.font, fontSize: 16, fontWeight: FontWeight.bold, color: txtColor)),
          ]),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reason', style: TextStyle(fontFamily: AppFonts.font, fontWeight: FontWeight.w600, color: txtColor)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedReason,
                dropdownColor: isDark ? DarkColors.darkTextFieldColor : Colors.white,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDark ? DarkColors.darkBackGround : const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: reasons.map((r) => DropdownMenuItem(value: r, child: Text(r, style: TextStyle(fontFamily: AppFonts.font, color: txtColor, fontSize: 13)))).toList(),
                onChanged: (v) => setDlgState(() => selectedReason = v!),
              ),
              const SizedBox(height: 12),
              Text('Description (optional)', style: TextStyle(fontFamily: AppFonts.font, fontWeight: FontWeight.w600, color: txtColor)),
              const SizedBox(height: 8),
              TextField(
                controller: reasonController,
                maxLines: 3,
                style: TextStyle(color: txtColor, fontFamily: AppFonts.font),
                decoration: InputDecoration(
                  hintText: 'Add more details...',
                  hintStyle: TextStyle(color: txtColor.withOpacity(0.4), fontFamily: AppFonts.font),
                  filled: true,
                  fillColor: isDark ? DarkColors.darkBackGround : const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx2), child: Text('Cancel', style: TextStyle(color: txtColor.withOpacity(0.6), fontFamily: AppFonts.font))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: LightColors.lightAttentionText,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(ctx2);
                _chatBloc.add(ReportUserEvent(
                  userId: userId,
                  complaintType: selectedReason,
                  description: reasonController.text.trim().isEmpty ? selectedReason : reasonController.text.trim(),
                ));
              },
              child: const Text('Submit', style: TextStyle(color: Colors.white, fontFamily: AppFonts.font)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    showTopSnackBar(context, msg, isError: isError);
  }



  // ──────────────────── Media Attachment Dialog ────────────────────

  void _showAttachmentPicker(BuildContext ctx) {
    final isDark = Theme.of(ctx).brightness == Brightness.dark;
    showModalBottomSheet(
      context: ctx,
      backgroundColor: isDark ? DarkColors.darkTextFieldColor : Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAttachOption(Icons.photo_library_rounded, 'Gallery', Colors.purple, () { Navigator.pop(ctx); _pickFromGallery(); }),
              _buildAttachOption(Icons.camera_alt_rounded, 'Camera', Colors.blue, () { Navigator.pop(ctx); _pickFromCamera(); }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachOption(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontFamily: AppFonts.font, fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ──────────────────── Build ────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final txtColor = isDark ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;

    return BlocProvider.value(
      value: _chatBloc,
      child: BlocListener<ChatBloc, ChatState>(
        listener: (ctx, state) {
          if (state is UserActionSuccess) {
            _showSnackBar(state.message);
          } else if (state is UserActionFailed) {
            _showSnackBar(state.message, isError: true);
          } else if (state is MessageDeleted) {
            _showSnackBar('Message deleted');
          } else if (state is MessageError) {
            _showSnackBar(state.message, isError: true);
          } else if (state is MediaUploaded) {
            // Upload succeeded → now send the message with attachment
            final data = state.responseData;
            print('========= MEDIA UPLOAD DATA =========');
            print(data);
            print('=====================================');
            // Build attachmentsJson from the response
            String attachmentsJson = '';
            if (data is Map) {
              attachmentsJson = jsonEncode([data]);
            } else if (data is String) {
              attachmentsJson = data;
            } else {
              attachmentsJson = jsonEncode([{'url': data?.toString() ?? ''}]);
            }
            _chatBloc.add(SendMessageEvent(
              chatId: widget.chatId,
              text: 'Image',
              messageType: state.messageType,
              attachmentsJson: attachmentsJson,
            ));
          }
        },
        child: Scaffold(
          backgroundColor: context.scaffoldBgColor,
          appBar: _buildAppBar(isDark, txtColor),
          body: Column(
            children: [
              // Messages list
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  buildWhen: (prev, curr) =>
                      curr is MessagesLoaded ||
                      curr is MessagesLoading ||
                      curr is ChatError ||
                      curr is ChatInitial,
                  builder: (ctx, state) {
                    if (state is MessagesLoading || state is ChatInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is ChatError) {
                      return Center(child: Text(state.message, style: TextStyle(color: txtColor)));
                    }
                    if (state is MessagesLoaded) {
                      return _buildMessageList(ctx, state, isDark, txtColor);
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),

              // Input area
              BlocBuilder<ChatBloc, ChatState>(
                builder: (ctx, state) => _buildInputArea(ctx, state, isDark, txtColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────── AppBar ────────────────────

  PreferredSizeWidget _buildAppBar(bool isDark, Color txtColor) {
    return AppBar(
      backgroundColor: isDark ? DarkColors.darkBackGround : Colors.white,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(isDark ? 0.5 : 0.1),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(24))),
      centerTitle: false,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: txtColor, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: BlocBuilder<ChatBloc, ChatState>(
        builder: (ctx, state) {
          ChatEntity? chat;
          if (state is MessagesLoaded) chat = state.chat;
          ParticipantEntity? otherUser = chat?.otherParticipant;
          if (otherUser == null && chat != null) {
            final currentUserId = int.tryParse(sl<CacheHelper>().getUserId() ?? '') ?? 0;
            if (chat.seeker != null && chat.seeker!.id != currentUserId) {
              otherUser = chat.seeker;
            } else if (chat.owner != null && chat.owner!.id != currentUserId) {
              otherUser = chat.owner;
            }
          }
          final name = otherUser?.name ?? 'Chat';
          
          String presenceText = 'Connecting...';
          Color presenceColor = Colors.grey;

          if (otherUser != null) {
            if (otherUser.isOnline) {
              presenceText = 'Online';
              presenceColor = Colors.green;
            } else if (otherUser.lastSeenAt != null) {
              final lastSeen = otherUser.lastSeenAt!;
              final now = DateTime.now();
              final diff = now.difference(lastSeen);
              
              if (diff.inMinutes < 60) {
                presenceText = 'Last seen ${diff.inMinutes}m ago';
              } else if (diff.inHours < 24) {
                presenceText = 'Last seen ${diff.inHours}h ago';
              } else {
                presenceText = 'Last seen ${lastSeen.day}/${lastSeen.month}/${lastSeen.year}';
              }
              presenceColor = Colors.grey;
            } else {
              presenceText = 'Offline';
              presenceColor = Colors.grey;
            }
          }

          return Row(
            children: [
              ChatAvatar(name: name, radius: 20, showOnlineIndicator: otherUser?.isOnline ?? false),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyle(fontFamily: AppFonts.font, fontSize: 16, fontWeight: FontWeight.w700, color: txtColor)),
                  Text(
                    presenceText,
                    style: TextStyle(fontFamily: AppFonts.font, fontSize: 12, fontWeight: FontWeight.w600, color: presenceColor),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      actions: [
        BlocBuilder<ChatBloc, ChatState>(
          builder: (ctx, state) {
            ChatEntity? chat;
            if (state is MessagesLoaded) chat = state.chat;
            ParticipantEntity? otherUser = chat?.otherParticipant;
            if (otherUser == null && chat != null) {
              final currentUserId = int.tryParse(sl<CacheHelper>().getUserId() ?? '') ?? 0;
              if (chat.seeker != null && chat.seeker!.id != currentUserId) {
                otherUser = chat.seeker;
              } else if (chat.owner != null && chat.owner!.id != currentUserId) {
                otherUser = chat.owner;
              }
            }
            final userId = otherUser?.id ?? 0;
            final userName = otherUser?.name ?? 'User';

            return PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: txtColor),
              color: isDark ? DarkColors.darkTextFieldColor : Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (value) {
                if (value == 'report') _showReportDialog(ctx, userId);
                if (value == 'block') _showBlockDialog(ctx, userId, userName);
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                  value: 'report',
                  child: Row(children: [
                    Icon(Icons.report_problem_outlined, color: LightColors.lightAttentionText, size: 20),
                    const SizedBox(width: 12),
                    Text('Report', style: TextStyle(fontFamily: AppFonts.font, fontSize: 14, fontWeight: FontWeight.w600, color: txtColor)),
                  ]),
                ),
                PopupMenuItem(
                  value: 'block',
                  child: Row(children: [
                    const Icon(Icons.block, color: Colors.red, size: 20),
                    const SizedBox(width: 12),
                    Text('Block', style: TextStyle(fontFamily: AppFonts.font, fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red)),
                  ]),
                ),
              ],
            );
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  // ──────────────────── Messages List ────────────────────

  Widget _buildMessageList(BuildContext ctx, MessagesLoaded state, bool isDark, Color txtColor) {
    final messages = state.messages;
    if (messages.isEmpty) {
      return Center(child: Text('No messages yet. Say hi! 👋', style: TextStyle(color: txtColor.withOpacity(0.5), fontFamily: AppFonts.font)));
    }
    final sessionState = context.read<SessionCubit>().state;
    return ListView.builder(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: messages.length,
      itemBuilder: (_, index) {
        final message = messages[index];
        bool isMe = false;
        if (sessionState is SessionAuthenticated) {
          isMe = message.sender.id.toString() == sessionState.user.id;
        }
        // Render image message
        if (message.messageType.toLowerCase() == 'image' && (message.attachmentsJson?.isNotEmpty ?? false)) {
          return _buildImageBubble(message, isMe, isDark);
        }
        return ChatMessageBubble(
          message: message, 
          isMe: isMe, 
          senderName: message.sender.name,
          onEdit: _startEditing,
          onDelete: (msg) => _chatBloc.add(DeleteMessageEvent(msg.id)),
        );
      },
    );
  }

  // ──────────────────── Image Bubble ────────────────────

  Widget _buildImageBubble(ChatMessageEntity message, bool isMe, bool isDark) {
    String imageUrl = '';
    try {
      final data = jsonDecode(message.attachmentsJson ?? '[]');
      if (data is List && data.isNotEmpty) {
        final first = data[0];
        imageUrl = first is Map ? (first['url'] ?? first['mediaUrl'] ?? first.values.first?.toString() ?? '') : first.toString();
      }
    } catch (_) {
      imageUrl = message.attachmentsJson ?? '';
    }

    if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      imageUrl = imageUrl.startsWith('/') ? '${EndPoints.baseUrl}$imageUrl' : '${EndPoints.baseUrl}/$imageUrl';
    }

    Offset tapPos = Offset.zero;

    return Builder(
      builder: (bubbleContext) => GestureDetector(
        onTapDown: (d) => tapPos = d.globalPosition,
        onLongPress: () async {
          final isDarkLocal = Theme.of(context).brightness == Brightness.dark;
          final txtColor = isDarkLocal ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;
          final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
          final button = bubbleContext.findRenderObject() as RenderBox;
          final value = await showMenu<String>(
            context: context,
            position: RelativeRect.fromRect(
              Rect.fromPoints(
                button.localToGlobal(Offset.zero, ancestor: overlay),
                button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
              ),
              Offset.zero & overlay.size,
            ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: isDarkLocal ? DarkColors.darkTextFieldColor : Colors.white,
          elevation: 4,
          items: [
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                  const SizedBox(width: 12),
                  Text('Delete', style: TextStyle(fontFamily: AppFonts.font, fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red)),
                ],
              ),
            ),
          ],
        );
        if (value == 'delete') {
          _chatBloc.add(DeleteMessageEvent(message.id));
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isMe) ...[ChatAvatar(name: message.sender.name, radius: 14), const SizedBox(width: 8)],
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                  maxHeight: 400,
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Container(
                    width: 200, height: 180, color: isDark ? DarkColors.darkTextFieldColor : Colors.grey.shade200,
                    child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
                  ),
                  loadingBuilder: (_, child, progress) => progress == null ? child : Container(
                    width: 200, height: 180,
                    alignment: Alignment.center,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),
            if (isMe) const SizedBox(width: 24),
          ],
        ),
      ),
    ));
  }

  // ──────────────────── Input Area ────────────────────

  Widget _buildInputArea(BuildContext ctx, ChatState state, bool isDark, Color txtColor) {
    // ── Blocked banner ──
    if (state is MessagesLoaded && state.isBlocked) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? DarkColors.darkBackGround : Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.block, color: Colors.red, size: 18),
            const SizedBox(width: 8),
            Text(
              'You blocked this user. You can no longer send messages.',
              style: TextStyle(fontFamily: AppFonts.font, fontSize: 13, color: Colors.red.shade400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final bool isBusy = state is MessageSending || state is MediaUploading || state is UserActionLoading;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: isDark ? DarkColors.darkBackGround : Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attach icon or Cancel Edit
          if (_editingMessageId != null)
            IconButton(
              icon: Icon(Icons.close_rounded, color: Colors.redAccent, size: 26),
              onPressed: _cancelEditing,
              padding: EdgeInsets.zero,
            )
          else
            IconButton(
              icon: Icon(Icons.add_circle_outline_rounded, color: isDark ? Colors.white54 : Colors.black45, size: 26),
              onPressed: isBusy ? null : () => _showAttachmentPicker(ctx),
              padding: EdgeInsets.zero,
            ),

          // Text field
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isDark ? DarkColors.darkTextFieldColor : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                enabled: !isBusy,
                maxLines: 4,
                minLines: 1,
                style: TextStyle(color: txtColor, fontFamily: AppFonts.font, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: txtColor.withOpacity(0.4), fontFamily: AppFonts.font, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ),

          // Send button
          if (isBusy)
            const Padding(
              padding: EdgeInsets.all(10),
              child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
            )
          else
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _messageController,
              builder: (_, val, __) {
                final hasText = val.text.trim().isNotEmpty;
                return GestureDetector(
                  onTap: hasText ? _sendTextMessage : null,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: hasText ? context.primaryColor : Colors.grey, 
                      shape: BoxShape.circle
                    ),
                    child: Icon(
                      _editingMessageId != null ? Icons.check_rounded : Icons.send_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
