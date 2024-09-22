import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
//Change the page controller to affect the circle around the arrow
//If the 3 pages are done then clicking the arrow navigates user to signin page
  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.animateToPage(
        _currentPage + 1,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/signIn');
    }
  }

  @override
  Widget build(BuildContext context) {
    double progress = 1 - (_currentPage + 1) / 3;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/signIn');
            },
            child: Text('Skip', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              children: [
                OnboardingPage(
                  title: 'Track Your Workouts',
                  description: 'Here is some information about our app.',
                  imagePath: 'images/boarding1.png',
                ),
                OnboardingPage(
                  title: 'Watch What You Eat',
                  description: 'Explore the amazing features we offer.',
                  imagePath: 'images/boarding2.png',
                ),
                OnboardingPage(
                  title: 'Start Your Fitness Journey',
                  description: 'Let\'s get started with your journey.',
                  imagePath: 'images/boarding3.png',
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: progress),
            duration: Duration(seconds: 1),
            builder: (context, value, _) => CircularPercentIndicator(
              radius: 50.0,
              lineWidth: 8.0,
              backgroundColor: Colors.purple,
              progressColor: Colors.white,
              percent: value,
              center: Material(
                shape: CircleBorder(),
                color: Colors.purple,
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  onPressed: _nextPage,
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Icon(
                      Icons.east_rounded,
                      size: 38.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
//Avoiding code redundancy by using Onboarding Page Template to build the three pages
class OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
//Needs title, description and an image
  OnboardingPage({required this.title, required this.description, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath),
          SizedBox(height: 20),
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(description, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
