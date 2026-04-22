class APIManager {
  static const fixedURL = "https://athapi.oasisdemaadi.com/api/";
  // static const fixedURL = "https://api.hatem-dev.com/api/";

  //APIS from Parents app API.Oasis
  static const fixedURL2 = "https://api1.oasisdemaadi.com/api/";

  static String loginAPI = "${fixedURL}Parent/Login";
  static String regStd = "${fixedURL}regstd";

  static String logOut = "${fixedURL}Parent/logOUT";
  //Messages
  static String messagesInbox = "${fixedURL}ParentMSGS_NEW";
  static String getDepartments = "${fixedURL}MSGPrepareNew";
  static String getDepartmentsEmps = "${fixedURL}MSGPrepareChangeCateg";
  static String SendMSGWithATTNew = "${fixedURL}SendMSGWithATTNew";

  //Student Profile Data
  static String getStdLinks = "${fixedURL}stdLinks";
  static String getAcademicSupport = "${fixedURL}stdLinksAcademic";
  static String getAcademicSupportReports = "${fixedURL}stdLinksAcademicReport";
  static String getSchoolAcademicLinks = "${fixedURL}stdAcademicLinks";
  static String getAthleticLinks = "${fixedURL}stdLinksAthletics";

  static String getStdLinksMedical = "${fixedURL}stdLinksMedical";

  static String updateFlagMedicalAndReports = "${fixedURL}stdLinksUPDATEViewMedicalAthletics";



  //Student Book
  static String std_studentBook = "${fixedURL2}std/stdBookX";
  static String prepareNewStdMsg = "${fixedURL2}std/stdBookPrepareNew";
  static String sendNewStdMsg = "${fixedURL2}std/stdBookSendNew";
  static String sendReply = "${fixedURL2}std/stdBookSendReply";
  static String updateStdMsgFlag = "${fixedURL2}std/updateStdMSGNEW";
  //Medical form
  static String getMedicalFormData = "${fixedURL}stdFormMedical";
  static String updateMedicalFormData = "${fixedURL}stdFormMedicalUpdate";

  //`Nutration form
  static String getNutrationFormData = "${fixedURL}stdFormNutration_General";
  static String updateUpdateFormData = "${fixedURL}stdFormNutration_GeneralUpdate";



  static String getNewsLetter = "${fixedURL}IntNewsLetter";

  //Canteen Charge
  static const getAmountList = "${fixedURL}chargAmounts";
  static const paymentLinkGeneration = "${fixedURL}CreateNewVoucher";
  static const paymentHistory = "${fixedURL}stdCanteenHistory";

  //Gallery
  static const getGalleryAlbums = "${fixedURL}Parent/GetGalleries";
  static const getAlbumsPhotos = "${fixedURL}Parent/GetGalleriesDetails";
  static const getCartPhotos = "${fixedURL}Parent/GetRequestedGalleries";

  static const requestNewPhoto = "${fixedURL}Parent/GalleriesRequest";
  static const cancelrequestedPhoto = "${fixedURL}Parent/GalleriesCancel";
  static const createNewVoucher = "${fixedURL}CreateNewVoucher";

  //Parents Profile
  static const parentDetails = "${fixedURL}Parent/getdata";
  static const pa_jobsdomain = "${fixedURL}Parent/jobDomain";
  static const pa_Status = "${fixedURL}Parent/parentStatus";
  static const pa_lang = "${fixedURL}Parent/parentLang";

  static const updateFa_Details = "${fixedURL}UpdateParents";
  static const updatePaGeneralInfo = "${fixedURL}Parent/UGeneralInfo";
  static const updatePaContactInfo = "${fixedURL}Parent/UContactInfo";
  static const updatePaWorkInfo = "${fixedURL}Parent/UworkInfo";
  static const updatePaEduInfo = "${fixedURL}Parent/UEducationInfo";
  static const updateEmergency = "${fixedURL}Parent/UUrgentInfo";

  //Notifications
  static const notificationCenter = "${fixedURL}GETNotification";
  static const readOneNotification = "${fixedURL}ReadNotification";
  static const readAllNotifications = "${fixedURL}ReadAllNotification";

  //Canteen Charge
  // static const getAmountList = "${fixedURL2}chargAmounts";
  // static const paymentLinkGeneration = "${fixedURL2}CreateNewVoucher";
  // static const paymentHistory = "${fixedURL2}stdCanteenHistory";

  //static const newsconstter = fixedURL + "IntNewsconstter";
}
