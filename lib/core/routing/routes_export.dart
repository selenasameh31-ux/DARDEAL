// ─────────────────────────────────────────────────────────
// ██  DART / FLUTTER SDK
// ─────────────────────────────────────────────────────────
export 'dart:async';
export 'dart:io';
export 'dart:math';
export 'dart:ui'
    hide
        Gradient,
        decodeImageFromList,
        Path,
        Codec,
        ImageDecoderCallback,
        TextStyle,
        StrutStyle,
        Image;
export 'dart:convert';
export 'dart:typed_data';
export 'package:flutter/material.dart';
export 'package:flutter/cupertino.dart'
    hide
        RefreshCallback,
        Gradient,
        decodeImageFromList,
        Path,
        ImageDecoderCallback,
        TextStyle,
        TextSpan,
        RichText,
        Text;
export 'package:flutter/services.dart';
export 'package:flutter/gestures.dart';

// ─────────────────────────────────────────────────────────
// ██  THIRD-PARTY PACKAGES
// ─────────────────────────────────────────────────────────
export 'package:dio/dio.dart';
export 'package:flutter_bloc/flutter_bloc.dart';
export 'package:flutter_svg/flutter_svg.dart';
export 'package:connectivity_plus/connectivity_plus.dart';
export 'package:shared_preferences/shared_preferences.dart';
export 'package:get_it/get_it.dart';
export 'package:intl/intl.dart' hide TextDirection;
export 'package:image_picker/image_picker.dart';
export 'package:wechat_assets_picker/wechat_assets_picker.dart' hide LatLng;
export 'package:reorderable_grid_view/reorderable_grid_view.dart';
export 'package:flutter_map/flutter_map.dart';
export 'package:latlong2/latlong.dart' hide pi, Path;
export 'package:geolocator/geolocator.dart' hide ServiceStatus;
export 'package:http/http.dart' hide MultipartFile, Response;
export 'package:video_player/video_player.dart';
export 'package:video_thumbnail/video_thumbnail.dart';
export 'package:flutter_markdown/flutter_markdown.dart';
export 'package:speech_to_text/speech_to_text.dart';
export 'package:permission_handler/permission_handler.dart';
export 'package:chewie/chewie.dart';
export 'package:image_editor_plus/image_editor_plus.dart';
export 'package:screenshot/screenshot.dart';
export 'package:share_plus/share_plus.dart';
export 'package:path_provider/path_provider.dart';
export 'package:qr_flutter/qr_flutter.dart';
export 'package:dropdown_button2/dropdown_button2.dart';
export 'package:file_picker/file_picker.dart';
export 'package:uuid/uuid.dart';
export 'package:paymob/paymob.dart';
export 'package:dartz/dartz.dart' hide State;
// ─────────────────────────────────────────────────────────
// ██  CORE — Styles
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/core/styles/app_colors.dart';
export 'package:graduation_project_flutter/core/styles/app_theme.dart';
export 'package:graduation_project_flutter/core/styles/app_input_styles.dart';

// ─────────────────────────────────────────────────────────
// ██  CORE — Utils
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/core/utils/app_snackbar.dart';
export 'package:graduation_project_flutter/core/utils/validators/app_validators.dart';
export 'package:graduation_project_flutter/core/utils/media_picker_helper.dart';

// ─────────────────────────────────────────────────────────
// ██  CORE — Constants
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/core/constants/image_name.dart';
export 'package:graduation_project_flutter/core/constants/app_fonts.dart';

// ─────────────────────────────────────────────────────────
// ██  CORE — Routing
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/core/routing/routes_name.dart';
export 'package:graduation_project_flutter/core/routing/app_routes.dart';

// ─────────────────────────────────────────────────────────
// ██  CORE — Database / API / Cache
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/core/database/api/api_consumer.dart';
export 'package:graduation_project_flutter/core/database/api/dio_consumer.dart';
export 'package:graduation_project_flutter/core/database/api/end_points.dart';
export 'package:graduation_project_flutter/core/database/cache/cache_helper.dart';

// ─────────────────────────────────────────────────────────
// ██  CORE — Connection
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/core/connection/network_info.dart';

// ─────────────────────────────────────────────────────────
// ██  CORE — Errors
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/core/errors/error_models.dart';
export 'package:graduation_project_flutter/core/errors/exceptions.dart';
export 'package:graduation_project_flutter/core/errors/failure.dart';

