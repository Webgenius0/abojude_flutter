import 'dart:io';

class BuySellListingModel {
  List<File> images;
  String title;
  String description;
  String price;
  String condition;
  String province;
  String city;
  String address;
  String phoneNumber;
  String whatsAppNumber;
  String emailAddress;
  bool enableInAppChat;

  BuySellListingModel({
    List<File>? images,
    this.title = '',
    this.description = '',
    this.price = '',
    this.condition = 'New',
    this.province = '',
    this.city = '',
    this.address = '',
    this.phoneNumber = '',
    this.whatsAppNumber = '',
    this.emailAddress = '',
    this.enableInAppChat = true,
  }) : images = images ?? [];
}
