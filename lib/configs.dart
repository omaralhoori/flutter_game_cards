import 'package:country_picker/country_picker.dart';

const APP_NAME = 'BookKart';
const DEFAULT_LANGUAGE = 'en';

// const DOMAIN_URL = 'https://smhosstore.com'; // Do not add slash in the end
// const BASE_URL = '$DOMAIN_URL/wp-json/';
// const CONSUMER_SECRET = 'cs_52b69709fc04202034fd831946158e956b7b5679';
// const CONSUMER_KEY = 'ck_0161f09d661dbfa4abc862df9896c00f4b81180d';
//
// const DOMAIN_URL = 'https://pushtigranth.com'; // Do not add slash in the end
// const BASE_URL = '$DOMAIN_URL/wp-json/';
// const CONSUMER_SECRET = 'cs_52b69709fc04202034fd831946158e956b7b5679';
// const CONSUMER_KEY = 'ck_0161f09d661dbfa4abc862df9896c00f4b81180d';
//

/// BASE CONFIG
const DOMAIN_URL = 'http://31.220.90.177';//'https://smhosstore.com'; // DO NOT ADD SLASH IN THE END
const BASE_URL = '$DOMAIN_URL/api/method/';
const CONSUMER_SECRET = 'cs_3ac38528e7553a83bd9477b4fce28f2436496a8';
const CONSUMER_KEY = 'ck_70a62090ac76c3c50c5f33a294e9e224d43aa85';

const PER_PAGE_ITEM = 30;
const bool ENABLE_ADS = false;
const TERMS_CONDITION_URL = 'https://iqonic.design/terms-of-use/';
const PRIVACY_POLICY_URL = 'https://iqonic.design/privacy-policy/';

const IOS_LINK_FOR_USER = '';

/// ONE-SIGNAL CONFIG
const ONESIGNAL_APP_ID = '37277ea5-ad97-4bac-a976-4db8243d0ae';
const ONESIGNAL_REST_KEY = 'NTQ2MmVhYTktYjE4Yi00NjY3LTk1N43A0ZjA5MWU0OTE5';
const ONESIGNAL_CHANNEL_ID = 'cce428a9-93d5-41ed-a407-029434a498';

///AD CONFIG
const BANNER_AD_ID_ANDROID = "ca-app-pub-3940256099942544/630043111";
const BANNER_AD_ID_IOS = "ca-app-pub-3940256099942544/29347436";
const INTERSTITIAL_AD_ID_ANDROID = "ca-app-pub-3940256099942544/1033433712";
const INTERSTITIAL_AD_ID_IOS = "ca-app-pub-3940256099942544/44143910";

/// PAYMENT CONFIG
const FLUTTER_WAVE_KEY = 'FLWSECK_TEST-d2759023efce6198a853b8433beb55-X';
const FLUTTER_WAVE_PUBLIC_KEY = 'FLWPUBK_TEST-eb3edef083c890a7e224ec43daa5-X';
const FLUTTER_ENCRYPTION_KEY = 'FLWSECK_TEST8497cc2db86c';
const RAZOR_KEY = "rzp_test_CLw7tH3O43eQM";

/// REVENUE CAT CONFIG
final String revenueCatKey = 'sk_YOgRvlncdYaXAGDMAx43qHpIhym';
final String publicGoogleApiKey = 'goog_XDFtUsIMFCTtH43YcesRUJYvF';
final String publicAmazonApiKey = '';
final String publicAppleApiKey = '';

/// COUNTRY CONFIG
const DEFAULT_COUNTRY_CODE = '+91';

Country defaultCountry() {
  return Country(
    phoneCode: '91',
    countryCode: 'IN',
    e164Sc: 91,
    geographic: true,
    level: 1,
    name: 'India',
    example: '9123456789',
    displayName: 'India (IN) [+91]',
    displayNameNoCountryCode: 'India (IN)',
    e164Key: '91-IN-0',
    fullExampleWithPlusSign: '+919123456789',
  );
}
