import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:product_app/UI/auth/login_screen.dart';
import 'package:product_app/UI/post/Product%20Screen/carousel_slider.dart';
import 'package:product_app/UI/post/Cart/cart_model.dart';
import 'package:product_app/UI/post/Cart/cart_provider.dart';
import 'package:product_app/UI/post/Cart/cart_screen.dart';
import 'package:product_app/UI/post/DB/db_helper.dart';
import 'package:product_app/utils/utils.dart';
import 'package:badges/badges.dart' as badges;
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {

  DBHelper? dbHelper = DBHelper();

  List<String> productName = ['SwiftFit Smartwatch','CozyComfort Throw Blanket','Wanderlust Backpack','FreshBloom Flower Vase','FreshBloom Flower Vase','White Blue Gradient Shoe','GourmetGrind Coffee Grinder','Aromatherapy Diffuser',];
  List<String> productRating = ['4.2/5','4.8/5','4.4/5','4.3/5','4.1/5','4.6/5','3.9/5','4.9/5',];
  List<int> productPrice = [6799, 2299, 4799, 1599, 6129, 2999, 1874, 7399];
  List<String> productImage = [
    'https://rukminim1.flixcart.com/image/850/1000/kolsscw0/smartwatch/c/d/3/wrb-sw-active-std-blk-android-ios-noise-original-imag3f7ta6vxxvxh.jpeg?q=90',
    'https://media1.popsugar-assets.com/files/thumbor/RyLTYFIyPtewlCfJommIn9hq_6A/fit-in/728xorig/filters:format_auto-!!-:strip_icc-!!-/2019/12/11/112/n/40938118/595a04ab5df19ae87e63b6.95421242_/i/best-throw-blankets-on-amazon.jpg',
    'https://images.squarespace-cdn.com/content/v1/569bb1d469a91a75f8117344/1585330875446-KDZ3OU1IV1FMQ5DNO3O8/_7R39374.jpg',
    'https://urbancart.in/cdn/shop/products/1_0f3c2fd2-6969-4f04-952b-8a21f960f231_800x.jpg?v=1657863121',
    'https://media.istockphoto.com/id/1303978937/photo/white-sneaker-on-a-blue-gradient-background-mens-fashion-sport-shoe-sneakers-lifestyle.jpg?s=612x612&w=0&k=20&c=L725fuzFTnm6qEaqE7Urc5q6IR80EgYQEjBn_qtBIQg=',
    'https://cdn.accentuate.io/558241677412/-1672763262488/Blog_Mobile_800x725_Best-Coffee-Grind_@2x-v1680801824918.png?1600x1450w_360',
    'https://m.media-amazon.com/images/I/712hpi7iNiL._AC_UF894,1000_QL80_.jpg',
    'https://m.media-amazon.com/images/I/71g64S28y4L.jpg',
  ];

  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            auth.signOut().then((value) {
              Utils().toastMessage('Logout Successful');
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
            });
          },
          icon: const Icon(Icons.logout_outlined),
        ),
        centerTitle: true,
        title: const Text('Product List'),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>const CartScreen()));
            },
            child: Center(
              child: badges.Badge(
                badgeStyle: const badges.BadgeStyle(
                  badgeColor: Color(0xFFCE93D8),
                ),
                badgeContent: Consumer<CartProvider>(
                  builder: (context, value,  child) {
                    return Text(
                      value.getCounter().toString(),
                      style: const TextStyle(color: Colors.white),
                    );
                  },
                ),
                badgeAnimation: const badges.BadgeAnimation.slide(
                  disappearanceFadeAnimationDuration: Duration(milliseconds: 300),
                  // curve: Curves.easeInCubic,
                ),
                child: const Icon(Icons.shopping_cart),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10,),
            const SizedBox(
              height: 240,
              child: SliderBar(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisExtent: 310,
                    mainAxisSpacing: 12),
                itemCount: productName.length,
                itemBuilder: (_, index ) {
                  return Container(
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child:
                          Image(
                            height: 170,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              productImage[index].toString(),
                            ),
                          ) ,
                        ),
                        Padding(
                          padding:  const EdgeInsets.fromLTRB(8, 4, 8, 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                // height: 54,
                                width: double.infinity,
                                child: Text(
                                  productName[index].toString(),
                                  style: GoogleFonts.manrope(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              const SizedBox(
                                height: 7,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("₹${productPrice[index].toString()}",
                                      style: GoogleFonts.manrope(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500)),
                                  Text(productRating[index].toString(),
                                      style: GoogleFonts.manrope(
                                          color: Colors.grey,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap:()async{
                                        await FirebaseFirestore.instance.collection("Cart").doc(productName[index].toString()).set({
                                          'productName': productName[index].toString(),
                                          'productRating' : productRating[index].toString(),
                                          'image': productImage[index].toString(),
                                          'quantity' : 1,
                                        });
                                      debugPrint('$index');
                                        debugPrint(productName[index].toString());
                                        debugPrint( productPrice[index].toString());
                                        debugPrint( 'productPrice${[index]}');
                                        debugPrint('1');
                                        debugPrint(productRating[index].toString());
                                        debugPrint(productImage[index].toString());

                                      dbHelper?.insert(
                                        Cart(id: index,
                                            productId: (index).toString(),
                                            productName: productName[index].toString(),
                                            productRating: productRating[index].toString(),
                                            initialPrice: productPrice[index],
                                            productPrice: productPrice[index],
                                            quantity: 1,
                                            image: productImage[index].toString())
                                      ).then((value){
                                        debugPrint('Product added to cart');
                                        cart.addTotalPrice(double.parse(productPrice[index].toString()));
                                        cart.addCounter();

                                      }).onError((error, stackTrace) {
                                        debugPrint(error.toString());
                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.deepPurple.shade200,
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Add to Cart',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width:40,
                                    child: ClipRRect(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(
                                          shape: const CircleBorder(),
                                          padding: const EdgeInsets.all(0),
                                          elevation: 0
                                        ),
                                        child: const Icon(
                                          CupertinoIcons.share,
                                          size: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

