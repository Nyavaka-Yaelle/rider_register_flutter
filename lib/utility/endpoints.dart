class Endpoints {
  static String baseURL = "https://jsonplaceholder.typicode.com";

  // static String baseURL = "https://rideeback.uc.r.appspot.com/api_v1";

  // static const String assetUrl =
  //     'https://checkervisor-assets.sgp1.digitaloceanspaces.com';

  static const String refreshTokenUrl = '/api/v1/auth/refresh-token';

  static const String meUrl = '/api/v1/customer/me';

  static const int receiveTimeout = 5000;

  static const int connectionTimeout = 3000;

  static String get post => '$baseURL/posts/1';
}
