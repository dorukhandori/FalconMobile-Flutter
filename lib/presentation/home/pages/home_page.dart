import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auth_app/domain/models/user.dart';

class HomePage extends ConsumerWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ana Sayfa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implement logout
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hoş geldiniz, ${user.email}'),
            const SizedBox(height: 20),
            // Diğer ana sayfa içeriği buraya eklenebilir
          ],
        ),
      ),
    );
  }
}
