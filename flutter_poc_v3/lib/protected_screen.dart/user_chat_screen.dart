// user_chat_screen.dart
// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/models/product_model.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserChatScreen extends StatefulWidget {
  final String conversationId;
  final ProductModel product;
  final String thumb;
  final String title;
  final double price;
   final bool isFromChatScreen; // Add this parameter
   final String buyerId;    // Add this
  final String sellerId;   // Add this
  final List<dynamic>? initialMessages;


  const UserChatScreen({
    super.key,
    required this.conversationId,
    required this.thumb,
    required this.title,
    required this.price,
    required this.product,
       required this.buyerId,    // Add this
    required this.sellerId,   // Add this
    this.initialMessages,
     this.isFromChatScreen = false, // Default to false
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

  String? formatSalary(dynamic salary) {
  if (salary == null) return null;
  try {
    num numericSalary = salary is String ? double.parse(salary) : salary;
    return NumberFormat('#,##0', 'en_IN').format(numericSalary);
  } catch (e) {
    return null;
  }
}


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
      log('Load messages token: $token');
      log('Load messages userId: $currentUserId');
//        if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Token Not Found")),
//         );
       
// // 
// Navigator.push(
//   context,
//   MaterialPageRoute(builder: (context) => LoginScreen()),
// );
//         return;
//       }


      final response = await http.post(
        Uri.parse('http://13.200.179.78/chat/messages'),
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
         if (token == null) {
        // Check if context is still valid
        if (!context.mounted) return;

        Get.snackbar(
          'Login Required',
          'Please login to continue',
          snackStyle: SnackStyle.FLOATING,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor:
              const Color.fromARGB(255, 232, 235, 239).withOpacity(0.8),
          colorText: const Color.fromARGB(255, 12, 65, 0),
          margin: const EdgeInsets.all(10),
          duration: const Duration(seconds: 2),
        );

        // Use Get.to instead of Navigator
        Get.to(() => const LoginScreen());
        return;
      }

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
        Uri.parse('http://13.200.179.78/chat/send'),
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

  

Widget buildThumbImage(ProductModel product) {
  // Use the existing getFirstImageUrl() method from ProductModel
  String imageUrl = product.getFirstImageUrl();

  return Container(
    width: 90,
    height: 90,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
    ),
    child: imageUrl.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                );
              },
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
            ),
          )
        : Container(
            color: Colors.grey[300],
            child: const Icon(Icons.image_not_supported),
          ),
  );
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true, // Add this
      backgroundColor: const Color.fromARGB(255, 217, 221, 240),
      appBar: AppBar(
        elevation: 0, // Remove shadow
        backgroundColor: const Color.fromARGB(255, 249, 246, 246), // Modern clean look
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.black87), // Modern back icon
          onPressed: () => Navigator.pop(context),
        ),
      
        title: Row(
mainAxisAlignment: MainAxisAlignment.center,
          children: [
            

          
             // Show product image only if not from chat screen
      if (!widget.isFromChatScreen) 
        buildThumbImage(widget.product),
      
      // Show chat thumbnail only if from chat screen
      if (widget.isFromChatScreen)
        Container(
          width: 60,
          height: 60,
          margin: const EdgeInsets.only(right: 10),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: ClipOval(
            child: widget.thumb.isNotEmpty
                ? Image.network(
                    widget.thumb,
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.image_not_supported,
                      size: 20,
                      color: Colors.grey,
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
                : const Icon(
                    Icons.image_not_supported,
                    size: 20,
                    color: Colors.grey,
                  ),
            ),
          ),
           
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   
                    widget.product.title?.toUpperCase() ?? 'No Title',
                     // Converts text to uppercase
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                      
                      
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Text(
                  //   '₹${widget.product.price?.toString() ?? '0.0'}',
                  //   style: const TextStyle(
                  //     fontSize: 13,
                  //     color: Colors.green,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  Text(
  widget.product.category?.toLowerCase() == 'jobs'
      ? 'Salary: ${formatSalary(widget.product.salary) ?? 'N/A'}'
      :  widget.product.price != null &&  widget.product.price.toString() != "0"
          ? '₹${NumberFormat('#,##0', 'en_IN').format(
               widget.product.price is String 
                  ? num.tryParse( widget.product.price) ?? 0 
                  :  widget.product.price
            )}'
          :  widget.product.category?.toLowerCase() == 'jobs'
              ? 'Salary: Negotiable'
              : 'Price: N/A',
  style: const TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 7, 13, 6),
    letterSpacing: 1.2,
    fontStyle: FontStyle.normal,
  ),
  overflow: TextOverflow.ellipsis,
)

                ],
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(179, 220, 210, 210)
                  .withAlpha((0.9 * 255).round()),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withAlpha((0.9 * 255).round()),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.call, color: Colors.green),
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
                  value: 'delete',
                  child: Row(
                    children:  [
                      Icon(Icons.block, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      // Text('DELETE'),


                      TextButton(
  onPressed: () async {
    // Close the current dialog first
    Navigator.pop(context);
    
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Conversation'),
          content: const Text('Are you sure you want to delete this conversation?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close confirmation dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Close confirmation dialog
                Navigator.pop(context);
                
                try {
                  final prefs = await SharedPreferences.getInstance();
                  final token = prefs.getString('token');

                  final response = await http.post(
                    Uri.parse('http://13.200.179.78/chat/removeConversation'),
                    headers: {
                      'Authorization': 'Bearer $token',
                      'Content-Type': 'application/json',
                    },
                    body: json.encode({
                      'conversationId': widget.conversationId,
                    }),
                  );

                  if (response.statusCode == 200) {
                    if (context.mounted) {
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Conversation deleted successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                      Navigator.pop(context);

                      // // Navigate back to chat screen
                      // Navigator.pushAndRemoveUntil(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const HomeScreen(),
                      //   ),
                      //   (route) => false,
                      // );
                    }
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to delete conversation'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  },
  child: const Text(
    'Delete',
    style: TextStyle(color: Colors.red),
  ),
),

                    ],
                  ),
                ),
                // PopupMenuItem(
                //   value: 'report',
                //   child: Row(
                //     children: const [
                //       Icon(Icons.flag, size: 20, color: Colors.orange),
                //       SizedBox(width: 8),
                //       Text('Report'),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),

     
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
                          final previousMessage = index > 0 ? messages[index - 1] : null;


                      return _MessageBubble(message: message,

                       previousMessage: previousMessage,
                       buyerId: widget.buyerId,
                       sellerId: widget.sellerId,
                


                        
                       
                      );
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
                  color: Colors.grey.withAlpha((0.9 * 255).round()),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Row(
                //   children: [
                //     Expanded(
                //       child: ElevatedButton(
                //         onPressed: () {},
                //         child: const Text('Chat'),
                //       ),
                //     ),
                //     const SizedBox(width: 12),
                //     Expanded(
                //       child: ElevatedButton(
                //         onPressed: () {},
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.green,
                //         ),
                //         child: const Text('Make Offer'),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                         autofocus: false, // Add this
                          enableInteractiveSelection: true, // Add this
  keyboardType: TextInputType.text, // Specify keyboard type
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



// class _MessageBubble extends StatefulWidget {
//   final Message message;
//   final Message? previousMessage; // Add this to compare timestamps
  

//   const _MessageBubble({
//     required this.message,
//     this.previousMessage,
//   });

//   @override
//   State<_MessageBubble> createState() => _MessageBubbleState();
// }

// class _MessageBubbleState extends State<_MessageBubble> {

  

// String getMessageTime() {
//   final messageDate = widget.message.createdAt.toLocal();
//   final now = DateTime.now();
//   final difference = now.difference(messageDate);
  
//   final timeFormat = DateFormat('h:mm a'); // 12-hour format with AM/PM

//   if (difference.inMinutes < 1) {
//     return 'Just now';
//   } else if (difference.inMinutes < 60) {
//     return '${difference.inMinutes}m ago';
//   } else if (difference.inHours < 24) {
//     return '${difference.inHours}h ago';
//   } else if (difference.inDays == 1) {
//     return 'Yesterday at ${timeFormat.format(messageDate)}';
//   } else if (difference.inDays < 7) {
//     final dayName = DateFormat('EEEE').format(messageDate); // Full day name
//     return '$dayName at ${timeFormat.format(messageDate)}';
//   } else if (difference.inDays < 365) {
//     return DateFormat('MMM d').format(messageDate); // Month and day
//   } else {
//     return DateFormat('MMM d, y').format(messageDate); // Month, day and year
//   }
// }


//   bool shouldShowDate() {
//     if (widget.previousMessage == null) return true;
    
//     final previousDate = widget.previousMessage!.createdAt;
//     final currentDate = widget.message.createdAt;
    
//     return !DateUtils.isSameDay(previousDate, currentDate);
//   }
//   @override
//   Widget build(BuildContext context) {
//     // Explicitly check if the message is from current user
//     final isSentMessage = widget.message.isFromCurrentUser;

//     return Column(
//       children: [
//         if (shouldShowDate())
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: Center(
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   getMessageTime(),
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey[600],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         Align(
//           // Force alignment based on message type
//           alignment: isSentMessage ? Alignment.centerRight : Alignment.centerLeft,
//           child: Container(
//             constraints: BoxConstraints(
//               maxWidth: MediaQuery.of(context).size.width * 0.75,
//             ),
//             margin: const EdgeInsets.symmetric(vertical: 4),
//             child: Column(
//               crossAxisAlignment: isSentMessage 
//                   ? CrossAxisAlignment.end 
//                   : CrossAxisAlignment.start,
//               children: [
//                 // Only show sender name for received messages
//                 if (!isSentMessage && 
//                     (widget.message.firstName != null || 
//                      widget.message.lastName != null))
//                   Padding(
//                     padding: const EdgeInsets.only(left: 12, bottom: 4),
//                     child: Text(
//                       '${widget.message.firstName ?? ''} ${widget.message.lastName ?? ''}'
//                           .trim(),
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 10,
//                   ),
//                   decoration: BoxDecoration(
//                     // Different colors for sent and received messages
//                     color: isSentMessage
//                         ? const Color(0xFF2B7FFF) // Blue for sent messages
//                         : const Color.fromARGB(255, 189, 211, 24),       // Grey for received messages
//                     borderRadius: BorderRadius.only(
//                       topLeft: const Radius.circular(16),
//                       topRight: const Radius.circular(16),
//                       bottomLeft: Radius.circular(isSentMessage ? 16 : 4),
//                       bottomRight: Radius.circular(isSentMessage ? 4 : 16),
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.05),
//                         blurRadius: 4,
//                         offset: const Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: isSentMessage 
//                         ? CrossAxisAlignment.end 
//                         : CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         widget.message.content,
//                         style: TextStyle(
//                           color: isSentMessage ? Colors.white : const Color.fromARGB(221, 249, 248, 248),
//                           fontSize: 18,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       Text(
//                         DateFormat('hh:mm a').format(
//                           widget.message.createdAt.toLocal()
//                         ),
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: isSentMessage
//                               ? Colors.white.withOpacity(0.7)
//                               : const Color.fromARGB(255, 13, 2, 2),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }



class _MessageBubble extends StatefulWidget {
  final Message message;
  final Message? previousMessage;
  final String buyerId;    // Add this
  final String sellerId;   // Add this

  const _MessageBubble({
    required this.message,
    this.previousMessage,
    required this.buyerId,    // Add this
    required this.sellerId,   // Add this
  });

  @override
  State<_MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<_MessageBubble> {

  String getMessageTime() {
  final messageDate = widget.message.createdAt.toLocal();
  final now = DateTime.now();
  final difference = now.difference(messageDate);
  
  final timeFormat = DateFormat('h:mm a'); // 12-hour format with AM/PM

  if (difference.inMinutes < 1) {
    return 'Just now';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h ago';
  } else if (difference.inDays == 1) {
    return 'Yesterday at ${timeFormat.format(messageDate)}';
  } else if (difference.inDays < 7) {
    final dayName = DateFormat('EEEE').format(messageDate); // Full day name
    return '$dayName at ${timeFormat.format(messageDate)}';
  } else if (difference.inDays < 365) {
    return DateFormat('MMM d').format(messageDate); // Month and day
  } else {
    return DateFormat('MMM d, y').format(messageDate); // Month, day and year
  }
}


  bool shouldShowDate() {
    if (widget.previousMessage == null) return true;
    
    final previousDate = widget.previousMessage!.createdAt;
    final currentDate = widget.message.createdAt;
    
    return !DateUtils.isSameDay(previousDate, currentDate);
  }
  @override
  Widget build(BuildContext context) {
    // Determine message alignment based on senderId
    final isSenderMessage = widget.message.senderId == widget.sellerId;

    return Column(
      children: [
        if (shouldShowDate())
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  getMessageTime(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ),
          ),
        Align(
          // Align based on sender type
          alignment: isSenderMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              crossAxisAlignment: isSenderMessage 
                  ? CrossAxisAlignment.end 
                  : CrossAxisAlignment.start,
              children: [
                // Show sender name for received messages
                if (!isSenderMessage && 
                    (widget.message.firstName != null || 
                     widget.message.lastName != null))
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 4),
                    child: Text(
                      '${widget.message.firstName ?? ''} ${widget.message.lastName ?? ''}'
                          .trim(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSenderMessage
                        ? const Color(0xFF2B7FFF) // Seller message color
                        : const Color.fromARGB(255, 189, 211, 24), // Buyer message color
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isSenderMessage ? 16 : 4),
                      bottomRight: Radius.circular(isSenderMessage ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: isSenderMessage 
                        ? CrossAxisAlignment.end 
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.message.content,
                        style: TextStyle(
                          color: isSenderMessage ? Colors.white : const Color.fromARGB(221, 249, 248, 248),
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('hh:mm a').format(
                          widget.message.createdAt.toLocal()
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          color: isSenderMessage
                              ? Colors.white.withOpacity(0.7)
                              : const Color.fromARGB(255, 13, 2, 2),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
   final String? firstName;  // Add this
  final String? lastName;   // Add this

  Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.isFromCurrentUser,
    this.firstName,         // Add this
    this.lastName,         // Add this
  });

  factory Message.fromJson(Map<String, dynamic> map, String currentUserId) {
     final senderName = map['senderName'] as Map<String, dynamic>?;
    return Message(
      id: map['_id']?.toString() ?? '',
      senderId: map['senderId']?.toString() ?? '',
      content: map['content']?.toString() ?? '',
       createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()).toLocal(), // Convert to local time
      isFromCurrentUser: map['senderId']?.toString() == currentUserId,
        firstName: senderName?['first_name']?.toString(),
      lastName: senderName?['last_name']?.toString(),
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
