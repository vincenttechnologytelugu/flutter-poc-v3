// user_chat_screen.dart
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserChatScreen extends StatefulWidget {
  final String conversationId;
  final ProductModel product;
  final String thumb;
  final String title;
  final double price;
  final List<dynamic>? initialMessages;
  const UserChatScreen({
    super.key,
    required this.conversationId,
    required this.thumb,
    required this.title,
    required this.price,
    required this.product,
    this.initialMessages,
  });

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Message> messages = [];
 

  bool isLoading = true;
  String? userName;

  @override
  void initState() {
    super.initState();
    // _loadUserName();
    _loadMessages();
    _initializeMessages();
  }

  void _initializeMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserId = prefs.getString('userId') ?? '';

    if (widget.initialMessages != null) {
      setState(() {
        messages = widget.initialMessages!
            .map((m) => Message.fromJson(m, currentUserId))
            .toList();
        isLoading = false;
      });
    } else {
      _loadMessages();
    }
  }

// Future<void> _loadUserName() async {
//   final prefs = await SharedPreferences.getInstance();

//   setState(() {
//     // Combine firstName and lastName from SharedPreferences
//     final firstName = prefs.getString('first_name') ?? '';
//     final lastName = prefs.getString('last_name') ?? '';
//     userName = '$firstName $lastName'.trim();
//   });
// }

  Future<void> _loadMessages() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final currentUserId = prefs.getString('userId');

      final response = await http.post(
        Uri.parse('http://192.168.0.170:8080/chat/messages'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'conversationId':
              widget.conversationId.toString(), // Ensure it's a string
        }),
      );

      log('Load messages response: ${response.statusCode}');
      log('Load messages body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> messagesList = json.decode(response.body);
        setState(() {
          messages = messagesList
              .map((m) => Message.fromJson(m, currentUserId ?? ''))
              .toList();
              // Update seller name if available in messages
       

          isLoading = false;
        });
        // _scrollToBottom();
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      log('Error loading messages: $e');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load messages')),
        );
      }
    }
  }

  Future<void> _sendMessage(String content) async {
    if (content.trim().isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final currentUserId = prefs.getString('userId');

      // Store the message content
      final messageContent = content;
      _messageController.clear();

      // Add message to UI immediately
      setState(() {
        messages.add(Message(
          id: DateTime.now().toString(),
          senderId: currentUserId ?? '',
          content: messageContent,
          createdAt: DateTime.now(),
          isFromCurrentUser: true,
        ));
      });

      final response = await http.post(
        Uri.parse('http://192.168.0.170:8080/chat/send'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'conversationId':
              widget.conversationId.toString(), // Ensure it's a string
          'content': messageContent,
        }),
      );

      log('Send message response status: ${response.statusCode}');
      log('Send message response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Message sent successfully, no need to do anything as UI is already updated
        _scrollToBottom();
      } else {
        log('Failed to send message. Status: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      log('Error sending message: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message: $e')),
        );
      }
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget buildThumbImage(String? thumbUrl, {double size = 40}) {
    return thumbUrl != null && thumbUrl.isNotEmpty
        ? Image.network(
            thumbUrl,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.image_not_supported,
              size: size * 0.75,
              color: Colors.grey[400],
            ),
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          )
        : Icon(
            Icons.image_not_supported,
            size: size * 0.75,
            color: Colors.grey[400],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  elevation: 0, // Remove shadow
  backgroundColor: Colors.white, // Modern clean look
  leading: IconButton(
    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87), // Modern back icon
    onPressed: () => Navigator.pop(context),
  ),
  title: Row(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: 45,
            height: 45,
            child: buildThumbImage(widget.product.thumb),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.product.title ?? 'No Title',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '₹${widget.product.price?.toString() ?? '0.0'}',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.green,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ],
  ),
  actions: [
    Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: const Icon(Icons.call, color: Colors.blue),
        onPressed: () {
          // Implement call functionality
        },
      ),
    ),
    Theme(
      data: Theme.of(context).copyWith(
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
      ),
      child: PopupMenuButton(
        icon: const Icon(Icons.more_vert, color: Colors.black87),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 'block',
            child: Row(
              children: const [
                Icon(Icons.block, size: 20, color: Colors.red),
                SizedBox(width: 8),
                Text('Block User'),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'report',
            child: Row(
              children: const [
                Icon(Icons.flag, size: 20, color: Colors.orange),
                SizedBox(width: 8),
                Text('Report'),
              ],
            ),
          ),
        ],
      ),
    ),
  ],
),

      // appBar: AppBar(
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: Row(
      //     children: [
      //       CircleAvatar(
      //         backgroundColor: Colors.grey[200],
      //         child: buildThumbImage(widget.product.thumb),
      //       ),
      //       const SizedBox(width: 8),
      //       Expanded(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             // Text(
      //             //   userName ?? 'User',
      //             //   style: const TextStyle(fontSize: 16),
      //             // ),

      //             Text(
      //               widget.product.title ?? 'No Title',
      //               style: const TextStyle(fontSize: 12),
      //               overflow: TextOverflow.ellipsis,
      //             ),
      //             Text(
      //               '₹${widget.product.price?.toString() ?? '0.0'}',
      //               style: const TextStyle(fontSize: 14),
      //             ),
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.call),
      //       onPressed: () {
      //         // Implement call functionality
      //       },
      //     ),
      //     PopupMenuButton(
      //       itemBuilder: (context) => [
      //         const PopupMenuItem(
      //           value: 'block',
      //           child: Text('Block User'),
      //         ),
      //         const PopupMenuItem(
      //           value: 'report',
      //           child: Text('Report'),
      //         ),
      //       ],
      //     ),
      //   ],
      // ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];

                      return _MessageBubble(message: message);
                    },
                  ),
          ),

          // Bottom Input Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Chat'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Make Offer'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () {
                        final content = _messageController.text;
                        if (content.isNotEmpty) {
                          _sendMessage(content);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatefulWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.message.isFromCurrentUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color:
              widget.message.isFromCurrentUser ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          widget.message.content,
          style: TextStyle(
            color:
                widget.message.isFromCurrentUser ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}



// Add these model classes at the bottom of the file or in a separate models file

class Message {
  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final bool isFromCurrentUser;

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.isFromCurrentUser,
  });

  factory Message.fromJson(Map<String, dynamic> map, String currentUserId) {
    return Message(
      id: map['_id']?.toString() ?? '',
      senderId: map['senderId']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
      createdAt:
          DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      isFromCurrentUser: map['senderId']?.toString() == currentUserId,
    );
  }
}



