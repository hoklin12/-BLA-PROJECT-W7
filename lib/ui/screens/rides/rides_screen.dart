import 'package:flutter/material.dart';
import '../../../model/ride/ride_filter.dart';
import 'widgets/ride_pref_bar.dart';
import '../../../service/ride_prefs_service.dart';
import 'package:week_3_blabla_project/Provider/Rides_Prefs_Provider.dart';
import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';
import 'package:provider/provider.dart'; 


class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

      // RidePreference get currentPreference =>
    //   RidePrefService.instance.currentPreference!;

  // RideFilter currentFilter = RideFilter();

  // List<Ride> get matchingRides =>
  //     RidesService.instance.getRidesFor(currentPreference, currentFilter);

  void _onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void _onRidePrefSelected(BuildContext context, RidePreference newPreference) {
    // Read the provider and set the current preference
    context.read<RidesPreferencesProvider>().setCurrentPreferrence(newPreference);
  }

  Future<void> _onPreferencePressed(BuildContext context) async {
    final currentPreference = context.read<RidesPreferencesProvider>().currentPreference;
    if (currentPreference == null) return;

    final RidePreference? newPreference = await Navigator.of(context).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      // 1 - Update the current preference
      // RidePrefService.instance.setCurrentPreference(newPreference);
      _onRidePrefSelected(context, newPreference);

      // 2 -   Update the state   -- TODO MAKE IT WITH STATE MANAGEMENT
      // setState(() {});
    }
  }

  void _onFilterPressed(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return Consumer<RidesPreferencesProvider>(
      builder: (context, provider, child) {
        // Get current preference from provider
        final RidePreference? currentPreference = provider.currentPreference;
        
        // Handle case where no preference is set
        if (currentPreference == null) {
          return const Scaffold(
            body: Center(child: Text('No ride preference selected')),
          );
        }

        // Get list of available rides regarding current preference
        final List<Ride> availableRides = RidesService.instance.getRidesFor(
          currentPreference,
          RideFilter(), // Default filter - could be enhanced
        );

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.only(
              left: BlaSpacings.m,
              right: BlaSpacings.m,
              top: BlaSpacings.s,
            ),
            child: Column(
              children: [
                // Top search bar
                RidePrefBar(
                  ridePreference: currentPreference,
                  onBackPressed: () => _onBackPressed(context),
                  onPreferencePressed: () => _onPreferencePressed(context),
                  onFilterPressed: () => _onFilterPressed(context),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: availableRides.length,
                    itemBuilder: (ctx, index) => RideTile(
                      ride: availableRides[index],
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


///
///  The Ride Selection screen allow user to select a ride, once ride preferences have been defined.
///  The screen also allow user to re-define the ride preferences and to activate some filters.
///
// class RidesScreen extends StatefulWidget {
//   const RidesScreen({super.key});

//   @override
//   State<RidesScreen> createState() => _RidesScreenState();
// }

// class _RidesScreenState extends State<RidesScreen> {
//   RidePreference get currentPreference =>
//       RidePrefService.instance.currentPreference!;

//   RideFilter currentFilter = RideFilter();

//   List<Ride> get matchingRides =>
//       RidesService.instance.getRidesFor(currentPreference, currentFilter);

//   void onBackPressed() {
//     // 1 - Back to the previous view
//     Navigator.of(context).pop();
//   }

//   onRidePrefSelected(RidePreference newPreference) async {}

//   void onPreferencePressed() async {
//     // Open a modal to edit the ride preferences
//     RidePreference? newPreference = await Navigator.of(
//       context,
//     ).push<RidePreference>(
//       AnimationUtils.createTopToBottomRoute(
//         RidePrefModal(initialPreference: currentPreference),
//       ),
//     );

//     if (newPreference != null) {
//       // 1 - Update the current preference
//       RidePrefService.instance.setCurrentPreference(newPreference);

//       // 2 -   Update the state   -- TODO MAKE IT WITH STATE MANAGEMENT
//       setState(() {});
//     }
//   }

//   void onFilterPressed() {}

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.only(
//           left: BlaSpacings.m,
//           right: BlaSpacings.m,
//           top: BlaSpacings.s,
//         ),
//         child: Column(
//           children: [
//             // Top search Search bar
//             RidePrefBar(
//               ridePreference: currentPreference,
//               onBackPressed: onBackPressed,
//               onPreferencePressed: onPreferencePressed,
//               onFilterPressed: onFilterPressed,
//             ),

//             Expanded(
//               child: ListView.builder(
//                 itemCount: matchingRides.length,
//                 itemBuilder: (ctx, index) =>
//                     RideTile(ride: matchingRides[index], onPressed: () {}),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }