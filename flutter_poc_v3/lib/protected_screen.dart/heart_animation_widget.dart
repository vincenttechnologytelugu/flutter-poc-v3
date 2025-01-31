// import 'package:flutter/material.dart';

// class HeartAnimationWidget extends StatefulWidget {
//   const HeartAnimationWidget({Key? key}) : super(key: key);

//   @override
//   State<HeartAnimationWidget> createState() => _HeartAnimationWidgetState();
// }

// class _HeartAnimationWidgetState extends State<HeartAnimationWidget> 
//     with TickerProviderStateMixin {
//   late AnimationController _controller;
//   late List<HeartParticle> hearts;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1500),
//     );
//     hearts = List.generate(
//       5,
//       (index) => HeartParticle(_controller, index * 0.2),
//     );
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller,
//       builder: (context, child) {
//         return Stack(
//           clipBehavior: Clip.none,
//           children: hearts.map((heart) {
//             return Positioned(
//               child: Transform.translate(
//                 offset: Offset(
//                   heart.moveAnimation.value * 20,
//                   -heart.moveAnimation.value * 40,
//                 ),
//                 child: Opacity(
//                   opacity: heart.opacityAnimation.value,
//                   child: Icon(
//                     Icons.favorite,
//                     color: Colors.pink,
//                     size: 20 * heart.scaleAnimation.value,
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         );
//       },
//     );
//   }
// }

// class HeartParticle {
//   final Animation<double> moveAnimation;
//   final Animation<double> scaleAnimation;
//   final Animation<double> opacityAnimation;

//   HeartParticle(AnimationController controller, double delay) :
//     moveAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: Interval(
//           delay,
//           1.0,
//           curve: Curves.easeOut,
//         ),
//       ),
//     ),
//     scaleAnimation = Tween<double>(
//       begin: 0.5,
//       end: 1.5,
//     ).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: Interval(
//           delay,
//           1.0,
//           curve: Curves.easeOut,
//         ),
//       ),
//     ),
//     opacityAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.0,
//     ).animate(
//       CurvedAnimation(
//         parent: controller,
//         curve: Interval(
//           delay + 0.3,
//           1.0,
//           curve: Curves.easeOut,
//         ),
//       ),
//     );
// }
