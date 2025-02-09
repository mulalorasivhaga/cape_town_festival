import 'package:flutter/material.dart';

class BackToHomeNav extends StatelessWidget {
  const BackToHomeNav({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: screenHeight * 0.08,
      backgroundColor: Colors.transparent,
      title: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10, bottom: 5),
                child: Tooltip(
                  message: 'Click to go back',
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context), // Goes back to previous screen
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFFE2AF29) // Use theme icon color
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