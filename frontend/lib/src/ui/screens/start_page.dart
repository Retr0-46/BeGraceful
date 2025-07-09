import 'package:flutter/material.dart';
import '../widgets/feature_tile.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top banner
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 75, 77, 233), Color.fromARGB(255, 160, 51, 223)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: const [
                Icon(Icons.local_florist, size: 60, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  'BeGraceful',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 5),
                Text(
                  'Your journey to mindful eating starts here',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Center(
            child:
            Text(
              'Our Features',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          
          // Features
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ListView(
                children: const [
                  FeatureTile(
                    icon: Icons.local_dining,
                    title: 'Calorie Counter',
                    subtitle: 'Monitor calories, meals, and nutrition with our comprehensive food database',
                    color: Colors.lightBlueAccent,
                  ),
                  FeatureTile(
                    icon: Icons.directions_run,
                    title: 'Activity Tracking',
                    subtitle: 'Log workouts, track steps, and monitor calories burned throughout the day',
                    color: Colors.greenAccent,
                  ),
                  FeatureTile(
                    icon: Icons.restaurant_menu,
                    title: 'Healthy Recipes',
                    subtitle: 'Discover personalized recipes based on your preferences and dietary needs',
                    color: Colors.orangeAccent,
                  ),
                  FeatureTile(
                    icon: Icons.track_changes,
                    title: 'Personal Goals',
                    subtitle: 'Set weight goals and track progress with personalized calorie recommendations',
                    color: Colors.purpleAccent,
                  ),
                ],
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Small changes lead to big results.\nLet\'s begin!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // TODO: Navigate to login
                    },
                    child: const Text('Log In'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6C63FF),
                    ),
                    onPressed: () {
                      // TODO: Navigate to sign up
                    },
                    child: const Text('Sign Up', style: TextStyle(color: Colors.white),),
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


