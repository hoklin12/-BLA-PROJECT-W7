import 'dart:async';

import 'package:flutter/material.dart';
import 'package:week_3_blabla_project/ui/Provider/Rides_Prefs_Provider.dart';

import '../../../model/ride/ride_pref.dart';
import '../../../service/ride_prefs_service.dart';
import '../../theme/theme.dart';

import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';
import 'package:provider/provider.dart'; 

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

const String blablaWifiImagePath = 'assets/images/blabla_wifi.png';

class BlaError extends StatelessWidget {
  const BlaError({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(left: BlaSpacings.m, right: BlaSpacings.m, top: BlaSpacings.s),
      child: Center(
        child: Column(
          children: [
            Image.asset(
              blablaWifiImagePath,
              fit: BoxFit.none, // Adjust image fit to cover the container
            ),
            Text(
              message,
              style: BlaTextStyles.heading.copyWith(color: BlaColors.textNormal),
            ),
          ],
        ),
      ),
    ));
  }
}

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

    Future<void> _onRidePrefSelected(BuildContext context,RidePreference newPreference) async {
    // 1 - Update the current preference
    // RidePrefService.instance.setCurrentPreference(newPreference);
    context.read<RidesPreferencesProvider>().setCurrentPreference(newPreference);

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
      builder: (context, RidesPreferencesProvider, child) {

        final pastPreferencesState = RidesPreferencesProvider.pastPreferencesState;

        if (pastPreferencesState.isLoading) {
          return const BlaError(message: 'loading');
        } else if (pastPreferencesState.isError) {
          return const BlaError(message: 'No connection. Try later');
        } else if (pastPreferencesState.isSuccess &&
            pastPreferencesState.data != null) {
          // If the state is success, display the screen as normal
          RidePreference? currentRidePreference =
              RidesPreferencesProvider.currentPreference;
          List<RidePreference> pastPreferences = pastPreferencesState.data!.reversed.toList();
        
return Stack(
            children: [
              // 1 - Background Image
              const BlaBackground(),

              // 2 - Foreground content
              Column(
                children: [
                  const SizedBox(height: BlaSpacings.m),
                  Text(
                    "Your pick of rides at low price",
                    style: BlaTextStyles.heading.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 100),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 2.1 Display the Form to input the ride preferences
                        RidePrefForm(
                          initialPreference: currentRidePreference,
                          onSubmit: (newPreference) =>
                              _onRidePrefSelected(context, newPreference),
                        ),
                        const SizedBox(height: BlaSpacings.m),

                        // 2.2 Display list of past preferences (latest to oldest)
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: pastPreferences.length,
                            itemBuilder: (ctx, index) => RidePrefHistoryTile(
                              ridePref: pastPreferences[index],
                              onPressed: () => _onRidePrefSelected(
                                  context, pastPreferences[index]),
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
        } else {

          return const BlaError(message: 'No preferences available');
        }
      },
    );
  }
}
