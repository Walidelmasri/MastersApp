# MastersApp - Fitness & Nutrition Mobile Application

A fitness and nutrition mobile application built with Flutter that converts natural language input into structured meal data, integrates external APIs for workout discovery, and tracks user activity through a scalable architecture.

## Overview

MastersApp is a production-style Flutter application that combines authentication, state management, and real-world API integrations into a single cohesive system.

The app allows users to:
- Input meals using natural language (e.g. "2 eggs and toast")
- Automatically convert text into structured nutritional data
- Search and explore workouts with visual guidance (GIFs)
- Track meals and workouts in a unified system
- Manage personal profile and fitness-related data

The project focuses on building a maintainable and scalable mobile application using a clean architecture approach.

## Architecture

The application follows a layered and modular structure:

- **Models**
  - `UserModel`, `MealModel`, `WorkoutModel`, `SetModel`

- **Providers (State Management)**
  - `AuthProvider` → Handles authentication state
  - `UserProvider` → Manages user profile data
  - `MealProvider` → Handles meals and nutrition logic
  - `WorkoutProvider` → Manages workout data

- **Services (Business Logic & APIs)**
  - `AuthService`
  - `MealService`
  - `ExerciseDbService`
  - `NutritionxService`

- **Screens (Feature-based)**
  - `authsystem/`
  - `food/`
  - `workout/`
  - `settings/`
  - `initialscreens/`

This separation ensures clean code, scalability, and easier maintenance.

## App Flow

1. App Launch (`/`)
   - Starts at Splash Screen
   - Initializes Firebase and Providers

2. Onboarding (`/onboarding`)
   - Introduces the app for first-time users

3. Authentication Flow
   - `/signIn`
   - `/signup`
   - `/otp` (OTP verification)
   - `/forgotpassword`
   - Managed via `AuthProvider`

4. Home (`/home`)
   - Central dashboard after authentication

5. Meal Tracking
   - User inputs natural language text
   - Nutrition API parses input into structured data
   - Calories and macros are extracted and displayed
   - Managed via `MealProvider`

6. Workout Exploration
   - Search workouts by name or body part
   - Exercise API returns workouts with GIF demonstrations
   - Managed via `WorkoutProvider`

7. Dynamic Navigation
   - Uses `onGenerateRoute` for parameter-based routing
   - Examples:
     - `/productDetails`
     - `/searchBodypart`

8. Profile & Settings
   - Update profile (`/updateprofile`)
   - View personal data (`/viewPersonalDetails`)
   - Manage settings (`/settings`)

9. State Management
   - Providers maintain global state
   - UI updates automatically based on changes

## Screenshots

> Screenshots will be added here.

- [ ] Splash Screen  
- [ ] Authentication Flow (Login / Signup / OTP)  
- [ ] Home Dashboard  
- [ ] Meal Tracking (Natural Language Input)  
- [ ] Workout Search (GIF-based results)  
- [ ] Profile & Settings  

## Tech Stack

- Flutter
- Dart
- Provider (State Management)
- Firebase (Authentication)
- Nutrition API (Natural language → structured meal data)
- Exercise API (Workout data with GIFs)

## Key Features

- Natural language meal parsing
- Nutrition API integration for calorie and macro extraction
- Workout search with GIF-based visual guidance
- Provider-based global state management
- Authentication system with OTP verification
- Modular architecture (models / providers / services / screens)
- Dynamic routing with arguments
- Real-time UI updates based on state

## How to Run

1. Install Flutter SDK  
   https://docs.flutter.dev/get-started/install  

2. Clone the repository  

    git clone https://github.com/Walidelmasri/MastersApp.git
    cd MastersApp

3. Install dependencies  

    flutter pub get

4. Run the application  

    flutter run

## Results

The application runs across:
- Android devices/emulators  
- iOS simulators (Mac only)  
- Web browsers  
- Desktop platforms  

It demonstrates:
- Full authentication flow with OTP
- Natural language processing via external APIs
- Structured state management using Provider
- Modular and scalable application design
- Real-time tracking of meals and workouts

## Future Improvements

- Image-based meal recognition  
  - Detect meals from uploaded images  
  - Convert visual input into nutritional data  

- Personalised fitness recommendations  
  - Calculate BMI and BMR  
  - Suggest workouts and calorie targets dynamically  

- Enhanced nutrition insights  
  - Analyse daily intake  
  - Recommend improvements based on deficiencies  

- Improved UI/UX  
  - Refine design with modern mobile patterns (e.g. glassmorphism)  
  - Improve responsiveness and visual feedback  

- Persistent tracking & analytics  
  - Store long-term user progress  
  - Provide trends and insights over time  

## Notes

This project reflects a production-style mobile application rather than a basic demo. It focuses on combining real-world API integrations, state management, and modular architecture into a scalable system.