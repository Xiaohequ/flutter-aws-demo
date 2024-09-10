import 'package:aws_demo/common/utils/colors.dart' as constants;
import 'package:aws_demo/features/trip/controller/trips_list_controller.dart';
import 'package:aws_demo/features/trip/ui/trips_gridview/trips_list_gridview.dart';
import 'package:aws_demo/features/trip/ui/trips_list/add_trip_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripsListPage extends ConsumerWidget {
  const TripsListPage({
    super.key,
  });

  Future<void> showAddTripDialog(BuildContext context) =>
      showModalBottomSheet<void>(
        isScrollControlled: true,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
        context: context,
        builder: (sheetContext) {
          return const AddTripBottomSheet();
        },
      );


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripsListValue = ref.watch(tripsListControllerProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Article List',
        ),
        backgroundColor: const Color(constants.primaryColorDark),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddTripDialog(context);
        },
        backgroundColor: const Color(constants.primaryColorDark),
        child: const Icon(Icons.add),
      ),
      body: TripsListGridView(
        tripsList: tripsListValue,
      ),
    );
  }
}