// ─────────────────────────────────────────────────────────
// ██  CORE — Root / DI
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/core/root/injection_container.dart';

// ─────────────────────────────────────────────────────────
// ██  CORE — Session
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/core/session/cubit/session_state.dart';
export 'package:graduation_project_flutter/core/session/cubit/session_cubit.dart';

// ─────────────────────────────────────────────────────────
// ██  CORE — Widgets
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/core/widgets/app_button.dart';
export 'package:graduation_project_flutter/core/widgets/app_dropdown_field.dart';
export 'package:graduation_project_flutter/core/widgets/app_page_title.dart';
export 'package:graduation_project_flutter/core/widgets/app_password_field.dart';
export 'package:graduation_project_flutter/core/widgets/app_text_field.dart';
export 'package:graduation_project_flutter/core/widgets/app_primary_button.dart';
export 'package:graduation_project_flutter/core/widgets/app_image_uploader.dart';
export 'package:graduation_project_flutter/core/widgets/app_section_title.dart';
export 'package:graduation_project_flutter/core/widgets/app_toggle_selector.dart';
export 'package:graduation_project_flutter/core/widgets/app_counter_widget.dart';
export 'package:graduation_project_flutter/core/widgets/app_selectable_chip.dart';
export 'package:graduation_project_flutter/core/widgets/app_checkbox.dart';
export 'package:graduation_project_flutter/core/widgets/app_dashed_container.dart';
export 'package:graduation_project_flutter/core/widgets/auth_link_text.dart';
export 'package:graduation_project_flutter/core/widgets/divider_with_text.dart';
export 'package:graduation_project_flutter/core/widgets/google_auth_button.dart';
export 'package:graduation_project_flutter/core/widgets/navigation_bar.dart';
export 'package:graduation_project_flutter/core/widgets/property_rules_section.dart';
export 'package:graduation_project_flutter/core/widgets/app_custom_dropdown.dart';

// ─────────────────────────────────────────────────────────
// ██  CORE — main
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/main.dart';


// ═════════════════════════════════════════════════════════
//  FEATURES
// ═════════════════════════════════════════════════════════

// ─────────────────────────────────────────────────────────
// ██  FEATURE — App Init (Splash + Onboarding + Auth Options)
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/features/app_init(sp+onB+authOP)/presentation/screens/splash_screen.dart';
export 'package:graduation_project_flutter/features/app_init(sp+onB+authOP)/presentation/screens/auth_options_screen.dart';
export 'package:graduation_project_flutter/features/app_init(sp+onB+authOP)/presentation/screens/onboarding/controller/onboarding_cubit.dart';
export 'package:graduation_project_flutter/features/app_init(sp+onB+authOP)/presentation/screens/onboarding/data/onboarding_data.dart';
export 'package:graduation_project_flutter/features/app_init(sp+onB+authOP)/presentation/screens/onboarding/presentation/screens/onboarding_screen.dart';
export 'package:graduation_project_flutter/features/app_init(sp+onB+authOP)/presentation/screens/onboarding/presentation/widgets/onboarding_item.dart';
export 'package:graduation_project_flutter/features/app_init(sp+onB+authOP)/presentation/screens/onboarding/presentation/widgets/moving_elipse.dart';

// ─────────────────────────────────────────────────────────
// ██  FEATURE — Auth (SignIn + SignUp + Forget Password)
// ─────────────────────────────────────────────────────────
// Data
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/data/datasources/user_local_data_source.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/data/datasources/user_remote_data_source.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/data/repositories/user_repository_impl.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/data/models/user_model.dart';
// Domain
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/domain/repositories/auth_repository.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/domain/usecases/forget_password_usecase.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/domain/usecases/reset_password_usecase.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/domain/usecases/resend_email_otp_usecase.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/domain/usecases/send_email_otp_usecase.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/domain/usecases/verify_email_otp_usecase.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/domain/usecases/verification_usecase.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/domain/usecases/google_signin_usecase.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/domain/usecases/signin_usecase.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/domain/usecases/signup_usecase.dart';
import 'package:graduation_project_flutter/features/role_selection/domain/usecases/roleSelection_usecase.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/domain/entities/user_entity.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/domain/entities/auth_entity.dart';

