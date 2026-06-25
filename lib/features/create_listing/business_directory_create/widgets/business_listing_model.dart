import 'dart:io';

class BusinessDayHours {
  bool isOpen;
  String openingTime;
  String closingTime;

  BusinessDayHours({
    required this.isOpen,
    this.openingTime = '10:00 AM',
    this.closingTime = '07:00 PM',
  });
}

class BusinessListingModel {
  File? coverImage;
  File? logo;
  String businessName;
  String businessCategory;
  String description;
  String website;
  Map<String, BusinessDayHours> businessHours;
  List<File> galleryImages;
  String province;
  String city;
  String address;
  String phoneNumber;
  String whatsAppNumber;
  String emailAddress;
  bool enableInAppChat;

  BusinessListingModel({
    this.coverImage,
    this.logo,
    this.businessName = '',
    this.businessCategory = '',
    this.description = '',
    this.website = '',
    Map<String, BusinessDayHours>? businessHours,
    List<File>? galleryImages,
    this.province = '',
    this.city = '',
    this.address = '',
    this.phoneNumber = '',
    this.whatsAppNumber = '',
    this.emailAddress = '',
    this.enableInAppChat = true,
  })  : businessHours = businessHours ??
            {
              "Sunday": BusinessDayHours(isOpen: false),
              "Monday": BusinessDayHours(isOpen: true),
              "Tuesday": BusinessDayHours(isOpen: true),
              "Wednesday": BusinessDayHours(isOpen: true),
              "Thursday": BusinessDayHours(isOpen: true),
              "Friday": BusinessDayHours(isOpen: true),
              "Saturday": BusinessDayHours(isOpen: true),
            },
        galleryImages = galleryImages ?? [];
}
