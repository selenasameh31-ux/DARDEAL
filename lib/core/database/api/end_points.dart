// All project endpoints defined here as named constants.
// Dynamic segments (e.g. /{id}/...) are built via static helper methods.

class EndPoints {
  static const String baseUrl = "https://dardeal.runasp.net";

  // ─────────────────────────────────────────────────────────
  // Auth
  // ─────────────────────────────────────────────────────────
  static const String newUser = "/api/v1/auth/register";
  static const String loggedinUser = "/api/v1/auth/login";
  static const String refreshAccessToken = "/api/v1/auth/refresh-token";
  static const String logoutUser = "/api/v1/auth/logout";
  static const String userEmailAndPhoneVerify = "/api/v1/auth/status";

  // ─────────────────────────────────────────────────────────
  // Email Verification
  // ─────────────────────────────────────────────────────────
  static const String sendOTPViaEmail = "/api/v1/auth/email/send";
  static const String verifyEmailUsingToken = "/api/v1/auth/email/verify";
  static const String alternativeSendOTP = "/api/v1/auth/email/verify-otp";
  static const String resendOTPViaEmail = "/api/v1/auth/email/resend";
  static const String confirmEmailChangeByToken =
      "/api/v1/auth/email/change-verify";
  static const String emailVerificationStatus = "/api/v1/auth/email/status";

  // ─────────────────────────────────────────────────────────
  // Password
  // ─────────────────────────────────────────────────────────
  static const String passwordResetViaEmail =
      "/api/v1/auth/password/forgot/email";
  static const String passwordResetViaPhone =
      "/api/v1/auth/password/forgot/phone";
  static const String passwordResetPage = "/api/v1/auth/password/reset";
  static const String resetPasswordUsingToken = "/api/v1/auth/password/reset";
  static const String verifyOTPforPassReset =
      "/api/v1/auth/password/verify-otp";

  // ─────────────────────────────────────────────────────────
  // Phone Verification
  // ─────────────────────────────────────────────────────────
  static const String sendOTPViaphone = "/api/v1/auth/phone/send-otp";
  static const String verifyPhoneOTP = "/api/v1/auth/phone/verify-otp";
  static const String resendOTPViaPhone = "/api/v1/auth/phone/resend-otp";
  static const String phoneVerificationStatus = "/api/v1/auth/phone/status";

  // ─────────────────────────────────────────────────────────
  // Health
  // ─────────────────────────────────────────────────────────
  static const String checkAPIisRunning = "/api/v1/health/live";
  static const String checkAPIandDBareReady = "/api/v1/health/ready";
  static const String detailedHealthStatusAndDBInfo = "/api/v1/health/status";

  // ─────────────────────────────────────────────────────────
  // Role Selection
  // ─────────────────────────────────────────────────────────
  static const String roleSelect = "/api/v1/auth/role/select";
  static const String roleGuest = "/api/v1/auth/role/guest";
  static const String roleCurrent = "/api/v1/auth/role/current";

  // ─────────────────────────────────────────────────────────
  // Social Auth
  // ─────────────────────────────────────────────────────────
  static const String googleSignIn = "/api/v1/SocialAuth/google-signin";
  static const String linkGoogle = "/api/v1/SocialAuth/link-google";
  static const String unlinkGoogle = "/api/v1/SocialAuth/unlink-google";

  // ─────────────────────────────────────────────────────────
  // Users / Profile
  // ─────────────────────────────────────────────────────────
  static const String currentUserProfileInfo = "/api/v1/users/profile";
  static const String updateUserProfileInfo = "/api/v1/users/profile";
  static const String inactiveUserProfile = "/api/v1/users/profile";
  static const String userProfileById = "/api/v1/users/{userId}";
  static const String changeCurrentUserPassword =
      "/api/v1/users/change-password";
  static const String usersWhoDonotHavePassword = "/api/v1/users/set-password";
  static const String checkIfCurrentUserHavePassword =
      "/api/v1/users/has-password";
  static const String changeEmailAddressWithOTP = "/api/v1/users/change-email";
  static const String changePhoneNumberWithOTP = "/api/v1/users/change-phone";
  static const String profile = "/api/v1/users/profile";
  static const String uploadProfilePhoto = "/api/v1/users/profile/photo";