class Conversation {
  final String id;
  final String adPostId;
  final String sellerId;
  final String buyerId;
  final bool isActive;
  final List<Message> messages;
  final DateTime lastMessageAt;
  final DateTime createdAt;
  final ProductModel product;
  final bool isBuying;


  // final String? firstName;
  // final String? lastName;

  Conversation({
    required this.id,
    required this.adPostId,
    required this.sellerId,
    required this.buyerId,
    required this.isActive,
    required this.messages,
    required this.lastMessageAt,
    required this.createdAt,
    required this.product,
    required this.isBuying,
    
    // this.firstName,
    // this.lastName,
  });

  String? get lastMessage => messages.isNotEmpty ? messages.last.content : null;

  DateTime get lastMessageTime => lastMessageAt;

  static Future<List<Conversation>> fromJsonList(List<dynamic> jsonList) async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserId = prefs.getString('userId') ?? '';

    return jsonList.map((map) {
      final List messagesJson = map['messages'] ?? [];
      final messages = messagesJson
          .map((m) =>
              Message.fromJson(Map<String, dynamic>.from(m), currentUserId))
          .toList();

      final adPost = map['adPost'] != null
          ? Map<String, dynamic>.from(map['adPost'])
          : <String, dynamic>{};

      return Conversation(
        id: map['_id']?.toString() ?? '',
        adPostId: map['adPostId']?.toString() ?? '',
        sellerId: map['sellerId']?.toString() ?? '',
        buyerId: map['buyerId']?.toString() ?? '',
        isActive: map['isActive'] ?? true,
        messages: messages,
        lastMessageAt: DateTime.parse(
            map['lastMessageAt'] ?? DateTime.now().toIso8601String()),
        createdAt: DateTime.parse(
            map['createdAt'] ?? DateTime.now().toIso8601String()),
        product: ProductModel.fromJson(adPost),
        isBuying: map['buyerId'] != null,
      );
    }).toList();
  }
}
