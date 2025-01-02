import 'package:flutter/material.dart';
import 'package:mooncake/mooncake.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mooncake Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      supportedLocales: const [
        Locale('en', 'US'),
      ],
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mooncake Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _result,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String? result = await showDialog<String?>(
                  context: context,
                  builder: (context) => const MooncakeView(),
                );
                if (!context.mounted) return;
                if (result != null && result.isNotEmpty) {
                  setState(() {
                    _result = 'Password: $result';
                  });
                }
              },
              child: const Text('Try Mooncake'),
            ),
          ],
        ),
      ),
    );
  }
}
