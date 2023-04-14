class Apis {
  static const Map<String, String> baseHeaders = {
    "Content-Type": "application/json; charset=UTF-8",
  };
  static String token = "";
  static void setToken(String token) {
    Apis.token = token;
  }

  static Map<String, String> headersWithToken = {
    "Content-Type": "application/json; charset=UTF-8",
    "x-auth-token": Apis.token,
  };
  static const String base = "http://localhost:3001";
  static const String login = "$base/auth/login";
  static const String getData = "$base/auth";

  static const String docs = "$base/docs";
  static const String createDocument = "$docs/create";
  static const String updateDocumentTitle = "$docs/title";
  static const String getAllDocuments = "$docs/me";
}
