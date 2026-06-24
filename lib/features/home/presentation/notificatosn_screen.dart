import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  // Styling Constants
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMuted = Color(0xFF757575);
  static const Color textBlue = Color(0xFF0D47A1);
  static const Color iconBgColor = Color(0xFFF0F4F8);
  static const Color dividerColor = Color(0xFFE0E0E0);

  // Mutable list for notifications
  List<NotificationItem> notifications = [
    NotificationItem(
      id: 1,
      title: 'New Message',
      description: 'Ahmed Al Rashid sent you a message about iPhone 14 pro max',
      time: '10 min ago',
      isUnread: true,
    ),
    NotificationItem(
      id: 2,
      title: 'Listing Approved',
      description:
      "Your listing ‘Samsung 55” QLWD TV’ has been approved and is now live.",
      time: '2 hours ago',
      isUnread: true,
    ),
    NotificationItem(
      id: 3,
      title: 'Welcome to Wasel Canada!',
      description:
      'Start exploring thousands of listings across Canada. Post your first listing for free!',
      time: '3 days ago',
      isUnread: false,
    ),
  ];

  // Counts how many notifications are currently unread
  int get unreadCount => notifications.where((item) => item.isUnread).length;

  // Mark an item as read when tapped
  void _markAsRead(int id) {
    setState(() {
      final index = notifications.indexWhere((item) => item.id == id);
      if (index != -1) {
        notifications[index] = notifications[index].copyWith(isUnread: false);
      }
    });
  }

  // Clear all notifications completely
  void _clearAllNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  // Handle removing an item via swipe dismiss
  void _dismissNotification(int id) {
    setState(() {
      notifications.removeWhere((item) => item.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: dividerColor, width: 1),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: textDark,
              ),
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ),
        title: const Text(
          'Notification',
          style: TextStyle(
            color: textDark,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: notifications.isEmpty
          ? const Center(
        child: Text(
          'No notifications available',
          style: TextStyle(color: textMuted, fontSize: 16),
        ),
      )
          : Column(
        children: [
          const SizedBox(height: 10),
          // Recent Header Section
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                const Text(
                  'Recent',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: textBlue,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$unreadCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const Spacer(),
                TextButton(
                  onPressed: _clearAllNotifications,
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  child: const Text(
                    'Clear All',
                    style: TextStyle(
                      color: textBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Notifications List Layout
          Expanded(
            child: ListView.separated(
              itemCount: notifications.length,
              separatorBuilder: (context, index) => const Divider(
                color: dividerColor,
                thickness: 1,
                height: 1,
              ),
              itemBuilder: (context, index) {
                final item = notifications[index];

                // Using Dismissible for swipe-to-delete function
                return Dismissible(
                  key: Key(item.id.toString()),
                  direction:
                  DismissDirection.endToStart, // Swipe right to left
                  onDismissed: (direction) =>
                      _dismissNotification(item.id),
                  background: Container(
                    color: Colors.red.shade600,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => _markAsRead(item.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 16.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Notification Bell Icon Layout
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: iconBgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.notifications_none_outlined,
                              color: textBlue,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Text Content Area
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        color: textDark,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    if (item.isUnread)
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: textBlue,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  item.description,
                                  style: const TextStyle(
                                    color: textMuted,
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item.time,
                                  style: const TextStyle(
                                    color: textMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final int id;
  final String title;
  final String description;
  final String time;
  final bool isUnread;

  NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.isUnread,
  });

  NotificationItem copyWith({bool? isUnread}) {
    return NotificationItem(
      id: id,
      title: title,
      description: description,
      time: time,
      isUnread: isUnread ?? this.isUnread,
    );
  }
}