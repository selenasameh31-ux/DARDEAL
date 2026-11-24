import 'package:graduation_project_flutter/core/routing/routes_export.dart';

// class FilterScreen extends StatefulWidget {
//   const FilterScreen({super.key});

//   @override
//   State<FilterScreen> createState() => _FilterScreenState();
// }

// class _FilterScreenState extends State<FilterScreen> {
//   // --- متغيرات حالة الفلاتر لتخزين القيم التي يختارها المستخدم ---
//   String listingType = "Rent";
//   List<String> propertyTypes = ["Room"];
  
//   // متغيرات تحديد الموقع الجغرافي
//   String? selectedGov;
//   String? selectedCity;
//   String? selectedDistrict;

//   // متغير تحديد نطاق الميزانية
//   RangeValues budgetRange = const RangeValues(1000, 35000);
  
//   // متغيرات عدد الغرف والحمامات
//   String beds = "2+ Beds";
//   String baths = "2+ Baths";
  
//   // قائمة المرافق المعروضة والمختارة حالياً
//   List<String> displayedAmenities = ["Wi-Fi", "Parking", "Elevator", "Gym", "Security"];
//   List<String> selectedAmenities = ["Wi-Fi", "Parking"];
  
//   // المرافق الإضافية المتاحة للإضافة من خلال النافذة المنبثقة
//   final List<String> allExtraAmenities = ["Pool", "Balcony", "Central AC", "Jacuzzi", "Smart Home", "BBQ Area", "Maid Room"];

//   String furnishing = "Furnished";
//   String availability = "Available Now";
//   String rentalDuration = "Short Term";
  
//   List<String> specialFeatures = ["Verified only", "Negotiable only"];

//   // القواعد المعروضة والمختارة حالياً
//   List<String> displayedRules = ["No Smoking", "No Pets", "Family Friendly", "Quiet Hours", "No Parties"];
//   List<String> houseRules = ["Family Friendly"];

//   // القواعد الإضافية المتاحة للإضافة من خلال النافذة المنبثقة
//   final List<String> allExtraRules = ["No Subletting", "No Commercial Use", "Couples Only", "Long Term Only", "Guests Allowed"];

//   List<String> roommatePreferences = ["Students"];
  
//   // متغير خيار الترتيب المختار
//   String sortBy = "Newest";

//   // --- قائمة بيانات المحافظات والمدن والمناطق في مصر ---
//   final List<String> governorates = [
//     "Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Faiyum",
//     "Gharbia", "Ismailia", "Menofia", "Minya", "Qaliubiya", "New Valley", "Suez",
//     "Aswan", "Assiut", "Beni Suef", "Port Said", "Damietta", "Sharkia", "South Sinai",
//     "Kafr El Sheikh", "Matrouh", "Luxor", "Qena", "North Sinai", "Sohag"
//   ];

//   final Map<String, List<String>> citiesMap = {
//     "Cairo": ["Cairo", "New Cairo", "Badr City", "El Shorouk", "Helwan", "15th of May", "El Marg", "New Capital"],
//     "Giza": ["Giza", "6th of October", "Sheikh Zayed", "El Hawamdiyah", "El Badrashein", "Oseem", "Kerdasa", "Abu Rawash"],
//     "Alexandria": ["Alexandria", "Borg El Arab", "New Borg El Arab", "Abu Qir", "Agami"],
//     "Dakahlia": ["Mansoura", "Talkha", "Mit Ghamr", "Dekernes", "Aga", "Minyet El Nasr", "Sherbin", "Beni Ebeid"],
//     "Red Sea": ["Hurghada", "Safaga", "Marsa Alam", "Ras Gharib", "El Quseir", "Shalateen"],
//     "Beheira": ["Damanhour", "Kafr El Dawwar", "Rashid", "Edku", "Abu Hommos", "Wadi El Natrun"],
//     "Faiyum": ["Faiyum City", "Sinnuris", "Ibsheway", "Tamiya", "Atsa", "Yousef El Seddik"],
//     "Gharbia": ["Tanta", "El Mahalla", "Kafr El Zayat", "Zifta", "Samanoud", "Basyoun"],
//     "Ismailia": ["Ismailia", "Fayed", "Qantara Sharq", "Qantara Gharb", "Abu Suwir", "Kassasin"],
//     "Menofia": ["Shibin El Kom", "Menouf", "Ashmoun", "Quesna", "Tala", "Sadat City", "Bagour"],
//     "Minya": ["Minya", "Mallawi", "Samalut", "Beni Mazar", "Maghagha", "Abu Qurqas", "Deir Mawas"],
//     "Qaliubiya": ["Banha", "Shubra El Kheima", "Qalyub", "Khanka", "Shebin", "Toukh", "Qaha"],
//     "New Valley": ["Kharga", "Dakhla", "Farafra", "Baris", "Balat"],
//     "Suez": ["Suez", "Ain Sokhna", "Ataka", "Arbaeen"],
//     "Aswan": ["Aswan", "Kom Ombo", "Edfu", "Daraw", "Nasr Al Nuba", "Abu Simbel"],
//     "Assiut": ["Assiut", "Dayrout", "El Qusiya", "Manfalut", "Abu Tig", "Abnub", "Sedfa", "El Ghanayem"],
//     "Beni Suef": ["Beni Suef", "Nasser", "Al Wasta", "Biba", "Ehnasia", "Sumusta", "Al Fashn"],
//     "Port Said": ["Port Said", "Port Fouad", "Al Zohour", "Al Dawahy"],
//     "Damietta": ["Damietta", "New Damietta", "Ras El Bar", "Faraskour", "Zarkha", "Kafr Saad"],
//     "Sharkia": ["Zagazig", "10th of Ramadan", "Minya El Qamh", "Bilbeis", "Mashtoul", "Faqus", "Abu Hammad"],
//     "South Sinai": ["Sharm El Sheikh", "Dahab", "Nuweiba", "Taba", "El Tor", "Saint Catherine", "Ras Sudr"],
//     "Kafr El Sheikh": ["Kafr El Sheikh", "Desouk", "Baltim", "Metoubes", "Fowa", "Kelin"],
//     "Matrouh": ["Marsa Matrouh", "El Alamein", "Sidi Abdel Rahman", "Dabaa", "Sidi Barrani", "Siwa"],
//     "Luxor": ["Luxor", "Karnak", "Esna", "Armant", "Qurna", "Tud"],
//     "Qena": ["Qena", "Nagaa Hammadi", "Qus", "Qift", "Dishna", "Farshut", "Abu Tesht"],
//     "North Sinai": ["Arish", "Sheikh Zuweid", "Rafah", "Bir al-Abed", "Nekhel", "Hassana"],
//     "Sohag": ["Sohag", "Akhmim", "Girga", "Tahta", "Tima", "Dar El Salam", "Juhayna"]
//   };

//   final Map<String, List<String>> districtsMap = {
//     "Cairo": ["Maadi", "Nasr City", "Heliopolis", "Downtown", "Zamalek", "Shubra", "Mokattam", "El Dokki", "Al Zeitoun", "Al Rehab", "Madinaty"],
//     "New Cairo": ["1st Settlement", "3rd Settlement", "5th Settlement", "Choueifat", "South Investors", "North Investors"],
//     "Helwan": ["Wadi Hof", "Hadayek Helwan", "15th of May", "El Tebeen"],
//     "Giza": ["Dokki", "Mohandeseen", "Agouza", "Haram", "Faisal", "Imbaba", "Bulaq Dakrour", "Kit Kat"],
//     "6th of October": ["1st District", "2nd District", "7th District", "8th District", "Hosary", "West Somid", "Al Ashgar"],
//     "Sheikh Zayed": ["Beverly Hills", "Zayed 2000", "Al-Rabaa", "El Hay El Tasea", "El Hay El Asher"],
//     "Alexandria": ["Smouha", "Sidi Gaber", "Gleem", "Mandara", "Agami", "Miami", "Montaza", "Roshdy", "San Stefano", "Stanley", "Mahatet El Raml", "Louran"],
//     "Borg El Arab": ["First District", "Second District", "Industrial Zone"],
//     "Port Said": ["Al-Sharq", "Al-Arab", "Al-Manakh", "Al-Dawahy", "Al-Zohour"],
//     "Mansoura": ["Hay Gharb", "Hay Sharq", "Gedila", "Toriel", "Al Mashaya"],
//     "Ismailia": ["Hay Awal", "Hay Thany", "Hay Thaleth", "Al-Sheikh Zayed"],
//     "Tanta": ["Al-Mahata", "Siger", "Kafr Essam", "Al-Galaa"],
//     "El Mahalla": ["Al-Shoqafy", "Al-Zeraa", "Hay Awal", "Hay Thany"],
//     "Hurghada": ["Al Dahar", "Sakkala", "Al Mamsha", "El Kawther", "Sahl Hasheesh", "El Gouna"],
//     "Sharm El Sheikh": ["Naama Bay", "Nabq Bay", "Hadaba", "Sharks Bay", "Old Market"],
//     "Marsa Matrouh": ["Al Awam", "Cleopatra", "Agiba", "Rommel", "Al Fayrouz"],
//     "El Alamein": ["Marina 1-7", "New Alamein Center", "Alamein City"],
//     "Faiyum City": ["Al Huwatem", "Al Baroudiyyah", "Dar Al Ramad", "Al Fawal", "Kiman Fares"],
//     "Aswan": ["Al-Sayeda Zeynab", "Kima", "Sahari", "Aswan El-Gedida"],
//     "Assiut": ["Al-Walideya", "Al-Arbaeen", "New Assiut"],
//     "Zagazig": ["Al-Qawmia", "Al-Montaza", "Hay Thany", "Hay Awal"],
//     "10th of Ramadan": ["First District", "Second District", "Third District", "Industrial Zone"],
//   };

