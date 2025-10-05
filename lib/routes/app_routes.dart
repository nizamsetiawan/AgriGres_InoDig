import 'package:agrigres/features/detection/screens/guidelines/guidelines_page.dart';
import 'package:agrigres/features/personalization/screens/settings/widgets/about_app.dart';
import 'package:agrigres/features/personalization/screens/settings/widgets/feedback_form.dart';
import 'package:agrigres/features/personalization/screens/settings/widgets/privacy_securty_page.dart';
import 'package:agrigres/navigation_menu.dart';
import 'package:get/get.dart';
import 'package:agrigres/features/authentication/screens/login/login.dart';
import 'package:agrigres/features/authentication/screens/onboarding/onboarding.dart';
import 'package:agrigres/features/authentication/screens/password_configuration/forget_password.dart';
import 'package:agrigres/features/authentication/screens/signup/signup.dart';
import 'package:agrigres/features/authentication/screens/signup/verify_email.dart';
import 'package:agrigres/features/personalization/screens/address/address.dart';
import 'package:agrigres/features/personalization/screens/profile/profile.dart';
import 'package:agrigres/features/personalization/screens/settings/settings.dart';
import 'package:agrigres/features/detection/screens/home/home.dart';
import 'package:agrigres/routes/routes.dart';

import '../features/article/screens/all_articles/article.dart';
import '../features/forum/screens/farmer_forum.dart';
import '../features/calculator/screens/calculator_screen.dart';
import '../features/agri_info/screens/agri_info_screen.dart';
import '../features/agri_info/screens/detail_agri_info_screen.dart';
import '../features/agri_info/screens/monthly_detail_agri_info_screen.dart';
import '../features/agri_info/screens/table_detail_agri_info_screen.dart';
import '../features/agri_info/screens/province_detail_agri_info_screen.dart';
import '../features/agrimart/screens/agrimart_screen.dart';
import '../features/calculator/screens/calculator_results_screen.dart';
import '../features/article/screens/favorite_articles/favorite_articles_screen.dart';
import '../features/forum/screens/create_post_screen.dart';
import '../features/detection/screens/agri_care/agri_care_screen.dart';
import '../features/agri_edu/screens/agri_edu_screen.dart';
import '../features/agri_edu/screens/video_detail_screen.dart';
import '../features/agri_edu/screens/channel_detail_screen.dart';

class AppRoutes {
  static final pages = [
    GetPage(name: TRoutes.navigationMenu, page: () => const NavigationMenu()),
    GetPage(name: TRoutes.home, page: () => const HomeScreen()),
    GetPage(name: TRoutes.article, page: () => const ArticleScreen()),
    GetPage(name: TRoutes.settings, page: () => const SettingsScreen()),
    GetPage(name: TRoutes.userProfile, page: () => const ProfileScreen()),
    GetPage(name: TRoutes.userAddress, page: () => const UserAddressScreen()),
    GetPage(name: TRoutes.signup, page: () => const SignupScreen()),
    GetPage(name: TRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: TRoutes.signIn, page: () => const LoginScreen()),
    GetPage(name: TRoutes.forgetPassword, page: () => const ForgetPassword()),
    GetPage(name: TRoutes.onBoarding, page: () => const OnBoardingScreen()),
    GetPage(name: TRoutes.privacyAndSecurity, page: () => const PrivacyAndSecurityPage()),
    GetPage(name: TRoutes.feedbackForm, page: () => const FeedbackForm()),
    GetPage(name: TRoutes.aboutApp, page: () => const AboutAPPPage()),
    GetPage(name: TRoutes.guidelines, page: () => const GuidelinesScreen()),
    GetPage(name: TRoutes.farmerForum, page: () => const FarmerForum()),
    GetPage(name: TRoutes.calculator, page: () => const CalculatorScreen()),
    GetPage(name: TRoutes.agriInfo, page: () => const AgriInfoScreen()),
    GetPage(name: TRoutes.detailAgriInfo, page: () => const DetailAgriInfoScreen()),
    GetPage(name: TRoutes.monthlyDetailAgriInfo, page: () => const MonthlyDetailAgriInfoScreen()),
    GetPage(name: TRoutes.tableDetailAgriInfo, page: () => const TableDetailAgriInfoScreen()),
    GetPage(name: TRoutes.provinceDetailAgriInfo, page: () => const ProvinceDetailAgriInfoScreen()),
    GetPage(name: TRoutes.agriMart, page: () => const AgriMartScreen()),
    GetPage(name: TRoutes.calculatorResults, page: () => const CalculatorResultsScreen()),
    GetPage(name: TRoutes.favoriteArticles, page: () => const FavoriteArticlesScreen()),
    GetPage(name: TRoutes.createPost, page: () => const CreatePostScreen()),
    GetPage(name: TRoutes.agriCare, page: () => const AgriCareScreen()),
    GetPage(name: TRoutes.agriEdu, page: () => const AgriEduScreen()),
    GetPage(
      name: TRoutes.videoDetail,
      page: () => VideoDetailScreen(
        videoId: Get.arguments['videoId'] ?? '',
        title: Get.arguments['title'] ?? '',
      ),
    ),
    GetPage(
      name: TRoutes.channelDetail,
      page: () => ChannelDetailScreen(
        channel: Get.arguments['channel'],
      ),
    ),

  ];
}