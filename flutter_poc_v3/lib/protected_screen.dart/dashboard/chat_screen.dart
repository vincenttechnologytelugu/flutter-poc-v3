import 'package:flutter/material.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/sell_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Chats Text
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Chats',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Main Tabs
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade200),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.blue,
                tabs: const [
                  Tab(text: 'ALL'),
                  Tab(text: 'BUYING'),
                  Tab(text: 'SELLING'),
                ],
              ),
            ),
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
          //         Column(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: [
          //             Icon(
          //                         Icons.chat_bubble_outline,
          //                         size: 64,
          //                         color: Colors.grey[300],
          //                       ),
          //                       SizedBox(height: 16),
          //                         Text(
          //   'You have got no message so far!',
          //   style: TextStyle(
          //     color: Colors.grey[600],
          //     fontSize: 16,
          //     fontWeight: FontWeight.w500,
          //   ),
          // ),
          //  const SizedBox(height: 8),
          // Text(
          //   'As soon as someone send you a message,\nit will start appearing here',
          //   textAlign: TextAlign.center,
          //   style: TextStyle(
          //     color: Colors.grey[500],
          //     fontSize: 14,
          //   ),
          // ),
          // SizedBox(height: 10,),
          //   ElevatedButton(
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => SellScreen()),
          //     );
          //   },
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.blue,
          //     padding: const EdgeInsets.symmetric(
          //       horizontal: 24,
          //       vertical: 12,
          //     ),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //     ),
          //   ),
          //   child: const Text(
          //     'Start Selling',
          //     style: TextStyle(
          //       fontSize: 16,
          //       fontWeight: FontWeight.w500,
          //     ),
          //   ),
          // ),

          //           ],
          //         ),
                  Center(child:  ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SellScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Start Selling',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),),
        
        

                Center(child:  ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SellScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Start Selling',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),),
                   Center(child:  ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SellScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Start Selling',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




















// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/dashboard/sell_screen.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> with SingleTickerProviderStateMixin {
//   TabController? _mainTabController;  // Make nullable
//   TabController? _filterTabController;  // Make nullable

//   @override
//   void initState() {
//     super.initState();
//     // Initialize in initState
//     _mainTabController = TabController(length: 3, vsync: this);
//     _filterTabController = TabController(length: 4, vsync: this);
//   }

//   Widget _buildQuickLink(String title, IconData icon) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       child: OutlinedButton.icon(
//         onPressed: () {},
//         icon: Icon(icon, size: 18),
//         label: Text(title),
//         style: OutlinedButton.styleFrom(
//           foregroundColor: Colors.grey[700],
//           side: BorderSide(color: Colors.grey.shade300),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(  // Wrap with DefaultTabController
//       length: 3,
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Padding(
//               padding: EdgeInsets.all(16.0),
//               child: Text(
//                 'Chats',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(color: Colors.grey.shade200),
//                 ),
//               ),
//               child: const TabBar(  // Remove controller here
//                 labelColor: Colors.blue,
//                 unselectedLabelColor: Colors.grey,
//                 indicatorColor: Colors.blue,
//                 tabs: [
//                   Tab(text: 'ALL'),
//                   Tab(text: 'BUYING'),
//                   Tab(text: 'SELLING'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: Row(
//                 children: [
//                   _buildQuickLink('All Chats', Icons.chat_outlined),
//                   _buildQuickLink('Unread', Icons.mark_email_unread_outlined),
//                   _buildQuickLink('Important', Icons.star_border),
//                   _buildQuickLink('Archived', Icons.archive_outlined),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               child: Text(
//                 'QUICK FILTERS',
//                 style: TextStyle(
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600,
//                   color: Colors.grey[600],
//                   letterSpacing: 0.5,
//                 ),
//               ),
//             ),
//             Container(
//               decoration: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(color: Colors.grey.shade200),
//                 ),
//               ),
//               child: const TabBar(  // Remove controller here
//                 labelColor: Colors.blue,
//                 unselectedLabelColor: Colors.grey,
//                 indicatorColor: Colors.blue,
//                 isScrollable: true,
//                 tabs: [
//                   Tab(text: 'All'),
//                   Tab(text: 'MEETING'),
//                   Tab(text: 'UNREAD'),
//                   Tab(text: 'IMPORTANT'),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.chat_bubble_outline,
//                       size: 64,
//                       color: Colors.grey[300],
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'You have got no message so far!',
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 16,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'As soon as someone send you a message,\nit will start appearing here',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.grey[500],
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => SellScreen()),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 24,
//                           vertical: 12,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: const Text(
//                         'Start Selling',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _mainTabController?.dispose();  // Add null check
//     _filterTabController?.dispose();  // Add null check
//     super.dispose();
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/dashboard/sell_screen.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'Chats',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           // First TabBar - ALL, BUYING, SELLING
//           DefaultTabController(
//             length: 3,
//             child: TabBar(
//               tabs: const [
//                 Tab(text: 'ALL'),
//                 Tab(text: 'BUYING'),
//                 Tab(text: 'SELLING'),
//               ],
//               labelColor: Colors.blue,
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: Colors.blue,
//             ),
//           ),
//           const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Text(
//               'QUICK FILTERS',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//           // Second TabBar - All, MEATING, UNREAD, IMPORTANT
//           DefaultTabController(
//             length: 4,
//             child: TabBar(
//               tabs: const [
//                 Tab(text: 'All'),
//                 Tab(text: 'MEATING'),
//                 Tab(text: 'UNREAD'),
//                 Tab(text: 'IMPORTANT'),
//               ],
//               labelColor: Colors.blue,
//               unselectedLabelColor: Colors.grey,
//               indicatorColor: Colors.blue,
//             ),
//           ),
//           // Empty state message
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text(
//                     'You have got no message so far!\nAs soon as someone send you a message,\nit will start appearing here',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.grey,
//                       fontSize: 16,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SellScreen()));
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
//                     ),
//                     child: const Text(
//                       'Start Selling',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';

// class ChatScreen extends StatefulWidget {
//   const ChatScreen({super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text('Chat Screen '),
//       ),
//     );
//   }
// }