//   @override
//   Widget build(BuildContext context) {
//     // إعداد متغيرات الألوان بناءً على ثيم التطبيق (فاتح أو داكن)
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final bgColor = Theme.of(context).scaffoldBackgroundColor;
//     final mainThemeColor = isDark ? DarkColors.darkmainColor : LightColors.lightmaincolor;
//     final attentionColor = isDark ? DarkColors.darkAttentionText : LightColors.lightAttentionText;
//     final titleColor = isDark ? DarkColors.darkTitleAndSubTitleText : LightColors.lightTitleAndSubTitleText;
//     final hintColor = isDark ? DarkColors.darkHintTextFieldColor : LightColors.lightHintTextFieldColor;
//     final cardBgColor = isDark ? DarkColors.darkTextFieldColor : LightColors.lightTextFieldColor;
//     final dividerColor = hintColor.withOpacity(0.2);

//     return Scaffold(
//       backgroundColor: bgColor,
//       body: Stack(
//         children: [
//           SafeArea(
//             child: CustomScrollView(
//               slivers: [
//                 // بناء الهيدر العلوي الذي يحتوي على زر الرجوع وعنوان الفلاتر وزر إعادة التعيين
//                 _buildSliverHeader(titleColor, mainThemeColor, isDark),
                
//                 SliverPadding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   sliver: SliverList(
//                     delegate: SliverChildListDelegate([
//                       Container(
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: cardBgColor,
//                           borderRadius: BorderRadius.circular(24),
//                           border: Border.all(color: dividerColor),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // قسم اختيار نوع المعاملة (إيجار، بيع، غرفة)
//                             _buildSectionHeader("sell", "What are you looking for?", mainThemeColor, titleColor, trailing: "Single"),
//                             _buildPillsRow(["Rent", "Sale"], listingType, (val) => setState(() => listingType = val), mainThemeColor, titleColor, isDark),
//                             Divider(height: 35, color: dividerColor),

//                             // قسم اختيار أنواع العقارات
//                             _buildSectionHeader("room", "Property Type", mainThemeColor, titleColor, trailing: "Multi"),
//                             _buildMultiSelectPills(["Room","Apartment", "Villa", "House", "Chalet", "Studio","Office","Commercial","Land","Warehouse"], propertyTypes, _togglePropertyType, mainThemeColor, titleColor, isDark),
//                             Divider(height: 35, color: dividerColor),

//                             // قسم اختيار الموقع الجغرافي بالتفصيل
//                             _buildSectionHeader("location_on", "Location", mainThemeColor, titleColor, subtitle: "Governorate, city, then district", hintColor: hintColor),
                            
//                             _buildDropdown("Select governorate", governorates, selectedGov, (val) {
//                               setState(() {
//                                 selectedGov = val;
//                                 selectedCity = null;
//                                 selectedDistrict = null;
//                               });
//                             }, cardBgColor, titleColor, dividerColor, mainThemeColor),
                            
//                             _buildDropdown(
//                               "Select city", 
//                               selectedGov != null ? (citiesMap[selectedGov] ?? ["General City"]) : [], 
//                               selectedCity, 
//                               (val) {
//                                 setState(() {
//                                   selectedCity = val;
//                                   selectedDistrict = null; 
//                                 });
//                               }, cardBgColor, titleColor, dividerColor, mainThemeColor
//                             ),
                            
//                             _buildDropdown(
//                               "Select district / area", 
//                               selectedCity != null ? (districtsMap[selectedCity] ?? ["City Center", "North District", "South District", "East District", "West District", "General Area"]) : [], 
//                               selectedDistrict, 
//                               (val) {
//                                 setState(() {
//                                   selectedDistrict = val;
//                                 });
//                               }, cardBgColor, titleColor, dividerColor, mainThemeColor
//                             ),
                            
//                             Divider(height: 35, color: dividerColor),

//                             // قسم تحديد الميزانية والسعر
//                             _buildSectionHeader("payments", "Your Budget", mainThemeColor, titleColor, trailing: "${budgetRange.start.round()} - ${budgetRange.end.round()} EGP"),
//                             _buildPriceInputs(cardBgColor, titleColor, hintColor, dividerColor, mainThemeColor),
//                             RangeSlider(
//                               values: budgetRange,
//                               min: 1000,
//                               max: 35000,
//                               activeColor: mainThemeColor,
//                               inactiveColor: dividerColor,
//                               onChanged: (values) => setState(() => budgetRange = values),
//                             ),
//                             Divider(height: 35, color: dividerColor),

//                             // قسم تحديد عدد الغرف والحمامات
//                             _buildSectionHeader("straighten", "Quick Specs", mainThemeColor, titleColor),
//                             _buildPillsRow(["1+ Beds", "2+ Beds", "3+ Beds", "4+ Beds"], beds, (val) => setState(() => beds = val), mainThemeColor, titleColor, isDark),
//                             const SizedBox(height: 10),
//                             _buildPillsRow(["1+ Baths", "2+ Baths", "3+ Baths"], baths, (val) => setState(() => baths = val), mainThemeColor, titleColor, isDark),
//                             Divider(height: 35, color: dividerColor),

//                             // قسم اختيار المرافق مع إمكانية إضافة مرافق مخصصة
//                             _buildInteractiveSectionHeader("checkroom", "Amenities", mainThemeColor, titleColor, "+ Add Custom", () {
//                               _showAddCustomDialog("Other Amenities", allExtraAmenities, displayedAmenities, selectedAmenities, (newItems) {
//                                 setState(() {
//                                   for (var item in newItems) {
//                                     if (!displayedAmenities.contains(item)) displayedAmenities.add(item);
//                                     if (!selectedAmenities.contains(item)) selectedAmenities.add(item);
//                                   }
//                                 });
//                               }, mainThemeColor, attentionColor, titleColor, cardBgColor, isDark);
//                             }),
//                             _buildMultiSelectPills(displayedAmenities, selectedAmenities, _toggleAmenity, mainThemeColor, titleColor, isDark),
//                             Divider(height: 35, color: dividerColor),

//                             // أقسام الحالة، التوفر، ومدة الإيجار
//                             _buildSectionHeader("weekend", "Furnishing", mainThemeColor, titleColor, trailing: "Single"),
//                             _buildPillsRow(["Furnished", "Semi-Furnished", "Unfurnished"], furnishing, (val) => setState(() => furnishing = val), mainThemeColor, titleColor, isDark),
//                             Divider(height: 35, color: dividerColor),

//                             _buildSectionHeader("schedule", "Availability", mainThemeColor, titleColor, trailing: "Single"),
//                             _buildPillsRow(["Available Now", "Book Ahead", "Flexible Dates"], availability, (val) => setState(() => availability = val), mainThemeColor, titleColor, isDark),
//                             Divider(height: 35, color: dividerColor),

