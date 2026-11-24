import 'package:graduation_project_flutter/core/routing/routes_export.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String selectedRole = "Seeker"; // افتراضي ممكن يكون null

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Choose Your Role",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                "Tailoring your experience to help you find or manage property with ease.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 40),

              // Role cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _roleCard(
                    "Owner",
                    "List and manage your properties",
                    selectedRole == "Owner",
                  ),
                  _roleCard(
                    "Seeker",
                    "Find your next dream home",
                    selectedRole == "Seeker",
                  ),
                ],
              ),

              const Spacer(),

              // Continue button
              ElevatedButton(
                onPressed: selectedRole.isNotEmpty
                    ? () {
                        // حفظ الدور في SharedPreferences أو Provider
                        // مثال: Navigator.pushReplacement
                        print("Selected role: $selectedRole");
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Continue"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _roleCard(String role, String subtitle, bool selected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        width: 140,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: selected ? context.attentionColor : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Placeholder للصورة / الillustration
            Icon(
              role == "Owner" ? Icons.home_outlined : Icons.person_outline,
              size: 60,
              color: selected ? context.attentionColor : Colors.grey,
            ),
            const SizedBox(height: 10),
            Text(
              role,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: selected ? context.attentionColor : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            if (selected)
              Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(
                  "SELECTED",
                  style: TextStyle(
                    fontSize: 12,
                    color: context.attentionColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