// Screens
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/screens/forget_password_screen.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/screens/sign_in_screen.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/screens/sign_up_screen.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/screens/new_password_screen.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/screens/verification_screen.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/screens/email_verification_screen.dart';
// Widgets
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/widgets/forgot_password_form.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/widgets/login_form.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/widgets/new_password_form.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/widgets/otp_code.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/widgets/register_form.dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/widgets/verification_form.dart';
// State Management
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/state_management(bloc)/login(event%20&%20state%20&%20bloc).dart';
export 'package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/state_management(bloc)/auth_state.dart';
export 'package:graduation_project_flutter/features/role_selection/domain/usecases/roleSelection_usecase.dart';
export 'package:graduation_project_flutter/features/role_selection/presentation/state_management(bloc)/roleSelection(event & state & bloc).dart';
export "package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/state_management(bloc)/Register(event&state&bloc).dart";
export "package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/state_management(bloc)/forget_password(event&state&block).dart";
export "package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/state_management(bloc)/google_auth(event&state&bloc).dart";
export "package:graduation_project_flutter/features/auth(Sin+Sup+Fpass)/presentation/state_management(bloc)/email_verification_bloc.dart";


// ─────────────────────────────────────────────────────────
// ██  FEATURE — Home Tab
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/home_screen.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/search_filter_results_screen.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/widgets/shared_property_widgets.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/state_management(bloc)/home(event & state & bloc).dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/state_management(bloc)/property_type_listing_cubit.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/state_management(bloc)/reviews_cubit.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/state_management(bloc)/property_details_cubit.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/state_management(bloc)/property_details_state.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/domain/entities/auth_entity.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/domain/entities/user_entity.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/domain/repositories/auth_repository.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/domain/repositories/home_repository.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/domain/repositories/reviews_repository.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/domain/usecases/home_usecase.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/domain/usecases/reviews_usecases.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/datasources/user_local_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/datasources/user_remote_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/datasources/home_remote_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/datasources/reviews_remote_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/models/user_model.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/models/review_model.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/models/home_property_model.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/models/property_details_model.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/models/property_type_model.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/repositories/user_repository_impl.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/repositories/home_repository_impl.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/data/repositories/reviews_repository_impl.dart';

// ─────────────────────────────────────────────────────────
// ██  FEATURE — Favourite Tab
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/presentation/screens/favourite_screen.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/presentation/state_management(bloc)/wishlist_cubit.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/domain/entities/wishlist_auth_entity.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/domain/entities/wishlist_entity.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/domain/repositories/auth_repository.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/domain/repositories/wishlist_repository.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/domain/usecases/favourite_usecase.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/data/datasources/wishlist_local_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/data/datasources/user_remote_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/data/datasources/wishlist_remote_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/data/models/user_model.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/data/models/wishlist_item_model.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/data/repositories/user_repository_impl.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/data/repositories/wishlist_repository_impl.dart';

// ─────────────────────────────────────────────────────────
// ██  FEATURE — Chat Tab
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/presentation/screens/chat_screen.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/presentation/screens/chat_details_screen.dart';
// State Management
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/presentation/state_management(bloc)/chat_bloc.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/presentation/state_management(bloc)/chat_event.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/presentation/state_management(bloc)/chat_state.dart';
// Widgets
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/presentation/widgets/chat_item_widget.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/presentation/widgets/chat_property_snippet.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/presentation/widgets/chat_message_bubble.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/presentation/widgets/chat_input_area.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/presentation/widgets/chat_avatar.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/presentation/widgets/chat_action_dialogs.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/presentation/widgets/shared_property_card.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/domain/entities/auth_entity.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/domain/entities/user_entity.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/domain/repositories/auth_repository.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/domain/usecases/chat_usecase.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/data/datasources/user_local_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/data/datasources/user_remote_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/data/models/user_model.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/chat_tab/data/repositories/user_repository_impl.dart';

