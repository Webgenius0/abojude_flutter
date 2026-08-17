// ignore_for_file: constant_identifier_names, unnecessary_string_interpolations

import 'package:abojude_flutter/helpers/helper_methods.dart';

const String url = "https://abojude.thesyndicates.team/api";
//const String url = "https://ruthie-gastroenterological-bee.ngrok-free.dev/api";
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
  static String registerVerifyOtp() => "/v1/verify/otp";
  static String getProvinceList() => "/v1/locations/provinces";
  static String getCitiesList(String province) =>
      "/v1/locations/provinces/$province/cities";
  static String selectLocationForAuthUser() => "/v1/locations/select";
  static String guestUserLocation() => "/v1/guest/location";
  static String setLanguage() => "/v1/language";

  // -------------------Guest user location end-------------------

  // -------------------Login start-------------------
  static String login() => "/v1/login";
  static String logout() => "/v1/auth/logout";
  static String deleteAccount() => "/v1/auth/delete-account";
  static String forgetPassword() => "/v1/forgot-password";
  static String setNewPassword() => "/v1/reset-password";
  static String changePassword() => "/v1/auth/change-password";
  static String forgetPasswordVerifyOtp() => "/v1/verify/otp";
  static String guestUser() => "/v1/guest";
  static String resendOtp() => "/v1/resend-otp";

  // -------------------Resend Otp end-------------------

  static String getCategoryList() => "/v1/categories";
  static String getRecentPostList() => "/v1/posts/recent";
  static String jobCreate() => "/v1/auth/post/draft";
  static String serviceCreate() => "/v1/auth/post/draft";
  static String businessDirectoryCreate() => "/v1/auth/post/draft";
  static String getFeaturedListings({int page = 1, int perPage = 10}) =>
      "/v1/posts/featured?page=$page&per_page=$perPage";

  static String exploreList({
    List<String>? categorySlugs,
    String? province,
    String? city,
    int? minPrice,
    int? maxPrice,
    String? sortBy,
    String? search,
    int page = 1,
    int perPage = 10,
  }) {
    final params = <String>[];

    if (categorySlugs != null && categorySlugs.isNotEmpty) {
      for (final slug in categorySlugs) {
        params.add("category_slug=$slug");
      }
    }

    if (province != null && province.isNotEmpty) {
      params.add("province=$province");
    }

    if (city != null && city.isNotEmpty) {
      params.add("city=$city");
    }

    if (minPrice != null) {
      params.add("min_price=$minPrice");
    }

    if (maxPrice != null) {
      params.add("max_price=$maxPrice");
    }

    if (sortBy != null && sortBy.isNotEmpty) {
      params.add("sort_by=$sortBy");
    }

    if (search != null && search.isNotEmpty) {
      params.add("search=$search");
    }

    params.add("page=$page");
    params.add("per_page=$perPage");

    return "/v1/posts?${params.join("&")}";
  }

  static String adsList() => "/v1/ads";

  // -------------------ExploreList end-------------------

  static String getProfile() => "/v1/auth/profile";
  static String updateProfile() => "/v1/auth/profile";
  static String contactSupport() => "/v1/contact-support";
  static String blockUserList() => "/v1/auth/blocked-users";
  static String blockUser() => "/v1/auth/block";
  static String termsAndService(String slug) => "/v1/page?slug=$slug";
  static String getNotificationSetting() => "/v1/auth/notification-settings";
  static String updateNotificationSetting() => "/v1/auth/notification-settings";
  static String getWishList() => "/v1/auth/wishes";
  static String createBuyAndSellCategory() => "/v1/auth/post/draft";
  static String buyAndSellGetPostDraft() => "/v1/auth/post/draft";
  static String postCreateDraft() => "/v1/auth/post/create";
  static String postReport() => "/v1/auth/report/post";


  ///____________________________ferdaus hossan sojib_______________________///

  static String chatList() => "/v1/auth/conversations";
  static String getConversationMessages(int conversationId) =>
      "/v1/auth/conversations/messages?conversation_id=$conversationId";

  static String getMyList({int page = 1, int perPage = 10}) =>
      "/v1/auth/posts?page=$page&per_page=$perPage";

  static String postDetails(int postId) => "/v1/post/details?post_id=$postId";
  static String wishesList() => "/v1/auth/wishes";
  static String sentMessage() => "/v1/auth/conversations/send";
  static String saveWishe() => "/v1/auth/wishes";

  // static String postDetails(int postId) =>
  //     "/v1/post/details?post_id=$postId";
}
