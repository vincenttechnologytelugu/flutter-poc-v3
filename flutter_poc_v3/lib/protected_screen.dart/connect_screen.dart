import 'package:flutter/material.dart';

class ConnectScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userMobile;

  const ConnectScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userMobile,
  });

  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  // Implement your chat screen UI and logic here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat one'),
      ),
      body:Column(
        children: [
          Text('User Name: ${widget.userName}'),
          Text('User Email: ${widget.userEmail}'),
          Text('User Mobile: ${widget.userMobile}'),
        ],
      ) // Your chat UI implementation
    );
  }
}
