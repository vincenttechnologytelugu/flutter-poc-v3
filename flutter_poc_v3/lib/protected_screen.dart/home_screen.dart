
import 'package:flutter/material.dart';



import 'package:flutter_poc_v3/protected_screen.dart/dashboard/chat_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/dashhome_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/my_adds.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/profile_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/dashboard/sell_screen.dart';

import 'package:flutter_poc_v3/protected_screen.dart/homeappbar_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/introduction_screen.dart';
import 'package:flutter_poc_v3/protected_screen.dart/location_screen.dart';


import 'package:flutter_poc_v3/public_screen.dart/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
   
  final pageController = PageController();


  String? userName;
  int currentIndex = 0;
  
  

String selectedLocation = 'Select Location';
  // Define screens list properly
  final List<Widget> _screens = [
    
    const DashhomeScreen(),
    IntroductionScreen(),
    // const ChatScreen(),
    const SellScreen(),
    const MyAdds(),
    const ProfileScreen(),
  ];

  // List of screen titles
  // final List<String> _screenTitles = [
  //   '', // Empty for home screen as it uses HomeappbarScreen
  //   'Chat',
  //   'Sell',
  //   'My Ads',
  //   'Profile',
  // ];

  @override
  void initState() {
    super.initState();
    loadUserData();
  }
 
// In your home screen
Future<void> showLocationScreen() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const LocationScreen()),
  );
  
  if (result != null) {
    setState(() {
      // Update your app bar with the selected location
      selectedLocation = result.toString();
    });
     // Fetch products based on new location
     

  }
}

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('first_name') ?? 'User';
    });
  }

  PreferredSizeWidget _buildAppBar() {
    if (currentIndex == 0) {
      // Home screen - use HomeappbarScreen
      return  PreferredSize(
        preferredSize:const Size.fromHeight(60),
        child: HomeappbarScreen(location: selectedLocation), // Pass the location here
      );
    } else {
      // Other screens - use simple AppBar with Olx logo
      return AppBar(
        elevation: 0.0,
        backgroundColor: const Color.fromARGB(255, 173, 171, 171),
        title: const Text(
          "U Sales",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      );
    }
  }

  Future<void> logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout ?? false) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.clear();

        Fluttertoast.showToast(
          msg: "Logged out successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
        );

        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Logout failed: $e",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    }
  }


  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: [
      //       DrawerHeader(
      //         decoration: const BoxDecoration(
      //           color: Color.fromARGB(255, 173, 171, 171),
      //         ),
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             const Text(
      //               'Welcome!',
      //               style: TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 24,
      //               ),
      //             ),
      //             const SizedBox(height: 10),
      //             Text(
      //               userName ?? 'User',
      //               style: const TextStyle(
      //                 color: Colors.white,
      //                 fontSize: 18,
      //               ),
      //             ),
      //           ],
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.location_on),
      //         title: Text(selectedLocation),
      //         onTap: _showLocationScreen,
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.logout),
      //         title: const Text('Logout'),
      //         onTap: logout,
      //       ),
      //     ],
      //   ),
      // ),
      
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 20,
        iconSize: 25,
        backgroundColor: Colors.grey,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Color.fromARGB(255, 171, 5, 189)),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat, color: Color.fromARGB(255, 171, 5, 189)),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline, color:  Color.fromARGB(255, 171, 5, 189)),
            label: "Sell",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded, color: Color.fromARGB(255, 171, 5, 189)),
            label: "My Ads",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Color.fromARGB(255, 171, 5, 189)),
            label: "Profile",
          ),
        ],
        type: BottomNavigationBarType.fixed,
     
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color.fromARGB(179, 22, 1, 1),
      ),
      body: _screens[currentIndex],
    );
  }
}
