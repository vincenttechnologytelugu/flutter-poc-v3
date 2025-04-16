import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/chat_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/my_adds.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/profile_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/sell_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/home_screen.dart';
import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// class CustomBottomNavBar extends StatefulWidget {
//   final int currentIndex;

//   const CustomBottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

//   @override
//   State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
// }

// class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
//   @override
//   Widget build(BuildContext context) {
    
//        // Don't show bottom nav bar for sell screen
//     //  if (widget.currentIndex == 2) {
//     //   return const SizedBox.shrink(); // Returns an empty widget
//     // }
//     return CurvedNavigationBar(
//       backgroundColor: Colors.transparent,
//       color: const Color.fromARGB(255, 169, 171, 168),
//       buttonBackgroundColor: const Color.fromARGB(255, 1, 179, 25),
//       height: 70,
//       index: widget.currentIndex,
//       items: [
//         _buildNavItem(Icons.home, "Home", 0),
//         _buildNavItem(Icons.chat, "Chats", 1),
//         _buildNavItem(Icons.add_circle_outline, "Selling", 2),
//         _buildNavItem(Icons.favorite_rounded, "Myadds", 3),
//         _buildNavItem(Icons.person, "Profile", 4),
//       ],
//     onTap: (index) {
//   Widget screen;
//   switch (index) {
//     case 0:
//       screen = const HomeScreen();
//       break;
//     case 1:
//       screen = const ChatScreen();
//       break;
//     case 2:
//       screen = const SellScreen();
//       break;
//     case 3:
//       screen = const MyAdds();
//       break;
//     case 4:
//       screen = const ProfileScreen();
//       break;
//     default:
//       screen = const HomeScreen();
//   }
  
//   Navigator.pushReplacement(
//     context,
//     MaterialPageRoute(
//       builder: (context) => screen,
//     ),
//   );
// },

//     );
//   }

//   Widget _buildNavItem(IconData icon, String label, int index) {
//     bool isSelected = widget.currentIndex == index;
//     return Container(
//       margin: EdgeInsets.only(top: 10),
//       height: 50,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             size: 23,
//             color: isSelected ? Colors.white : const Color.fromARGB(255, 15, 12, 17),
//           ),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               color: isSelected ? Colors.white : const Color.fromARGB(255, 15, 12, 17),
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// In custom_bottom_nav_bar.dart

class CustomBottomNavBar extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: const Color.fromARGB(255, 200, 200, 200),
      buttonBackgroundColor: const Color.fromARGB(255, 240, 107, 31),
      height: 70,
      index: currentIndex,
      items: [
        _buildNavItem(Icons.home, "Home", 0),
        _buildNavItem(Icons.chat, "Chats", 1),
        _buildNavItem(Icons.add_circle_outline, "Selling", 2),
        _buildNavItem(Icons.favorite_rounded, "Myadds", 3),
        _buildNavItem(Icons.person, "Profile", 4),
      ],
      onTap: (index) async {
        if (index == 2) { // Sell Screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const SellScreen(),
            ),
            (route) => false,
          );
          return;
        }

        if (index == 1 || index == 3 || index == 4) {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');

          if (token == null) {
            // Store attempted index
            await prefs.setInt('attempted_index', index);
            
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              ).then((_) async {
                final updatedToken = await prefs.getString('token');
                if (updatedToken == null) {
                  setState(() {
                    currentIndex = 0;
                  });
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false,
                    );
                  }
                }
              });
            }
            return;
          }

          try {
            final response = await http.get(
              Uri.parse('http://13.200.179.78/authentication/auth_user'),
              headers: {
                'Authorization': 'Bearer $token',
                'Content-Type': 'application/json',
              },
            );

            if (response.statusCode == 200) {
              setState(() {
                currentIndex = index;
              });

              if (mounted) {
                Widget screen;
                switch (index) {
                  case 1:
                    screen = const ChatScreen();
                    break;
                  case 3:
                    screen = const MyAdds();
                    break;
                  case 4:
                    screen = const ProfileScreen();
                    break;
                  default:
                    screen = const HomeScreen();
                }

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                  (route) => false,
                );
              }
            } else {
              setState(() {
                currentIndex = 0;
              });
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              }
            }
          } catch (e) {
            setState(() {
              currentIndex = 0;
            });
            if (mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            }
          }
        } else {
          setState(() {
            currentIndex = index;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      },
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    bool isSelected = currentIndex == index;
    return Container(
      margin: EdgeInsets.only(top: 10),
      height: 50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 23,
            color: isSelected ? Colors.white : const Color.fromARGB(255, 15, 12, 17),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : const Color.fromARGB(255, 15, 12, 17),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
