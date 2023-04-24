import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  ///PAYTABS
  static String profileId = dotenv.get('PROFILE_ID');
  static String serverKey = dotenv.get('SERVER_KEY');
  static String clientKey = dotenv.get('CLIENT_KEY');
  static String merchantName = dotenv.get('MERCHANT_NAME');
  static String currencyCode = dotenv.get('CURRENCY_CODE');
  static String merchantCountryCode = dotenv.get('MERCHANT_COUNTRY_CODE');

  ///AGORA
  static String agoraAppId = dotenv.get('AGORA_APP_ID');

  ///RAZOR_PAY_KEY
  static String razorPayKey = dotenv.get('RAZOR_PAY_KEY');
}

