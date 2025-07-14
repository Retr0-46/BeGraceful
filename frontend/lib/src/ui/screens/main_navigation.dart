import 'package:flutter/material.dart';
import 'package:frontend/src/ui/screens/profile/profile_screen.dart';
import 'package:frontend/src/ui/screens/home_page.dart';
import 'package:frontend/src/mock_data.dart';
import 'package:frontend/src/storage/user_temp_storage.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  @override
void initState() {
  super.initState();
  UserTempStorage.setUser(demoUser); 
}

  final List<Widget> _pages = [
    HomePage(), 
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}