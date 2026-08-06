// ignore_for_file: depend_on_referenced_packages

import 'package:abojude_flutter/features/auth/register/data/rx_register/rx.dart';
import 'package:abojude_flutter/features/auth/register/model/register_model.dart';
import 'package:abojude_flutter/features/auth/register/data/rx_register_verify_otp/rx.dart';
import 'package:abojude_flutter/features/auth/register/model/register_verify_otp_model.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/data/rx_create_buy_and_sell_category/rx.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/model/buy_and_sell_category_post_create_model.dart';
import 'package:abojude_flutter/features/create_listing/jobs_create/data/rx_job_create/rx.dart';
import 'package:abojude_flutter/features/create_listing/jobs_create/model/job_post_create_model.dart';
import 'package:abojude_flutter/features/create_listing/services_create/data/rx_service_create/rx.dart';
import 'package:abojude_flutter/features/create_listing/services_create/model/service_post_create_model.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/data/rx_business_create/rx.dart';
import 'package:abojude_flutter/features/create_listing/business_directory_create/model/business_post_create_model.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/data/rx_buy_and_sell_get_post_draft/rx.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/model/buy_and_sell_get_post_draft_model.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/data/create_listing_after_draft/rx.dart';
import 'package:abojude_flutter/features/create_listing/buy_and_sell_create/model/buy_and_sell_post_create_model.dart';
import 'package:abojude_flutter/features/auth/login/data/rx_login/rx.dart';
import 'package:abojude_flutter/features/auth/login/model/login_model.dart';
import 'package:abojude_flutter/features/auth/login/data/rx_logout/rx.dart';
import 'package:abojude_flutter/features/message_screeen/data/rx.dart';
import 'package:abojude_flutter/features/message_screeen/model/get_all_mesage_list_model.dart';
import 'package:abojude_flutter/features/profile/data/rx_delete_account/rx.dart';
import 'package:abojude_flutter/features/auth/forget_password/data/rx_forget_password/rx.dart';
import 'package:abojude_flutter/features/auth/forget_password/model/forget_password_model.dart';
import 'package:abojude_flutter/features/auth/forget_password/data/rx_forget_password_verify_otp/rx.dart';
import 'package:abojude_flutter/features/auth/forget_password/model/forget_password_verify_otp_model.dart';
import 'package:abojude_flutter/features/auth/guest_user/data/rx.dart';
import 'package:abojude_flutter/features/auth/guest_user/model/guest_user_model.dart';
import 'package:abojude_flutter/features/auth/register/data/rx_resend_otp/rx.dart';
import 'package:abojude_flutter/features/auth/register/model/resend_otp_model.dart';
import 'package:abojude_flutter/features/home/data/rx_get_category_list/rx.dart';
import 'package:abojude_flutter/features/home/model/get_category_list_model.dart';
import 'package:abojude_flutter/features/home/data/rx_recent_post_list/rx.dart';
import 'package:abojude_flutter/features/home/model/recent_post_list_model.dart';
import 'package:abojude_flutter/features/home/data/rx_featured_listings_api/rx.dart';
import 'package:abojude_flutter/features/home/model/get_featured_listings_model.dart';
import 'package:abojude_flutter/features/home/data/rx_expoler_api/rx.dart';
import 'package:abojude_flutter/features/home/model/get_explore_model.dart';
import 'package:abojude_flutter/features/home/data/rx_all_porducaosn_deatils_api/rx.dart';
import 'package:abojude_flutter/features/home/model/get_post_details_model.dart';
import 'package:abojude_flutter/features/profile/data/rx_change_password/rx.dart';
import 'package:abojude_flutter/features/profile/data/rx_my_listing_api/rx.dart';
import 'package:abojude_flutter/features/profile/data/rx_my_whises_list_api/rx.dart';
import 'package:abojude_flutter/features/profile/data/rx_save_wishes_api/rx.dart';
import 'package:abojude_flutter/features/profile/model/my_listing_model.dart';
import 'package:abojude_flutter/features/profile/model/wishes_save_model.dart';
import 'package:abojude_flutter/features/profile/model/change_password_model.dart';
import 'package:abojude_flutter/features/auth/set_new_password/data/rx_set_new_password/rx.dart';
import 'package:abojude_flutter/features/auth/set_new_password/model/set_new_password_model.dart'
    as snp;