//                             _buildSectionHeader("event_repeat", "Rental Duration", mainThemeColor, titleColor, trailing: "Single"),
//                             _buildPillsRow(["Short Term", "Long Term"], rentalDuration, (val) => setState(() => rentalDuration = val), mainThemeColor, titleColor, isDark),
//                             Divider(height: 35, color: dividerColor),

//                             // قسم الميزات الخاصة المختارة
//                             _buildSectionHeader("verified", "Special Features", mainThemeColor, titleColor, trailing: "Multi"),
//                             _buildMultiSelectPills(["Verified only", "Featured only", "Negotiable only"], specialFeatures, _toggleSpecialFeature, mainThemeColor, titleColor, isDark),
//                             Divider(height: 35, color: dividerColor),

//                             // قسم قواعد المنزل وتفضيلات السكن مع إمكانية إضافة قواعد جديدة
//                             _buildInteractiveSectionHeader("rule", "Rules & Preferences", mainThemeColor, titleColor, "+ Add Rules", () {
//                                _showAddCustomDialog("Other Rules", allExtraRules, displayedRules, houseRules, (newItems) {
//                                 setState(() {
//                                   for (var item in newItems) {
//                                     if (!displayedRules.contains(item)) displayedRules.add(item);
//                                     if (!houseRules.contains(item)) houseRules.add(item);
//                                   }
//                                 });
//                               }, mainThemeColor, attentionColor, titleColor, cardBgColor, isDark);
//                             }),
//                             Text("HOUSE RULES", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: hintColor, letterSpacing: 0.5, fontFamily: AppFonts.font)),
//                             const SizedBox(height: 10),
//                             _buildMultiSelectPills(displayedRules, houseRules, _toggleHouseRule, mainThemeColor, titleColor, isDark),
//                             const SizedBox(height: 20),
//                             Text("ROOMMATE PREFERENCES", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: hintColor, letterSpacing: 0.5, fontFamily: AppFonts.font)),
//                             const SizedBox(height: 10),
//                             _buildMultiSelectPills(["Female Only", "Male Only", "Students", "Working Professionals", "Pet Friendly"], roommatePreferences, _toggleRoommatePref, mainThemeColor, titleColor, isDark),
//                             Divider(height: 35, color: dividerColor),

//                             // قسم ترتيب النتائج مع تعديل لون النص المختار ليكون أبيض دوماً
//                             _buildSectionHeader("sort", "Sort Results", mainThemeColor, titleColor),
//                             _buildPillsRow(["Newest", "Price", "Rating", "Area"], sortBy, (val) => setState(() => sortBy = val), attentionColor, titleColor, isDark, forceWhite: true),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 120),
//                     ]),
//                   ),
//                 ),
//               ],
//             ),
//           ),
          
//           // الفوتر السفلي الذي يحتوي على أزرار الإلغاء وتطبيق الفلاتر
//           _buildStickyFooter(attentionColor, titleColor, cardBgColor, dividerColor, bgColor, isDark),
//         ],
//       ),
//     );
//   }

//   // --- بناء نافذة الإضافة المخصصة مع توحيد لون النص المختار في الوضع الداكن ---
//   void _showAddCustomDialog(
//     String title, 
//     List<String> allItems, 
//     List<String> currentDisplayed, 
//     List<String> currentSelected, 
//     Function(List<String>) onConfirm,
//     Color mainColor, Color attentionColor, Color titleColor, Color bgColor, bool isDark) {
    
