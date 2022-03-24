import 'package:app/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OTPControllerScreen extends StatefulWidget {
  final String phone;
  final String codeDigits;
  OTPControllerScreen({required this.phone,required this.codeDigits});

  @override
  State<OTPControllerScreen> createState() => _OTPControllerScreenState();
}

class _OTPControllerScreenState extends State<OTPControllerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  final TextEditingController _pinOTPCodeController = TextEditingController();
  final FocusNode _pinOTPCodeFocus = FocusNode();
  String? verificationCode;

  final BoxDecoration pinOTPCodeDecoration = BoxDecoration(
    color: Colors.blueAccent,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.grey),
  );

  @override
  void initState() {
    super.initState();

    verifyPhoneNumber();
  }

  verifyPhoneNumber() async{
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${widget.codeDigits} - ${widget.phone}",
        verificationCompleted: (PhoneAuthCredential credential)  async{
          await FirebaseAuth.instance.signInWithCredential(credential).then((value) => {
          if(value.user != null)
          {
              Navigator.of(context).push(MaterialPageRoute(builder: (c) => HomeScreen())),
          }
          });
        },
      verificationFailed: (FirebaseAuthException e){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message.toString()),
            duration: Duration(seconds: 3),
          ),
        );
      },
      codeSent: (String vID,int? resentToken){
          setState(() {
            verificationCode = vID;
          });
      },
      codeAutoRetrievalTimeout: (String vID){
          setState(() {
            verificationCode = vID;
          });
      },
      timeout: Duration(seconds: 60),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar : AppBar(
        title: Text('OTP Verification'),
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 28,right: 28),
              child: Image.asset("assets/register.png"),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Center(
                child: GestureDetector(
                  onTap: (){
                    verifyPhoneNumber();
                  },
                  child: Text("verifying : ${widget.codeDigits} - ${widget.phone}",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(40),
              child: Pinput(
                focusNode: _pinOTPCodeFocus,
                controller: _pinOTPCodeController,
                pinAnimationType: PinAnimationType.rotation,
                onSubmitted: (pin) async
                {
                  try{
                    await FirebaseAuth.instance.signInWithCredential(
                        PhoneAuthProvider.credential(verificationId: verificationCode!,
                            smsCode: pin)).then((value){
                              if(value.user != null)
                                {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (c) => HomeScreen()));
                                }

                    });
                  }
                  catch(e){
                    FocusScope.of(context).unfocus();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Invalid Otp"),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
    );
  }
}
