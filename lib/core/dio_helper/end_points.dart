class EndPoints {
  //flights
  static const String FLIGHTSEARCH = '/flight_search_api';
  //login
  static const String LOGIN = '/login';
  static const String register = '/add-user';
  //car
  static const String CARTYPES = '/cars-type-view';
  static const String ALLCARS = '/cars-view';
  static const String BOOKCAR = '/car-order';
  //settings
  static const String PRIVACY = '/privacypolicy';
  static const String TERMS = '/termsAndConditions';
  static const String INFO = '/info';

  // Auth
  static const String userLogin = '/login';
  static const String userForget = '/forget';
  static const String userConfirm = '/con-code';
  static const String userReset = '/reset-password';

  // Users
  static const String usersViewAll = '/usersview';
  static const String userDelete = '/user-delete';
  static const String userEdit = '/user-edit';
  static const String userAdd = '/add-user';

  // country
  static const String viewCountries = '/country-view';
  static const String addCountry = '/country-new';
  static const String deleteCountry = '/country-delete';
  static const String editCountry = '/country-edit';

  // city
  static const String viewCities = '/cities-view';
  static const String addCity = '/city-add';
  static const String deleteCity = '/city-delete';
  static const String editCity = '/city-edit';

  // car
  static const String viewCars = '/cars-view';
  static const String addCar = '/car-add';
  static const String deleteCar = '/car-delete';
  static const String editCar = '/car-edit';
  static const String statusCar = '/car-cancel';

  // car types
  static const String viewCarTypes = '/cars-type-view';
  static const String addCarType = '/cars-type-add';
  static const String deleteCarType = '/cars-type-delete';
  static const String editCarType = '/cars-type-edit';

  // airport
  static const String viewAirports = '/viewAirports';
  static const String addAirport = '/airports-loaction';
  static const String deleteAirport = '/deleteAirport';
  static const String editAirport = '/airport-ubdate';
  static const String getAirportById = '/viewAirportById';

  // FlightLine
  static const String viewFlightLines = '/airlines-view';
  static const String addFlightLine = '/airlines';
  static const String deleteFlightLine = '/airline-delete';
  static const String editFlightLine = '/airline-edit';
  static const String getFlightLineById = '/airline-view-by-id';

  // Hotel
  static const String viewHotels = '/all-hotel';
  static const String addHotel = '/add-hotel';
  static const String deleteHotel = '/hotel-delete';
  static const String editHotel = '/hotel-edit';
  static const String getHotelById = '/single-hotel';
  static const String changeHotelStatus = '/hotel-cancel';

  // Hotel Book
  static const String viewHotelsBook = '/hotel-booking-view';
  static const String addHotelBook = '/new-hotel-booking';
  static const String deleteHotelBook = '/hotel-delete';
  static const String editHotelBook = '/hotel-booking-edit';
  static const String getHotelBookById = '/hotel-booking-by-id';
  static const String getHotelBookNotEnd = '/hotel-booking-not-end';
}
