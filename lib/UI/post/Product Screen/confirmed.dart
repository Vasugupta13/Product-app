import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderPlaced extends StatelessWidget {
  const OrderPlaced({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Order Placed'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: double.infinity,
              child: Center(child: Image.asset('img/tick.png'))),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              "Order Placed Successfully",
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
