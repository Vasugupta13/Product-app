import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_app/UI/post/Cart/cart_model.dart';
import 'package:product_app/UI/post/Cart/cart_provider.dart';
import 'package:product_app/UI/post/DB/db_helper.dart';
import 'package:product_app/UI/post/Product%20Screen/confirmed.dart';
import 'package:product_app/UI/post/Product%20Screen/product_screen.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper? dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Cart'),
        actions: [
          Center(
            child: badges.Badge(
              badgeStyle: const badges.BadgeStyle(
                badgeColor: Color(0xFFCE93D8),
              ),
              badgeContent: Consumer<CartProvider>(
                builder: (context, value, child) {
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
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: cart.getData(),
            builder: (context, AsyncSnapshot<List<Cart>> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return Column(
                    children: [
                      Center(
                        child: Center(
                          child: Image.asset(
                            'img/Empty.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        "Uh Oh!! Your Cart is Empty add Items to your Cart",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 40,
                        width: 120,
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> const ProductScreen()));
                          },
                          label: const Text('Add Items'),
                          elevation: 1,
                        ),
                      )
                    ],
                  );
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),

                            ),
                            color: Colors.grey[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Image(
                                        height: 100,
                                        width: 100,
                                        image: NetworkImage(snapshot.data![index].image.toString()),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:MainAxisAlignment.start,
                                          crossAxisAlignment:CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  snapshot.data![index].productName.toString(),
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:FontWeight.w500),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    await FirebaseFirestore.instance.collection("Cart").
                                                    doc(snapshot.data![index].productName!.toString()).delete();

                                                    dbHelper!.delete(snapshot.data![index].id!);
                                                    cart.removeCounter();
                                                    cart.removeTotalPrice(double.parse(snapshot.data![index].productPrice.toString()));
                                                  },
                                                  child: const Icon(Icons.delete,
                                                  ),
                                                )
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "₹${snapshot.data![index].productPrice}",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: InkWell(
                                                onTap: () {},
                                                child: Container(
                                                  height: 35,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                    color: Colors.lightGreen,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                            onTap: () async {
                                                              int quantity =snapshot.data![index].quantity!;
                                                              int price = snapshot.data![index].initialPrice!;
                                                              quantity--;
                                                              int? newPrice =price * quantity;

                                                              await FirebaseFirestore .instance.collection("Cart")
                                                                  .doc(snapshot.data![index].productName!.toString()).
                                                                  update({'productName': snapshot.data![index].productName!.toString(),
                                                                'productPrice': newPrice.toString(),
                                                                'productRating': snapshot.data![index].productRating.toString(),
                                                                'image': snapshot.data![index].image.toString(),
                                                                'quantity': quantity.toString(),
                                                              });

                                                              if (quantity >0) {
                                                                dbHelper!
                                                                    .updateQuantity(Cart(
                                                                        id: snapshot.data![index].id!,
                                                                        productId: snapshot.data![index].id!.toString(),
                                                                        productName: snapshot.data![index].productName!,
                                                                        initialPrice: snapshot.data![index].initialPrice!,
                                                                        productPrice:newPrice,
                                                                        quantity:quantity,
                                                                        productRating: snapshot.data![index].productRating.toString(),
                                                                        image: snapshot.data![index].image.toString()))
                                                                    .then((value) {
                                                                  newPrice = 0;
                                                                  quantity = 0;
                                                                  cart.removeTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                                }).onError((error,stackTrace) {
                                                                  if (kDebugMode) {
                                                                    print(error.toString());
                                                                  }
                                                                });
                                                              }
                                                            },
                                                            child: const Icon(
                                                              Icons.remove,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                        Text(
                                                            snapshot.data![index].quantity.toString(),
                                                            style:const TextStyle(
                                                                    color: Colors
                                                                        .white)),
                                                        InkWell(
                                                            onTap: () async {
                                                              int quantity = snapshot.data![index].quantity!;
                                                              int price = snapshot.data![index].initialPrice!;
                                                              quantity++;
                                                              int? newPrice =price * quantity;

                                                              await FirebaseFirestore.instance.collection("Cart")
                                                                  .doc(snapshot.data![index].productName!.toString()).update({
                                                                'productName': snapshot.data![index].productName!.toString(),
                                                                'productPrice': newPrice.toString(),
                                                                'productRating': snapshot.data![index].productRating.toString(),
                                                                'image': snapshot.data![index].image.toString(),
                                                                'quantity': quantity.toString(),
                                                              });

                                                              dbHelper!.updateQuantity(Cart
                                                                (id: snapshot.data![index].id!,
                                                                      productId: snapshot.data![index].id!.toString(),
                                                                      productName: snapshot.data![index].productName!,
                                                                      initialPrice: snapshot.data![index].initialPrice!,
                                                                      productPrice:newPrice,
                                                                      quantity:quantity,
                                                                      productRating: snapshot.data![index].productRating.toString(),
                                                                      image: snapshot.data![index].image.toString())).then((value) {
                                                                       newPrice = 0;
                                                                       quantity = 0;
                                                                cart.addTotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                              }).onError((error,stackTrace) {
                                                                if (kDebugMode) {
                                                                  print(error
                                                                      .toString());
                                                                }
                                                              });
                                                            },
                                                            child: const Icon(
                                                              Icons.add,
                                                              color:Colors.white,
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  );
                }
              } else {
                return const Text("");
              }
            },
          ),
          Consumer<CartProvider>(builder: (context, value, child) {
            return Visibility(
              visible: value.getTotalPrice().toStringAsFixed(2) == "0.00"
                  ? false
                  : true,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ReusableWidget(
                      title: 'Sub Total',
                      value: r'₹' + value.getTotalPrice().toStringAsFixed(2),
                    ),
                    const ReusableWidget(
                      title: 'Delivery Charges',
                      value: r'Free',
                    ),
                    ReusableWidget(
                      title: 'Total',
                      value: r'₹' + value.getTotalPrice().toStringAsFixed(2),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> const OrderPlaced()));
                         await dbHelper!.deleteOptionTable();
                        cart.deleteCounter();
                        cart.deleteTotalPrice();
                      },
                      style:ElevatedButton.styleFrom(
                        elevation: 1,
                      padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )
                    ),
                      child: const Text('Place Order'),
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

class ReusableWidget extends StatelessWidget {
  final String title, value;
  const ReusableWidget({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
