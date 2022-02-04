import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tranquil_life/helpers/sizes_helpers.dart';
import 'package:tranquil_life/pages/scheduling/consultant_list/scheduling_time/widgets/time_slot_container.dart';

/// TIME SLOT BUILDER for building timeSlots based on the list
class TimeSlotBuilderWidget extends StatelessWidget {
  final List<String>? timeList;
  final List<int>? bookedIndex;
  final List<int>? enabledIndex;
  final Function(int)? onTapped;
  final int? selectedIndexOfTimeSlot;
  final List<int>? selectedIndexOfTimeSlotsList;
  final bool shouldShowScheduledHours;

  const TimeSlotBuilderWidget(
      {Key? key,
        this.timeList,
        this.selectedIndexOfTimeSlot,
        this.bookedIndex,
        this.enabledIndex,
        this.selectedIndexOfTimeSlotsList,
        this.shouldShowScheduledHours = false,
        this.onTapped})
      :
  //  assert(
  //       (selectedIndexOfTimeSlot == null &&
  //               selectedIndexOfTimeSlotsList != null) ||
  //           selectedIndexOfTimeSlotsList == null,
  //       'if selectedIndexOfTimeSlotsList is null, then selectedIndexOfTimeSlot must not be null and vice Versa'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: displayWidth(context) * 0.07),
      alignment: Alignment.centerLeft,
      child: timeList != null && timeList!.isNotEmpty
          ? Wrap(
        alignment: WrapAlignment.start,
        runSpacing: 20,
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        runAlignment: WrapAlignment.start,
        children: timeList!
            .map(
              (timeSectionItem) => TimeSlotContainer(
            time: timeSectionItem,
            enabled: enabledIndex
                ?.contains(timeList!.indexOf(timeSectionItem)) ??
                true,
            indexOfTimeSlot: timeList!.indexOf(timeSectionItem),
            selectedIndexOfTimeSlot: selectedIndexOfTimeSlot,
            selectedIndexOfTimeSlotsList:
            selectedIndexOfTimeSlotsList,
            bookedIndex: bookedIndex,
            onTapped: onTapped,
          ),
        )
            .toList(),
      )
          : const SizedBox(
        height: 80,
        child: Center(
          child: Text(
            'No Available Slots',
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.1,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}