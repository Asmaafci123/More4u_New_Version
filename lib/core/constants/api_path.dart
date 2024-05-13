import 'constants.dart';
String? baseUrl=env!['API_URL'];
String userLogin = '$baseUrl/LoginAPI/userLogin';
String whoCanIGiveThisBenefit =
    '$baseUrl/BenefitAPI/WhoCanIGiveThisBenefit';
String whoCanRedeemThisGroupBenefit =
    '$baseUrl/BenefitAPI/WhoCanRedeemThisGroupBenefit';
String showMyBenefits = '$baseUrl/BenefitAPI/ShowMyBenefits';
String showMyGifts = '$baseUrl/BenefitAPI/ShowMyGifts';
String showMyBenefitRequests =
    '$baseUrl/BenefitAPI/ShowMyBenefitRequests';
String requestCancel = '$baseUrl/BenefitAPI/RequestCancel';
String confirmRequest = '$baseUrl/BenefitAPI/ConfirmRequest';
String showRequestsDefault = '$baseUrl/BenefitAPI/ShowRequestsDefault';
String getProfilePictureAndRequestDocuments =
    '$baseUrl/BenefitAPI/GetProfilePictureAndRequestDocuments';
String showRequests = '$baseUrl/BenefitAPI/ShowRequests';
String addRequestResponse = '$baseUrl/BenefitAPI/AddResponse';
String showNotifications = '$baseUrl/BenefitAPI/ShowFiftyNotifications';
String updateProfilePictureEndPoint =
    '$baseUrl/BenefitAPI/updateProfilePicture';
String changePasswordEndPoint = '$baseUrl/LoginAPI/ChangePassword';
String getPrivilegesEndPoint = '$baseUrl/PriviligesAPI/Getprivilges';
String getUserProfilePictureEndPoint =
    '$baseUrl/BenefitAPI/GetUserProfilePicture';
String mobileTokenAPI = '$baseUrl/LoginAPI/mobileToken';
String getLastMobileVersionAPI = '$baseUrl/LoginAPI/GetLastMobileVersion';
String getMedicalEndPoint = '$baseUrl/MedicalAPI/MedicalData';
String getTermsAndConditionsEndPoint='$baseUrl/LoginAPI/GetTermsOfConditions';
String refreshTokenAPI = '$baseUrl/LoginAPI/refreshToken';
String getHomeDataEndPoint = '$baseUrl/LoginAPI/getHomeData';

