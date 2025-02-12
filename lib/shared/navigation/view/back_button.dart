import 'package:ct_festival/shared/navigation/view/main_nav.dart';
import 'package:flutter/material.dart';

class BackToHomeNav extends StatelessWidget {
  const BackToHomeNav({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: screenHeight * 0.5, // Increased toolbar height
      backgroundColor: Colors.transparent,
      title: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 30, bottom: 10), // Adjusted padding
                child: Tooltip(
                  message: 'Click to go back',
                  child: GestureDetector(
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MainNav()), // Replace HomeScreen with your home screen widget
                          (Route<dynamic> route) => false,
                    ),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFFE0E0CE) // Use theme icon color
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}