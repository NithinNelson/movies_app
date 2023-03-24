import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/screens/login/otp.dart';
import 'package:movies_app/utils/snackBar.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);
  static String verify = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController _phnController = TextEditingController();
  bool buttonLoading = false;

  @override
  void initState() {
    countryController.text = "+91";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Enter your phone number for verification",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.purple),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.purple),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextField(
                      controller: _phnController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Phone",
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: () {
                      setState(() {
                        buttonLoading = true;
                      });
                      _phoneVerifiction();
                    },
                    child: buttonLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text("Sent OTP")),
              )
            ],
          ),
        ),
      ),
    );
  }

  _phoneVerifiction() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '${countryController.text + _phnController.text}',
      verificationCompleted: (PhoneAuthCredential credential) {
        setState(() {
          buttonLoading = false;
        });
        snackBar(context, "Verification Code Sent");
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() {
          buttonLoading = false;
        });
        print('---verificationFailed----${e.toString()}');
        snackBar(context, "Connection problem / Invalid phone number");
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          buttonLoading = false;
        });
        MyPhone.verify = verificationId;
        snackBar(context, "Verification Code Sent");
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return MyOTP();
        }));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          buttonLoading = false;
        });
        snackBar(context, "Verification Timeout");
      },
    );
  }
}
