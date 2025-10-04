class CartItems{
  final String itemId;
  final String itemName;
  final double price;
  final String pickupType;
  final int quantity;
  final String image_url;
  final String vendorId;
  
  CartItems({
    required this.itemId,
    required this.itemName,
    required this.price,
    required this.pickupType,
    required this.quantity,
    required this.image_url,
    required this.vendorId,
  });

  Map<String, dynamic> toMap(){
    return{
      "itemId":itemId,
      "itemName":itemName,
      "price":price,
      "quantity":quantity,
      "image_url":image_url,
      "vendorId":vendorId,
    };
  }

  factory CartItems.fromMap(Map<String, dynamic> data)
  {
    return CartItems(
      itemId: data["itemId"], 
      itemName: data["itemName"], 
      price: data["price"], 
      pickupType:data["pickupType"],
      quantity: data["quantity"],
      image_url: data["image_url"],
      vendorId:data["vendorId"],
    );
  }

}