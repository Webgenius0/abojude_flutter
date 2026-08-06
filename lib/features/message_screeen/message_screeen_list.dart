import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:abojude_flutter/features/message_screeen/model/get_all_mesage_list_model.dart';
import 'package:abojude_flutter/networks/api_acess.dart';

import 'message_screen.dart';

// 1. Data Model
class ChatMessage {
  final String id;
  final String name;
  final String initials;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final int unreadCount;
  final String? avatarUrl;

  ChatMessage({
    required this.id,
    required this.name,
    required this.initials,
    required this.lastMessage,
    required this.time,
    required this.isOnline,
    this.unreadCount = 0,
    this.avatarUrl,
  });

  factory ChatMessage.fromDatum(Datum datum) {
    final name = (datum.otherUser?.name != null && datum.otherUser!.name!.trim().isNotEmpty)
        ? datum.otherUser!.name!.trim()
        : 'User';
    final initials = _getInitials(name);
    final lastMsg = datum.lastMessage?.message ?? '';
    final timeStr = datum.lastMessage?.timeAgo ?? _formatDate(datum.updatedAt ?? datum.createdAt);

    return ChatMessage(
      id: datum.id?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      initials: initials,
      lastMessage: lastMsg,
      time: timeStr,
      isOnline: datum.otherUser?.isOnline ?? false,
      unreadCount: datum.unreadCount ?? 0,
      avatarUrl: _formatImageUrl(datum.otherUser?.avatar),
    );
  }

