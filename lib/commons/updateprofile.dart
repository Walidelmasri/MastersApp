import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/providers/userprovider.dart';
import 'package:apptrial3/providers/authprovider.dart';
import 'package:apptrial3/services/authservice.dart';
class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  File? _imageFile;
  String _selectedActivityLevel = 'Moderately Active'; // Default activity level

  final ImagePicker _picker = ImagePicker();
  String _selectedGender = 'Male'; // Default gender

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthenticationProvider>().user;
    if (user != null) {
      _nameController.text = user.name;
      _usernameController.text = user.username ?? '';
      _ageController.text = user.age?.toString() ?? '';
      _weightController.text = user.weight?.toString() ?? '';
      _heightController.text = user.height?.toString() ?? '';
      _selectedGender = user.gender ?? 'Male';
      if (user.photoURL != null && user.photoURL!.isNotEmpty) {
        _imageFile = File(user.photoURL!);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery); // You can use ImageSource.camera to take a photo
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
//On confirmation of update show user new BMI and BMR
//as well as caloric intake per day
  void _showUpdateConfirmationDialog(double bmi, double bmr, double caloricIntake) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Successful'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your profile has been updated successfully.'),
            SizedBox(height: 10),
            Text('BMI: ${bmi.toStringAsFixed(2)}'),
            Text('BMR: ${bmr.toStringAsFixed(2)}'),
            Text('Basic Caloric Intake: ${caloricIntake.toStringAsFixed(2)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); //Close the dialog
              Navigator.of(context).pop(); //Close the screen as well
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
//function to calculate
  double _calculateBMI(double weight, double height) {
    return weight / (height * height);
  }

  double _calculateBMR(double weight, double height, int age, String gender) {
    if (gender == 'male') {
      return 5 + (10.0 * weight) + (6.25 * height * 100) - (5.0 * age);
    } else {
      return (10.0 * weight) + (6.25 * height * 100) - (5.0 * age) - 161.0;
    }
  }

  double _calculateCaloricIntake(double bmr, String activityLevel) {
    switch (activityLevel) {
      case 'sedentary':
        return bmr * 1.2;
      case 'lightly active':
        return bmr * 1.375;
      case 'moderately active':
        return bmr * 1.55;
      case 'very active':
        return bmr * 1.725;
      case 'extra active':
        return bmr * 1.9;
      default:
        return bmr * 1.2;
    }
  }

  // Add a method to upload the image to Firebase Storage
  Future<String?> _uploadImage(File image) async {
    try {
      String filePath = 'user_images/${AuthService.getUserId()}/${DateTime.now()}.png'; // Unique file path
      UploadTask uploadTask = FirebaseStorage.instance.ref().child(filePath).putFile(image);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }
//Update the users records after calculations using height weight and age
  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      String? photoURL;
      if (_imageFile != null) {
        photoURL = await _uploadImage(_imageFile!);
      }
      final userProvider = context.read<UserProvider>();
      final activityLevel = 'moderately active'; // Or fetch from user data
      final age = int.parse(_ageController.text);
      final weight = double.parse(_weightController.text);
      final height = double.parse(_heightController.text);

      final bmi = _calculateBMI(weight, height);
      final bmr = _calculateBMR(weight, height, age, _selectedGender);
      final caloricIntake = _calculateCaloricIntake(bmr, activityLevel);

      userProvider.updateUserData(
        name: _nameController.text,
        username: _usernameController.text,
        age: age,
        weight: weight,
        height: height,
        gender: _selectedGender,
        bmi: bmi,
        bmr: bmr,
        caloricIntake: caloricIntake,
        photoURL: photoURL ?? _imageFile?.path,
      ).then((_) {
        //Show confirmation dialog after update is successful
        _showUpdateConfirmationDialog(bmi, bmr, caloricIntake);
      }).catchError((error) {

        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Update Failed'),
            content: Text('There was an error updating your profile. Please try again.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: _imageFile == null
                    ? CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/default_avatar.png'),
                )
                    : CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(_imageFile!),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Photo'),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  final age = int.tryParse(value);
                  //Age has to be between 14 and 99 years old
                  if (age == null || age < 14 || age > 99) {
                    return 'Please enter a valid age between 14 and 99';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(labelText: 'Weight (kg)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  final weight = double.tryParse(value);
                  //Weight cannot be more than 400
                  if (weight == null || weight <= 0 || weight > 400) {
                    return 'Please enter a valid weight';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _heightController,
                decoration: InputDecoration(labelText: 'Height (m)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  final height = double.tryParse(value);
                  //Height cannot be more than 3m
                  if (height == null || height <= 0 || height > 3) {
                    return 'Please enter a valid height';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                items: ['Male', 'Female','Other'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your gender';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedActivityLevel,
                items: [
                  'Sedentary',
                  'Lightly Active',
                  'Moderately Active',
                  'Very Active',
                  'Extra Active'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedActivityLevel = newValue!;
                  });
                },
                decoration: InputDecoration(labelText: 'Lifestyle'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your lifestyle';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
