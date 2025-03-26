import 'dart:async';

import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/Provider/Rides_Prefs_Provider.dart';

import '../../../model/ride/ride_pref.dart';
import '../../../service/ride_prefs_service.dart';
import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';
import 'package:provider/provider.dart'; 

const String blablaHomeImagePath = 'assets/images/blabla_home.png';



class BlaBackground extends StatelessWidget {

  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}


class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

    void _onRidePrefSelected(BuildContext context,RidePreference newPreference) async {
    // 1 - Update the current preference
    // RidePrefService.instance.setCurrentPreference(newPreference);
    context.read<RidesPreferencesProvider>().setCurrentPreferrence(newPreference);

    // 2 - Navigate to the rides screen (with a buttom to top animation)
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(RidesScreen()));

    // 3 - After wait  - Update the state   -- TODO MAKE IT WITH STATE MANAGEMENT
    // setState(() {});
  }

   @override
  Widget build(BuildContext context) {
   return Consumer<RidesPreferencesProvider>(
    // Get current preference and history from provider
      builder: (context, RidesPreferencesProvider, child){
        final RidePreference? currentRidePreference = RidesPreferencesProvider.currentPreference;
        final List<RidePreference> pastPreferences =
        RidesPreferencesProvider.preferencesHistory;
        
        return Stack(
          children: [
            // 1 - Background  Image
            BlaBackground(),

            // 2 - Foreground content
            Column(
              children: [
                SizedBox(height: BlaSpacings.m),
                Text(
                  "Your pick of rides at low price",
                  style: BlaTextStyles.heading.copyWith(color: Colors.white),
                ),
                SizedBox(height: 100),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                  decoration: BoxDecoration(
                    color: Colors.white, // White background
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 2.1 Display the Form to input the ride preferences
                      RidePrefForm(
                          initialPreference: currentRidePreference,
                          onSubmit: (pref) => _onRidePrefSelected(context,pref)),
                      SizedBox(height: BlaSpacings.m),

                      // 2.2 Optionally display a list of past preferences
                      SizedBox(
                        height: 200, // Set a fixed height
                        child: ListView.builder(
                          shrinkWrap: true, // Fix ListView height issue
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: pastPreferences.length,
                          itemBuilder: (ctx, index) => RidePrefHistoryTile(
                            ridePref: pastPreferences[index],
                            onPressed: () =>
                                _onRidePrefSelected(context, pastPreferences[index]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
   );
  }
}
