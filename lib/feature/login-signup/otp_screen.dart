import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

// class OTPScreen extends StatelessWidget {
//   //final String phoneNumber;

//   OTPScreen({required this.phoneNumber});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }
class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body:SingleChildScrollView(
        child: Padding(
         padding: const EdgeInsets.all(20.0),
         child: Column(
          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            Container(
                  width: screenWidth * 0.5, 
                  height: screenHeight * 0.3, 
                  child: Image.asset('assets/splash/sg_logo.png'), 
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                    "Verify OTP",
                    style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                Text(
                    "We have just sent you 4 digit code to your email and phone number",
                    style: TextStyle(fontSize: 20.0),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                PinCodeTextField(
              appContext: context,
              length: 4, 
              onChanged: (value) {
                // Handle OTP changes
              },
              onCompleted: (value) {
                // Handle successful OTP entry
                print("Completed: $value");
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 56,
                fieldWidth: 56,
                activeColor: Colors.blue,
                inactiveColor: Colors.grey,
                selectedColor: Colors.black,
              ),
              ),
              SizedBox(height: screenHeight * 0.02),
               SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                      onPressed: () {
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        )
                      ),
                      child: Text('Continue',style: TextStyle(
                        color: Colors.black
                      ),),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,      
                    children: [
                      Text("Didn't recieve OTP?"),
                      TextButton(
                        onPressed: () {
                        },
                        child: Text(
                          "Resend",
                          style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                        ),
                      )
                    ],
                  )
          ],
         ),
         ),
      )
    );
  }
}