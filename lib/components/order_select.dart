import 'package:flutter/material.dart';

class OrderSelect extends StatefulWidget {
  final Function(int) onChanged;

  const OrderSelect({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<OrderSelect> createState() => _OrderSelectState();
}

class _OrderSelectState extends State<OrderSelect> {
  final List<String> _menuItems = [
    "Decrescente",
    "Crescente",
  ];

  int _orderBy = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        PopupMenuButton<int>(
          onSelected: (value) {
            widget.onChanged(value);
            setState(() {
              _orderBy = value;
            });
          },
          initialValue: _orderBy,
          tooltip: "Ordine",
          itemBuilder: (BuildContext context) {
            return _menuItems.asMap().keys.map((index) {
              return PopupMenuItem<int>(
                value: index,
                child: Text(_menuItems[index]),
              );
            }).toList();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Text(
                  "Ordine",
                  style: Theme.of(context).textTheme.button,
                ),
                Icon(
                  _menuItems[_orderBy] == "Crescente"
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
