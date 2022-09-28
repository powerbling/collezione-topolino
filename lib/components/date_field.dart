import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateField extends StatefulWidget {
  final DateTime? initialDate;
  final DateFormat dateFormat;
  final Function onChanged;

  DateField({
    Key? key,
    required this.onChanged,
    DateFormat? dateFormat,
    this.initialDate,
  })  : dateFormat = dateFormat ?? DateFormat.yMd('it_IT'),
        super(key: key);

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  DateTime? _selected;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _selected = widget.initialDate ?? DateTime.now();

    _controller.text = widget.dateFormat.format(_selected!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: _controller,
      onTap: () {
        showDatePicker(
          context: context,
          initialDate: _selected!,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        ).then((value) {
          if (value == null || value == _selected) return;

          setState(() {
            _selected = value;
          });

          widget.onChanged(_selected);
          _controller.text = widget.dateFormat.format(_selected!);
        });
      },
    );
  }
}
