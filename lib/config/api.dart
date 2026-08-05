class Api {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  static const String login = '$baseUrl/auth/login';

  static const String register = '$baseUrl/auth/register';

  static const String logout = '$baseUrl/auth/logout';

  static const String me = '$baseUrl/auth/me';

  static const String categories = '$baseUrl/categories';

  static const String services = '$baseUrl/services';

static const String nearbyWorkers = '$baseUrl/nearby-workers';

  static const String topWorkers = '$baseUrl/top-workers';

  static const String profile = '$baseUrl/profile';

  static const String bookings = '$baseUrl/my-bookings';

  static const booking = "$baseUrl/booking";

  static const myBookings = "$baseUrl/my-bookings";

  static const String createBooking = '$baseUrl/booking';

  static const String workerDashboard = "$baseUrl/worker/dashboard";

  static const String workerBookings = "$baseUrl/worker/bookings";

  static const workerServices ="$baseUrl/worker/services";

  static const String completeProfile ='$baseUrl/worker/profile';

  static const String workerProfileStatus ='$baseUrl/worker/profile-status';

  static const String adminUsers = "$baseUrl/admin/users";

  static const String adminDashboard = "$baseUrl/admin/dashboard";

  static const String adminWorkers = "$baseUrl/admin/workers";

  static const String adminCategories ="$baseUrl/admin/categories";

  static const String adminBookings ="$baseUrl/admin/bookings";

  static const String pendingWorkers ="$baseUrl/admin/workers/pending-verification";

  static const String favorites = "$baseUrl/favorites";

}
