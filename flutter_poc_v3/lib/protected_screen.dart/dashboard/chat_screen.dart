// chat_screen.dart
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/custom_bottom_nav_bar.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/user_chat_screen.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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

  String? formatSalary(dynamic salary) {
  if (salary == null) return null;
  
  try {
    num numericSalary = salary is String ? double.parse(salary) : salary;
    return NumberFormat('#,##0', 'en_IN').format(numericSalary);
  } catch (e) {
    return null;
  }
}

String formatPriceDisplay(ProductModel productModel) {
  try {
    if (productModel.category?.toLowerCase() == 'jobs') {
      if (productModel.salary != null) {
        return 'Salary: ₹${formatSalary(productModel.salary) ?? 'Negotiable'}';
      }
      return 'Salary: Negotiable';
    }

    if (productModel.price != null && productModel.price != 0) {
      num price = productModel.price is String 
          ? double.parse(productModel.price.toString()) 
          : productModel.price;
      return 'Price: ₹${NumberFormat('#,##0', 'en_IN').format(price)}';
    }

    return 'Price: N/A';
  } catch (e) {
    return 'Price: N/A';
  }
}


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
          // Make sure thumb is included in the product data
          if (conv['product'] != null && conv['product']['thumb'] != null) {
            conv['product']['thumb'] = conv['product']['thumb'].toString();
          }
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
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Failed to load conversations')),
        // );
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
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
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

class _ConversationTile extends StatefulWidget {
  final Conversation conversation;

  const _ConversationTile({
    // ignore: unused_element_parameter
    super.key,
    required this.conversation,
  });

  @override
  State<_ConversationTile> createState() => _ConversationTileState();
}

class _ConversationTileState extends State<_ConversationTile> {

String? formatSalary(dynamic salary) {
  if (salary == null) return null;
  try {
    num numericSalary = salary is String ? double.parse(salary) : salary;
    return NumberFormat('#,##0', 'en_IN').format(numericSalary);
  } catch (e) {
    return null;
  }
}



  Widget buildThumbImage(String? thumbUrl, {double size = 40}) {
    return thumbUrl != null && thumbUrl.isNotEmpty
        ? Image.network(
            // thumbUrl,
            'http://13.200.179.78/$thumbUrl', // Updated URL construction
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
        color: widget.conversation.isActive ? Colors.white : Colors.grey[200],
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
          width: 85,
          height: 85,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: widget.conversation.isActive
                  ? Colors.grey.shade200
                  : Colors.grey.shade400,
              width: 2,
            ),
          ),
          child: ClipOval(
            child: buildThumbImage(
              widget.conversation.product.thumb,
              size: 125,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.conversation.messages.isNotEmpty)
              Text(
                '${widget.conversation.messages.last.firstName ?? ''} ${widget.conversation.messages.last.lastName ?? ''}'
                    .trim(),
                style: TextStyle(
                  fontSize: 14,
                  color: widget.conversation.isActive
                      ? Colors.grey[600]
                      : Colors.grey[400],
                ),
              ),
            Text(
              (widget.conversation.product.title ?? 'No Title').toUpperCase(),
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
                color: widget.conversation.isActive
                    ? const Color.fromARGB(255, 67, 65, 65)
                    : Colors.grey,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              widget.conversation.lastMessage ?? 'No messages',
              style: TextStyle(
                color: widget.conversation.isActive
                    ? Colors.grey[600]
                    : Colors.grey[400],
                fontSize: 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            // Text(
            //   widget.conversation.product.price != null
            //       ? '₹${NumberFormat('#,##0', 'en_IN').format(widget.conversation.product.price)}'
            //       : 'N/A',
            //   style: const TextStyle(
            //     fontSize: 15,
            //     fontWeight: FontWeight.w900,  
            //     color: Color.fromARGB(255, 13, 1, 1),
            //     letterSpacing: 1.2,
            //     fontFamily: 'Poppins',
            //     fontStyle: FontStyle.normal,
            //   ),
            //   overflow: TextOverflow.ellipsis,
            // )
Text(
  widget.conversation.product.category?.toLowerCase() == 'jobs'
    ? widget.conversation.product.salary != null && widget.conversation.product.salary != 0
        ? '₹${NumberFormat('#,##0', 'en_IN').format(widget.conversation.product.salary)}'
        : 'Salary: Negotiable'
    : widget.conversation.product.price != null && widget.conversation.product.price != 0
        ? '₹${NumberFormat('#,##0', 'en_IN').format(widget.conversation.product.price)}'
        : 'Price: N/A',
  style: const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w900,  
    color: Color.fromARGB(255, 13, 1, 1),
    letterSpacing: 1.2,
    fontFamily: 'Poppins',
    fontStyle: FontStyle.normal,
  ),
  overflow: TextOverflow.ellipsis,
)


          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatDateTime(widget.conversation.lastMessageTime.toString()),
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
                if (widget.conversation
                    .isActive) // Only show deactivate option if conversation is active
                  const PopupMenuItem(
                    value: 'deactivate',
                    child: Row(
                      children: [
                        Icon(
                          Icons.block,
                          color: Colors.orange,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Deactivate',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
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
              onSelected: (value) async {
                try {
                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('token');

                  if (value == 'deactivate') {
                    try {
                      final response = await http.put(
                        Uri.parse('http://13.200.179.78/chat/deactivate'),
                        headers: {
                          'Authorization': 'Bearer $token',
                          'Content-Type': 'application/json',
                        },
                        body: json.encode({
                          'conversationId': widget.conversation.id,
                        }),
                      );

                      if (response.statusCode == 200) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Conversation deactivated successfully')),
                          );
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //           const HomeScreen()), // Navigate to chat tab
                          // );
                          // Find parent ChatScreen and refresh
                          final chatScreenState = context
                              .findAncestorStateOfType<_ChatScreenState>();
                          if (chatScreenState != null) {
                            await chatScreenState
                                ._loadConversationsAndMessages();
                          }
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Failed to deactivate conversation')),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  } else if (value == 'delete') {
                    try {
                      final response = await http.post(
                        Uri.parse(
                            'http://13.200.179.78/chat/removeConversation'),
                        headers: {
                          'Authorization': 'Bearer $token',
                          'Content-Type': 'application/json',
                        },
                        body: json.encode({
                          'conversationId': widget.conversation.id,
                        }),
                      );

                      if (response.statusCode == 200) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Conversation deleted successfully')),
                          );
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const HomeScreen(),
                          //   ),

                          //   // Navigate to chat tab
                          // );
                          // Find parent ChatScreen and refresh
                          final chatScreenState = context
                              .findAncestorStateOfType<_ChatScreenState>();
                          if (chatScreenState != null) {
                            await chatScreenState
                                ._loadConversationsAndMessages();
                          }
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Failed to delete conversation')),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              },
            ),
          ],
        ),
        onTap: widget.conversation.isActive
            ? () {
                final String fullThumbUrl = widget.conversation.product.thumb !=
                            null &&
                        widget.conversation.product.thumb!.isNotEmpty
                    ? 'http://13.200.179.78/${widget.conversation.product.thumb}'
                    : '';
                // Add debug logging
                log('Debug - Original thumb: ${widget.conversation.product.thumb}');
                ('Debug - Full thumb URL: $fullThumbUrl');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserChatScreen(
                      conversationId: widget.conversation.id,
                      product: widget.conversation.product,
                      // thumb: widget.conversation.product.thumb ?? '',
                      thumb: fullThumbUrl, // Pass the full URL
                      title: widget.conversation.product.title ?? '',
                      price: widget.conversation.product.price ?? 0.0,

                      sellerId: widget.conversation.sellerId ?? '',
                      buyerId: widget.conversation.buyerId ?? '',
                      
                       isFromChatScreen: true, // Specify that it's from chat screen
                    ),
                  ),
                );
              }
            : null,
      ),
    );
  }

  

  String _formatDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return 'Recently'; // Default text if date is null or empty
    }

    try {
      final DateTime dateTime = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          if (difference.inMinutes == 0) {
            return 'Just now';
          }
          return '${difference.inMinutes} minutes ago';
        }
        return '${difference.inHours} hours ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'Recently'; // Return default text if date parsing fails
    }
  }



  
}


