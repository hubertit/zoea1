import 'package:flutter/material.dart';

Future<DateTimeRange?> showCustomRangePicker(BuildContext context,DateTime now,{Duration? duration,DateTimeRange? initialRange}){
  return showDialog<DateTimeRange>(
      context: context,
      builder: (context) => Theme(
        data: Theme.of(context).copyWith(
          appBarTheme: ThemeData.fallback().appBarTheme,
        ),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
              size: Size(MediaQuery.of(context).size.width - 50,
                  MediaQuery.of(context).size.height - 100)),
          child: ClipRRect(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            borderRadius: BorderRadius.circular(25),
            child: DateRangePickerDialog(
              currentDate: now,
              initialDateRange: initialRange,
              saveText: "Next",
              firstDate: now,
              lastDate: now.add(duration ?? const Duration(days: 360)),
            ),
          ),
        ),
      ));
}