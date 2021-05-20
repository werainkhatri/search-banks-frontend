import 'package:flutter/material.dart';

class CitiesDropdownWidget extends StatefulWidget {
  CitiesDropdownWidget();

  @override
  _CitiesDropdownWidgetState createState() => _CitiesDropdownWidgetState();
}

class _CitiesDropdownWidgetState extends State<CitiesDropdownWidget> {
  late String value;

  final List<String> _cities = [
    "Bangalore",
    'Mumbai',
    'Delhi',
    'Chennai',
    'Hyderabad',
  ];

  @override
  void initState() {
    super.initState();
    value = _cities[0];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(border: OutlineInputBorder(gapPadding: 0)),
      value: value,
      items: _cities
          .map<DropdownMenuItem<String>>((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: (newValue) {
        setState(() {
          value = newValue!;
        });
      },
    );
  }
}
