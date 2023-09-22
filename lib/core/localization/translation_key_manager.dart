import 'dart:ui';

import '../local_database/cache_helper_keys.dart';

class TranslationKeyManager {
  static const Locale localeEN = Locale(CacheHelperKeys.keyEN);
  static const Locale localeAR = Locale(CacheHelperKeys.keyAR);

  // OnBoarding
  static const String onBoardBookInquiry = 'الاستعلام عن الحجوزات بكود الحجز';
  static const String onBoardBookInquiryBtn = 'استعلام عن الحجز';

  static const String booksInquiry = 'الاستعلام عن الحجوزات';
  static const String bookSearchCodeBtn = 'ابحث بكود تأكيد الحجز';
  static const String ex = 'ex';
  static const String bookInquiryBtn = "استعلم عن الحجز";

  static const String onBoardBookFlightTitle = 'حجز الطيران';
  static const String onBoardBookFlight = "يمكنك الان حجز رحلتك بضغطة زر";
  static const String onBoardBookFlightBtn = 'حجز الطيران';

  static const String onBoardBookTourismTitle = 'حجز البرامج السياحية';
  static const String onBoardBookTourism = "يمكنك حجز برنامج سياحي بسهولة";
  static const String onBoardBookTourismBtn = 'البرامج السياحية';

  static const String onBoardBookHotelsTitle = 'حجز الفنادق';
  static const String onBoardBookHotels =
      "اختر فندق لاقامتك من بين مجموعة مميزة من الفنادق";
  static const String onBoardBookHotelsBtn = 'احجز الان';

  static const String onBoardBookCarsTitle = 'حجز السيارات';
  static const String onBoardBookCars = "اختر سيارتك الان سيدان، فان او باص";
  static const String onBoardBookCarsBtn = 'احجز الان';

  static const String onBoardShowMore = 'يمكنك استعراض المزيد';
  static const String onBoardSkipBtn = 'تخطي';

  // bottom navigation
  static const String bottomNavMore = 'more';
  static const String bottomNavTourism = 'tourism';
  static const String bottomNavHotels = 'hotels';
  static const String bottomNavFlight = 'flight';
  static const String bottomNavHome = 'home';
  static const String allNeed = 'allNeed';
  static const String recentSearch = 'recentSearch';
  static const String canHelp = 'canHelp';

  // public
  static const String main = "main";
  static const String bookNow = "bookNow";
  static const String usd = "usd";
  static const String firstName = "firstName";
  static const String lastName = "lastName";
  static const String phoneNumber = "phoneNumber";
  static const String email = "email";
  static const String fromDate = "fromDate";
  static const String toDate = "toDate";
  static const String daysCount = "daysCount";
  static const String total = "total";
  static const String tax = "tax";
  static const String net = "net";

  // login
  static const String userName = "email";
  static const String password = "password";
  static const String login = "login";
  static const String loginTitle = "loginTitle";
  static const String loginHint = "loginHint";

  //hotels
  static const String hotelBook = "hotelBook";
  static const String hotels = "hotels";
  static const String hotelDetails = "hotelDetails";
  static const String hotelData = "hotelData";
  static const String hotelName = "hotelName";
  static const String hotelRate = "hotelRate";
  static const String stars = "stars";
  static const String hotelType = "hotelType";
  static const String roomChoose = "roomChoose";
  static const String singleRoom = "singleRoom";
  static const String doubleRoom = "doubleRoom";
  static const String tripleRoom = "tripleRoom";
  static const String childBook = "childBook";
  static const String noChild = "noChild";
  static const String childWithBed = "childWithBed";
  static const String childWithoutBed = "childWithoutBed";
  static const String roomPricePerDay = "roomPricePerDay";
  static const String showAll = "showAll";

  // car
  static const String cars = "cars";
  static const String carBook = "carBook";
  static const String carType = "carType";
  static const String withDriverQues = "withDriverQues";
  static const String withDriver = "withDriver";
  static const String withoutDriver = "withoutDriver";
  static const String pricePerDay = "pricePerDay";
  static const String notes = "notes";
  static const String notesHint = "notesHint";
  static const String next = "next";
  static const String defValidation = "defValidation";

  // settings
  static const String settings = "settings";
  static const String versionNumber = "versionNumber";
  static const String language = "language";
  static const String seasonsTour = "seasonsTour";
  static const String aboutUs = "aboutUs";
  static const String privacyPolicy = "privacyPolicy";
  static const String contactUs = "contactUs";
  static const String contactUsBio = "contactUsBio";
  static const String contactsMethods = "contactsMethods";
  static const String via = "via";
  static const String whatsApp = "whatsApp";
  static const String mobileNumber = "mobile";
  static const String twitter = "twitter";
  static const String telegram = "telegram";
  static const String youtube = "Youtube";
  static const String instagram = "instagram";
  static const String snapchat = "snapchat";
  static const String tiktok = "tiktok";
  static const String messenger = "messenger";
  static const String googlePlayLink = "Google Play Link";
  static const String appStoreLink = "App Store Link";
  static const String facebook = "facebook";
  static const String followUs = "followUs";

  // flight
  static const String oneWay = "oneWay";
  static const String flightTitle = "flightTitle";
  static const String goingAndComingBack = "goingAndComingBack";
  static const String travelFrom = "travelFrom";
  static const String arriveTo = "arriveTo";
  static const String choose = "choose";
  static const String close = "close";
  static const String departureDate = "departureDate";
  static const String whereFrom = "whereFrom";
  static const String numberOfAdults = "numberOfAdults";
  static const String yearsOld12 = "yearsOld12";
  static const String numberOfChildren2 = "numberOfChildren2";
  static const String years11 = "years11";
  static const String numberOfInfantsFrom = "numberOfInfantsFrom";
  static const String yearsOld02 = "yearsOld02";
  static const String search = "search";
  static const String results = "results";
  static const String allAirports = "allAirports";
  static const String Continue = "Continue";
  static const String whereTo = "WhereTo";
  static const String passengers = "passengers";
  static const String haveAccount = "haveAccount";
  static const String loginFaster = "loginFaster";
  static const String contactDetails = "contactDetails";
  static const String nationality = "nationality";
  static const String passportNum = "passportNum";
  static const String availableFlights = "availableFlights";
  static const String allTaxes = "allTaxes";
  static const String checkedBaggage = "checkedBaggage";
  static const String roundTrip = "roundTrip";
  static const String dateRange = "dateRange";
  static const String when = "when";
  static const String sorry = "sorry";
  static const String noResult = "noResult";
  static const String changeDate = "Try Changing the dates or the destinations";
  static const String searchFlight = "searchFlight";
  static const String onlyFlight = "onlyFlight";

  // tourism
  static const String tourismTitle = "tourismTitle";
  static const String includeFlight = "includeFlight";
  static const String notIncludeFlight = "notIncludeFlight";
  static const String city = "city";
  static const String cities = "cities";
  static const String chooseCountry = "chooseCountry";
  static const String noCities = "noCities";
  static const String country = "country";
  static const String serverError = "serverError";
  static const String countries= "countries";
  static const String chooseRoom = "chooseRoom";
  static const String roomType = "roomType";
  static const String kidsReservation = "kidsReservation";
  static const String kidsCount = "kidsCount";
}