// ─────────────────────────────────────────────────────────
// ██  FEATURE — Profile Tab
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/presentation/screens/profile_screen.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/presentation/state_management(bloc)/profile(event & state & bloc).dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/domain/entities/auth_entity.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/domain/entities/user_entity.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/domain/repositories/auth_repository.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/domain/usecases/profile_usecase.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/datasources/user_local_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/datasources/user_remote_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/models/user_model.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/repositories/user_repository_impl.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/presentation/widgets/profile_header.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/presentation/widgets/profile_menu_tile.dart';
export 'package:graduation_project_flutter/features/offer_profile/presentation/screens/my_offer_screen.dart';
export 'package:graduation_project_flutter/features/offer_profile/presentation/widget/offer_card.dart';
export 'package:graduation_project_flutter/features/offer_profile/presentation/widget/section_title.dart';
export 'package:graduation_project_flutter/features/my_listing/presentation/screens/my_listings_screen.dart';
export 'package:graduation_project_flutter/features/my_listing/presentation/widgets/listing_card.dart';
export 'package:graduation_project_flutter/features/my_listing/presentation/widgets/listing_tab_bar.dart';
export 'package:graduation_project_flutter/features/my_listing/presentation/widgets/boost_dialog.dart';
export 'package:graduation_project_flutter/features/offer_request/presentation/widgets/offer_request_card.dart';
export 'package:graduation_project_flutter/features/offer_request/presentation/widgets/offer_request_tab_bar.dart';
export 'package:graduation_project_flutter/features/offer_request/presentation/screens/offer_requests_screen.dart';
export 'package:graduation_project_flutter/features/rental_management/presentation/widgets/rental_card.dart';
export 'package:graduation_project_flutter/features/rental_management/presentation/widgets/rental_summary_card.dart';
export 'package:graduation_project_flutter/features/rental_management/presentation/screens/rental_management_screen.dart';
export 'package:graduation_project_flutter/features/rental_management/presentation/state_management/rental_management_cubit.dart';


export 'package:graduation_project_flutter/features/my_listing/presentation/widgets/resolution_center_screen.dart';

// My Listings API
export 'package:graduation_project_flutter/features/my_listing/data/models/my_property_model.dart';
export 'package:graduation_project_flutter/features/my_listing/data/datasources/my_listing_remote_data_source.dart';
export 'package:graduation_project_flutter/features/my_listing/domain/repositories/my_listing_repository.dart';
export 'package:graduation_project_flutter/features/my_listing/data/repositories/my_listing_repository_impl.dart';
export 'package:graduation_project_flutter/features/my_listing/presentation/state_management(bloc)/my_listing_cubit.dart';

export 'package:graduation_project_flutter/features/verification&decomentation/presentation/screens/verification_status_screen.dart';
export 'package:graduation_project_flutter/features/my_wallet/presentation/screens/wallet_screen.dart';
export 'package:graduation_project_flutter/features/my_wallet/presentation/screens/top_up_screen.dart';
export 'package:graduation_project_flutter/features/my_wallet/presentation/screens/scan_screen.dart';
export 'package:graduation_project_flutter/features/my_wallet/presentation/screens/transfer_screen.dart';
export 'package:graduation_project_flutter/features/active_rental/presentation/widget/help_button.dart';
export 'package:graduation_project_flutter/features/active_rental/presentation/widget/rentals_header.dart';
export 'package:graduation_project_flutter/features/active_rental/presentation/widget/active_rental_card.dart';
export 'package:graduation_project_flutter/features/active_rental/presentation/screens/active_rentals_screen.dart';
export 'package:graduation_project_flutter/features/edit_profile/presentation/widget/edit_profile_action_buttons.dart';
export 'package:graduation_project_flutter/features/edit_profile/presentation/widget/edit_profile_date_picker.dart';
export 'package:graduation_project_flutter/features/edit_profile/presentation/widget/edit_profile_gender_dropdown.dart';
export 'package:graduation_project_flutter/features/edit_profile/presentation/widget/edit_profile_text_field.dart';
export 'package:graduation_project_flutter/features/edit_profile/presentation/screens/edit_profile_screen.dart';
export 'package:graduation_project_flutter/features/payment_method/presentation/widget/add_payment_method_button.dart';
export 'package:graduation_project_flutter/features/payment_method/presentation/widget/payment_method_card.dart';
export 'package:graduation_project_flutter/features/payment_method/presentation/widget/payment_methods_header.dart';
export 'package:graduation_project_flutter/features/payment_method/presentation/screens/payment_methods_screen.dart';

export 'package:graduation_project_flutter/features/payment_method/presentation/screens/add_payment_method_screen.dart';

// ─────────────────────────────────────────────────────────
// ██  FEATURE — Add Property
// ─────────────────────────────────────────────────────────
// Data — Datasources
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/datasources/add_property_remote_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/datasources/property_draft_local_data_source.dart';
// Data — Models
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/models/room_model.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/models/room_type_model.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/models/room_types_data.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/models/amenity_model.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/models/amenities_data.dart';
// Data — Repositories
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/repositories/add_property_repository_impl.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/models/property_request_models.dart';
// Data — Lookup Models & DataSource
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/models/lookup_models.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/datasources/lookup_remote_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/data/repositories/lookup_repository_impl.dart';
// Domain — Lookup Repository & UseCases
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/domain/repositories/lookup_repository.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/domain/usecases/lookup_usecases.dart';
// Domain
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/domain/entities/property_draft_entity.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/domain/repositories/add_property_repository.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/domain/usecases/addproperty_usecase.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/domain/usecases/save_draft_usecase.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/domain/usecases/load_draft_usecase.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/domain/usecases/clear_draft_usecase.dart';
// Screens
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/screens/add_property_screen.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/screens/location_picker_screen.dart';
// State Management
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/state_management(bloc)/add_property_event.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/state_management(bloc)/add_property_state.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/state_management(bloc)/add_property_bloc.dart';
// Widgets — Shared
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/step_header.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/step_navigation_buttons.dart';
// Widgets — Step 0 (Listing Type)
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/listing_type_step/listing_type_step.dart';
// Widgets — Step 1 (Basic Info)
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/basic_info_step/basic_info_step.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/basic_info_step/property_type_selector.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/basic_info_step/property_type_card.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/basic_info_step/transaction_type_selector.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/basic_info_step/collection_category_selector.dart';
// Widgets — Step 2 (Location)
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/location_step/location_step.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/location_step/location_details_section.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/location_step/nearby_facilities_section.dart';
// Widgets — Step 3a (Sale Pricing & Specs)
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/sale/sale_pricing_step/sale_pricing_step.dart';
// Widgets — Step 3b (Rental Pricing)
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/rent_full/rental_pricing_step/rental_pricing_step.dart';
// Widgets — Step 4 (Specs & Features) [NEW]
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/specs_step/specs_step.dart';
// Widgets — Amenities Step [SHARED]
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/amenities_step/amenities_step.dart';
// Widgets — Room Pricing Step [NEW]
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/rent_room/room_pricing_step/room_pricing_step.dart';
// Widgets — Shared Pricing Components
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/pricing/selection_card.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/pricing/pricing_input_field.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/pricing/short_term_fields.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/pricing/long_term_base_fields.dart';
// Widgets — Step 5 (Images)
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/media_step/media_step.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/media_step/cover_image_picker.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/media_step/photography_tips_card.dart';
// Step 6 (Pricing) was removed
// Widgets — Step 7 (Property Interior)
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/rent_room/interior_step/interior_step.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/rent_room/interior_step/room_card_widget.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/rent_room/interior_step/add_room_bottom_sheet.dart';
// Widgets — Step 8 (Availability Calendar)
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/rent_full/calendar_step/calendar_step.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/rent_full/calendar_step/custom_availability_calendar.dart';
// Widgets — Step 9 (Summary)
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/summary_step/summary_step.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/add_property/presentation/widgets/shared/summary_step/success_step.dart';

// ─────────────────────────────────────────────────────────
// ██  FEATURE — Notifications
// ─────────────────────────────────────────────────────────
// Domain
export 'package:graduation_project_flutter/features/notifications/domain/entities/notification_entity.dart';
// Data
export 'package:graduation_project_flutter/features/notifications/data/models/notification_model.dart';
// State Management
export 'package:graduation_project_flutter/features/notifications/presentation/state_management/notification_bloc.dart';
export 'package:graduation_project_flutter/features/notifications/presentation/state_management/notification_event.dart';
export 'package:graduation_project_flutter/features/notifications/presentation/state_management/notification_state.dart';
// Screens

export 'package:graduation_project_flutter/features/notifications/presentation/screens/notifications_screen.dart';
// Widgets
export 'package:graduation_project_flutter/features/notifications/presentation/widgets/notification_item.dart';
export 'package:graduation_project_flutter/features/notifications/presentation/widgets/notifications_tabs.dart';

