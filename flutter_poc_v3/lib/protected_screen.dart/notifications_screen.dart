import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> notifications = [];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  void showMessage(String message) {
    // Use ScaffoldMessenger instead of Toast
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ScaffoldMessenger(
        key: _scaffoldKey,
        child: Scaffold(
          backgroundColor: Colors.grey[100],
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: const Text(
              'Notifications',
              style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black54),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: notifications.isNotEmpty
                ? [
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.black54),
                      onPressed: () {
                        setState(() {
                          notifications.clear();
                        });
                        showMessage('All notifications cleared');
                      },
                    ),
                  ]
                : null,
          ),
          body: SafeArea(
            child: notifications.isEmpty
                ? _buildEmptyState()
                : _buildNotificationsList(),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 175, 180, 180).withAlpha((0.9 * 255).round()),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.notifications_off_outlined,
                        size: 86,
                        color: const Color.fromARGB(255, 232, 92, 5),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'No Notifications Yet',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'We\'ll notify you when something arrives',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        showMessage('Refreshing notifications...');
                        // Add your refresh logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: _buildNotificationItem(notification),
        );
      },
    );
  }

  Widget _buildNotificationItem(NotificationItem notification) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          setState(() {
            notification.isRead = true;
          });
          showMessage('Notification marked as read');
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildNotificationIcon(notification.type),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: TextStyle(
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(notification.time),
                      style: TextStyle(
                        fontSize: 12,
                        color: const Color.fromARGB(255, 243, 136, 136),
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 227, 231, 235),
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type) {
    IconData iconData;
    Color iconColor;

    switch (type) {
      case NotificationType.product:
        iconData = Icons.shopping_bag_outlined;
        iconColor = Colors.blue;
        break;
      case NotificationType.order:
        iconData = Icons.receipt_long_outlined;
        iconColor = Colors.green;
        break;
      case NotificationType.offer:
        iconData = Icons.local_offer_outlined;
        iconColor = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withAlpha((0.9 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return DateFormat('MMM d, y').format(time);
    }
  }
}

enum NotificationType {
  product,
  order,
  offer,
}

class NotificationItem {
  final String title;
  final String message;
  final DateTime time;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});

//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }

// class _NotificationsScreenState extends State<NotificationsScreen> {
//   // Dummy notification data - you can replace this with your actual data
//   final List<NotificationItem> notifications = [
//     // Comment out or empty this list to test empty state
//     /*NotificationItem(
//       title: "New Product Added",
//       message: "iPhone 15 Pro Max is now available",
//       time: DateTime.now().subtract(const Duration(minutes: 5)),
//       type: NotificationType.product,
//       isRead: false,
//     ),*/
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.white,
//         title: const Text(
//           'Notifications',
//           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
//         ),
//         actions: notifications.isNotEmpty
//             ? [
//                 IconButton(
//                   icon: const Icon(Icons.delete_outline, color: Colors.black54),
//                   onPressed: () {
//                     setState(() {
//                       notifications.clear();
//                     });
//                   },
//                 ),
//               ]
//             : null,
//       ),
//       body: notifications.isEmpty
//           ? _buildEmptyState()
//           : _buildNotificationsList(),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(32),
//             decoration: BoxDecoration(
//               color: Colors.blue.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.notifications_off_outlined,
//               size: 86,
//               color: Colors.blue[300],
//             ),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'No Notifications Yet',
//             style: TextStyle(
//               fontSize: 24,
//               color: Colors.grey[800],
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'We\'ll notify you when something arrives',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 32),
//           ElevatedButton(
//             onPressed: () {
//               // Add refresh functionality here
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.blue,
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(25),
//               ),
//             ),
//             child: const Text('Refresh'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationsList() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(8),
//       itemCount: notifications.length,
//       itemBuilder: (context, index) {
//         final notification = notifications[index];
//         return _buildNotificationItem(notification);
//       },
//     );
//   }

//   Widget _buildNotificationItem(NotificationItem notification) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: notification.isRead ? Colors.white : Colors.blue[50],
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: _buildNotificationIcon(notification.type),
//         title: Text(
//           notification.title,
//           style: TextStyle(
//             fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 8),
//             Text(
//               notification.message,
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _formatTime(notification.time),
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//         onTap: () {
//           setState(() {
//             notification.isRead = true;
//           });
//         },
//         trailing: !notification.isRead
//             ? Container(
//                 width: 12,
//                 height: 12,
//                 decoration: const BoxDecoration(
//                   color: Colors.blue,
//                   shape: BoxShape.circle,
//                 ),
//               )
//             : null,
//       ),
//     );
//   }

//   Widget _buildNotificationIcon(NotificationType type) {
//     IconData iconData;
//     Color iconColor;

//     switch (type) {
//       case NotificationType.product:
//         iconData = Icons.shopping_bag_outlined;
//         iconColor = Colors.blue;
//         break;
//       case NotificationType.order:
//         iconData = Icons.receipt_long_outlined;
//         iconColor = Colors.green;
//         break;
//       case NotificationType.offer:
//         iconData = Icons.local_offer_outlined;
//         iconColor = Colors.orange;
//         break;
//     }