  // ─────────────────────────────────────────────────────────
  // Properties — static paths
  // ─────────────────────────────────────────────────────────
  static const String createProperty = "/api/v1/Properties";
  static const String submitProperty = "/api/v1/properties";
  static const String myProperties = "/api/v1/Properties/my-properties";

  // Properties — dynamic path builders (use these in DataSource)
  static String property(int id) => "/api/v1/Properties/$id";
  static String propertyById(int id) => "/api/v1/Properties/$id";
  static String propertyMedia(int id) => "/api/v1/Properties/$id/media";
  static String propertyRooms(int id) => "/api/v1/Properties/$id/rooms";
  static String propertySubmit(int id) => "/api/v1/Properties/$id/submit";
  static String propertyAvailability(int id) =>
      "/api/v1/Properties/$id/availability";

  // ─────────────────────────────────────────────────────────
  // Lookups
  // ─────────────────────────────────────────────────────────
  static const String getGovernorates = "/api/v1/Lookups/governorates";
  static const String getCities = "/api/v1/Lookups/cities";
  static const String getDistricts = "/api/v1/Lookups/districts";
  static const String getAmenities = "/api/v1/Lookups/amenities";
  static const String getNearbyFacilities = "/api/v1/Lookups/nearby-facilities";
  static const String getRules = "/api/v1/Lookups/rules";
  static const String getPropertyTypes = "/api/v1/Lookups/property-types";
  static const String getPropertyStatuses = "/api/v1/Lookups/property-statuses";
  static const String getQuickFilters = "/api/v1/Lookups/quick-filters";

  // ─────────────────────────────────────────────────────────
  // Contracts / Handover
  // ─────────────────────────────────────────────────────────
  static String myContracts = "/api/v1/Contracts/my";
  static String contractDetails(int contractId) => "/api/v1/Contracts/$contractId";
  static String confirmHandover(int contractId) => "/api/v1/Contracts/$contractId/handover/confirm";
  static String uploadHandoverPdf(int contractId) => "/api/v1/Contracts/$contractId/handover/pdf";

  // ─────────────────────────────────────────────────────────
  // Offers
  // ─────────────────────────────────────────────────────────
  static const String getPropertySummary = "/api/v1/Properties/{propertyId}";
  static const String offers = "/api/v1/Offers";
  static const String createOffer = "/api/v1/Offers";
  static const String submitOffer = "/api/v1/Offers/{offerId}/submit";
  static const String confirmPayment = "/api/v1/Offers/{offerId}/payment";
  static const String completeHandover = "/api/v1/offers/{offerId}/handover";

  static const String sentOffers = "/api/v1/Offers/sent";
  static const String receivedOffers = "/api/v1/Offers/received";
  static const String myOffers = "/api/v1/Offers/sent";
  static const String offerById = "/api/v1/Offers/{id}";
  static const String reviewOffer = "/api/v1/Offers/{id}/review";
  static const String initiatePayment = "/api/v1/Payments/initiate";
  static String paymentStatus(int id) => "/api/v1/Payments/$id";
  static String offer(String id) => "/api/v1/Offers/$id";

  // Offer Requests
  static const String offerRequests = "/api/v1/Offers/received";
  static String offerRequest(String id) => "/api/v1/Offers/$id";

  // Reviews
  static const String createReview        = "/api/v1/Reviews";
  static const String getPropertyReviews  = "/api/v1/Reviews/property"; // /{propertyId}
  static const String getPropertyReviewSummary = "/api/v1/Reviews/property"; // /{propertyId}/summary
  static const String getMyReviews        = "/api/v1/Reviews/my";
  static const String ownerReviews        = "/api/v1/Reviews/owner"; // /{ownerId}
  static const String reviewResponse      = "/api/v1/Reviews"; // /{id}/response
  static const String reportReview        = "/api/v1/Reviews"; // /{id}/report
  static const String createComplaint     = "/api/v1/Complaints";

  // Wishlist
  static const String getWishlist = '/api/v1/Wishlist';
  static const String getWishlistDetail = '/api/v1/Wishlist/detail';
  static const String toggleWishlist = '/api/v1/Wishlist/';
  static const String checkWishlist = '/api/v1/Wishlist/';
  static const String batchCheckWishlist = '/api/v1/Wishlist/batch-check';
  static const String getWishlistCount = '/api/v1/Wishlist/count';

