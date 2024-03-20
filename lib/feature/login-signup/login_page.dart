import 'package:flutter/material.dart';
import 'package:silver_genie/core/widgets/divider.dart';
import 'package:silver_genie/feature/login-signup/otp_screen.dart';
import 'package:silver_genie/feature/login-signup/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String routeName = 'login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //TextEditingController _mobileController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
                width: screenWidth * 0.5, 
                height: screenHeight * 0.4, 
                child: Image.asset('assets/splash/sg_logo.png'), 
              ),
              SizedBox(height: screenHeight * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Login",
                  style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.w600),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  "Enter your email or phone number",
                  style: TextStyle(fontSize: 20.0),
                ),
                SizedBox(height: screenHeight * 0.01),
                TextField(
                  //controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Enter your email address or phone',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OTPScreen(
                            //phoneNumber: _mobileController.text,
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
                    child: Text('Login',style: TextStyle(
                      color: Colors.black
                    ),),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
                DividerComponent(),
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
                                builder: (context) => SignUpScreen()));
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                      ),
                    )
                  ],
                )
          ],
        ),
      ),
    );
  }
}
