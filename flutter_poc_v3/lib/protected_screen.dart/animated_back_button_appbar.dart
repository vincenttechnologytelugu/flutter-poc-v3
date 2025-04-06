




// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AnimatedBackButtonAppBar extends StatefulWidget implements PreferredSizeWidget {
//   final String? title;
//   final VoidCallback onBackButtonPressed;

//   const AnimatedBackButtonAppBar({
//     super.key,
//     this.title,
//     required this.onBackButtonPressed,
//   });

//   @override
//   _AnimatedBackButtonAppBarState createState() => _AnimatedBackButtonAppBarState();

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

// class _AnimatedBackButtonAppBarState extends State<AnimatedBackButtonAppBar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   final List<Color> _borderColors = [
//     Colors.red,
//     Colors.orange,
//     Colors.yellow,
//     Colors.green,
//     Colors.blue,
//     Colors.indigo,
//     Colors.purple,
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 8),
//       vsync: this,
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Color _getCurrentBorderColor(double value) {
//     final double scaledValue = value * (_borderColors.length - 1);
//     final int index = scaledValue.floor();
//     final double lerpValue = scaledValue - index;

//     if (index >= _borderColors.length - 1) {
//       return _borderColors.last;
//     }

//     return Color.lerp(
//       _borderColors[index],
//       _borderColors[index + 1],
//       lerpValue,
//     )!;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       leading: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           final borderColor = _getCurrentBorderColor(_animationController.value);
          
//           return Container(
//             margin: const EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: RadialGradient(
//                 colors: [
//                   borderColor.withOpacity(0.4),
//                   Colors.transparent,
//                 ],
//                 stops: const [0.5, 1.0],
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: borderColor.withOpacity(0.3),
//                   blurRadius: 10,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: borderColor,
//                   width: 2.5,
//                 ),
//               ),
//               child: IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: widget.onBackButtonPressed,
//               ),
//             ),
//           );
//         },
//       ),
//       title: Stack(
//         alignment: Alignment.center,
        
//         children: [
//           RotationTransition(
//             turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
//             child: Container(
//               width: 160,
//               height: 48,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: _getCurrentBorderColor(_animationController.value),
//                   width: 3,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: _getCurrentBorderColor(_animationController.value).withOpacity(0.3),
//                     blurRadius: 10,
//                     spreadRadius: 2,
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               // widget.title ?? 'Product Details',
//                 (widget.title ?? 'Product Details').toUpperCase(), // Added toUpperCase() here
//               style: GoogleFonts.montserrat(
//                 color: Colors.white,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 20,
//                 shadows: [
//                   Shadow(
//                     color: Colors.black.withOpacity(0.2),
//                     blurRadius: 4,
//                     offset: const Offset(2, 2),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       centerTitle: true,
//       elevation: 0,
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.deepPurple.shade800, Colors.purple.shade600],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class AnimatedBackButtonAppBar extends StatefulWidget implements PreferredSizeWidget {
//   final String? title;
//   final VoidCallback onBackButtonPressed;

//   const AnimatedBackButtonAppBar({
//     super.key,
//     this.title,
//     required this.onBackButtonPressed,
//   });

//   @override
//   _AnimatedBackButtonAppBarState createState() => _AnimatedBackButtonAppBarState();

//   @override
//   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
// }

// class _AnimatedBackButtonAppBarState extends State<AnimatedBackButtonAppBar>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;
//   final List<Color> _borderColors = [
//     Colors.red,
//     Colors.orange,
//     Colors.yellow,
//     Colors.green,
//     Colors.blue,
//     Colors.indigo,
//     Colors.purple,
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(seconds: 6),
//       vsync: this,
//     )..repeat();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   Color _getCurrentBorderColor(double value) {
//     final double scaledValue = value * (_borderColors.length - 1);
//     final int index = scaledValue.floor();
//     final double lerpValue = scaledValue - index;

//     if (index >= _borderColors.length - 1) {
//       return _borderColors.last;
//     }

//     return Color.lerp(
//       _borderColors[index],
//       _borderColors[index + 1],
//       lerpValue,
//     )!;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       leading: AnimatedBuilder(
//         animation: _animationController,
//         builder: (context, child) {
//           final borderColor = _getCurrentBorderColor(_animationController.value);

//           return Container(
//             margin: const EdgeInsets.all(8.0),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: borderColor.withOpacity(0.4),
//                   blurRadius: 12,
//                   spreadRadius: 2,
//                 ),
//               ],
//             ),
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: borderColor,
//                   width: 2.5,
//                 ),
//               ),
//               child: IconButton(
//                 icon: const Icon(Icons.arrow_back, color: Colors.white),
//                 onPressed: widget.onBackButtonPressed,
//               ),
//             ),
//           );
//         },
//       ),
//       title: Text(
//         widget.title?.toUpperCase() ?? 'PRODUCT DETAILS',
//         style: GoogleFonts.montserrat(
//           color: Colors.white,
//           fontWeight: FontWeight.w600,
//           fontSize: 20,
//           shadows: [
//             Shadow(
//               color: Colors.black.withOpacity(0.2),
//               blurRadius: 4,
//               offset: const Offset(2, 2),
//             ),
//           ],
//         ),
//       ),
//       centerTitle: true,
//       elevation: 4,
//       shadowColor: Colors.black26,
//       flexibleSpace: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.deepPurple.shade800, Colors.purple.shade600],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//         ),
//       ),
//     );
//   }
// }


// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedBackButtonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? title;
  final VoidCallback onBackButtonPressed;

  const AnimatedBackButtonAppBar({
    super.key,
    this.title,
    required this.onBackButtonPressed,
  });

  @override
  _AnimatedBackButtonAppBarState createState() => _AnimatedBackButtonAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AnimatedBackButtonAppBarState extends State<AnimatedBackButtonAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return GestureDetector(
            onTap: widget.onBackButtonPressed,
            child: Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
                gradient: LinearGradient(
                  colors: [const Color.fromARGB(255, 223, 70, 70).withOpacity(0.2), Colors.white.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Container(
                 decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                 color: const Color.fromARGB(255, 232, 224, 234),
                  width: 0,
                ),
              ),
                 child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: widget.onBackButtonPressed,
              ),
                ),
            ),
          );
        },
      ),
      title: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                colors: [Colors.purpleAccent, Colors.blueAccent],
                stops: [_animationController.value, _animationController.value + 0.3],
              ).createShader(bounds);
            },
            child: Text(
              (widget.title ?? 'Product Details').toUpperCase(),
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          );
        },
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 178, 176, 183), const Color.fromARGB(255, 244, 243, 244)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ],
        ),
      ),
    );
  }
}
