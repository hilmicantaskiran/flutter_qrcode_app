import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:student/assets/style/palette.dart';
import 'package:student/core/cache_manager.dart';
import 'package:student/model/environment.dart';
import 'package:student/screens/profile.dart';
import 'package:easy_localization/easy_localization.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with CacheManager {
  late IO.Socket socket;
  final _baseUrl = Environment.apiUrl;

  var logger = Logger();

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  Future<void> initSocket() async {
    try {
      socket = IO.io(_baseUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': true,
      });

      socket.connect();

      socket.on('connect', (_) {
        logger.i('Socket connected');
        socket.emit('message', 'Socket connected');
      });

      socket.on('message', (data) {
        logger.d('Received message: $data');
      });

      socket.on('disconnect', (_) {
        logger.i('Socket disconnected');
      });
    } catch (e) {
      logger.e('Socket error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Image.asset(
                    'lib/assets/images/adu_logo.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                    style: TextStyle(fontSize: 18.0),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: tr('screen.home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            label: tr('screen.profile'),
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Palette.blueToDark[50],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        unselectedItemColor: Palette.whiteToDark[600],
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
                (route) => false,
              );
              break;
            case 1:
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
                (route) => false,
              );
              break;
          }
        },
      ),
    );
  }
}
