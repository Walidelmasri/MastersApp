import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:apptrial3/providers/authprovider.dart';

class OTPVerificationPage extends StatelessWidget {
  final TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //Retrieve verificationId passed from the arguments
    final verificationId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('OTP Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the OTP sent to your phone',
              style: TextStyle(fontSize: 18),
            ),
            TextFormField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'OTP',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final otp = otpController.text.trim();
                if (otp.isNotEmpty) {
                  //Once verified login the user and send him to the homepage
                  try {
                    await context.read<AuthenticationProvider>().verifyPhoneNumber(
                      verificationId,
                      otp,
                    );
                    // Navigator.pushReplacementNamed(context, '/signIn');
                    Navigator.pop(context);
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Verification failed: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter OTP')),
                  );
                }
              },
              child: Text('Verify OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
