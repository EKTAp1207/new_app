import 'package:app/OTPController.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, String? title}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String dialCodeDigits = "+00";
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 28,right: 28),
              child: Image.asset("assets/login.png"),
            ),

            Container(
              margin: EdgeInsets.only(top: 10),
              child: Center(
                child: Text(
                  "phone no authentication",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,fontFamily: 'Arial'),
                ),
              ),
            ),
            SizedBox(
              height: 50
            ),

            SizedBox(
              width: 400,
              height: 60,
              child: CountryCodePicker(
                onChanged: (country){
                  setState(() {
                    dialCodeDigits = country.dialCode!;
                  });
                },
                initialSelection: "Ind",
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                favorite: ["+91","Ind","+1","US"],
              ),
            ),

            Container(
              margin: EdgeInsets.only(top: 10,right: 10,left: 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "phone number",
                  prefix: Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(dialCodeDigits),
                  )
                ),
                maxLength: 12,
                keyboardType: TextInputType.number,
                controller: _controller,
              ),
            ),

            Container(
              margin: EdgeInsets.all(15),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (c) => OTPControllerScreen(
                    phone: _controller.text,
                    codeDigits: dialCodeDigits,
                  )));
                },
                child: Text("Next",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),

            ),

            ),
          ],
        ),
      ),
    );
  }
}
