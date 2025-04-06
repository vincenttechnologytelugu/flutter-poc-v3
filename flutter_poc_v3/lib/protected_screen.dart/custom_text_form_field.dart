// import 'package:flutter/material.dart';

// class CustomTextFormField extends StatefulWidget {
//   final String labelText;
//   final String hintText;
//   final IconData prefixIcon;
//   final bool readOnly;
//   final TextEditingController controller;

//   const CustomTextFormField({
//     super.key,
//     required this.labelText,
//     required this.hintText,
//     required this.prefixIcon,
//     required this.readOnly,
//     required this.controller,
//   });

//   @override
//   State<CustomTextFormField> createState() => _CustomTextFormFieldState();
// }

// class _CustomTextFormFieldState extends State<CustomTextFormField> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [
//             Colors.deepPurple[100]!,
//             Colors.purple[200]!,
//             Colors.deepPurple[200]!,
//           ],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//         borderRadius: BorderRadius.circular(40.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.deepPurple[200]!.withOpacity(0.3),
//             blurRadius: 35.0,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: TextFormField(
//         readOnly: widget.readOnly,
//         controller: widget.controller,
//         decoration: InputDecoration(
//           labelText: widget.labelText,
//           labelStyle: TextStyle(
//             color: Colors.deepPurple[300],
//             fontWeight: FontWeight.w600,
//             letterSpacing: 1.2,
//             fontSize: 14.0,
         
//             fontFamily: 'Roboto',
//             fontStyle: FontStyle.italic,
//           ),
//           hintText: widget.hintText,
//           hintStyle: TextStyle(
//             color: Colors.deepPurple[200],
//             fontStyle: FontStyle.italic,
//             fontSize: 14.0,
//           ),
//           prefixIcon: Icon(
//             widget.prefixIcon,
//             color: Colors.deepPurple[400],
//             size: 20,
//           ),
//           filled: true,
//           fillColor: Colors.white,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             borderSide: BorderSide.none,
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             borderSide: BorderSide.none,
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20.0),
//             borderSide: BorderSide(
//               color: Colors.deepPurple[400]!,
//               width: 2.0,
//               style: BorderStyle.solid,
//             ),
//           ),
//           contentPadding: const EdgeInsets.symmetric(
//             vertical: 18.0,
//             horizontal: 20.0,
//           ),
//           floatingLabelBehavior: FloatingLabelBehavior.auto,
//           suffixIcon: Container(
//             margin: const EdgeInsets.all(4.0),
//             padding: const EdgeInsets.all(6.0),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.deepPurple[400]!, Colors.purple[200]!],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(
//               Icons.star_border,
//               color: Colors.white,
//               size: 18,
//             ),
//           ),
//         ),
//         style: TextStyle(
//           fontSize: 20.0,
//           color: Colors.deepPurple[800],
//           fontWeight: FontWeight.w500,
//           letterSpacing: 0.5,
         
//           fontFamily: 'Roboto',
//         ),
//         cursorColor: Colors.deepPurple[400],
//         validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
//         keyboardAppearance: Brightness.light,
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData prefixIcon;
  
  final bool readOnly;
  final TextEditingController controller;
  

  const CustomTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    
    required this.readOnly,
    required this.controller,

  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late FocusNode _focusNode;


 @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

    @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25.0),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.grey[300]!.withOpacity(0.5),
              blurRadius: 10.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextFormField(
          autofocus: true,
          enableInteractiveSelection: true,
          readOnly: widget.readOnly,
          controller: widget.controller,
        keyboardType: TextInputType.text,
          onTap: () {
            if (!_focusNode.hasFocus) {
              _focusNode.requestFocus();
              SystemChannels.textInput.invokeMethod('TextInput.show');
            }
          },
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
              fontFamily: 'Roboto',
            ),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.0,
            ),
            prefixIcon: Icon(
              widget.prefixIcon,
              color: Colors.grey[700],
              size: 22,
            ),
            suffixIcon: Icon(
              Icons.bubble_chart,
              color: Colors.blue[700],
            ),
            filled: true,
            fillColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.grey[300]!, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(color: Colors.blue[400]!, width: 2.0),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 20.0,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.grey[900],
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
          cursorColor: Colors.blue[600],
          validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          keyboardAppearance: Brightness.light,
        ),
      ),
    );
  }
}

