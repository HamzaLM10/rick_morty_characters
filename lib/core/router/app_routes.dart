/// Route paths only. No imports from features, so `core` stays independent.
class AppRoutes {
  const AppRoutes._();

  static const String login = '/login';
  static const String characters = '/';
  static const String characterDetails = '/characters/:id';

  static String characterDetailsPath(int id) => '/characters/$id';
}