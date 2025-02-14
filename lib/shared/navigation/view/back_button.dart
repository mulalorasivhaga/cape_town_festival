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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MainNav()),
                      );
                    },
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black
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