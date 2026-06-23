import 'dart:io';

class ServiceListingModel {
  List<File> images;
  String title;
  String description;
  List<String> serviceAreas;
  String province;
  String city;
  String address;
  String phoneNumber;
  String whatsAppNumber;
  String emailAddress;
  bool enableInAppChat;

  ServiceListingModel({
    List<File>? images,
    this.title = '',
    this.description = '',
    List<String>? serviceAreas,
    this.province = '',
    this.city = '',
    this.address = '',
    this.phoneNumber = '',
    this.whatsAppNumber = '',
    this.emailAddress = '',
    this.enableInAppChat = true,
  })  : images = images ?? [],
        serviceAreas = serviceAreas ?? [];
}
