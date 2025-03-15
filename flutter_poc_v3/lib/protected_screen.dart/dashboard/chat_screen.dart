// chat_screen.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/user_chat_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Conversation> conversations = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadConversationsAndMessages();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _loadConversationsAndMessages();
      }
    });
  }

  Future<void> _loadConversationsAndMessages() async {
    try {
      setState(() => isLoading = true);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      // firstName = prefs.getString('firstName');
      // lastName = prefs.getString('lastName');

      final response = await http.get(
        Uri.parse('http://13.200.179.78/chat/conversations'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        final List<Conversation> conversationsList = [];

        for (var conv in data) {
          // Load messages for each conversation
          final messagesResponse = await http.post(
            Uri.parse('http://13.200.179.78/chat/messages'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'conversationId': conv['_id'],
            }),
          );

          if (messagesResponse.statusCode == 200) {
            final messages = json.decode(messagesResponse.body);
            conv['messages'] = messages;
          }

          final conversation = await Conversation.fromJsonList([conv]);
          if (conversation.isNotEmpty) {
            conversationsList.add(conversation[0]);
          }
        }

        setState(() {
          conversations = conversationsList;

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load conversations');
      }
    } catch (e) {
      log('Error loading conversations and messages: $e');
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load conversations')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'ALL'),
            Tab(text: 'BUYING'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConversationsTab(),
          _buildBuyingTab(),
        ],
      ),
    );
  }

  Widget _buildConversationsTab() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (conversations.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadConversationsAndMessages,
      child: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return _ConversationTile(
            conversation: conversation,
            // userName: '${firstName ?? ''} ${lastName ?? ''}'.trim(),
          );
        },
      ),
    );
  }

  Widget _buildBuyingTab() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final buyingConversations = conversations.where((c) => c.isBuying).toList();

    if (buyingConversations.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      itemCount: buyingConversations.length,
      itemBuilder: (context, index) {
        return _ConversationTile(
          conversation: buyingConversations[index],
          // userName: '${firstName ?? ''} ${lastName ?? ''}'.trim(),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No conversations yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start chatting with sellers',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation conversation;
  // final String userName;

  const _ConversationTile({
    Key? key,
    required this.conversation,
    // required this.userName,
  }) : super(key: key);

  Widget buildThumbImage(String? thumbUrl, {double size = 40}) {
    return thumbUrl != null && thumbUrl.isNotEmpty
        ? Image.network(
            thumbUrl,
            width: size,
            height: size,
            fit: BoxFit.fill,
            errorBuilder: (context, error, stackTrace) => Icon(
              Icons.image_not_supported,
              size: size * 0.45,
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.9 * 255).round()),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 85, // Increased image size
          height: 85, // Increased image size
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.grey.shade200,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: buildThumbImage(
              conversation.product.thumb,
              size: 85,
            ),
          ),
        ),
        title: Text(
          conversation.product.title ?? 'No Title',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              conversation.lastMessage ?? 'No messages',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '₹${conversation.product.price ?? 0}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.blue,
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatTime(conversation.lastMessageTime),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.grey,
              ),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'delete') {
                  // Add your delete functionality here
                  // For example, show a confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Conversation'),
                      content: const Text(
                          'Are you sure you want to delete this conversation?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Add delete logic here
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserChatScreen(
                conversationId: conversation.id,
                product: conversation.product,
                thumb: conversation.product.thumb ?? '',
                title: conversation.product.title ?? '',
                price: conversation.product.price ?? 0.0,
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays == 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }
}
