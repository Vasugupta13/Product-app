import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:product_app/UI/post/Product%20Screen/product_screen.dart';

import '../../Widgets/round_button.dart';
import '../../utils/utils.dart';

class VerifyCode extends StatefulWidget {
  final String verificationId;

  const VerifyCode({super.key, required this.verificationId});

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  final verifyCode = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: verifyCode,
              decoration: const InputDecoration(
                hintText: 'Enter verification code',
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            RoundButton(
              title: 'Verify',
              loading: loading,
              onTap: ()async {
                setState(() {
                  loading = true;
                });
                final credential = PhoneAuthProvider.credential(
                  verificationId: widget.verificationId,
                  smsCode: verifyCode.text.toString(),
                );

                try{
                  await auth.signInWithCredential(credential);
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const ProductScreen(),),);
                }catch(e){
                  setState(() {
                    loading = false;
                  });
                  Utils().toastMessage(e.toString());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
