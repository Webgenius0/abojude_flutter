import 'dart:io';

class JobListingModel {
  File? image;
  String title;
  String companyName;
  String description;
  String jobType;
  String province;
  String city;
  String address;
  String phoneNumber;
  String whatsAppNumber;
  String emailAddress;
  bool enableInAppChat;

  JobListingModel({
    this.image,
    this.title = '',
    this.companyName = '',
    this.description = '',
    this.jobType = 'Full-Time',
    this.province = '',
    this.city = '',
    this.address = '',
    this.phoneNumber = '',
    this.whatsAppNumber = '',
    this.emailAddress = '',
    this.enableInAppChat = true,
  });
}