//     List<String> availableToAdd = allItems.where((item) => !currentDisplayed.contains(item)).toList();
//     List<String> tempSelected = [];

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setDialogState) {
//             return Dialog(
//               backgroundColor: bgColor,
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//               child: Container(
//                 padding: const EdgeInsets.all(20),
//                 constraints: const BoxConstraints(maxHeight: 400),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: titleColor, fontFamily: AppFonts.font)),
//                         IconButton(
//                           onPressed: () => Navigator.pop(context),
//                           icon: Icon(Icons.close_rounded, color: titleColor),
//                           padding: EdgeInsets.zero,
//                           constraints: const BoxConstraints(),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
                    
//                     if (availableToAdd.isEmpty)
//                       Expanded(child: Center(child: Text("All options are already added.", style: TextStyle(color: titleColor, fontFamily: AppFonts.font)))),
                    
//                     if (availableToAdd.isNotEmpty)
//                       Expanded(
//                         child: SingleChildScrollView(
//                           child: Wrap(
//                             spacing: 8,
//                             runSpacing: 10,
//                             children: availableToAdd.map((item) {
//                               bool isSelected = tempSelected.contains(item);
//                               final unselectedBg = isDark ? const Color(0xff4A4A4A) : Colors.grey[300];
//                               return GestureDetector(
//                                 onTap: () {
//                                   setDialogState(() {
//                                     isSelected ? tempSelected.remove(item) : tempSelected.add(item);
//                                   });
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                                   decoration: BoxDecoration(
//                                     color: isSelected ? mainColor : unselectedBg,
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                   child: Text(
//                                     item,
//                                     style: TextStyle(
//                                       // تعديل لون النص المختار في الدارك ليتطابق مع باقي الخيارات (Rent, Sale, Room)
//                                       color: isSelected ? (isDark ? DarkColors.darkBackGround : Colors.white) : titleColor,
//                                       fontSize: 14,
//                                       fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
//                                       fontFamily: AppFonts.font
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                           ),
//                         ),
//                       ),
                    
//                     const SizedBox(height: 20),
                    
//                     Align(
//                       alignment: Alignment.centerRight,
//                       child: GestureDetector(
//                         onTap: () {
//                           if (tempSelected.isNotEmpty) {
//                             onConfirm(tempSelected);
//                           }
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                           decoration: BoxDecoration(
//                             color: attentionColor,
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Text(
//                             "Confirm",
//                             style: TextStyle(
//                               color: Colors.white, 
//                               fontWeight: FontWeight.bold, 
//                               fontSize: 16,
//                               fontFamily: AppFonts.font
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // وظائف لتعديل حالة الفلاتر عند الاختيار
//   void _togglePropertyType(String val) => setState(() => propertyTypes.contains(val) ? propertyTypes.remove(val) : propertyTypes.add(val));
//   void _toggleAmenity(String val) => setState(() => selectedAmenities.contains(val) ? selectedAmenities.remove(val) : selectedAmenities.add(val));
//   void _toggleSpecialFeature(String val) => setState(() => specialFeatures.contains(val) ? specialFeatures.remove(val) : specialFeatures.add(val));
//   void _toggleHouseRule(String val) => setState(() => houseRules.contains(val) ? houseRules.remove(val) : houseRules.add(val));
//   void _toggleRoommatePref(String val) => setState(() => roommatePreferences.contains(val) ? roommatePreferences.remove(val) : roommatePreferences.add(val));

//   // بناء الهيدر العلوي كـ Sliver
//   Widget _buildSliverHeader(Color titleColor, Color mainThemeColor, bool isDark) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: SvgPicture.asset(AppIcons.ArrowIcon, width: 28, height: 28, colorFilter: ColorFilter.mode(titleColor, BlendMode.srcIn)),
//             ),
//             Text("Filters", style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 20, fontFamily: AppFonts.font)),
//             TextButton(
//               onPressed: _resetFilters,
//               child: Text("Reset", style: TextStyle(color: mainThemeColor, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: AppFonts.font)),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // وظيفة لإعادة كافة الفلاتر لقيمتها الافتراضية
//   void _resetFilters() {
//     setState(() {
//       listingType = "Rent";
//       propertyTypes = ["Apartment"];
//       selectedGov = null; selectedCity = null; selectedDistrict = null;
//       budgetRange = const RangeValues(1000, 35000);
//       beds = "2+ Beds"; baths = "2+ Baths";
//       displayedAmenities = ["Wi-Fi", "Parking", "Elevator", "Gym", "Security"];
//       selectedAmenities = ["Wi-Fi", "Parking"];
//       displayedRules = ["No Smoking", "No Pets", "Family Friendly", "Quiet Hours", "No Parties"];
//       houseRules = ["Family Friendly"];
//       furnishing = "Furnished"; availability = "Available Now"; rentalDuration = "Short Term";
//       specialFeatures = ["Verified only", "Negotiable only"];
//       roommatePreferences = ["Students"];
//       sortBy = "Newest";
//     });
//   }

//   // بناء عنوان القسم مع أيقونة ونص توضيحي
//   Widget _buildSectionHeader(String iconName, String title, Color mainColor, Color titleColor, {String? subtitle, String? trailing, Color? hintColor}) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: Row(
//         crossAxisAlignment: subtitle != null ? CrossAxisAlignment.start : CrossAxisAlignment.center,
//         children: [
//           if (iconName.isNotEmpty) ...[
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(color: mainColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
//               child: Icon(_getIconData(iconName), size: 20, color: mainColor),
//             ),
//             const SizedBox(width: 10),
//           ],
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor, fontFamily: AppFonts.font)),
//                 if (subtitle != null) Text(subtitle, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: hintColor ?? Colors.grey, fontFamily: AppFonts.font)),
//               ],
//             ),
//           ),
//           if (trailing != null) 
//             Text(trailing, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: hintColor ?? Colors.grey, fontFamily: AppFonts.font)),
//         ],
//       ),
//     );
//   }

//   // بناء عنوان القسم التفاعلي (الذي يحتوي على زر "إضافة")
//   Widget _buildInteractiveSectionHeader(String iconName, String title, Color mainColor, Color titleColor, String actionText, VoidCallback onActionTap) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (iconName.isNotEmpty) ...[
//             Container(
//               padding: const EdgeInsets.all(6),
//               decoration: BoxDecoration(color: mainColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
//               child: Icon(_getIconData(iconName), size: 20, color: mainColor),
//             ),
//             const SizedBox(width: 10),
//           ],
//           Expanded(
//             child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor, fontFamily: AppFonts.font)),
//           ),
//           GestureDetector(
//             onTap: onActionTap,
//             child: Text(actionText, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: mainColor, fontFamily: AppFonts.font)),
//           ),
//         ],
//       ),
//     );
//   }

//   // بناء قوائم الاختيار المنسدلة (Dropdown)
//   Widget _buildDropdown(String hint, List<String> items, String? value, Function(String?) onChanged, Color bgColor, Color titleColor, Color dividerColor, Color mainColor) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
//       decoration: BoxDecoration(
//         color: bgColor,
//         border: Border.all(color: dividerColor),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           isExpanded: true,
//           hint: Text(hint, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: titleColor, fontFamily: AppFonts.font)),
//           value: value,
//           icon: Icon(Icons.keyboard_arrow_down_rounded, color: mainColor),
//           dropdownColor: bgColor,
//           items: items.isEmpty ? null : items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: titleColor, fontFamily: AppFonts.font)))).toList(),
//           onChanged: items.isEmpty ? null : onChanged,
//         ),
//       ),
//     );
//   }

//   // بناء صف الخيارات الأحادية الاختيار (Pills)
//   Widget _buildPillsRow(List<String> options, String current, Function(String) onSelect, Color activeColor, Color titleColor, bool isDark, {bool forceWhite = false}) {
//     return Wrap(
//       spacing: 10,
//       runSpacing: 10,
//       children: options.map((opt) {
//         bool isSelected = opt == current;
//         return GestureDetector(
//           onTap: () => onSelect(opt),
//           child: _buildPillContainer(opt, isSelected, activeColor, titleColor, isDark, forceWhite: forceWhite),
//         );
//       }).toList(),
//     );
//   }

//   // بناء صف الخيارات المتعددة الاختيار (Multi-select Pills)
//   Widget _buildMultiSelectPills(List<String> options, List<String> selected, Function(String) onSelect, Color activeColor, Color titleColor, bool isDark) {
//     return Wrap(
//       spacing: 10,
//       runSpacing: 10,
//       children: options.map((opt) {
//         bool isSelected = selected.contains(opt);
//         return GestureDetector(
//           onTap: () => onSelect(opt),
//           child: _buildPillContainer(opt, isSelected, activeColor, titleColor, isDark),
//         );
//       }).toList(),
//     );
//   }

//   // بناء عنصر الخيار (Pill) نفسه والتحكم في ألوان الخلفية والنص عند الاختيار
//   Widget _buildPillContainer(String text, bool isSelected, Color activeColor, Color titleColor, bool isDark, {bool forceWhite = false}) {
//     final unselectedBgColor = isDark ? const Color(0xff4A4A4A) : Colors.grey[300];
    
//     // تحديد لون النص المختار؛ إذا كان القسم هو الترتيب (forceWhite) فيكون أبيض، وإلا يتبع الثيم
//     final selectedTextColor = forceWhite ? Colors.white : (isDark ? DarkColors.darkBackGround : Colors.white);

//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 180),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: BoxDecoration(
//         color: isSelected ? activeColor : unselectedBgColor,
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Text(
//         text, 
//         style: TextStyle(
//           color: isSelected ? selectedTextColor : titleColor, 
//           fontSize: 14, 
//           fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, 
//           fontFamily: AppFonts.font
//         )
//       ),
//     );
//   }

//   // بناء حقول إدخال السعر (الحد الأدنى والأقصى)
//   Widget _buildPriceInputs(Color bgColor, Color titleColor, Color hintColor, Color dividerColor, Color mainColor) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 14),
//       child: Row(
//         children: [
//           Expanded(child: _buildMiniInput("MIN", budgetRange.start.round().toString(), bgColor, titleColor, hintColor, dividerColor, mainColor)),
//           const SizedBox(width: 12),
//           Expanded(child: _buildMiniInput("MAX", budgetRange.end.round().toString(), bgColor, titleColor, hintColor, dividerColor, mainColor)),
//         ],
//       ),
//     );
//   }

//   // بناء حقل إدخال صغير مخصص للسعر
//   Widget _buildMiniInput(String label, String value, Color bgColor, Color titleColor, Color hintColor, Color dividerColor, Color mainColor) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: hintColor, letterSpacing: 0.3, fontFamily: AppFonts.font)),
//         const SizedBox(height: 6),
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//           decoration: BoxDecoration(
//             color: bgColor,
//             border: Border.all(color: dividerColor, width: 1.5),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: mainColor, fontFamily: AppFonts.font)),
//         ),
//       ],
//     );
//   }

//   // بناء الفوتر الثابت في أسفل الشاشة للأزرار النهائية
//   Widget _buildStickyFooter(Color attentionColor, Color titleColor, Color cardBgColor, Color dividerColor, Color scaffoldBg, bool isDark) {
//     return Positioned(
//       bottom: 0, left: 0, right: 0,
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter, end: Alignment.bottomCenter,
//             colors: [scaffoldBg.withOpacity(0), scaffoldBg],
//           ),
//         ),
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             color: cardBgColor,
//             borderRadius: BorderRadius.circular(18),
//             border: Border.all(color: dividerColor),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: _buildFooterBtn("Cancel", Colors.transparent, titleColor, true, dividerColor),
//                 ),
//               ),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: _buildFooterBtn("Apply Filters", attentionColor, Colors.white, false, dividerColor),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // بناء تصميم زر الفوتر (Cancel أو Apply)
//   Widget _buildFooterBtn(String label, Color bg, Color text, bool hasBorder, Color borderColor) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 14),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(16),
//         border: hasBorder ? Border.all(color: borderColor) : null,
//       ),
//       child: Text(label, textAlign: TextAlign.center, style: TextStyle(color: text, fontWeight: FontWeight.bold, fontSize: 16, fontFamily: AppFonts.font)),
//     );
//   }

//   // وظيفة مساعدة لتحويل أسماء الأيقونات إلى بيانات IconData
//   IconData _getIconData(String name) {
//     switch (name) {
//       case "sell": return Icons.sell_rounded;
//       case "apartment": return Icons.apartment_rounded;
//       case "location_on": return Icons.location_on_rounded;
//       case "payments": return Icons.payments_rounded;
//       case "straighten": return Icons.straighten_rounded;
//       case "checkroom": return Icons.checkroom_rounded;
//       case "weekend": return Icons.weekend_rounded;
//       case "schedule": return Icons.schedule_rounded;
//       case "event_repeat": return Icons.event_repeat_rounded;
//       case "verified": return Icons.verified_rounded;
//       case "rule": return Icons.rule_rounded;
//       case "sort": return Icons.sort_rounded;
//       default: return Icons.filter_alt_rounded;
//     }
//   }
// }







class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  // --- متغيرات حالة الفلاتر لتخزين القيم التي يختارها المستخدم ---
  String listingType = "Rent";
  List<String> propertyTypes = ["Room"];

  // متغيرات تحديد الموقع الجغرافي
  String? selectedGov;
  String? selectedCity;
  String? selectedDistrict;

  // متغير تحديد نطاق الميزانية
  RangeValues budgetRange = const RangeValues(1000, 35000);

  // متغيرات عدد الغرف والحمامات
  String beds = "2+ Beds";
  String baths = "2+ Baths";

  // قائمة المرافق المعروضة والمختارة حالياً
  List<String> displayedAmenities = [
    "Wi-Fi",
    "Parking",
    "Elevator",
    "Gym",
    "Security",
  ];
  List<String> selectedAmenities = ["Wi-Fi", "Parking"];

  // المرافق الإضافية المتاحة للإضافة من خلال النافذة المنبثقة
  final List<String> allExtraAmenities = [
    "Pool",
    "Balcony",
    "Central AC",
    "Jacuzzi",
    "Smart Home",
    "BBQ Area",
    "Maid Room",
  ];

  String furnishing = "Furnished";
  String availability = "Available Now";
  String rentalDuration = "Short Term";

  List<String> specialFeatures = ["Verified only", "Negotiable only"];

  // القواعد المعروضة والمختارة حالياً
  List<String> displayedRules = [
    "No Smoking",
    "No Pets",
    "Family Friendly",
    "Quiet Hours",
    "No Parties",
  ];
  List<String> houseRules = ["Family Friendly"];

  // القواعد الإضافية المتاحة للإضافة من خلال النافذة المنبثقة
  final List<String> allExtraRules = [
    "No Subletting",
    "No Commercial Use",
    "Couples Only",
    "Long Term Only",
    "Guests Allowed",
  ];

  List<String> roommatePreferences = ["Students"];

  // متغير خيار الترتيب المختار
  String sortBy = "Newest";

  // --- قائمة بيانات المحافظات والمدن والمناطق في مصر ---
  final List<String> governorates = [
    "Cairo",
    "Giza",
    "Alexandria",
    "Dakahlia",
    "Red Sea",
    "Beheira",
    "Faiyum",
    "Gharbia",
    "Ismailia",
    "Menofia",
    "Minya",
    "Qaliubiya",
    "New Valley",
    "Suez",
    "Aswan",
    "Assiut",
    "Beni Suef",
    "Port Said",
    "Damietta",
    "Sharkia",
    "South Sinai",
    "Kafr El Sheikh",
    "Matrouh",
    "Luxor",
    "Qena",
    "North Sinai",
    "Sohag",
  ];

  final Map<String, List<String>> citiesMap = {
    "Cairo": [
      "Cairo",
      "New Cairo",
      "Badr City",
      "El Shorouk",
      "Helwan",
      "15th of May",
      "El Marg",
      "New Capital",
    ],
    "Giza": [
      "Giza",
      "6th of October",
      "Sheikh Zayed",
      "El Hawamdiyah",
      "El Badrashein",
      "Oseem",
      "Kerdasa",
      "Abu Rawash",
    ],
    "Alexandria": [
      "Alexandria",
      "Borg El Arab",
      "New Borg El Arab",
      "Abu Qir",
      "Agami",
    ],
    "Dakahlia": [
      "Mansoura",
      "Talkha",
      "Mit Ghamr",
      "Dekernes",
      "Aga",
      "Minyet El Nasr",
      "Sherbin",
      "Beni Ebeid",
    ],
    "Red Sea": [
      "Hurghada",
      "Safaga",
      "Marsa Alam",
      "Ras Gharib",
      "El Quseir",
      "Shalateen",
    ],
    "Beheira": [
      "Damanhour",
      "Kafr El Dawwar",
      "Rashid",
      "Edku",
      "Abu Hommos",
      "Wadi El Natrun",
    ],
    "Faiyum": [
      "Faiyum City",
      "Sinnuris",
      "Ibsheway",
      "Tamiya",
      "Atsa",
      "Yousef El Seddik",
    ],
    "Gharbia": [
      "Tanta",
      "El Mahalla",
      "Kafr El Zayat",
      "Zifta",
      "Samanoud",
      "Basyoun",
    ],
    "Ismailia": [
      "Ismailia",
      "Fayed",
      "Qantara Sharq",
      "Qantara Gharb",
      "Abu Suwir",
      "Kassasin",
    ],
    "Menofia": [
      "Shibin El Kom",
      "Menouf",
      "Ashmoun",
      "Quesna",
      "Tala",
      "Sadat City",
      "Bagour",
    ],
    "Minya": [
      "Minya",
      "Mallawi",
      "Samalut",
      "Beni Mazar",
      "Maghagha",
      "Abu Qurqas",
      "Deir Mawas",
    ],
    "Qaliubiya": [
      "Banha",
      "Shubra El Kheima",
      "Qalyub",
      "Khanka",
      "Shebin",
      "Toukh",
      "Qaha",
    ],
    "New Valley": ["Kharga", "Dakhla", "Farafra", "Baris", "Balat"],
    "Suez": ["Suez", "Ain Sokhna", "Ataka", "Arbaeen"],
    "Aswan": [
      "Aswan",
      "Kom Ombo",
      "Edfu",
      "Daraw",
      "Nasr Al Nuba",
      "Abu Simbel",
    ],
    "Assiut": [
      "Assiut",
      "Dayrout",
      "El Qusiya",
      "Manfalut",
      "Abu Tig",
      "Abnub",
      "Sedfa",
      "El Ghanayem",
    ],
    "Beni Suef": [
      "Beni Suef",
      "Nasser",
      "Al Wasta",
      "Biba",
      "Ehnasia",
      "Sumusta",
      "Al Fashn",
    ],
    "Port Said": ["Port Said", "Port Fouad", "Al Zohour", "Al Dawahy"],
    "Damietta": [
      "Damietta",
      "New Damietta",
      "Ras El Bar",
      "Faraskour",
      "Zarkha",
      "Kafr Saad",
    ],
    "Sharkia": [
      "Zagazig",
      "10th of Ramadan",
      "Minya El Qamh",
      "Bilbeis",
      "Mashtoul",
      "Faqus",
      "Abu Hammad",
    ],
    "South Sinai": [
      "Sharm El Sheikh",
      "Dahab",
      "Nuweiba",
      "Taba",
      "El Tor",
      "Saint Catherine",
      "Ras Sudr",
    ],
    "Kafr El Sheikh": [
      "Kafr El Sheikh",
      "Desouk",
      "Baltim",
      "Metoubes",
      "Fowa",
      "Kelin",
    ],
    "Matrouh": [
      "Marsa Matrouh",
      "El Alamein",
      "Sidi Abdel Rahman",
      "Dabaa",
      "Sidi Barrani",
      "Siwa",
    ],
    "Luxor": ["Luxor", "Karnak", "Esna", "Armant", "Qurna", "Tud"],
    "Qena": [
      "Qena",
      "Nagaa Hammadi",
      "Qus",
      "Qift",
      "Dishna",
      "Farshut",
      "Abu Tesht",
    ],
    "North Sinai": [
      "Arish",
      "Sheikh Zuweid",
      "Rafah",
      "Bir al-Abed",
      "Nekhel",
      "Hassana",
    ],
    "Sohag": [
      "Sohag",
      "Akhmim",
      "Girga",
      "Tahta",
      "Tima",
      "Dar El Salam",
      "Juhayna",
    ],
  };

  final Map<String, List<String>> districtsMap = {
    "Cairo": [
      "Maadi",
      "Nasr City",
      "Heliopolis",
      "Downtown",
      "Zamalek",
      "Shubra",
      "Mokattam",
      "El Dokki",
      "Al Zeitoun",
      "Al Rehab",
      "Madinaty",
    ],
    "New Cairo": [
      "1st Settlement",
      "3rd Settlement",
      "5th Settlement",
      "Choueifat",
      "South Investors",
      "North Investors",
    ],
    "Helwan": ["Wadi Hof", "Hadayek Helwan", "15th of May", "El Tebeen"],
    "Giza": [
      "Dokki",
      "Mohandeseen",
      "Agouza",
      "Haram",
      "Faisal",
      "Imbaba",
      "Bulaq Dakrour",
      "Kit Kat",
    ],
    "6th of October": [
      "1st District",
      "2nd District",
      "7th District",
      "8th District",
      "Hosary",
      "West Somid",
      "Al Ashgar",
    ],
    "Sheikh Zayed": [
      "Beverly Hills",
      "Zayed 2000",
      "Al-Rabaa",
      "El Hay El Tasea",
      "El Hay El Asher",
    ],
    "Alexandria": [
      "Smouha",
      "Sidi Gaber",
      "Gleem",
      "Mandara",
      "Agami",
      "Miami",
      "Montaza",
      "Roshdy",
      "San Stefano",
      "Stanley",
      "Mahatet El Raml",
      "Louran",
    ],
    "Borg El Arab": ["First District", "Second District", "Industrial Zone"],
    "Port Said": ["Al-Sharq", "Al-Arab", "Al-Manakh", "Al-Dawahy", "Al-Zohour"],
    "Mansoura": ["Hay Gharb", "Hay Sharq", "Gedila", "Toriel", "Al Mashaya"],
    "Ismailia": ["Hay Awal", "Hay Thany", "Hay Thaleth", "Al-Sheikh Zayed"],
    "Tanta": ["Al-Mahata", "Siger", "Kafr Essam", "Al-Galaa"],
    "El Mahalla": ["Al-Shoqafy", "Al-Zeraa", "Hay Awal", "Hay Thany"],
    "Hurghada": [
      "Al Dahar",
      "Sakkala",
      "Al Mamsha",
      "El Kawther",
      "Sahl Hasheesh",
      "El Gouna",
    ],
    "Sharm El Sheikh": [
      "Naama Bay",
      "Nabq Bay",
      "Hadaba",
      "Sharks Bay",
      "Old Market",
    ],
    "Marsa Matrouh": ["Al Awam", "Cleopatra", "Agiba", "Rommel", "Al Fayrouz"],
    "El Alamein": ["Marina 1-7", "New Alamein Center", "Alamein City"],
    "Faiyum City": [
      "Al Huwatem",
      "Al Baroudiyyah",
      "Dar Al Ramad",
      "Al Fawal",
      "Kiman Fares",
    ],
    "Aswan": ["Al-Sayeda Zeynab", "Kima", "Sahari", "Aswan El-Gedida"],
    "Assiut": ["Al-Walideya", "Al-Arbaeen", "New Assiut"],
    "Zagazig": ["Al-Qawmia", "Al-Montaza", "Hay Thany", "Hay Awal"],
    "10th of Ramadan": [
      "First District",
      "Second District",
      "Third District",
      "Industrial Zone",
    ],
  };

  @override
  Widget build(BuildContext context) {
    // إعداد متغيرات الألوان بناءً على ثيم التطبيق (فاتح أو داكن)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final mainThemeColor = isDark
        ? DarkColors.darkmainColor
        : LightColors.lightmaincolor;
    final attentionColor = isDark
        ? DarkColors.darkAttentionText
        : LightColors.lightAttentionText;
    final titleColor = isDark
        ? DarkColors.darkTitleAndSubTitleText
        : LightColors.lightTitleAndSubTitleText;
    final hintColor = isDark
        ? DarkColors.darkHintTextFieldColor
        : LightColors.lightHintTextFieldColor;
    final cardBgColor = isDark
        ? DarkColors.darkTextFieldColor
        : LightColors.lightTextFieldColor;
    final dividerColor = hintColor.withOpacity(0.2);

    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // بناء الهيدر العلوي الذي يحتوي على زر الرجوع وعنوان الفلاتر وزر إعادة التعيين
                _buildSliverHeader(titleColor, mainThemeColor, isDark),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardBgColor,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: dividerColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // قسم اختيار نوع المعاملة (إيجار، بيع، غرفة)
                            _buildSectionHeader(
                              "sell",
                              "What are you looking for?",
                              mainThemeColor,
                              titleColor,
                              trailing: "Single",
                            ),
                            _buildPillsRow(
                              ["Rent", "Sale"],
                              listingType,
                              (val) => setState(() => listingType = val),
                              mainThemeColor,
                              titleColor,
                              isDark,
                            ),
                            Divider(height: 35, color: dividerColor),

                            // قسم اختيار أنواع العقارات
                            _buildSectionHeader(
                              "room",
                              "Property Type",
                              mainThemeColor,
                              titleColor,
                              trailing: "Multi",
                            ),
                            _buildMultiSelectPills(
                              [
                                "Room",
                                "Apartment",
                                "Villa",
                                "House",
                                "Chalet",
                                "Studio",
                                "Office",
                                "Commercial",
                                "Land",
                                "Warehouse",
                                "Duplex"
                              ],
                              propertyTypes,
                              _togglePropertyType,
                              mainThemeColor,
                              titleColor,
                              isDark,
                            ),
                            Divider(height: 35, color: dividerColor),

                            // قسم اختيار الموقع الجغرافي بالتفصيل
                            _buildSectionHeader(
                              "location_on",
                              "Location",
                              mainThemeColor,
                              titleColor,
                              subtitle: "Governorate, city, then district",
                              hintColor: hintColor,
                            ),

                            _buildDropdown(
                              "Select governorate",
                              governorates,
                              selectedGov,
                              (val) {
                                setState(() {
                                  selectedGov = val;
                                  selectedCity = null;
                                  selectedDistrict = null;
                                });
                              },
                              cardBgColor,
                              titleColor,
                              dividerColor,
                              mainThemeColor,
                            ),

                            _buildDropdown(
                              "Select city",
                              selectedGov != null
                                  ? (citiesMap[selectedGov] ?? ["General City"])
                                  : [],
                              selectedCity,
                              (val) {
                                setState(() {
                                  selectedCity = val;
                                  selectedDistrict = null;
                                });
                              },
                              cardBgColor,
                              titleColor,
                              dividerColor,
                              mainThemeColor,
                            ),

                            _buildDropdown(
                              "Select district / area",
                              selectedCity != null
                                  ? (districtsMap[selectedCity] ??
                                        [
                                          "City Center",
                                          "North District",
                                          "South District",
                                          "East District",
                                          "West District",
                                          "General Area",
                                        ])
                                  : [],
                              selectedDistrict,
                              (val) {
                                setState(() {
                                  selectedDistrict = val;
                                });
                              },
                              cardBgColor,
                              titleColor,
                              dividerColor,
                              mainThemeColor,
                            ),

                            Divider(height: 35, color: dividerColor),

                            // قسم تحديد الميزانية والسعر
                            _buildSectionHeader(
                              "payments",
                              "Your Budget",
                              mainThemeColor,
                              titleColor,
                              trailing:
                                  "${budgetRange.start.round()} - ${budgetRange.end.round()} EGP",
                            ),
                            _buildPriceInputs(
                              cardBgColor,
                              titleColor,
                              hintColor,
                              dividerColor,
                              mainThemeColor,
                            ),
                            RangeSlider(
                              values: budgetRange,
                              min: 1000,
                              max: 35000,
                              activeColor: mainThemeColor,
                              inactiveColor: dividerColor,
                              onChanged: (values) =>
                                  setState(() => budgetRange = values),
                            ),
                            Divider(height: 35, color: dividerColor),

                            // قسم تحديد عدد الغرف والحمامات
                            _buildSectionHeader(
                              "straighten",
                              "Quick Specs",
                              mainThemeColor,
                              titleColor,
                            ),
                            _buildPillsRow(
                              ["1+ Beds", "2+ Beds", "3+ Beds", "4+ Beds"],
                              beds,
                              (val) => setState(() => beds = val),
                              mainThemeColor,
                              titleColor,
                              isDark,
                            ),
                            const SizedBox(height: 10),
                            _buildPillsRow(
                              ["1+ Baths", "2+ Baths", "3+ Baths"],
                              baths,
                              (val) => setState(() => baths = val),
                              mainThemeColor,
                              titleColor,
                              isDark,
                            ),
                            Divider(height: 35, color: dividerColor),

                            // قسم اختيار المرافق مع إمكانية إضافة مرافق مخصصة
                            _buildInteractiveSectionHeader(
                              "checkroom",
                              "Amenities",
                              mainThemeColor,
                              titleColor,
                              "+ Add Custom",
                              () {
                                _showAddCustomDialog(
                                  "Other Amenities",
                                  allExtraAmenities,
                                  displayedAmenities,
                                  selectedAmenities,
                                  (newItems) {
                                    setState(() {
                                      for (var item in newItems) {
                                        if (!displayedAmenities.contains(item))
                                          displayedAmenities.add(item);
                                        if (!selectedAmenities.contains(item))
                                          selectedAmenities.add(item);
                                      }
                                    });
                                  },
                                  mainThemeColor,
                                  attentionColor,
                                  titleColor,
                                  cardBgColor,
                                  isDark,
                                );
                              },
                            ),
                            _buildMultiSelectPills(
                              displayedAmenities,
                              selectedAmenities,
                              _toggleAmenity,
                              mainThemeColor,
                              titleColor,
                              isDark,
                            ),
                            Divider(height: 35, color: dividerColor),

                            // أقسام الحالة، التوفر، ومدة الإيجار
                            _buildSectionHeader(
                              "weekend",
                              "Furnishing",
                              mainThemeColor,
                              titleColor,
                              trailing: "Single",
                            ),
                            _buildPillsRow(
                              ["Furnished", "Semi-Furnished", "Unfurnished"],
                              furnishing,
                              (val) => setState(() => furnishing = val),
                              mainThemeColor,
                              titleColor,
                              isDark,
                            ),
                            Divider(height: 35, color: dividerColor),

                            _buildSectionHeader(
                              "schedule",
                              "Availability",
                              mainThemeColor,
                              titleColor,
                              trailing: "Single",
                            ),
                            _buildPillsRow(
                              ["Available Now", "Book Ahead", "Flexible Dates"],
                              availability,
                              (val) => setState(() => availability = val),
                              mainThemeColor,
                              titleColor,
                              isDark,
                            ),
                            Divider(height: 35, color: dividerColor),

                            _buildSectionHeader(
                              "event_repeat",
                              "Rental Duration",
                              mainThemeColor,
                              titleColor,
                              trailing: "Single",
                            ),
                            _buildPillsRow(
                              ["Short Term", "Long Term"],
                              rentalDuration,
                              (val) => setState(() => rentalDuration = val),
                              mainThemeColor,
                              titleColor,
                              isDark,
                            ),
                            Divider(height: 35, color: dividerColor),

                            // قسم الميزات الخاصة المختارة
                            _buildSectionHeader(
                              "verified",
                              "Special Features",
                              mainThemeColor,
                              titleColor,
                              trailing: "Multi",
                            ),
                            _buildMultiSelectPills(
                              [
                                "Verified only",
                                "Featured only",
                                "Negotiable only",
                              ],
                              specialFeatures,
                              _toggleSpecialFeature,
                              mainThemeColor,
                              titleColor,
                              isDark,
                            ),
                            Divider(height: 35, color: dividerColor),

                            // قسم قواعد المنزل وتفضيلات السكن مع إمكانية إضافة قواعد جديدة
                            _buildInteractiveSectionHeader(
                              "rule",
                              "Rules & Preferences",
                              mainThemeColor,
                              titleColor,
                              "+ Add Rules",
                              () {
                                _showAddCustomDialog(
                                  "Other Rules",
                                  allExtraRules,
                                  displayedRules,
                                  houseRules,
                                  (newItems) {
                                    setState(() {
                                      for (var item in newItems) {
                                        if (!displayedRules.contains(item))
                                          displayedRules.add(item);
                                        if (!houseRules.contains(item))
                                          houseRules.add(item);
                                      }
                                    });
                                  },
                                  mainThemeColor,
                                  attentionColor,
                                  titleColor,
                                  cardBgColor,
                                  isDark,
                                );
                              },
                            ),
                            Text(
                              "HOUSE RULES",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: hintColor,
                                letterSpacing: 0.5,
                                fontFamily: AppFonts.font,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildMultiSelectPills(
                              displayedRules,
                              houseRules,
                              _toggleHouseRule,
                              mainThemeColor,
                              titleColor,
                              isDark,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "ROOMMATE PREFERENCES",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: hintColor,
                                letterSpacing: 0.5,
                                fontFamily: AppFonts.font,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildMultiSelectPills(
                              [
                                "Female Only",
                                "Male Only",
                                "Students",
                                "Working Professionals",
                                "Pet Friendly",
                              ],
                              roommatePreferences,
                              _toggleRoommatePref,
                              mainThemeColor,
                              titleColor,
                              isDark,
                            ),
                            Divider(height: 35, color: dividerColor),

                            // قسم ترتيب النتائج مع تعديل لون النص المختار ليكون أبيض دوماً
                            _buildSectionHeader(
                              "sort",
                              "Sort Results",
                              mainThemeColor,
                              titleColor,
                            ),
                            _buildPillsRow(
                              ["Newest", "Price", "Rating", "Area"],
                              sortBy,
                              (val) => setState(() => sortBy = val),
                              attentionColor,
                              titleColor,
                              isDark,
                              forceWhite: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 120),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // الفوتر السفلي الذي يحتوي على أزرار الإلغاء وتطبيق الفلاتر
          _buildStickyFooter(
            attentionColor,
            titleColor,
            cardBgColor,
            dividerColor,
            bgColor,
            isDark,
          ),
        ],
      ),
    );
  }

  // --- بناء نافذة الإضافة المخصصة مع توحيد لون النص المختار في الوضع الداكن ---
  void _showAddCustomDialog(
    String title,
    List<String> allItems,
    List<String> currentDisplayed,
    List<String> currentSelected,
    Function(List<String>) onConfirm,
    Color mainColor,
    Color attentionColor,
    Color titleColor,
    Color bgColor,
    bool isDark,
  ) {
    List<String> availableToAdd = allItems
        .where((item) => !currentDisplayed.contains(item))
        .toList();
    List<String> tempSelected = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                constraints: const BoxConstraints(maxHeight: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: titleColor,
                            fontFamily: AppFonts.font,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close_rounded, color: titleColor),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    if (availableToAdd.isEmpty)
                      Expanded(
                        child: Center(
                          child: Text(
                            "All options are already added.",
                            style: TextStyle(
                              color: titleColor,
                              fontFamily: AppFonts.font,
                            ),
                          ),
                        ),
                      ),

                    if (availableToAdd.isNotEmpty)
                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 10,
                            children: availableToAdd.map((item) {
                              bool isSelected = tempSelected.contains(item);
                              final unselectedBg = isDark
                                  ? const Color(0xff4A4A4A)
                                  : Colors.grey[300];
                              return GestureDetector(
                                onTap: () {
                                  setDialogState(() {
                                    isSelected
                                        ? tempSelected.remove(item)
                                        : tempSelected.add(item);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? mainColor
                                        : unselectedBg,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Text(
                                    item,
                                    style: TextStyle(
                                      // تعديل لون النص المختار في الدارك ليتطابق مع باقي الخيارات (Rent, Sale, Room)
                                      color: isSelected
                                          ? (isDark
                                                ? DarkColors.darkBackGround
                                                : Colors.white)
                                          : titleColor,
                                      fontSize: 14,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w600,
                                      fontFamily: AppFonts.font,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          if (tempSelected.isNotEmpty) {
                            onConfirm(tempSelected);
                          }
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: attentionColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: AppFonts.font,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // وظائف لتعديل حالة الفلاتر عند الاختيار
  void _togglePropertyType(String val) => setState(
    () => propertyTypes.contains(val)
        ? propertyTypes.remove(val)
        : propertyTypes.add(val),
  );
  void _toggleAmenity(String val) => setState(
    () => selectedAmenities.contains(val)
        ? selectedAmenities.remove(val)
        : selectedAmenities.add(val),
  );
  void _toggleSpecialFeature(String val) => setState(
    () => specialFeatures.contains(val)
        ? specialFeatures.remove(val)
        : specialFeatures.add(val),
  );
  void _toggleHouseRule(String val) => setState(
    () =>
        houseRules.contains(val) ? houseRules.remove(val) : houseRules.add(val),
  );
  void _toggleRoommatePref(String val) => setState(
    () => roommatePreferences.contains(val)
        ? roommatePreferences.remove(val)
        : roommatePreferences.add(val),
  );

  // بناء الهيدر العلوي كـ Sliver
  Widget _buildSliverHeader(
    Color titleColor,
    Color mainThemeColor,
    bool isDark,
  ) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: SvgPicture.asset(
                AppIcons.ArrowIcon,
                width: 28,
                height: 28,
                colorFilter: ColorFilter.mode(titleColor, BlendMode.srcIn),
              ),
            ),
            Text(
              "Filters",
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: AppFonts.font,
              ),
            ),
            TextButton(
              onPressed: _resetFilters,
              child: Text(
                "Reset",
                style: TextStyle(
                  color: mainThemeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: AppFonts.font,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // وظيفة لإعادة كافة الفلاتر لقيمتها الافتراضية
  void _resetFilters() {
    setState(() {
      listingType = "Rent";
      propertyTypes = ["Apartment"];
      selectedGov = null;
      selectedCity = null;
      selectedDistrict = null;
      budgetRange = const RangeValues(1000, 35000);
      beds = "2+ Beds";
      baths = "2+ Baths";
      displayedAmenities = ["Wi-Fi", "Parking", "Elevator", "Gym", "Security"];
      selectedAmenities = ["Wi-Fi", "Parking"];
      displayedRules = [
        "No Smoking",
        "No Pets",
        "Family Friendly",
        "Quiet Hours",
        "No Parties",
      ];
      houseRules = ["Family Friendly"];
      furnishing = "Furnished";
      availability = "Available Now";
      rentalDuration = "Short Term";
      specialFeatures = ["Verified only", "Negotiable only"];
      roommatePreferences = ["Students"];
      sortBy = "Newest";
    });
  }

  // بناء عنوان القسم مع أيقونة ونص توضيحي
  Widget _buildSectionHeader(
    String iconName,
    String title,
    Color mainColor,
    Color titleColor, {
    String? subtitle,
    String? trailing,
    Color? hintColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: subtitle != null
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          if (iconName.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_getIconData(iconName), size: 20, color: mainColor),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                    fontFamily: AppFonts.font,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: hintColor ?? Colors.grey,
                      fontFamily: AppFonts.font,
                    ),
                  ),
              ],
            ),
          ),
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: hintColor ?? Colors.grey,
                fontFamily: AppFonts.font,
              ),
            ),
        ],
      ),
    );
  }

  // بناء عنوان القسم التفاعلي (الذي يحتوي على زر "إضافة")
  Widget _buildInteractiveSectionHeader(
    String iconName,
    String title,
    Color mainColor,
    Color titleColor,
    String actionText,
    VoidCallback onActionTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (iconName.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_getIconData(iconName), size: 20, color: mainColor),
            ),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: titleColor,
                fontFamily: AppFonts.font,
              ),
            ),
          ),
          GestureDetector(
            onTap: onActionTap,
            child: Text(
              actionText,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: mainColor,
                fontFamily: AppFonts.font,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بناء قوائم الاختيار المنسدلة (Dropdown)
  Widget _buildDropdown(
    String hint,
    List<String> items,
    String? value,
    Function(String?) onChanged,
    Color bgColor,
    Color titleColor,
    Color dividerColor,
    Color mainColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: dividerColor),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: titleColor,
              fontFamily: AppFonts.font,
            ),
          ),
          value: value,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: mainColor),
          dropdownColor: bgColor,
          items: items.isEmpty
              ? null
              : items
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: titleColor,
                            fontFamily: AppFonts.font,
                          ),
                        ),
                      ),
                    )
                    .toList(),
          onChanged: items.isEmpty ? null : onChanged,
        ),
      ),
    );
  }

  // بناء صف الخيارات الأحادية الاختيار (Pills)
  Widget _buildPillsRow(
    List<String> options,
    String current,
    Function(String) onSelect,
    Color activeColor,
    Color titleColor,
    bool isDark, {
    bool forceWhite = false,
  }) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((opt) {
        bool isSelected = opt == current;
        return GestureDetector(
          onTap: () => onSelect(opt),
          child: _buildPillContainer(
            opt,
            isSelected,
            activeColor,
            titleColor,
            isDark,
            forceWhite: forceWhite,
          ),
        );
      }).toList(),
    );
  }

  // بناء صف الخيارات المتعددة الاختيار (Multi-select Pills)
  Widget _buildMultiSelectPills(
    List<String> options,
    List<String> selected,
    Function(String) onSelect,
    Color activeColor,
    Color titleColor,
    bool isDark,
  ) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((opt) {
        bool isSelected = selected.contains(opt);
        return GestureDetector(
          onTap: () => onSelect(opt),
          child: _buildPillContainer(
            opt,
            isSelected,
            activeColor,
            titleColor,
            isDark,
          ),
        );
      }).toList(),
    );
  }

  // بناء عنصر الخيار (Pill) نفسه والتحكم في ألوان الخلفية والنص عند الاختيار
  Widget _buildPillContainer(
    String text,
    bool isSelected,
    Color activeColor,
    Color titleColor,
    bool isDark, {
    bool forceWhite = false,
  }) {
    final unselectedBgColor = isDark
        ? const Color(0xff4A4A4A)
        : Colors.grey[300];

    // تحديد لون النص المختار؛ إذا كان القسم هو الترتيب (forceWhite) فيكون أبيض، وإلا يتبع الثيم
    final selectedTextColor = forceWhite
        ? Colors.white
        : (isDark ? DarkColors.darkBackGround : Colors.white);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? activeColor : unselectedBgColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? selectedTextColor : titleColor,
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
          fontFamily: AppFonts.font,
        ),
      ),
    );
  }

  // بناء حقول إدخال السعر (الحد الأدنى والأقصى)
  Widget _buildPriceInputs(
    Color bgColor,
    Color titleColor,
    Color hintColor,
    Color dividerColor,
    Color mainColor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: _buildMiniInput(
              "MIN",
              budgetRange.start.round().toString(),
              bgColor,
              titleColor,
              hintColor,
              dividerColor,
              mainColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildMiniInput(
              "MAX",
              budgetRange.end.round().toString(),
              bgColor,
              titleColor,
              hintColor,
              dividerColor,
              mainColor,
            ),
          ),
        ],
      ),
    );
  }

  // بناء حقل إدخال صغير مخصص للسعر
  Widget _buildMiniInput(
    String label,
    String value,
    Color bgColor,
    Color titleColor,
    Color hintColor,
    Color dividerColor,
    Color mainColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: hintColor,
            letterSpacing: 0.3,
            fontFamily: AppFonts.font,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: dividerColor, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: mainColor,
              fontFamily: AppFonts.font,
            ),
          ),
        ),
      ],
    );
  }

  // بناء الفوتر الثابت في أسفل الشاشة للأزرار النهائية
  Widget _buildStickyFooter(
    Color attentionColor,
    Color titleColor,
    Color cardBgColor,
    Color dividerColor,
    Color scaffoldBg,
    bool isDark,
  ) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [scaffoldBg.withOpacity(0), scaffoldBg],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: dividerColor),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: _buildFooterBtn(
                    "Cancel",
                    Colors.transparent,
                    titleColor,
                    true,
                    dividerColor,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final Map<String, dynamic> filters = {
                      'listingType': listingType,
                      'propertyTypes': propertyTypes,
                    };
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchFilterResultsScreen(
                          title: "Filtered Results",
                          filterParams: filters,
                        ),
                      ),
                    );
                  },
                  child: _buildFooterBtn(
                    "Apply Filters",
                    attentionColor,
                    Colors.white,
                    false,
                    dividerColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // بناء تصميم زر الفوتر (Cancel أو Apply)
  Widget _buildFooterBtn(
    String label,
    Color bg,
    Color text,
    bool hasBorder,
    Color borderColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: hasBorder ? Border.all(color: borderColor) : null,
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: text,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          fontFamily: AppFonts.font,
        ),
      ),
    );
  }

  // وظيفة مساعدة لتحويل أسماء الأيقونات إلى بيانات IconData
  IconData _getIconData(String name) {
    switch (name) {
      case "sell":
        return Icons.sell_rounded;
      case "apartment":
        return Icons.apartment_rounded;
      case "location_on":
        return Icons.location_on_rounded;
      case "payments":
        return Icons.payments_rounded;
      case "straighten":
        return Icons.straighten_rounded;
      case "checkroom":
        return Icons.checkroom_rounded;
      case "weekend":
        return Icons.weekend_rounded;
      case "schedule":
        return Icons.schedule_rounded;
      case "event_repeat":
        return Icons.event_repeat_rounded;
      case "verified":
        return Icons.verified_rounded;
      case "rule":
        return Icons.rule_rounded;
      case "sort":
        return Icons.sort_rounded;
      default:
        return Icons.filter_alt_rounded;
    }
  }
}
