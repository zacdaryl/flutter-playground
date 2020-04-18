import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeEx on DateTime {
  String ft() {
    return DateFormat.yMd().format(this);
  }
}

Future<DateTime> _showDatePicker(BuildContext context) {
  return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime.parse('2022-12-31'));
}

class DatePicker extends StatefulWidget {
  DatePicker({Key key}) : super(key: key);

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  DateTime _start =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime _end = 
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String _startFormat = DateTime.now().ft();
  String _endFormat = DateTime.now().ft();

  int _days = 0;
  int _hours = 0;

  int _d = 0, _h = 0;

  setValue() {
    _days = _end.difference(_start).inDays;
    _hours = _end.difference(_start).inHours;

    _d = _hours ~/ 24;
    _h = _hours % 24;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Date Duration'),
        ),
        body: Column(
          children: <Widget>[
            DateItem(
                label: 'start',
                formatDate: _startFormat,
                onDateSelected: (date) {
                  _start = date;
                  print('start: $_start, $_end');
                  setState(() {
                    setValue();
                  });
                  print('start dur: $_days');
                }),
            DateItem(
                label: 'end',
                formatDate: _endFormat,
                onDateSelected: (date) {
                  _end = date;
                  print('end: $_start, $_end');
                  setState(() {
                    setValue();
                  });
                  print('end dur: $_days');
                }),
            Padding(
                padding: EdgeInsets.all(30),
                child: Column(
                  children: <Widget>[
                    Text(
                      'duration: $_days days',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      'duration: $_hours hours',
                      style: TextStyle(fontSize: 30),
                    ),
                    Text(
                      'duration: $_d days and $_h hours',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                )),
          ],
        ));
  }
}

class DateItem extends StatefulWidget {
  final String label;
  final String formatDate;
  final Function(DateTime) onDateSelected;

  DateItem(
      {Key key, @required this.label, this.formatDate, this.onDateSelected});

  @override
  State<StatefulWidget> createState() {
    return ItemState(formatDate);
  }
}

class ItemState extends State<DateItem> {
  String formatDate;
  ItemState(this.formatDate);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30),
      child: Row(
        children: <Widget>[
          Text('${widget.label}:', style: TextStyle(fontSize: 26)),
          SizedBox(width: 10),
          Text(formatDate, style: TextStyle(fontSize: 26)),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              _showDatePicker(context).then((date) {
                setState(() {
                  formatDate = date.ft();
                });
                widget.onDateSelected(date);
              });
            },
          )
        ],
      ),
    );
  }
}