import 'package:abojude_flutter/features/profile/data/rx_get_profile/rx.dart';
import 'package:abojude_flutter/features/profile/model/get_profile_model.dart';
import 'package:abojude_flutter/features/profile/data/get_notification_setting/rx.dart';
import 'package:abojude_flutter/features/profile/model/get_notification_setting_model.dart';
import 'package:abojude_flutter/features/profile/data/update_notification_setting/rx.dart';
import 'package:abojude_flutter/features/profile/model/get_wishes_list_model.dart';
import 'package:abojude_flutter/features/profile/model/update_notification_setting_model.dart';
import 'package:abojude_flutter/features/profile/data/rx_block_user_list/rx.dart';
import 'package:abojude_flutter/features/profile/model/block_user_list_model.dart';
import 'package:abojude_flutter/features/profile/data/rx_block_user/rx.dart';
import 'package:abojude_flutter/features/auth/register/data/rx_get_province/rx.dart';
import 'package:abojude_flutter/features/auth/register/model/get_province_model.dart';
import 'package:abojude_flutter/features/auth/register/data/rx_get_city/rx.dart';
import 'package:abojude_flutter/features/auth/register/model/get_city_model.dart';
import 'package:abojude_flutter/features/auth/register/data/rx_select_location_for_auth_user/rx.dart';
import 'package:abojude_flutter/features/auth/register/model/select_location_for_auth_user_model.dart';
import 'package:abojude_flutter/features/auth/register/data/rx_select_location_for_guest/rx.dart';
import 'package:abojude_flutter/features/auth/register/model/select_location_for_guest_user_model.dart';
import 'package:abojude_flutter/features/profile/data/rx_edit_profile/rx.dart';
import 'package:abojude_flutter/features/profile/model/edit_profile_model.dart';
import 'package:abojude_flutter/features/profile/data/rx_contact_support/rx.dart';
import 'package:abojude_flutter/features/profile/model/contact_support_model.dart';
import 'package:abojude_flutter/features/terms_of_service_screen/data/rx_terms_and_condition/rx.dart';
import 'package:abojude_flutter/features/terms_of_service_screen/model/terms_and_condition_model.dart';
import 'package:rxdart/rxdart.dart';

// // ------------- Register Api Access -----------------//
RegisterRx registerRxObj = RegisterRx(
  empty: RegisterModel(),
  dataFetcher: BehaviorSubject<RegisterModel>(),
);

// // ------------- Verify Register Otp Api Access -----------------//
RegisterVerifyOtpRx registerVerifyOtpRxObj = RegisterVerifyOtpRx(
  empty: RegisterVerifyOtpModel(),
  dataFetcher: BehaviorSubject<RegisterVerifyOtpModel>(),
);

// // ------------- Login Api Access -----------------//
LoginRx loginRxObj = LoginRx(
  empty: LoginModel(),
  dataFetcher: BehaviorSubject<LoginModel>(),
);

// // ------------- Logout Api Access -----------------//
LogoutRx logoutRxObj = LogoutRx(empty: {}, dataFetcher: BehaviorSubject<Map>());

// // ------------- Delete Account Api Access -----------------//
DeleteAccountRx deleteAccountRxObj = DeleteAccountRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

// // ------------- Change Password Api Access -----------------//
ChangePasswordRx changePasswordRxObj = ChangePasswordRx(
  empty: ChangePasswordModel(),
  dataFetcher: BehaviorSubject<ChangePasswordModel>(),
);

// // ------------- Set New Password Api Access -----------------//
SetNewPasswordRx setNewPasswordRxObj = SetNewPasswordRx(
  empty: snp.ChangePasswordModel(),
  dataFetcher: BehaviorSubject<snp.ChangePasswordModel>(),
);

// // ------------- Get Profile Api Access -----------------//
GetProfileRx getProfileRxObj = GetProfileRx(
  empty: GetProfileModel(),
  dataFetcher: BehaviorSubject<GetProfileModel>(),
);

