import 'package:apptrial3/providers/authprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/providers/userprovider.dart';
import 'package:apptrial3/models/usermodel.dart'; // Import the User model

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileHeader(user),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildSectionTitle('Personal Details'),
                  ListTile(
                    title: Text('View Personal Details'),
                    onTap: () {
                      Navigator.pushNamed(context, '/viewPersonalDetails');
                    },
                  ),
                  ListTile(
                    title: Text('Update Personal Details'),
                    onTap: () {
                      Navigator.pushNamed(context, '/updateprofile');
                    },
                  ),
                  _buildSectionTitle('Account Settings'),
                  ListTile(
                    title: Text('Change Your Email'),
                    onTap: () {
                      Navigator.pushNamed(context, '/changeEmail');
                    },
                  ),
                  ListTile(
                    title: Text('Reset Password'),
                    onTap: () {
                      Navigator.pushNamed(context, '/resetPassword');
                    },
                  ),
                  _buildSectionTitle('Support'),
                  ListTile(
                    title: Text('Support and FAQs'),
                    onTap: () {
                      // Navigator.pushNamed(context, '/supportFaqs');
                    },
                  ),
                  _buildSectionTitle('About'),
                  ListTile(
                    title: Text('About Us'),
                    onTap: () {
                      // Navigator.pushNamed(context, '/aboutUs');
                    },
                  ),
                  ListTile(
                    title: Text('Terms and Conditions'),
                    onTap: () {
                      // Navigator.pushNamed(context, '/termsConditions');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(UserModel? user) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: user != null && user.photoURL != null
              ? NetworkImage(user.photoURL!)
              : AssetImage('assets/images/default_avatar.png') as ImageProvider,
          backgroundColor: Colors.grey[200],
        ),
        SizedBox(height: 10),
        Text(
          user != null ? user.username ?? 'User' : 'Guest',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
