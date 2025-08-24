import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Emergency',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        // Custom AppBar theme with a transparent background for our gradient
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // Custom BottomNavigationBar theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color.fromARGB(255, 32, 11, 69),
          unselectedItemColor: Color.fromARGB(255, 113, 111, 111),
          elevation: 10,
        ),
      ),
      home: const LandingScreen(),
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int _currentIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // _pages = [
    //   const HomePage(),
    //   const SampleNavigationApp(),
    //   const AccountsPage(),
    // ];
  }

  // void _onItemTapped(int index) {
  //   if (index == 2) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => const AccountsPage()),
  //     );
  //   } else {
  //     setState(() {
  //       _currentIndex = index;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // When not on the Maps page, show an AppBar with a custom gradient background.
      appBar:
          _currentIndex == 1
              ? null
              : PreferredSize(
                preferredSize: const Size.fromHeight(56.0),
                child: AppBar(
                  title: const Text("Emergency"),
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 47, 40, 40), // Light red
                          Color.fromARGB(255, 39, 36, 34), // Light skin colour
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                ),
              ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Maps'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Accounts',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Updated background gradient for the HomePage: light red to light skin tone.
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 47, 40, 40), // Light red
            Color.fromARGB(255, 39, 36, 34), // Light skin colour
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      // Fade-in animation for a smooth appearance
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: const Duration(seconds: 2),
        builder: (context, double opacity, child) {
          return Opacity(opacity: opacity, child: child);
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.home, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text(
                'Welcome Home!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Every Moment Counts.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
