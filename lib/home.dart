import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> hearts = []; // List to hold heart widgets
  int heartCount = 0; // Keeps track of the number of hearts

  // Function to create a new falling heart
  void addHeart() {
    setState(() {
      heartCount++;
      hearts.add(AnimatedHeart()); // Add new heart
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: const Center(
          child: Text(
            'Home',
            style: TextStyle(color: Colors.white),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
      ),
      body: Stack(
        children: [
          // Display hearts
          ...hearts,
          // Center content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to the Home Screen!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: addHeart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[200], // Consistent with the theme
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  child: const Text('Count Hearts', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedHeart extends StatefulWidget {
  const AnimatedHeart({super.key});

  @override
  _AnimatedHeartState createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, -1), // Start from top
      end: const Offset(0, 1), // Move down
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ));
    _controller.forward(); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -100, // Start offscreen, above the app bar
      left: (MediaQuery.of(context).size.width * (0.5 + (0.5 - (0.5 - (0.5 + 0.5))))) -
          35, // Random X-position for each heart
      child: SlideTransition(
        position: _animation,
        child: Icon(
          Icons.favorite,
          size: 40,
          color: Colors.pink[200],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
