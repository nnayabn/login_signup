import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:login_signup/login_screen.dart';
import 'package:audioplayers/audioplayers.dart'; // Music

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> hearts = [];
  final Random random = Random();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool isPlaying = false;
  String? currentSong;

  final List<String> songs = [
    'music/Espresso - Sabrina Carpenter (1).mp3',
    'music/Blue-song.mp3', // <-- Add more song files here
    'music/co2.mp3',
  ];

  void addFallingHeart() {
    double screenWidth = MediaQuery.of(context).size.width;
    double randomLeft = random.nextDouble() * (screenWidth - 50);

    setState(() {
      hearts.add(
        AnimatedHeart(
          key: UniqueKey(),
          leftPosition: randomLeft,
          onAnimationComplete: () {
            setState(() {
              hearts.removeAt(0);
            });
          },
        ),
      );
    });
  }

  Future<void> playSong(String songPath) async {
    await _audioPlayer.stop(); // Stop previous if any
    await _audioPlayer.play(AssetSource(songPath), volume: 1.0);
    setState(() {
      isPlaying = true;
      currentSong = songPath;
    });
  }

  Future<void> toggleMusic() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else if (currentSong != null) {
      await _audioPlayer.resume();
    } else {
      await playSong(songs[0]); // Default play first song if nothing selected
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void openSongPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return ListView.builder(
          itemCount: songs.length,
          itemBuilder: (context, index) {
            String songName = songs[index].split('/').last;
            return ListTile(
              leading: const Icon(Icons.music_note, color: Colors.pink),
              title: Text(songName),
              onTap: () {
                Navigator.pop(context); // Close bottom sheet
                playSong(songs[index]);
              },
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: const Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_music, color: Colors.white),
            onPressed: openSongPicker, // Open song picker
          ),
        ],
      ),
      body: Stack(
        children: [
          ...hearts,
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to the HeartBeats!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.pink),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: addFallingHeart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink[200],
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  ),
                  child: const Text('Count Hearts', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
                const SizedBox(height: 20),

                // 🌟 Glowing Music Button
                AnimatedScale(
                  duration: const Duration(seconds: 1),
                  scale: isPlaying ? 1.1 : 1.0,
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: isPlaying
                          ? [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.8),
                          spreadRadius: 8,
                          blurRadius: 16,
                        ),
                      ]
                          : [],
                    ),
                    child: ElevatedButton(
                      onPressed: toggleMusic,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPlaying ? Colors.redAccent : Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      ),
                      child: Text(
                        isPlaying ? 'Pause Music' : 'Play Music',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
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
  final double leftPosition;
  final VoidCallback onAnimationComplete;

  const AnimatedHeart({super.key, required this.leftPosition, required this.onAnimationComplete});

  @override
  _AnimatedHeartState createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart> {
  double _topPosition = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() {
    Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        _topPosition = MediaQuery.of(context).size.height;
      });
    });

    Future.delayed(const Duration(seconds: 3), widget.onAnimationComplete);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 3),
      top: _topPosition,
      left: widget.leftPosition,
      child: Image.asset('assets/images/heart.png', width: 50, height: 50),
    );
  }
}
