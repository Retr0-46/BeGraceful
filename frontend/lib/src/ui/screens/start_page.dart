import 'package:flutter/material.dart';
import '../widgets/registration_page/feature_tile.dart';
import '../screens/registration/registration_page_navigator.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../screens/login_dialog.dart';
import 'package:frontend/src/providers/theme_provider.dart';
import 'package:provider/provider.dart';


class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/start_page/clever-icon.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'BeGraceful',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ] 
                ),
                
                const SizedBox(height: 5),
                const Text(
                  'Your journey to mindful eating starts here',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Align(
            alignment: Alignment.topRight,
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) => IconButton(
                icon: Image.asset(
                  themeProvider.isDarkMode
                      ? 'assets/images/main_page/sun-light-theme.png'
                      : 'assets/images/main_page/moon-dark-theme.png',
                  width: 24,
                  height: 24,
                ),
                onPressed: () {
                  themeProvider.toggleTheme(!themeProvider.isDarkMode);
                },
              ),
            ),
          ),

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
                children: [
                  FeatureTile(
                    icon: Text('🍎'),
                    title: 'Calorie Counter',
                    subtitle: 'Monitor calories, meals, and nutrition with our comprehensive food database',
                    color: Colors.lightBlueAccent,
                  ),
                  FeatureTile(
                    icon: Text('🏃‍♀️‍➡️'),
                    title: 'Activity Tracking',
                    subtitle: 'Log workouts, track steps, and monitor calories burned throughout the day',
                    color: Colors.greenAccent,
                  ),
                  FeatureTile(
                    icon: Text('🥗'),
                    title: 'Healthy Recipes',
                    subtitle: 'Discover personalized recipes based on your preferences and dietary needs',
                    color: Colors.orangeAccent,
                  ),
                  FeatureTile(
                    icon: Text('🎯'),
                    title: 'Personal Goals',
                    subtitle: 'Set weight goals and track progress with personalized calorie recommendations',
                    color: Colors.purpleAccent,
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Small changes lead to big results.\nLet\'s begin!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onBackground),
            ),
          ),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegistrationPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4B4DE9), Color(0xFFA033DF)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        'Get Started',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Login button (outlined style)
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    side: BorderSide(color: Theme.of(context).colorScheme.onBackground),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    alignment: Alignment.center,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => const LoginDialog(),
                    );
                  },
                  child: Text(
                    'Already Have An Account? Log In',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
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