//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: iconColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Icon(
//         iconData,
//         color: iconColor,
//         size: 24,
//       ),
//     );
//   }

//   String _formatTime(DateTime time) {
//     final now = DateTime.now();
//     final difference = now.difference(time);

//     if (difference.inMinutes < 60) {
//       return '${difference.inMinutes}m ago';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours}h ago';
//     } else {
//       return DateFormat('MMM d, y').format(time);
//     }
//   }
// }

// enum NotificationType {
//   product,
//   order,
//   offer,
// }

// class NotificationItem {
//   final String title;
//   final String message;
//   final DateTime time;
//   final NotificationType type;
//   bool isRead;

//   NotificationItem({
//     required this.title,
//     required this.message,
//     required this.time,
//     required this.type,
//     this.isRead = false,
//   });
// }















// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart'; // Add this package to pubspec.yaml

// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});

//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }

// class _NotificationsScreenState extends State<NotificationsScreen> {
//   // Dummy notification data
//   final List<NotificationItem> notifications = [
//     NotificationItem(
//       title: "New Product Added",
//       message: "iPhone 15 Pro Max is now available",
//       time: DateTime.now().subtract(const Duration(minutes: 5)),
//       type: NotificationType.product,
//       isRead: false,
//     ),
//     NotificationItem(
//       title: "Order Confirmed",
//       message: "Your order #12345 has been confirmed",
//       time: DateTime.now().subtract(const Duration(hours: 2)),
//       type: NotificationType.order,
//       isRead: true,
//     ),
//     NotificationItem(
//       title: "Special Offer",
//       message: "Get 20% off on all electronics today!",
//       time: DateTime.now().subtract(const Duration(days: 1)),
//       type: NotificationType.offer,
//       isRead: false,
//     ),
//     // Add more notifications as needed
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Notifications'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.delete_outline),
//             onPressed: () {
//               // Add clear all notifications functionality
//             },
//           ),
//         ],
//       ),
//       body: notifications.isEmpty
//           ? _buildEmptyState()
//           : _buildNotificationsList(),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.notifications_off_outlined,
//             size: 86,
//             color: Colors.grey[400],
//           ),
//           const SizedBox(height: 16),
//           Text(
//             'No Notifications',
//             style: TextStyle(
//               fontSize: 24,
//               color: Colors.grey[600],
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             'You\'re all caught up!',
//             style: TextStyle(
//               fontSize: 16,
//               color: Colors.grey[500],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNotificationsList() {
//     return ListView.builder(
//       itemCount: notifications.length,
//       itemBuilder: (context, index) {
//         final notification = notifications[index];
//         return _buildNotificationItem(notification);
//       },
//     );
//   }

//   Widget _buildNotificationItem(NotificationItem notification) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: notification.isRead ? Colors.white : Colors.blue[50],
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             spreadRadius: 1,
//             blurRadius: 4,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: _buildNotificationIcon(notification.type),
//         title: Text(
//           notification.title,
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(height: 8),
//             Text(
//               notification.message,
//               style: const TextStyle(fontSize: 14),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               _formatTime(notification.time),
//               style: TextStyle(
//                 fontSize: 12,
//                 color: Colors.grey[600],
//               ),
//             ),
//           ],
//         ),
//         onTap: () {
//           // Handle notification tap
//           setState(() {
//             notification.isRead = true;
//           });
//         },
//       ),
//     );
//   }

//   Widget _buildNotificationIcon(NotificationType type) {
//     IconData iconData;
//     Color iconColor;

//     switch (type) {
//       case NotificationType.product:
//         iconData = Icons.shopping_bag_outlined;
//         iconColor = Colors.blue;
//         break;
//       case NotificationType.order:
//         iconData = Icons.receipt_long_outlined;
//         iconColor = Colors.green;
//         break;
//       case NotificationType.offer:
//         iconData = Icons.local_offer_outlined;
//         iconColor = Colors.orange;
//         break;
//     }

//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: iconColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Icon(
//         iconData,
//         color: iconColor,
//         size: 24,
//       ),
//     );
//   }

//   String _formatTime(DateTime time) {
//     final now = DateTime.now();
//     final difference = now.difference(time);

//     if (difference.inMinutes < 60) {
//       return '${difference.inMinutes}m ago';
//     } else if (difference.inHours < 24) {
//       return '${difference.inHours}h ago';
//     } else {
//       return DateFormat('MMM d, y').format(time);
//     }
//   }
// }

// enum NotificationType {
//   product,
//   order,
//   offer,
// }

// class NotificationItem {
//   final String title;
//   final String message;
//   final DateTime time;
//   final NotificationType type;
//   bool isRead;

//   NotificationItem({
//     required this.title,
//     required this.message,
//     required this.time,
//     required this.type,
//     this.isRead = false,
//   });
// }


// import 'package:flutter/material.dart';

// class NotificationsScreen extends StatefulWidget {
//   const NotificationsScreen({super.key});

//   @override
//   State<NotificationsScreen> createState() => _NotificationsScreenState();
// }

// class _NotificationsScreenState extends State<NotificationsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar:AppBar(
//         title: Text('Notifications'),
        
//       ),

//       body: Center(
//         child: Text('Notifications Screen'),
//       ),
//     );
//   }
// }

