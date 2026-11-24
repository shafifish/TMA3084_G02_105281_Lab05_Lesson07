import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// One row of the table
class Car {
  final String make;
  final String model;
  final double price;

  const Car(this.make, this.model, this.price);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 05 Lab B',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const CarTableScreen(),
    );
  }
}

class CarTableScreen extends StatefulWidget {
  const CarTableScreen({super.key});

  @override
  State<CarTableScreen> createState() => _CarTableScreenState();
}

class _CarTableScreenState extends State<CarTableScreen> {
  // Null means no column is sorted yet, so no arrow shows
  int? _sortColumnIndex;
  bool _sortAscending = true;

  final List<Car> _cars = <Car>[
    const Car('Perodua', 'Myvi', 48500),
    const Car('Proton', 'X50', 86300),
    const Car('Honda', 'City', 89000),
    const Car('Toyota', 'Vios', 92000),
    const Car('Perodua', 'Axia', 38600),
    const Car('Proton', 'Saga', 34800),
    const Car('Honda', 'Civic', 134000),
    const Car('Toyota', 'Corolla', 142000),
  ];

  // Sorts the list by whichever field the tapped column gives back
  void _sort<T>(
    Comparable<T> Function(Car car) getField,
    int columnIndex,
    bool ascending,
  ) {
    _cars.sort((Car a, Car b) {
      final Comparable<T> aValue = getField(a);
      final Comparable<T> bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Price List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            columns: <DataColumn>[
              DataColumn(
                label: const Text('Car Make'),
                onSort: (int columnIndex, bool ascending) =>
                    _sort<String>((Car car) => car.make, columnIndex, ascending),
              ),
              DataColumn(
                label: const Text('Model'),
                onSort: (int columnIndex, bool ascending) =>
                    _sort<String>((Car car) => car.model, columnIndex, ascending),
              ),
              DataColumn(
                label: const Text('Price (RM)'),
                numeric: true,
                onSort: (int columnIndex, bool ascending) =>
                    _sort<num>((Car car) => car.price, columnIndex, ascending),
              ),
            ],
            rows: _cars.map((Car car) {
              return DataRow(
                cells: <DataCell>[
                  DataCell(Text(car.make)),
                  DataCell(Text(car.model)),
                  DataCell(Text(car.price.toStringAsFixed(2))),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
