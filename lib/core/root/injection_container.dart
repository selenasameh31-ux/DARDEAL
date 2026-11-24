import 'package:graduation_project_flutter/core/routing/routes_export.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/datasources/lookup_remote_data_source.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/repositories/lookup_repository_impl.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/domain/repositories/lookup_repository.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/domain/usecases/lookup_usecases.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/datasources/profile_remote_data_source.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/repositories/profile_repository_impl.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/domain/repositories/profile_repository.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/presentation/state_management(bloc)/profile_cubit.dart';
import 'package:graduation_project_flutter/features/edit_profile/data/datasources/edit_profile_remote_data_source.dart';
import 'package:graduation_project_flutter/features/edit_profile/data/repositories/edit_profile_repository_impl.dart';
import 'package:graduation_project_flutter/features/edit_profile/domain/repositories/edit_profile_repository.dart';
import 'package:graduation_project_flutter/features/edit_profile/presentation/state_management(bloc)/edit_profile_cubit.dart';
import 'package:graduation_project_flutter/features/offer_profile/presentation/state_management(bloc)/sent_offers_cubit.dart';
import 'package:graduation_project_flutter/features/offer_profile/presentation/state_management(bloc)/my_offers_cubit.dart';
import 'package:graduation_project_flutter/features/offer_request/presentation/state_management(bloc)/received_offers_cubit.dart';
import 'package:graduation_project_flutter/features/active_rental/data/datasources/active_rental_remote_data_source.dart';
import 'package:graduation_project_flutter/features/active_rental/data/repositories/active_rental_repository_impl.dart';
import 'package:graduation_project_flutter/features/active_rental/domain/repositories/active_rental_repository.dart';
import 'package:graduation_project_flutter/features/rental_management/presentation/state_management/rental_management_cubit.dart';
import 'package:graduation_project_flutter/features/active_rental/presentation/state_management(bloc)/active_rentals_cubit.dart';
import 'package:graduation_project_flutter/features/offer_request/data/datasources/offer_request_remote_data_source.dart';
import 'package:graduation_project_flutter/features/offer_request/data/repositories/offer_request_repository_impl.dart';
import 'package:graduation_project_flutter/features/offer_request/domain/repositories/offer_request_repository.dart';
import 'package:graduation_project_flutter/features/offer_request/presentation/state_management(bloc)/offer_request_cubit.dart';
import 'package:graduation_project_flutter/features/verification&decomentation/data/datasources/verification_remote_data_source.dart';
import 'package:graduation_project_flutter/features/verification&decomentation/data/repositories/verification_repository_impl.dart';
import 'package:graduation_project_flutter/features/verification&decomentation/domain/repositories/verification_repository.dart';
import 'package:graduation_project_flutter/features/verification&decomentation/presentation/state_management(bloc)/verification_cubit.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/data/datasources/chat_remote_data_source.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/data/repositories/chat_repository_impl.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/domain/repositories/chat_repository.dart';
import 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/presentation/state_management(bloc)/chat_bloc.dart';
import 'package:graduation_project_flutter/features/my_contracts/data/datasources/contracts_remote_data_source.dart';
import 'package:graduation_project_flutter/features/my_contracts/data/repositories/contracts_repository_impl.dart';
import 'package:graduation_project_flutter/features/my_contracts/domain/repositories/contracts_repository.dart';
import 'package:graduation_project_flutter/features/my_contracts/presentation/state_management(bloc)/contracts_cubit.dart';
import 'package:graduation_project_flutter/core/styles/theme_cubit.dart';
import 'package:graduation_project_flutter/core/localization/locale_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(() => Connectivity());
  // =======================
  // Cache Helper
  // =======================
  sl.registerLazySingleton(() => CacheHelper(sl()));

  // =======================
  // API Consumer (IMPORTANT)
  // =======================

  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(sl()));

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // ==============================
  // 🔵 AUTH FEATURE
  // ==============================

  //! Session
  sl.registerLazySingleton(() => SessionCubit(sl(), sl()));
  //! Theme and Localization
  sl.registerLazySingleton(() => ThemeCubit(sl()));
  sl.registerLazySingleton(() => LocaleCubit(sl()));

  //! Auth Feature
  sl.registerLazySingleton<RemoteUserDataSource>(
    () => RemoteUserDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl(), local: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));
  sl.registerLazySingleton(() => SelectRoleUseCase(sl()));
  sl.registerLazySingleton(() => VerifyEmailOtpUseCase(sl()));
  sl.registerLazySingleton(() => ResendEmailOtpUseCase(sl()));
  sl.registerLazySingleton(() => SendEmailOtpUseCase(sl()));
  // Blocs
  sl.registerFactory(() => LoginBloc(sl()));
  sl.registerFactory(() => RegisterBloc(sl()));
  sl.registerFactory(
    () => GoogleAuthBloc(googleSignInUseCase: sl(), repository: sl()),
  );
  sl.registerFactory(
    () => ForgotPasswordBloc(
      forgotPasswordUseCase: sl(),
      verifyOtpUseCase: sl(),
      resetPasswordUseCase: sl(),
    ),
  );
  sl.registerFactory(() => RoleSelectionBloc(sl()));
  sl.registerFactory(
    () => EmailVerificationBloc(
      verifyEmailOtpUseCase: sl(),
      resendEmailOtpUseCase: sl(),
      sendEmailOtpUseCase: sl(),
    ),
  );
  //! Add Property Feature
  sl.registerLazySingleton<AddPropertyRemoteDataSource>(
    () => AddPropertyRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<PropertyDraftLocalDataSource>(
    () => PropertyDraftLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AddPropertyRepository>(
    () => AddPropertyRepositoryImpl(remote: sl(), local: sl()),
  );
  sl.registerLazySingleton(() => AddPropertyUseCase(sl()));

  // Draft UseCases
  sl.registerLazySingleton(() => SaveDraftUseCase(sl()));
  sl.registerLazySingleton(() => LoadDraftUseCase(sl()));
  sl.registerLazySingleton(() => ClearDraftUseCase(sl()));

  // Lookup Feature — DataSource, Repository, UseCases
  sl.registerLazySingleton<LookupRemoteDataSource>(
    () => LookupRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<LookupRepository>(() => LookupRepositoryImpl(sl()));
  sl.registerLazySingleton(() => FetchAmenitiesUseCase(sl()));
  sl.registerLazySingleton(() => FetchNearbyFacilitiesUseCase(sl()));
  sl.registerLazySingleton(() => FetchRulesUseCase(sl()));
  sl.registerLazySingleton(() => FetchPropertyTypesUseCase(sl()));
  sl.registerLazySingleton(() => FetchGovernotatesUseCase(sl()));
  sl.registerLazySingleton(() => FetchCitiesUseCase(sl()));
  sl.registerLazySingleton(() => FetchDistrictsUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => AddPropertyBloc(
      saveDraftUseCase: sl(),
      loadDraftUseCase: sl(),
      clearDraftUseCase: sl(),
      submitPropertyUseCase: sl(),
      cacheHelper: sl(),
      fetchAmenitiesUseCase: sl(),
      fetchNearbyFacilitiesUseCase: sl(),
      fetchRulesUseCase: sl(),
      fetchPropertyTypesUseCase: sl(),
      fetchGovernotatesUseCase: sl(),
      fetchCitiesUseCase: sl(),
      fetchDistrictsUseCase: sl(),
    ),
  );

  // ==============================
  // 🔵 OFFER FEATURE
  // ==============================

  // UseCases
  sl.registerLazySingleton(() => CreateOfferUseCase(sl()));
  sl.registerLazySingleton(() => SubmitOfferUseCase(sl()));
  sl.registerLazySingleton(() => ConfirmPaymentUseCase(sl()));
  sl.registerLazySingleton(() => CompleteHandoverUseCase(sl()));
  sl.registerLazySingleton(() => GetPropertySummaryUseCase(sl()));
  sl.registerLazySingleton(() => InitiatePaymentUseCase(sl()));
  sl.registerLazySingleton(() => CheckPaymentStatusUseCase(sl()));

  // Repository
  sl.registerLazySingleton<OfferRepository>(() => OfferRepositoryImpl(sl()));

  // DataSource
  sl.registerLazySingleton<OfferRemoteDataSource>(
    () => OfferRemoteDataSourceImpl(api: sl(), cacheHelper: sl()),
  );

  // Bloc
  sl.registerFactory(
    () => OfferBloc(
      createOfferUseCase: sl(),
      submitOfferUseCase: sl(),
      confirmPaymentUseCase: sl(),
      completeHandoverUseCase: sl(),
      getPropertySummaryUseCase: sl(),
      initiatePaymentUseCase: sl(),
      checkPaymentStatusUseCase: sl(),
    ),
  );

  // ==============================
  // 🔵 HOME FEATURE
  // ==============================

  // DataSource
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(apiConsumer: sl()),
  );

  // Repository
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  // UseCases
  sl.registerLazySingleton(() => GetFeaturedPropertiesUseCase(sl()));
  sl.registerLazySingleton(() => GetRecentPropertiesUseCase(sl()));
  sl.registerLazySingleton(() => GetPropertyTypesUseCase(sl()));
  sl.registerLazySingleton(() => SearchPropertiesUseCase(sl()));
  sl.registerLazySingleton(() => GetPropertyDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetSimilarPropertiesUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => HomeCubit(
      getFeaturedPropertiesUseCase: sl(),
      getRecentPropertiesUseCase: sl(),
      getPropertyTypesUseCase: sl(),
    ),
  );

  sl.registerFactory(
    () => PropertyTypeListingCubit(searchPropertiesUseCase: sl()),
  );

  sl.registerFactory(
    () => PropertyDetailsCubit(
      getPropertyDetailsUseCase: sl(),
      getSimilarPropertiesUseCase: sl(),
    ),
  );

  // // Reviews Data Source
  // sl.registerLazySingleton<ReviewsRemoteDataSource>(
  //   () => ReviewsRemoteDataSourceImpl(apiConsumer: sl()),
  // );

  // // Reviews Repository
  // sl.registerLazySingleton<ReviewsRepository>(
  //   () => ReviewsRepositoryImpl(remoteDataSource: sl()),
  // );

  // // Reviews UseCases
  // sl.registerLazySingleton(() => GetPropertyReviewsUseCase(sl()));
  // sl.registerLazySingleton(() => GetPropertyReviewSummaryUseCase(sl()));
  // sl.registerLazySingleton(() => CreateReviewUseCase(sl()));

  // // Reviews Cubit
  // sl.registerFactory(
  //   () => ReviewsCubit(
  //     getPropertyReviewsUseCase: sl(),
  //     getPropertyReviewSummaryUseCase: sl(),
  //     createReviewUseCase: sl(),
  //   ),
  // );

  // Reviews Data Source
  sl.registerLazySingleton<ReviewsRemoteDataSource>(
    () => ReviewsRemoteDataSourceImpl(apiConsumer: sl()),
  );

  // Reviews Repository
  sl.registerLazySingleton<ReviewsRepository>(
    () => ReviewsRepositoryImpl(remoteDataSource: sl()),
  );

  // Reviews UseCases
  sl.registerLazySingleton(() => GetPropertyReviewsUseCase(sl()));
  sl.registerLazySingleton(() => GetPropertyReviewSummaryUseCase(sl()));
  sl.registerLazySingleton(() => CreateReviewUseCase(sl()));

  // Reviews Cubit
  sl.registerFactory(
    () => ReviewsCubit(
      getPropertyReviewsUseCase: sl(),
      getPropertyReviewSummaryUseCase: sl(),
      createReviewUseCase: sl(),
    ),
  );

  // ==============================
  // 💛 WISHLIST FEATURE
  // ==============================

  // DataSources
  sl.registerLazySingleton<WishlistRemoteDataSource>(
    () => WishlistRemoteDataSourceImpl(apiConsumer: sl()),
  );
  sl.registerLazySingleton<WishlistLocalDataSource>(
    () => WishlistLocalDataSourceImpl(cacheHelper: sl()),
  );

  // Repository
  sl.registerLazySingleton<WishlistRepository>(
    () => WishlistRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Cubit (singleton so heart-icon state is shared across all screens)
  sl.registerLazySingleton(() => WishlistCubit(repository: sl()));

  // ✅ Profile Feature
  sl.registerLazySingleton<RemoteProfileDataSource>(
    () => RemoteProfileDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remote: sl(), cacheHelper: sl()),
  );

  // Cubits
  sl.registerFactory(() => ProfileCubit(repository: sl()));
  sl.registerFactory(() => SentOffersCubit(repository: sl()));
  sl.registerFactory(() => MyOffersCubit(repository: sl()));
  sl.registerFactory(() => ReceivedOffersCubit(repository: sl()));

  // ✅ Edit Profile Feature
  sl.registerLazySingleton<EditProfileRemoteDataSource>(
    () => EditProfileRemoteDataSourceImpl(api: sl()),
  );
  sl.registerLazySingleton<EditProfileRepository>(
    () => EditProfileRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(
    () => EditProfileCubit(repository: sl(), sessionCubit: sl()),
  );


  // ==============================
  // 🔵 MY LISTINGS FEATURE
  // ==============================
  sl.registerLazySingleton<MyListingsRemoteDataSource>(
    () => MyListingsRemoteDataSourceImpl(api: sl(), cacheHelper: sl()),
  );
  sl.registerLazySingleton<MyListingRepository>(
    () => MyListingRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => MyListingCubit(repository: sl()));

  // ==============================
  // 🔵 ACTIVE RENTAL FEATURE
  // ==============================
  sl.registerLazySingleton<ActiveRentalRemoteDataSource>(
    () => ActiveRentalRemoteDataSourceImpl(api: sl()),
  );
  sl.registerLazySingleton<ActiveRentalRepository>(
    () => ActiveRentalRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => RentalManagementCubit(repository: sl()));
  sl.registerFactory(() => ActiveRentalsCubit(repository: sl()));

  // ==============================
  // 🔵 MY CONTRACTS FEATURE
  // ==============================
  sl.registerLazySingleton<ContractsRemoteDataSource>(
      () => ContractsRemoteDataSourceImpl(api: sl()));
  sl.registerLazySingleton<ContractsRepository>(
      () => ContractsRepositoryImpl(remoteDataSource: sl()));
  sl.registerFactory(() => ContractsCubit(repository: sl()));

  // ==============================
  // 🔵 OFFER REQUEST FEATURE
  // ==============================
  sl.registerLazySingleton<OfferRequestRemoteDataSource>(
    () => OfferRequestRemoteDataSourceImpl(api: sl()),
  );
  sl.registerLazySingleton<OfferRequestRepository>(
    () => OfferRequestRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => OfferRequestCubit(repository: sl()));

  // ==============================
  // 🔵 VERIFICATION DOCUMENTS FEATURE
  // ==============================
  sl.registerLazySingleton<VerificationRemoteDataSource>(
    () => VerificationRemoteDataSourceImpl(api: sl()),
  );
  sl.registerLazySingleton<VerificationRepository>(
    () => VerificationRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerFactory(() => VerificationCubit(repository: sl()));
  // ==============================
  // 🔵 CHAT FEATURE
  // ==============================
  sl.registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(api: sl()));
  sl.registerLazySingleton<ChatRepository>(
      () => ChatRepositoryImpl(remoteDataSource: sl()));
  sl.registerFactory(() => ChatBloc(repository: sl()));
}




    // // ==============================
  // // 💚 SEARCH FEATURE
  // // ==============================

  // // Data Sources
  // sl.registerLazySingleton<SearchRemoteDataSource>(
  //   () => SearchRemoteDataSourceImpl(apiConsumer: sl()),
  // );

  // // Repositories
  // sl.registerLazySingleton<SearchRepository>(
  //   () => SearchRepositoryImpl(remoteDataSource: sl()),
  // );

  // // UseCases
  // sl.registerLazySingleton(() => DoSmartSearchUseCase(sl()));
  // sl.registerLazySingleton(() => DoAdvancedFilterUseCase(sl()));
  // sl.registerLazySingleton(() => GetLookupUseCase(sl()));

  // // Cubit
  // sl.registerFactory(
  //   () => SearchFilterCubit(
  //     smartSearchUseCase: sl(),
  //     advancedFilterUseCase: sl(),
  //     lookupUseCase: sl(),
  //     cacheHelper: sl(),
  //   ),
  // );

