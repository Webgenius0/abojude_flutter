import 'package:flutter/material.dart';



// 1. Data Model
class ChatMessage {
  final String id;
  final String name;
  final String initials;
  final String lastMessage;
  final String time;
  final bool isOnline;
  final int unreadCount;

  ChatMessage({
    required this.id,
    required this.name,
    required this.initials,
    required this.lastMessage,
    required this.time,
    required this.isOnline,
    this.unreadCount = 0,
  });
}

// 2. Main Screen Widget
class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  // Mock Data mimicking the image exactly
  final List<ChatMessage> _allMessages = [
    ChatMessage(
      id: '1',
      name: 'Sara Khali',
      initials: 'SA',
      lastMessage: 'Is the price negotiable?',
      time: '10:32 AM',
      isOnline: true,
      unreadCount: 1,
    ),
    ChatMessage(
      id: '2',
      name: 'Fatima Nour',
      initials: 'FN',
      lastMessage: 'What are your opening hours on...',
      time: '10:32 AM',
      isOnline: true,
    ),
    ChatMessage(
      id: '3',
      name: 'Hassan Youssef',
      initials: 'HY',
      lastMessage: 'I can come this Saturday morning.',
      time: '10:32 AM',
      isOnline: true,
    ),
    ChatMessage(
      id: '4',
      name: 'Ahmed Al Rashid',
      initials: 'AR',
      lastMessage: 'iPhone 14 pro max - 256GM',
      time: 'Yesterday',
      isOnline: true,
    ),
    ChatMessage(
      id: '5',
      name: 'Taowfik Alom',
      initials: 'TA',
      lastMessage: 'Please send us your resume.',
      time: '2 days ago',
      isOnline: false,
    ),
  ];

  // List used for displaying filtered search results
  List<ChatMessage> _filteredMessages = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredMessages = List.from(_allMessages);
  }

  // Search filter logic
  void _filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMessages = List.from(_allMessages);
      } else {
        _filteredMessages = _allMessages
            .where((chat) =>
        chat.name.toLowerCase().contains(query.toLowerCase()) ||
            chat.lastMessage.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Delete logic
  void _deleteMessage(int index) {
    final removedItem = _filteredMessages[index];
    setState(() {
      _filteredMessages.removeAt(index);
      _allMessages.removeWhere((item) => item.id == removedItem.id);
    });

    // Optional confirmation banner
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Conversation with ${removedItem.name} deleted'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Total unread count dynamically configured
    int totalUnread = _allMessages.where((m) => m.unreadCount > 0).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 20,
        title: Row(
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
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
            ]
          ],
        ),
      ),
      body: Column(
        children: [
          // 3. Search Bar Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterSearch,
              decoration: InputDecoration(
                hintText: 'Search conversations...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 22),
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

          // 4. Conversations List View
          Expanded(
            child: _filteredMessages.isEmpty
                ? Center(
              child: Text(
                'No conversations found',
                style: TextStyle(color: Colors.grey[400]),
              ),
            )
                : ListView.separated(
              itemCount: _filteredMessages.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1,
                indent: 80,
                color: Color(0xFFF1F3F5),
              ),
              itemBuilder: (context, index) {
                final chat = _filteredMessages[index];

                // 5. Swipe-to-Delete Dismissible Layout
                return Dismissible(
                  key: Key(chat.id),
                  direction: DismissDirection.endToStart, // Swipe right to left
                  background: Container(
                    color: Colors.red[600],
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    _deleteMessage(index);
                  },
                  child: _buildChatTile(chat),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 6. Custom Chat ListTile Builder
  Widget _buildChatTile(ChatMessage chat) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          // Avatar Stack with Online indicator dot
          Stack(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: const Color(0xFFE9ECEF),
                child: Text(
                  chat.initials,
                  style: const TextStyle(
                    color: Color(0xFF0F3D7A),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
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
          ),
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
                    color: chat.unreadCount > 0 ? Colors.black87 : Colors.grey[500],
                    fontWeight: chat.unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
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
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
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
                const SizedBox(height: 20), // Keeps structural symmetry unchanged
            ],
          ),
        ],
      ),
    );
  }
}