import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/screens/home_screen.dart';
import 'package:movies_app/utils/snackBar.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController countryController = TextEditingController();
  TextEditingController _phnController = TextEditingController();
  TextEditingController _pinEditingController = TextEditingController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String verify = "";
  String? number;
  bool buttonLoading = false;
  bool otp = false;

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
              Text(
                otp ? "Enter the OTP" : "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                otp
                    ? "An OTP send to registered phone number"
                    : "Enter your phone number for verification",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              otp ? _otpField() : _phoneField(),
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
                      otp ? _otpVerification() : _phoneVerifiction();
                    },
                    child: buttonLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(otp ? "Verify OTP" : "Sent OTP")),
              ),
              otp
                  ? Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                otp = !otp;
                              });
                            },
                            child: Text(
                              "Edit Phone Number ?",
                              style: TextStyle(color: Colors.black),
                            ))
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  _phoneVerifiction() async {
    if (_phnController.text.isNotEmpty) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '${countryController.text + _phnController.text}',

        verificationCompleted: (PhoneAuthCredential credential) {
          setState(() {
            buttonLoading = false;
          });
          _phnController.clear();
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
            number = _phnController.text;
            verify = verificationId;
            buttonLoading = false;
            otp = !otp;
          });
          _phnController.clear();
          snackBar(context, "Verification Code Sent");
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            buttonLoading = false;
          });
          if(!mounted) return;
          snackBar(context, "Verification Timeout");
        },
      );
    } else {
      setState(() {
        buttonLoading = false;
      });
      snackBar(context, "Enter Phone Number");
    }
  }

  _otpVerification() async {
    if (_pinEditingController.text.isNotEmpty) {
      String user = number ?? "";

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: verify, smsCode: _pinEditingController.text);

        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential);
        await prefs.setString('login', user);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }), (route) => false);
      } catch (e) {
        setState(() {
          buttonLoading = false;
        });
        snackBar(context, "Enter Correct OTP");
      }
      _pinEditingController.clear();
    } else {
      setState(() {
        buttonLoading = false;
      });
      snackBar(context, "Enter OTP");
    }
  }

  Widget _phoneField() {
    return Container(
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
    );
  }

  Widget _otpField() {
    return Pinput(
      length: 6,
      controller: _pinEditingController,
      // defaultPinTheme: defaultPinTheme,
      // focusedPinTheme: focusedPinTheme,
      // submittedPinTheme: submittedPinTheme,
      showCursor: true,
      onCompleted: (pin) {
        print('-----------$pin');
      },
    );
  }
}