  static String _formatDate(DateTime? dt) {
    if (dt == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) {
      return 'Just now';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  static String _getInitials(String name) {
    if (name.trim().isEmpty) return 'U';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts[0].isNotEmpty) {
      if (parts[0].length >= 2) {
        return parts[0].substring(0, 2).toUpperCase();
      }
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  static String? _formatImageUrl(String? rawUrl) {
    if (rawUrl == null || rawUrl.trim().isEmpty) return null;
    String url = rawUrl.trim();
    if (url.startsWith('http://') || url.startsWith('https://')) return url;

    const String baseDomain = "https://abojude.thesyndicates.team";
    url = url.replaceAll('/./', '/').replaceAll('/../', '/');
    if (!url.toLowerCase().contains('storage')) {
      final cleanPath = url.startsWith('/') ? url : '/$url';
      return '$baseDomain/storage$cleanPath';
    } else {
      final cleanPath = url.startsWith('/') ? url : '/$url';
      return '$baseDomain$cleanPath';
    }
  }
}

// 2. Main Screen Widget connected to GetAllChatListRx & GetAllChatListApi
class MessagesScreenList extends StatefulWidget {
  const MessagesScreenList({super.key});

  @override
  State<MessagesScreenList> createState() => _MessagesScreenListState();
}

class _MessagesScreenListState extends State<MessagesScreenList>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final List<String> _deletedIds = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    // Call GetAllChatListApi via chatListRxObj on initial load
    _fetchChatList();
  }

  Future<void> _fetchChatList() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });
    }
    try {
      await chatListRxObj.list();
    } catch (_) {
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _animController.forward(from: 0.0);
      }
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase().trim();
    });
  }

  void _deleteMessage(ChatMessage chat) {
    setState(() {
      _deletedIds.add(chat.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conversation with ${chat.name} deleted'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: StreamBuilder<GetMessageListModel>(
          stream: chatListRxObj.getCategoryListData,
          builder: (context, snapshot) {
            final rawItems = snapshot.data?.data ?? [];
            final items = rawItems
                .map((d) => ChatMessage.fromDatum(d))
                .where((m) => !_deletedIds.contains(m.id))
                .toList();
            final int totalUnread =
                items.where((m) => m.unreadCount > 0).length;

            return Row(
              children: [
                const Text(
                  'Messages',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (totalUnread > 0) ...[
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F3D7A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$totalUnread',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchChatList();
        },
        color: const Color(0xFF0F3D7A),
        child: Column(
          children: [
            // 3. Search Bar Section
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey[400],
                    size: 22,
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF8F9FA),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[200]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF0F3D7A)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 4. Stream Builder for Conversations List View with Shimmer Loading & Animations
            Expanded(
              child: StreamBuilder<GetMessageListModel>(
                stream: chatListRxObj.getCategoryListData,
                builder: (context, snapshot) {
                  if (_isLoading ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerList();
                  }

                  if (_hasError || snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Failed to load messages',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _fetchChatList,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F3D7A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  final rawData = snapshot.data?.data ?? [];
                  List<ChatMessage> chats = rawData
                      .map((d) => ChatMessage.fromDatum(d))
                      .where((m) => !_deletedIds.contains(m.id))
                      .toList();

                  // Apply search filter if entered
                  if (_searchQuery.isNotEmpty) {
                    chats = chats
                        .where(
                          (chat) =>
                              chat.name.toLowerCase().contains(_searchQuery) ||
                              chat.lastMessage
                                  .toLowerCase()
                                  .contains(_searchQuery),
                        )
                        .toList();
                  }

                  if (chats.isEmpty) {
                    return Center(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.chat_bubble_outline,
                              size: 56,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'No conversations found'
                                  : 'No messages yet',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: chats.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      indent: 80,
                      color: Color(0xFFF1F3F5),
                    ),
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return _buildAnimatedTile(chat, index, chats.length);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Animated Tile with Staggered Entrance Animation
  Widget _buildAnimatedTile(ChatMessage chat, int index, int totalCount) {
    final double start = (index * 0.08).clamp(0.0, 0.7);
    final double end = (start + 0.3).clamp(0.3, 1.0);

    final Animation<double> fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );

    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: SlideTransition(
        position: slideAnimation,
        child: Dismissible(
          key: Key(chat.id),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red[600],
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            _deleteMessage(chat);
          },
          child: GestureDetector(
            onTap: () {
              Get.to(() => MessageScreen(chat: chat, conversation_id: int.tryParse(chat.id) ?? 0,));
            },
            child: _buildChatTile(chat),
          ),
        ),
      ),
    );
  }

  // Custom Shimmer Loading View
  Widget _buildShimmerList() {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      itemCount: 7,
      separatorBuilder: (context, index) => const Divider(
        height: 1,
        indent: 80,
        color: Color(0xFFF1F3F5),
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              children: [
                // Avatar Shimmer
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                // Text Lines Shimmer
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 180,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                // Timestamp & Badge Shimmer
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 40,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Chat Tile Builder with Network Image (CachedNetworkImage) & Fallback Initials Avatar
  Widget _buildChatTile(ChatMessage chat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // Avatar Stack with Online indicator dot & CachedNetworkImage
          _buildAvatar(chat),
          const SizedBox(width: 14),

          // Core Text Structure (Name & Subtext message)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  chat.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: chat.unreadCount > 0
                        ? Colors.black87
                        : Colors.grey[500],
                    fontWeight: chat.unreadCount > 0
                        ? FontWeight.w500
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Right End Info (Time stamp & Unread Circle)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                chat.time,
                style: TextStyle(fontSize: 12, color: Colors.grey[400]),
              ),
              const SizedBox(height: 6),
              if (chat.unreadCount > 0)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF0F3D7A),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${chat.unreadCount}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else
                const SizedBox(
                  height: 20,
                ),
            ],
          ),
        ],
      ),
    );
  }

  // Network avatar builder with fallback
  Widget _buildAvatar(ChatMessage chat) {
    const double radius = 26;
    const double size = radius * 2;

    Widget fallbackAvatar = CircleAvatar(
      radius: radius,
      backgroundColor: const Color(0xFFE9ECEF),
      child: Text(
        chat.initials,
        style: const TextStyle(
          color: Color(0xFF0F3D7A),
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );

    return Stack(
      children: [
        if (chat.avatarUrl != null && chat.avatarUrl!.isNotEmpty)
          CachedNetworkImage(
            imageUrl: chat.avatarUrl!,
            imageBuilder: (context, imageProvider) => Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: size,
                height: size,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            errorWidget: (context, url, error) => fallbackAvatar,
          )
        else
          fallbackAvatar,
        if (chat.isOnline)
          Positioned(
            right: 1,
            bottom: 1,
            child: Container(
              width: 13,
              height: 13,
              decoration: BoxDecoration(
                color: const Color(0xFF2B8A3E),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
