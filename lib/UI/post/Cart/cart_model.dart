class Cart {
  late final int? id;
  final String? productId;
  final String? productName;
  final int? initialPrice;
  final int? productPrice;
  final String? productRating;
  final int? quantity;
  final String? image;

  Cart({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productRating,
    required this.initialPrice,
    required this.productPrice,
    required this.quantity,
    required this.image,
  });

  Cart.fromMap(Map<dynamic, dynamic> res)
      : id = res["id"],
        productId = res["productId"],
        productName = res["productName"],
        initialPrice = res["initialPrice"],
        productPrice = res["productPrice"],
        productRating = res["productRating"],
        quantity = res["quantity"],
        image = res["image"];

  Map<String, Object?> toMap(){
    return{
      'id' : id,
      'productId' : productId,
      'productName' : productName,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'productRating': productRating,
      'quantity': quantity,
      'image':image,

    };
  }
}
