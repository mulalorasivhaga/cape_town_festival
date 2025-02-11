//show events created by admin
// all users can view event details
// logged in users can RSVP event details
// all users can see stats on attendance and RSVP level
// google maps integration for event location


import 'package:ct_festival/shared/navigation/view/back_button.dart';
import 'package:flutter/material.dart';

class EventView extends StatelessWidget {
  const EventView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(25),
        child: BackToHomeNav(),
      ),
      body: Center(child: Text('Event View'),),
    );
  }
}
