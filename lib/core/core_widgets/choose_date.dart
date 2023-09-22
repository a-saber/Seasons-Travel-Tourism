import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class DateRange extends StatefulWidget {
  const DateRange({Key? key, required this.onChanged}) : super(key: key);

  final void Function(DateRangePickerSelectionChangedArgs)? onChanged;
  @override
  State<DateRange> createState() => _DateRangeState();
}

class _DateRangeState extends State<DateRange> {
  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    String _selectedDate = '';
    String _dateCount = '';
    String _range = '';
    String _rangeCount = '';
    setState(() {
      if (args.value is PickerDateRange) {
        print(args.value.startDate);
        print(args.value.endDate);
        _range = '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
        // ignore: lines_longer_than_80_chars
            ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
      } else if (args.value is DateTime) {
        _selectedDate = args.value.toString();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.length.toString();
      } else {
        _rangeCount = args.value.length.toString();
      }
    });
    print('++++++++++++');
    print(_selectedDate);
    print(_range);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 100),
        child: SfDateRangePicker(
          view: DateRangePickerView.month,
          enablePastDates: false,
          selectionMode: DateRangePickerSelectionMode.range,

          onSelectionChanged: widget.onChanged,
          // selectableDayPredicate: (DateTime day)
          // {
          //   return day.weekday == DateTime.saturday;
          // },
        ),
      ),
    );
  }
}