// // ------------- Get Notification Setting Api Access -----------------//
GetNotificationSettingRx getNotificationSettingRxObj = GetNotificationSettingRx(
  empty: GetNotificationModel(),
  dataFetcher: BehaviorSubject<GetNotificationModel>(),
);

// // ------------- Update Notification Setting Api Access -----------------//
UpdateNotificationSettingRx updateNotificationSettingRxObj =
    UpdateNotificationSettingRx(
      empty: UpdateNotificationSettingsModel(),
      dataFetcher: BehaviorSubject<UpdateNotificationSettingsModel>(),
    );

// // ------------- Block User List Api Access -----------------//
BlockUserListRx blockUserListRxObj = BlockUserListRx(
  empty: BlockUserListModel(),
  dataFetcher: BehaviorSubject<BlockUserListModel>(),
);

// // ------------- Block User Api Access -----------------//
BlockUserRx blockUserRxObj = BlockUserRx(
  empty: {},
  dataFetcher: BehaviorSubject<Map>(),
);

// // ------------- Edit Profile Api Access -----------------//
EditProfileRx editProfileRxObj = EditProfileRx(
  empty: EditProfileModel(),
  dataFetcher: BehaviorSubject<EditProfileModel>(),
);

// // ------------- Contact Support Api Access -----------------//
ContactSupportRx contactSupportRxObj = ContactSupportRx(
  empty: ContactSupportModel(),
  dataFetcher: BehaviorSubject<ContactSupportModel>(),
);

// //___________________ Forget Password Api Access ______________________//
ForgetPasswordRx forgetPasswordRxObj = ForgetPasswordRx(
  empty: ForgetPasswordModel(),
  dataFetcher: BehaviorSubject<ForgetPasswordModel>(),
);

// // ------------- Forget Password Verify Otp Api Access -----------------//
ForgetPasswordVerifyOtpRx forgetPasswordVerifyOtpRxObj =
    ForgetPasswordVerifyOtpRx(
      empty: ForgetPasswordVerifyOtpModel(),
      dataFetcher: BehaviorSubject<ForgetPasswordVerifyOtpModel>(),
    );

// // ------------- Guest User Api Access -----------------//
GuestUserRx guestUserRxObj = GuestUserRx(
  empty: GuestUserModel(),
  dataFetcher: BehaviorSubject<GuestUserModel>(),
);

// // ------------- Resend Otp Api Access -----------------//
ResendOtpRx resendOtpRxObj = ResendOtpRx(
  empty: ResendOtpModel(),
  dataFetcher: BehaviorSubject<ResendOtpModel>(),
);

// // ------------- Get Province List Api Access -----------------//
GetProvinceRx getProvinceRxObj = GetProvinceRx(
  empty: GetProvinceModel(),
  dataFetcher: BehaviorSubject<GetProvinceModel>(),
);

// // ------------- Get Cities List Api Access -----------------//
GetCityRx getCityRxObj = GetCityRx(
  empty: GetCityModel(),
  dataFetcher: BehaviorSubject<GetCityModel>(),
);

// // ------------- Select Location For Auth User Api Access -----------------//
SelectLocationForAuthUserRx selectLocationForAuthUserRxObj =
    SelectLocationForAuthUserRx(
      empty: SelectLocationForAuthUserModel(),
      dataFetcher: BehaviorSubject<SelectLocationForAuthUserModel>(),
    );

// // ------------- Select Location For Guest Api Access -----------------//
SelectLocationForGuestRx selectLocationForGuestRxObj = SelectLocationForGuestRx(
  empty: SelectLocationForGuestUserModel(),
  dataFetcher: BehaviorSubject<SelectLocationForGuestUserModel>(),
);

// // ------------- Get Category List Api Access -----------------//
GetCategoryListRx getCategoryListRxObj = GetCategoryListRx(
  empty: CategoryListModel(),
  dataFetcher: BehaviorSubject<CategoryListModel>(),
);

// // ------------- Get Recent Post List Api Access -----------------//
GetRecentPostListRx getRecentPostListRxObj = GetRecentPostListRx(
  empty: RecentPostListModel(),
  dataFetcher: BehaviorSubject<RecentPostListModel>(),
);