// ─────────────────────────────────────────────────────────
// ██  FEATURE — Offer
// ─────────────────────────────────────────────────────────
// Domain
export 'package:graduation_project_flutter/features/offer/domain/entities/offer_entity.dart';
export 'package:graduation_project_flutter/features/offer/domain/entities/payment_entity.dart';
export 'package:graduation_project_flutter/features/offer/domain/entities/property_entity.dart';
export 'package:graduation_project_flutter/features/offer/domain/repositories/offer_repository.dart';
export 'package:graduation_project_flutter/features/offer/domain/repositories/offers_repository.dart';
export 'package:graduation_project_flutter/features/offer/domain/usecases/complete_handover_usecase.dart';
export 'package:graduation_project_flutter/features/offer/domain/usecases/confirm_payment_usecase.dart';
export 'package:graduation_project_flutter/features/offer/domain/usecases/create_offer_usecase.dart';
export 'package:graduation_project_flutter/features/offer/domain/usecases/get_property_summary_usecase.dart';
export 'package:graduation_project_flutter/features/offer/domain/usecases/submit_offer_usecase.dart';
export 'package:graduation_project_flutter/features/offer/domain/usecases/initiate_payment_usecase.dart';
export 'package:graduation_project_flutter/features/offer/domain/usecases/check_payment_status_usecase.dart';

// Data
export 'package:graduation_project_flutter/features/offer/data/datasources/offer_remote_data_source.dart';
export 'package:graduation_project_flutter/features/offer/data/datasources/offers_remote_data_source.dart';
export 'package:graduation_project_flutter/features/offer/data/models/offer_model.dart';
export 'package:graduation_project_flutter/features/offer/data/models/payment_model.dart';
export 'package:graduation_project_flutter/features/offer/data/models/property_model.dart';
export 'package:graduation_project_flutter/features/offer/data/models/paginated_offers_model.dart';
export 'package:graduation_project_flutter/features/offer/data/repositories/offer_repository_impl.dart';
export 'package:graduation_project_flutter/features/offer/data/repositories/offers_repository_impl.dart';

// Presentation — State Management
export 'package:graduation_project_flutter/features/offer/presentation/state_management/bloc/offer_bloc.dart';
export 'package:graduation_project_flutter/features/offer/presentation/state_management/bloc/offer_event.dart';
export 'package:graduation_project_flutter/features/offer/presentation/state_management/bloc/offer_state.dart';

// Presentation — Screens
export 'package:graduation_project_flutter/features/offer/presentation/screens/final_success_screen.dart';
export 'package:graduation_project_flutter/features/offer/presentation/screens/handover_check_screen.dart';
export 'package:graduation_project_flutter/features/offer/presentation/screens/make_offer_screen.dart';
export 'package:graduation_project_flutter/features/offer/presentation/screens/offer_flow_screen.dart';
export 'package:graduation_project_flutter/features/offer/presentation/screens/offer_sent_success_screen.dart';
export 'package:graduation_project_flutter/features/offer/presentation/screens/payment_deposit_screen.dart';
export 'package:graduation_project_flutter/features/offer/presentation/screens/payment_receipt_screen.dart';
export 'package:graduation_project_flutter/features/offer/presentation/screens/payment_success_screen.dart';

// Presentation — Widgets
export 'package:graduation_project_flutter/features/offer/presentation/widgets/checklist_item.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/community_guidelines_card.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/info_row.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/offer_progress_stepper.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/offer_property_card.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/offer_section_title.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/offer_status_text_section.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/offer_stepper.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/offer_success_image_card.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/offer_validity_banner.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/payment_method_card.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/property_summary_card.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/proposed_terms_card.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/status_card.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/verified_listing_banner.dart';
export 'package:graduation_project_flutter/features/offer/presentation/widgets/sale_proposed_terms_card.dart';

// ─────────────────────────────────────────────────────────
// ██  FEATURE — Favourite Tab Widgets
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/presentation/widgets/favourite_search_bar.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/presentation/widgets/favourite_category_filter.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/presentation/widgets/favourite_property_card.dart';

// ─────────────────────────────────────────────────────────
// ██  FEATURE — Home Tab Screens (Property Details, Search, Filter , Reviews)
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_details_wrapper.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_details_rent.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_details_sale.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_room.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_sharedRoom.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_shortterm.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_listing_screen.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_type_listing_screen.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/search_screen.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/filter_screen.dart';