  // Properties
  static const String updateProperty = '/api/v1/Properties/';
  static const String deleteProperty = '/api/v1/Properties/';
  static const String getPropertyDetails = '/api/v1/Properties/';
  static const String getFeaturedProperties = '/api/v1/Properties/featured';
  static const String getRecentProperties = '/api/v1/Properties/recent';
  static const String getMyProperties = '/api/v1/Properties/my-properties';
  static const String addRoom = '/api/v1/Properties/'; // + {id}/rooms
  static const String getPropertyRooms = '/api/v1/Properties/'; // + {id}/rooms
  static const String updateRoom = '/api/v1/Properties/'; // + {id}/rooms/{roomId}
  static const String deleteRoom = '/api/v1/Properties/'; // + {id}/rooms/{roomId}
  static const String setAvailability = '/api/v1/Properties/'; // + {id}/availability
  static const String getAvailability = '/api/v1/Properties/'; // + {id}/availability
  static const String uploadPropertyMedia = '/api/v1/Properties/'; // + {id}/media
  static const String deletePropertyMedia = '/api/v1/Properties/'; // + {id}/media/{mediaId}
  static const String reorderPropertyMedia = '/api/v1/Properties/'; // + {id}/media/reorder
  static const String trackPropertyView = '/api/v1/Properties/'; // + {id}/view
  static const String searchProperties = '/api/v1/Properties/search';
  static const String searchRooms = '/api/v1/Properties/rooms/search';
  static const String getSimilarProperties = '/api/v1/Properties/'; // + {id}/similar
  static const String uploadVerificationDocuments = '/api/v1/Properties/'; // + {id}/verification-documents

  // Search & Filters
  static const String homeFeed = "/api/v1/HomeFeed";
  static const String savedSearches = "/api/v1/Search/saved";
  static const String searchSuggestions = "/api/v1/Search/suggestions";
  static const String searchRecent = "/api/v1/Search/recent";
  static const String smartSearch = "/api/v1/Search/smart";
  static const String trendingSearch = "/api/v1/Search/trending";
  static const String popularAreas = "/api/v1/Search/popular-areas";
  static const String searchCount = "/api/v1/Search/count";

  // Lookups
  static const String propertyTypesLookups = "/api/v1/Lookups/property-types";

  // Profile (New)
  static const String getProfile = "/api/v1/Profile";
  static const String updateProfile = "/api/v1/Profile";
  static const String getProfileStats = "/api/v1/Profile/stats";
  static const String getOwnerStats = "/api/v1/Profile/owner-stats";

  // Active Rentals
  static const String rentals = "/api/v1/Rentals";
  static const String getRentalsCount = "/api/v1/Rentals/count";
  static String getRentalById(int id) => "/api/v1/Rentals/$id";
  static String getRentalPayments(int id) => "/api/v1/Rentals/$id/payments";
  static String addRentalPayment(int id) => "/api/v1/Rentals/$id/payments";
  static String terminateRental(int id) => "/api/v1/Rentals/$id/terminate";

  // Verification Documents
  static const String verificationDocuments = "/api/v1/verification-documents";

  // AI Chatbot
  static const String aiChat = "/api/v1/AI/chat";
  static const String aiChatInit = "/api/v1/AI/chat/init";

  // Chats
  static const String chats = "/api/v1/Chats";
  static const String unreadCount = "/api/v1/Chats/unread-count";

  static String chatDetails(int chatId) => "/api/v1/Chats/$chatId";
  static String chatMessages(int chatId) => "/api/v1/Chats/$chatId/messages";
  static String markChatRead(int chatId) => "/api/v1/Chats/$chatId/read";
  static String chatMedia(int chatId) => "/api/v1/Chats/$chatId/media";
  static String editMessage(int messageId) => "/api/v1/Chats/messages/$messageId";
  static String deleteMessage(int messageId) => "/api/v1/Chats/messages/$messageId";

  // User Actions (Block / Unblock)
  static String blockUser(int userId) => "/api/v1/users/$userId/block";
  static String unblockUser(int userId) => "/api/v1/users/$userId/unblock";
}
