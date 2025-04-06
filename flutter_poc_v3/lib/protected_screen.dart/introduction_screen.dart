// import 'package:flutter/material.dart';
// import 'package:animated_introduction/animated_introduction.dart';
// import 'package:flutter_poc_v3/protected_screen.dart/notifications_screen.dart';
// class IntroductionScreen extends StatefulWidget {
//    IntroductionScreen({super.key});
  
//   /// List of pages to be shown in the introduction
// ///
// final List<SingleIntroScreen> pages = [
//   const SingleIntroScreen(
//     title: 'Welcome to the Event Management App !',
    
//     description: 'You plans your Events, We\'ll do the rest and will be the best! Guaranteed!  ',
//     imageNetwork: "https://media.istockphoto.com/id/621856364/photo/certified-tick-icon.jpg?s=2048x2048&w=is&k=20&c=9lLsW0dnMZq3KXViK2RnfOThjEk-pYwvp49D6STK4q0=",

//     // imageAsset: 'assets/images/allevents.png',
//   ),
//   const SingleIntroScreen(
//     title: 'Book tickets to cricket matches and events',
//     description: 'Tickets to the latest movies, crickets matches, concerts, comedy shows, plus lots more !',
//     imageNetwork: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS1fQ_bZkowoTHogTcoZIMEfJ8MakI-08PSaA&s",
//     // imageAsset: 'assets/images/cricket.png',
//   ),
//   const SingleIntroScreen(
//     title: 'Grabs all events now only in your hands',
//     description: 'All events are now in your hands, just a click away ! ',
//     imageNetwork: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTYgFL8YKGFw-g41tSuGfBa5ttbuOG9OTev8Q&s",
//     // imageAsset: 'assets/images/events.png',
//   ),
//     const SingleIntroScreen(
//     title: 'Grabs all events now only in your hands',
//     description: 'All events are now in your hands, just a click away ! ',
//     imageNetwork: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTEqesCYqHmjBw5QqNjc7hJPLx-LESdYftEEw&s",
//     // imageAsset: 'assets/images/events.png',
//   ),
// ];

// /// Example page

//   @override
//   State<IntroductionScreen> createState() => _IntroductionScreenState();
// }

// class _IntroductionScreenState extends State<IntroductionScreen> {
  
//  @override
//   Widget build(BuildContext context) {
//     return AnimatedIntroduction(
    
//       skipText: 'Skip',
//       nextText: 'Next',
//       doneText: 'Done',
 

//       slides: widget.pages,

//       // slides: pages,
//       indicatorType: IndicatorType.circle,


//       onDone: () {
//       Navigator.pushReplacement(
            
//               context,
//               MaterialPageRoute(builder: (context) => const NotificationsScreen()),
//             );
     
//       },
//     );
//   }
// }



