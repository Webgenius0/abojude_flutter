// ignore_for_file: constant_identifier_names, unnecessary_string_interpolations

const String url = "https://abojude.thesyndicates.team/api";
const String imageUrl = "${url}";

final class NetworkConstants {
  NetworkConstants._();
  static const ACCEPT = "Accept";
  static const APP_KEY = "App-Key";
  static const ACCEPT_LANGUAGE = "Accept-Language";
  static const ACCEPT_LANGUAGE_VALUE = "pt";
  static const APP_KEY_VALUE = String.fromEnvironment("APP_KEY_VALUE");
  static const ACCEPT_TYPE = "application/json";
  static const AUTHORIZATION = "Authorization";
  static const CONTENT_TYPE = "content-Type";
}

final class Endpoints {
  Endpoints._();


  // ------------------- Azizul Hakim -------------------
  
  // -------------------Register start-------------------
  static String register() => "/v1/sign-up";
  // -------------------Register end-------------------

  // -------------------Register Verify email start-----------------
  static String registerVerifyOtp() => "/v1/verify/otp";
  // -------------------Register Verify email end-------------------

  // -------------------Get Province List start-----------------
  static String getProvinceList() => "/v1/locations/provinces";
  // -------------------Get Province List end-------------------

  // -------------------Get Cities List start-----------------
  static String getCitiesList(String province) =>
      "/v1/locations/provinces/$province/cities";
  // -------------------Get Cities List end-------------------

  // -------------------Select Location auth user start-----------------
  static String selectLocationForAuthUser() => "/v1/locations/select";
  // -------------------Select Location auth user end-------------------

  // -------------------Guest user location start-----------------
  static String guestUserLocation() => "/v1/guest/location";
  // -------------------Guest user location end-------------------
 

  // -------------------Login start-------------------
  static String login() => "/v1/login";
  // -------------------Login end-------------------

  // -------------------Logout start-------------------
  static String logout() => "/v1/auth/logout";
  // -------------------Logout end-------------------

  // -------------------Delete Account start-------------------
  static String deleteAccount() => "/v1/auth/delete-account";
  // -------------------Delete Account end-------------------

  // -------------------Forget Password start-------------------
  static String forgetPassword() => "/v1/forgot-password";
  // -------------------Forget Password end-------------------

  // -------------------Set New Password start-------------------
  static String setNewPassword() => "/v1/reset-password";
  // -------------------Set New Password end-------------------

  // -------------------Change Password start-------------------
  static String changePassword() => "/v1/auth/change-password";
  // -------------------Change Password end-------------------

  // -------------------Forget Password verify otp start-------------------
  static String forgetPasswordVerifyOtp() => "/v1/verify/otp";
  // -------------------Forget Password verify otp end-------------------

  // -------------------Guest User start-------------------
  static String guestUser() => "/v1/guest";
  // -------------------Guest User end-------------------

  // -------------------Resend Otp start-------------------
  static String resendOtp() => "/v1/resend-otp";
  // -------------------Resend Otp end-------------------

    // ------------------- GetCategoryList start--------------
  static String getCategoryList() => "/v1/categories";
  // -------------------GetCategoryList end-------------------

  // ------------------- GetRecentPostList start-------------------
  static String getRecentPostList() => "/v1/posts/recent";
  // -------------------GetRecentPostList end-------------------

  // ------------------- GetProfile start-------------------
  static String getProfile() => "/v1/auth/profile";
  // -------------------GetProfile end-------------------

  // ------------------- UpdateProfile start-------------------
  static String updateProfile() => "/v1/auth/profile";
  // -------------------UpdateProfile end-------------------

  // -------------------ContactSupport start-------------------
  static String contactSupport() => "/v1/contact-support";
  // -------------------ContactSupport end-------------------

  // // ------------------- BlockUserList start-------------------
  static String blockUserList() => "/v1/auth/blocked-users";
  // // -------------------BlockUserList end-------------------

  // // ------------------- BlockUser start-------------------
  static String blockUser() => "/v1/auth/block";
  // // -------------------BlockUser end-------------------

  // -------------------TermsAndService start--------------
  static String termsAndService(String slug) => "/v1/page?slug=$slug";
  // -------------------TermsAndService end-------------------

  // ------------------- GetNotificationSetting start--------------
  static String getNotificationSetting() => "/v1/auth/notification-settings";
  // -------------------GetNotificationSetting end-------------------

  // ------------------- UpdateNotificationSetting start--------------
  static String updateNotificationSetting() => "/v1/auth/notification-settings";
  // -------------------UpdateNotificationSetting end-------------------

  // ------------------- GetWishList start--------------
  static String getWishList() => "/v1/auth/wishes";
  // -------------------GetWishList end-------------------


  


}
