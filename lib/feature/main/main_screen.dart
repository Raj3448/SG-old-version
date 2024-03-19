import 'package:flutter/material.dart';
import 'package:silver_genie/feature/bookings/bookings_screen.dart';
import 'package:silver_genie/feature/home/home_screen.dart';
import 'package:silver_genie/feature/profile/profile_screen.dart';
import 'package:silver_genie/feature/services/services_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final pages = [
    const HomeScreen(),
    const ServicesScreen(),
    const BookingsScreen(),
    const ProfileScreen(),
  ];

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: pages[index],
      ),
      bottomNavigationBar: SizedBox(
        height: 70,
        child: BottomNavigationBar(
          backgroundColor: Colors.white,
          elevation: 8,
          selectedLabelStyle:
              TextStyle(color: Colors.grey.shade900, fontSize: 14),
          currentIndex: index,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          unselectedLabelStyle:
              TextStyle(color: Colors.grey.shade400, fontSize: 14),
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(
                Icons.home,
                color: Colors.grey.shade400,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Services',
              icon: Icon(
                Icons.home_repair_service_outlined,
                color: Colors.grey.shade400,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Bookings',
              icon: Icon(
                Icons.watch_later_outlined,
                color: Colors.grey.shade400,
              ),
            ),
            BottomNavigationBarItem(
              label: 'Health profile',
              icon: Icon(
                Icons.person,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
