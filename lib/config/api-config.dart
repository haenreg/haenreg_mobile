class ApiConfig {
  static const String devBaseUrl = 'http://10.0.2.2:3000/api';
  static const String prodBaseUrl = '';

  static String get baseUrl {
    const bool isProduction = bool.fromEnvironment('dart.vm.product');
    return isProduction ? prodBaseUrl : devBaseUrl;
  }
}