// // ------------- Terms And Condition Api Access -----------------//
TermsAndConditionRx termsAndConditionRxObj = TermsAndConditionRx(
  empty: TermsAndConditionModel(),
  dataFetcher: BehaviorSubject<TermsAndConditionModel>(),
);

// // ------------- About Page Api Access -----------------//
TermsAndConditionRx aboutPageRxObj = TermsAndConditionRx(
  empty: TermsAndConditionModel(),
  dataFetcher: BehaviorSubject<TermsAndConditionModel>(),
);

// // ------------- Privacy Policy Api Access -----------------//
TermsAndConditionRx privacyPolicyRxObj = TermsAndConditionRx(
  empty: TermsAndConditionModel(),
  dataFetcher: BehaviorSubject<TermsAndConditionModel>(),
);

// // ------------- Create Buy and Sell Category Api Access -----------------//
CreateBuyAndSellCategoryRx createBuyAndSellCategoryRxObj =
    CreateBuyAndSellCategoryRx(
      empty: BuyAndSellCategoryPostCreateModel(),
      dataFetcher: BehaviorSubject<BuyAndSellCategoryPostCreateModel>(),
    );

// // ------------- Create Job Api Access -----------------//
CreateJobRx createJobRxObj = CreateJobRx(
  empty: JobPostCreateModel(),
  dataFetcher: BehaviorSubject<JobPostCreateModel>(),
);

// // ------------- Create Service Api Access -----------------//
CreateServiceRx createServiceRxObj = CreateServiceRx(
  empty: ServicePostCreateModel(),
  dataFetcher: BehaviorSubject<ServicePostCreateModel>(),
);

// // ------------- Create Business Api Access -----------------//
CreateBusinessRx createBusinessRxObj = CreateBusinessRx(
  empty: BusinessPostCreateModel(),
  dataFetcher: BehaviorSubject<BusinessPostCreateModel>(),
);

// // ------------- Get Buy and Sell Post Draft Api Access -----------------//
BuyAndSellGetPostDraftRx buyAndSellGetPostDraftRxObj = BuyAndSellGetPostDraftRx(
  empty: BuyAndSellGetPostDraftModel(),
  dataFetcher: BehaviorSubject<BuyAndSellGetPostDraftModel>(),
);

// // ------------- Create Buy and Sell Post Api Access -----------------//
CreateListingAfterDraftRx createListingAfterDraftRxObj =
    CreateListingAfterDraftRx(
      empty: BuyAndSellPostCreateModel(),
      dataFetcher: BehaviorSubject<BuyAndSellPostCreateModel>(),
    );

// //___________________  chat List Api Access ______________________//
GetAllChatListRx chatListRxObj = GetAllChatListRx(
  empty: GetMessageListModel(),
  dataFetcher: BehaviorSubject<GetMessageListModel>.seeded(
    GetMessageListModel(),
  ),
);

// //___________________  Featured Listings Api Access ______________________//
GetFeaturedListingsRx getFeaturedListingsRxObj = GetFeaturedListingsRx(
  empty: GetFeaturedListingsModel(),
  dataFetcher: BehaviorSubject<GetFeaturedListingsModel>(),
);

// //___________________  Explore Api Access ______________________//
GetExploreRx getExploreRxObj = GetExploreRx(
  empty: GetExploreModel(),
  dataFetcher: BehaviorSubject<GetExploreModel>(),
);

// //___________________  Post Details Api Access ______________________//
GetPostDetailsRx getPostDetailsRxObj = GetPostDetailsRx(
  empty: GetPostDetailsModel(),
  dataFetcher: BehaviorSubject<GetPostDetailsModel>(),
);

GetWishesListRx getWishesListRxObj = GetWishesListRx(
  empty: GetWishListModel(),
  dataFetcher: BehaviorSubject<GetWishListModel>(),
);

GetMyListRx getMyListRxObj = GetMyListRx(
  empty: GetMyListingModel(),
  dataFetcher: BehaviorSubject<GetMyListingModel>(),
);

SaveWishesRx saveWishesRxObj = SaveWishesRx(
  empty: GetWhiesSavetModel(),
  dataFetcher: BehaviorSubject<GetWhiesSavetModel>(),
);
