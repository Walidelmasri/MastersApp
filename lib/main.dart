import 'package:apptrial3/providers/workoutprovider.dart';
import 'package:apptrial3/screens/settings/viewpersonaldetails.dart';
import 'package:apptrial3/screens/workout/workouthistorypage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:apptrial3/providers/authprovider.dart';
import 'package:apptrial3/providers/userprovider.dart';
import 'screens/authsystem/login.dart';
import 'screens/authsystem/signup.dart';
import 'screens/authsystem/otppage.dart';
import 'screens/home.dart';
import 'screens/initialscreens/splash.dart';
import 'screens/initialscreens/onboarding.dart';
import 'screens/authsystem/forgotpassword.dart';
import 'commons/updateprofile.dart';
import 'screens/settings/settingspage.dart';
import 'screens/food/addmeal.dart';
import 'package:apptrial3/services/nutritionxservice.dart';
import 'package:apptrial3/screens/food/productdetails.dart';
import 'package:apptrial3/screens/food/breakdownmeal.dart';
import 'package:apptrial3/providers/mealprovider.dart';
import 'package:apptrial3/screens/workout/bodypartsearch.dart';
import 'package:apptrial3/screens/workout/workoutsearch.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Initialize Firebase
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//Providers used in the application
//They are responsible for managing the application's states
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => MealProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        Provider(create: (_) => SyndigoApiService()),
//Initialize UserProvider based on the AuthProvider state
        ChangeNotifierProxyProvider<AuthenticationProvider, UserProvider?>(
          create: (_) => null,
          update: (_, authProvider, userProvider) {
            if (authProvider.user != null) {
              return UserProvider(userId: authProvider.user!.uid);
            }
            return null; //Return null if no user is logged in
          },
        ),
      ],
      child: MainApp(),
    );
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//Main widget in the application that has to be the root for all other widgets
    return MaterialApp(
      title: 'Fitness4Life',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',//Start with splash screen
      routes: {

        '/': (context) => SplashScreen(),
        '/onboarding': (context) => OnboardingScreen(),
        '/signIn': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
        '/otp': (context) => OTPVerificationPage(),
        '/home': (context) => HomePage(),
        '/forgotpassword': (context) => ForgotPasswordPage(),
        '/updateprofile': (context) => UpdateProfilePage(),
        '/settings': (context) => SettingsPage(),
        '/addMeal': (context) => AddMealPage(),
        '/breakdownMeal': (context) => BreakdownMealPage(),
        '/searchWorkout': (context) => WorkoutSearchPage(),
        '/viewPersonalDetails': (context) => ViewPersonalDetailsPage(),
      },
      //Pages that require some parameters to open need to be wrapped in if statements
      //or else will not initialize routes
      onGenerateRoute: (settings) {
        if (settings.name == '/productDetails') {
          final foodName = settings.arguments as String?;
          return MaterialPageRoute(
            builder: (context) => ProductDetailsPage(foodName: foodName!),
          );
        } else if (settings.name == '/searchBodypart') {
          final bodyPart = settings.arguments as String;
          return MaterialPageRoute(
            builder: (context) => BodypartSearchPage(bodyPart: bodyPart),
          );
        }
        return null; //If the route name is not recognized, return null
      },
    );
  }
}
