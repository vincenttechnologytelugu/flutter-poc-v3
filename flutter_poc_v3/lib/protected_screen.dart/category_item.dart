// import 'package:flutter/material.dart';

// class CategoryItem extends StatefulWidget {
//   final Map<String, dynamic> item;
//   final VoidCallback onTap;

//   const CategoryItem({Key? key, required this.item, required this.onTap})
//       : super(key: key);

//   @override
//   _CategoryItemState createState() => _CategoryItemState();
// }

// class _CategoryItemState extends State<CategoryItem> {
//   double _scale = 1.0;

//   void _handleTapDown(TapDownDetails details) {
//     setState(() {
//       _scale = 0.95; // Scale down on tap
//     });
//   }

//   void _handleTapUp(TapUpDetails details) {
//     setState(() {
//       _scale = 1.0; // Scale back up
//     });
//     widget.onTap(); // Navigate after animation
//   }

//   void _handleTapCancel() {
//     setState(() {
//       _scale = 1.0; // Reset if tap is canceled
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTapDown: _handleTapDown,
//       onTapUp: _handleTapUp,
//       onTapCancel: _handleTapCancel,
//       child: AnimatedScale(
//         scale: _scale,
//         duration: const Duration(milliseconds: 100),
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             onTap: () {}, // Handled by GestureDetector
//             borderRadius: BorderRadius.circular(24),
//             splashColor: widget.item["color"].withOpacity(0.2),
//             highlightColor: widget.item["color"].withOpacity(0.1),
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     widget.item["color"].withOpacity(0.05),
//                     widget.item["color"].withOpacity(0.1),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(24),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.1),
//                     blurRadius: 20,
//                     spreadRadius: 2,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//                 border: Border.all(
//                   color: Colors.grey.withOpacity(0.1),
//                   width: 1,
//                 ),
//               ),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(20), // Larger icon area
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(
//                         colors: [
//                           widget.item["color"].withOpacity(0.9),
//                           widget.item["color"].withOpacity(0.7),
//                         ],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: widget.item["color"].withOpacity(0.3),
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       widget.item["icon"],
//                       size: 40, // Larger icon
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12),
//                     child: Text(
//                       widget.item["caption"],
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.grey.shade800,
//                         letterSpacing: 0.3,
//                       ),
//                       textAlign: TextAlign.center,
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class CategoryItem extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback onTap;

  const CategoryItem({super.key, required this.item, required this.onTap});

  @override
  _CategoryItemState createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem> {
  double _scale = 1.0;

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _scale = 0.95; // Scale down on tap
    });
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // Scale back up
    });
    widget.onTap(); // Trigger navigation here
  }

  void _handleTapCancel() {
    setState(() {
      _scale = 1.0; // Reset if tap is canceled
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            splashColor: widget.item["color"].withOpacity(0.2),
            highlightColor: widget.item["color"].withOpacity(0.1),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.item["color"].withOpacity(0.05),
                    widget.item["color"].withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          widget.item["color"].withOpacity(0.9),
                          widget.item["color"].withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.item["color"].withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.item["icon"],
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      widget.item["caption"],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                        letterSpacing: 0.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}