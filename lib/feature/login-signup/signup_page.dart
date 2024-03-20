import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:silver_genie/feature/login-signup/login_page.dart';
import 'package:silver_genie/feature/login-signup/otp_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _mobileController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                  width: screenWidth * 0.5, 
                  height: screenHeight * 0.3, 
                  child: Image.asset('assets/splash/sg_logo.png'), 
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: screenHeight * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Enter Full Name",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextField(
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: 'Enter Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "Enter Email",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Enter E-mail',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "Mobile Number",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      hintText: "Enter Mobile Number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPScreen(
                              phoneNumber: _mobileController.text,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        )
                      ),
                      child: Text('Sign Up',style: TextStyle(
                        color: Colors.black
                      ),),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  SizedBox(height: screenHeight * 0.03),
                ],
              ),
              Row(
                    mainAxisAlignment: MainAxisAlignment.center,      
                    children: [
                      Text("Dont have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()));
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                        ),
                      )
                    ],
                  )
            ],
          ),
        ),
      ),
    );
  }
}