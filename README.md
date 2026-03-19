# ## Overview

MastersApp is a full-featured fitness and nutrition application built with Flutter. It combines authentication, state management, and real-world API integrations into a scalable mobile app.

The application allows users to:
- Track meals using natural language input
- Automatically convert text into structured nutritional data
- Search and explore workouts with visual guidance (GIFs)
- Manage personal fitness and nutrition data in one place

It is designed to demonstrate how a production-style Flutter app integrates external APIs, handles dynamic data, and maintains a clean architecture.

## Key Features

- Authentication system with OTP verification
- Provider-based global state management
- Natural language meal parsing (e.g. "2 eggs and toast")
- Integration with Nutrition API to extract calories and macros
- Workout search using external API with GIF-based guidance
- Meal tracking and nutritional breakdown
- Workout tracking and exploration
- Dynamic routing with arguments
- Profile and settings management

## App Flow

1. App Launch  
   - Splash screen initializes Firebase and providers  

2. Authentication Flow  
   - Sign in / Sign up / OTP verification  
   - AuthProvider manages session state  

3. Home Dashboard  
   - Central hub for meals and workouts  

4. Meal Tracking  
   - User inputs natural language (e.g. "chicken rice and salad")  
   - Nutrition API parses input into structured meal data  
   - MealProvider stores and updates state  
   - Nutritional breakdown is displayed  

5. Workout Exploration  
   - Users search workouts by name or body part  
   - Exercise API returns workouts with GIF demonstrations  
   - WorkoutProvider manages results and state  

6. Tracking & State Management  
   - Meals and workouts are tracked within the app state  
   - Providers ensure UI updates in real-time  

7. Profile & Settings  
   - User data managed via UserProvider  
   - Editable profile and preferences  

## Tech Stack

- Flutter
- Dart
- Provider (State Management)
- Firebase (Authentication)
- Nutrition API (Natural language → structured meal data)
- Exercise API (Workout data with GIFs)
 
