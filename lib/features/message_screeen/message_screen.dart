import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'message_screeen_list.dart'; // import to access ChatMessage data model
import 'package:google_fonts/google_fonts.dart';
import '../home/presentation/report_screen.dart';

// 1. Details Message Data Model
class DetailsMessage {
  final String id;
  final String sender; // "You" or the recipient's name
  final String text;
  final List<String> images; // Local file paths or URLs
  final String time;
  final ProductRelates? relatesToProduct;

  DetailsMessage({
    required this.id,
    required this.sender,
    required this.text,
    this.images = const [],
    required this.time,
    this.relatesToProduct,
  });
}

class ProductRelates {
  final String title;
  final String imageUrl;

  ProductRelates({
    required this.title,
    required this.imageUrl,
  });
}

// 2. Chat Details Screen Widget
class MessageScreen extends StatefulWidget {
  final ChatMessage chat;

  const MessageScreen({Key? key, required this.chat}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final List<DetailsMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  
  // Holds the list of selected image files before sending
  final List<XFile> _selectedImages = [];

  @override
  void initState() {
    super.initState();
    _seedMockMessages();
  }

  // Pre-populate mock messages to match the user's screenshot exactly
  void _seedMockMessages() {
    _messages.addAll([
      DetailsMessage(
        id: 'mock_1',
        sender: widget.chat.name,
        text: "Hi, I'm interested in the Samsung S24 Ultra, is the still available?",
        time: 'Oct 15, 9:42 AM',
        relatesToProduct: ProductRelates(
          title: "Samsung Galaxy S24 Ultra Excelle...",
          imageUrl: "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=400&auto=format&fit=crop&q=80",
        ),
      ),
      DetailsMessage(
        id: 'mock_2',
        sender: "You",
        text: "Hello! Yes it's still available. Feel free to ask any questions.",
        time: 'Oct 15, 9:35 AM',
      ),
      DetailsMessage(
        id: 'mock_3',
        sender: widget.chat.name,
        text: "Great! Is the price negotiable?",
        time: 'Oct 15, 9:42 AM',
      ),
      DetailsMessage(
        id: 'mock_4',
        sender: widget.chat.name,
        text: "Can we meet in person for inspection?",
        time: 'Oct 15, 9:42 AM',
      ),
      DetailsMessage(
        id: 'mock_5',
        sender: "You",
        text: "Sure, where will you come from?",
        time: 'Oct 15, 9:35 AM',
      ),
    ]);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Pick images from gallery or camera
  Future<void> _pickImages() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select Images to Send',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3D7A).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.photo_library, color: Color(0xFF0F3D7A)),
                ),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Select multiple photos'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final List<XFile> images = await _picker.pickMultiImage();
                    if (images.isNotEmpty) {
                      setState(() {
                        _selectedImages.addAll(images);
                      });
                    }
                  } catch (e) {
                    _showErrorSnackBar('Failed to pick images: $e');
                  }
                },
              ),
              const Divider(height: 1),
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F3D7A).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Color(0xFF0F3D7A)),
                ),
                title: const Text('Take a Photo'),
                subtitle: const Text('Use camera to capture'),
                onTap: () async {
                  Navigator.pop(context);
                  try {
                    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      setState(() {
                        _selectedImages.add(image);
                      });
                    }
                  } catch (e) {
                    _showErrorSnackBar('Failed to take photo: $e');
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Remove a selected image from the preview list
  void _removeSelectedImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // Send message action
  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty && _selectedImages.isEmpty) return;

    final String currentTime = DateFormat('h:mm a').format(DateTime.now());
    
    // Copy the selected images paths
    final List<String> imagePaths = _selectedImages.map((file) => file.path).toList();

    setState(() {
      _messages.add(
        DetailsMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          sender: "You",
          text: text,
          images: imagePaths,
          time: currentTime,
        ),
      );
      _textController.clear();
      _selectedImages.clear();
    });

    // Auto-scroll to the bottom of the list
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leadingWidth: 70,
            leading: Center(
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
                  ),
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: Colors.black87,
                    size: 26,
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: const Color(0xFFE9ECEF),
                      child: Text(
                        widget.chat.initials,
                        style: const TextStyle(
                          color: Color(0xFF0F3D7A),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (widget.chat.isOnline)
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2B8A3E),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.chat.name,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          if (widget.chat.isOnline)
                            Container(
                              width: 6,
                              height: 6,
                              margin: const EdgeInsets.only(right: 5),
                              decoration: const BoxDecoration(
                                color: Color(0xFF2B8A3E),
                                shape: BoxShape.circle,
                              ),
                            ),
                          Text(
                            widget.chat.isOnline ? 'Online' : 'Offline',
                            style: TextStyle(
                              color: widget.chat.isOnline
                                  ? const Color(0xFF2B8A3E)
                                  : Colors.grey[500],
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
                    ),
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert_rounded, color: Colors.black87, size: 20),
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      surfaceTintColor: Colors.white,
                      onSelected: (value) {
                        if (value == 'report') {
                          Get.to(() => ReportScreen(
                            targetName: widget.chat.name,
                            isReportUser: true,
                          ));
                        } else if (value == 'block') {
                          _showBlockUserDialog(context);
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem<String>(
                          value: 'report',
                          child: Row(
                            children: [
                              const Icon(Icons.report_gmailerrorred_outlined, color: Colors.redAccent, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Report User',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: 'block',
                          child: Row(
                            children: [
                              const Icon(Icons.block_flipped, color: Colors.black54, size: 20),
                              const SizedBox(width: 10),
                              Text(
                                'Block User',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 3. Message Stream List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final bool isMe = message.sender == 'You';

                  return _buildMessageBubble(message, isMe);
                },
              ),
            ),

            // 4. Image Previews above text field (if selected)
            if (_selectedImages.isNotEmpty) _buildImagePreviewBar(),

            // 5. Bottom Text Input and Action bar
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  // Builder for individual message bubbles
  Widget _buildMessageBubble(DetailsMessage message, bool isMe) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Sender Name
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0, left: 4.0, right: 4.0),
            child: Text(
              isMe ? 'You' : message.sender,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Bubble Content
          Row(
            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  decoration: BoxDecoration(
                    color: isMe ? const Color(0xFF1B2D6B) : const Color(0xFFF1F3F5),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16.0),
                      topRight: const Radius.circular(16.0),
                      bottomLeft: Radius.circular(isMe ? 16.0 : 4.0),
                      bottomRight: Radius.circular(isMe ? 4.0 : 16.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text message content
                      if (message.text.isNotEmpty)
                        Text(
                          message.text,
                          style: TextStyle(
                            color: isMe ? Colors.white : Colors.black87,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),

                      // Relates-to product card
                      if (message.relatesToProduct != null) ...[
                        if (message.text.isNotEmpty) const SizedBox(height: 12),
                        Text(
                          "This message relates to:",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  width: 48,
                                  height: 48,
                                  color: const Color(0xFFF8F9FA),
                                  child: Image.network(
                                    message.relatesToProduct!.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.phone_android_rounded,
                                        color: Color(0xFF0F3D7A),
                                        size: 24,
                                      );
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  message.relatesToProduct!.title,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black87,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Images layout grid/collage
                      if (message.images.isNotEmpty) ...[
                        if (message.text.isNotEmpty || message.relatesToProduct != null)
                          const SizedBox(height: 12),
                        _buildImagesGrid(message.images),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Timestamp
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0, right: 4.0),
            child: Text(
              message.time,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[400],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builder for image grids inside message bubbles
  Widget _buildImagesGrid(List<String> images) {
    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 200, maxWidth: 240),
          child: _renderSingleImage(images[0]),
        ),
      );
    } else if (images.length == 2) {
      return SizedBox(
        width: 240,
        height: 110,
        child: Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: _renderSingleImage(images[0]),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                child: _renderSingleImage(images[1]),
              ),
            ),
          ],
        ),
      );
    } else {
      // 3 or more images: collage/grid structure
      return SizedBox(
        width: 240,
        height: 180,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: _renderSingleImage(images[0]),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                      ),
                      child: _renderSingleImage(images[1]),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(12),
                      ),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _renderSingleImage(images[2]),
                          if (images.length > 3)
                            Container(
                              color: Colors.black.withOpacity(0.55),
                              alignment: Alignment.center,
                              child: Text(
                                '+${images.length - 3}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  // Render file, asset, or network image helper
  Widget _renderSingleImage(String imagePath) {
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
          );
        },
      );
    } else {
      // Local image picked from gallery
      return Image.file(
        File(imagePath),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
          );
        },
      );
    }
  }

  // Image preview list above bottom bar
  Widget _buildImagePreviewBar() {
    return Container(
      height: 86,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!, width: 1),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length,
        itemBuilder: (context, index) {
          final file = _selectedImages[index];

          return Container(
            margin: const EdgeInsets.only(right: 12),
            width: 70,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    File(file.path),
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: () => _removeSelectedImage(index),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.black54,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Bottom action bar: paperclip, input field, send button
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[100]!, width: 1.5),
        ),
      ),
      child: Row(
        children: [
          // Paperclip button
          GestureDetector(
            onTap: _pickImages,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF1F3F5), width: 1.5),
              ),
              child: const Icon(
                Icons.attach_file_rounded,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Message input field
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(24.0),
                border: Border.all(color: const Color(0xFFF1F3F5), width: 1.0),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(
                child: TextField(
                  controller: _textController,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                  style: const TextStyle(fontSize: 14.5, color: Colors.black87),
                  decoration: const InputDecoration(
                    hintText: 'Type message here...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.send_rounded,
                  color: Color(0xFF0F3D7A),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showBlockUserDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          contentPadding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFFEF2F2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFDC2626),
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Block ${widget.chat.name}?',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to block ${widget.chat.name}? You will no longer receive messages or see listings from this user.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF6B7280),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              // Block Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                  _performBlockUser();
                },
                child: Text(
                  'Block User',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Cancel Button
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF374151),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _performBlockUser() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.chat.name} has been blocked successfully.',
          style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.red[600],
        behavior: SnackBarBehavior.floating,
      ),
    );
    Get.back();
  }
}
