import 'package:flutter/material.dart';

class NoticificationsScreen extends StatefulWidget {
  const NoticificationsScreen({super.key});

  @override
  State<NoticificationsScreen> createState() => _NoticificationsScreenState();
}

class _NoticificationsScreenState extends State<NoticificationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Noticifications"),
      ),
    );
  }

}