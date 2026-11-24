import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());

      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());

      case Routes.authOptions:
        return MaterialPageRoute(builder: (_) => AuthOptionsScreen());

      case Routes.signIn:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case Routes.signUp:
        return MaterialPageRoute(builder: (_) => RegisterScreen());

      case Routes.roleSelection:
        return MaterialPageRoute(  builder: (_) => const RoleSelectionScreen());  

      case Routes.chatDetails:
        final chatId = settings.arguments as int?;
        return MaterialPageRoute(builder: (_) => ChatDetailsScreen(chatId: chatId ?? 0));

      case Routes.propertyDetailsRent:
      case Routes.propertyDetailsSale:
      case Routes.propertyDetailsRoom:
      case Routes.propertyDetailsShared:
      case Routes.propertyDetailsShort:
        final args = settings.arguments;
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => BlocProvider(
              create: (context) => sl<WishlistCubit>(),
              child: PropertyDetailsWrapperScreen(propertyId: args),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("Property ID required")),
          ),
        );

      case Routes.mainLayout:
        return MaterialPageRoute(builder: (_) => const MainBottomNavBar());

      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());

      case Routes.chatbot:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => ChatbotBloc(
              sendMessageUseCase: SendMessageUseCase(
                ChatbotRepositoryImpl(
                  remoteDataSource: ChatbotRemoteDataSourceImpl(
                    api: sl<ApiConsumer>(),
                    cacheHelper: sl<CacheHelper>(),
                  ),
                ),
              ),
              getChatHistoryUseCase: GetChatHistoryUseCase(
                ChatbotRepositoryImpl(
                  remoteDataSource: ChatbotRemoteDataSourceImpl(
                    api: sl<ApiConsumer>(),
                    cacheHelper: sl<CacheHelper>(),
                  ),
                ),
              ),
            )..add(LoadChatHistory()),
            child: const ChatbotScreen(),
          ),
        );

      case Routes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());

      case Routes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());

      case Routes.verification:
        return MaterialPageRoute(builder: (_) => const VerificationStatusScreen());

      case Routes.helpCenter:
        return MaterialPageRoute(builder: (_) => const HelpCenterScreen());

      case Routes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());

      case Routes.terms:
        return MaterialPageRoute(builder: (_) => const TermsConditionsScreen());

      case Routes.myContracts:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<ContractsCubit>(),
            child: const MyContractsScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("Route Not Found"))),
        );
    }
  }
}