// ─────────────────────────────────────────────────────────
// ██  FEATURE — Role Selection
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/features/role_selection/presentation/screens/roleSelection_screen.dart';

// ─────────────────────────────────────────────────────────
// ██  Add Property Auto-Added Exports
// ─────────────────────────────────────────────────────────
export 'package:flutter/foundation.dart';
// ─────────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────────
// ██  PROFILE — Clean Architecture (New)
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/datasources/profile_remote_data_source.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/data/repositories/profile_repository_impl.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/domain/repositories/profile_repository.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/profile_tab/presentation/state_management(bloc)/profile_cubit.dart';

// ─────────────────────────────────────────────────────────
// ██  OFFER PROFILE — Cubits
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/features/offer_profile/presentation/state_management(bloc)/sent_offers_cubit.dart';
export 'package:graduation_project_flutter/features/offer_profile/presentation/state_management(bloc)/my_offers_cubit.dart';
export 'package:graduation_project_flutter/features/offer_request/presentation/state_management(bloc)/received_offers_cubit.dart';

// Chatbot Feature
export 'package:graduation_project_flutter/features/chatbot/presentation/screens/chatbot_screen.dart';
export 'package:graduation_project_flutter/features/chatbot/presentation/state_management/bloc/chatbot_bloc.dart';
export 'package:graduation_project_flutter/features/chatbot/presentation/state_management/bloc/chatbot_event.dart';
export 'package:graduation_project_flutter/features/chatbot/presentation/state_management/bloc/chatbot_state.dart';
export 'package:graduation_project_flutter/features/chatbot/domain/usecases/chatbot_usecases.dart';
export 'package:graduation_project_flutter/features/chatbot/domain/repositories/chatbot_repository.dart';
export 'package:graduation_project_flutter/features/chatbot/data/repositories/chatbot_repository_impl.dart';
export 'package:graduation_project_flutter/features/chatbot/data/datasources/chatbot_remote_data_source.dart';
export 'package:graduation_project_flutter/features/chatbot/data/models/chat_message_model.dart';
export 'package:graduation_project_flutter/features/chatbot/domain/entities/chat_message_entity.dart';

// Additional Chatbot Feature Exports

export 'package:graduation_project_flutter/features/chatbot/presentation/widgets/chat_bubble.dart';
export 'package:graduation_project_flutter/features/chatbot/presentation/widgets/chatbot_input_area.dart';
export 'package:graduation_project_flutter/features/chatbot/presentation/widgets/suggestion_chips.dart';
export 'package:graduation_project_flutter/features/chatbot/presentation/widgets/typing_indicator.dart';
export 'package:graduation_project_flutter/features/chatbot/presentation/widgets/chatbot_property_card.dart';

// Core Widgets
export 'package:graduation_project_flutter/core/widgets/app_date_picker_field.dart';
export 'package:graduation_project_flutter/core/widgets/app_dropdown_field.dart';

// Settings & Additional Screens
export 'package:graduation_project_flutter/features/setting/presentation/screans/settings_screan.dart';
export 'package:graduation_project_flutter/features/setting/presentation/screans/help_center_screen.dart';
export 'package:graduation_project_flutter/features/setting/presentation/screans/privacy_policy_screen.dart';
export 'package:graduation_project_flutter/features/setting/presentation/screans/terms_conditions_screen.dart';

// ─────────────────────────────────────────────────────────
// ██  MY CONTRACTS
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/features/my_contracts/presentation/screens/my_contracts_screen.dart';
export 'package:graduation_project_flutter/features/my_contracts/presentation/screens/contract_details_screen.dart';
export 'package:graduation_project_flutter/features/my_contracts/presentation/state_management(bloc)/contracts_cubit.dart';

// ─────────────────────────────────────────────────────────
// Missing Exports fixed by AI
// ─────────────────────────────────────────────────────────
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_details_wrapper.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_details_rent.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_details_sale.dart' hide ExpandableChipsWidget, AnimatedLocationIconWidget;
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_sharedRoom.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_room.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_shortterm.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/property_type_listing_screen.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/home_tab/presentation/screens/search_screen.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/presentation/widgets/favourite_search_bar.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/presentation/widgets/favourite_category_filter.dart';
export 'package:graduation_project_flutter/features/tabs(Home+Fav+AddProperty+Chat+Profile)/favourite_tab/presentation/widgets/favourite_property_card.dart';
