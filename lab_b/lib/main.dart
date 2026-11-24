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

  // FIX 1: RM 1,000 steps instead of RM 100. 107 divisions, not 1,072.
  static const double _priceStep = 1000;

  late double _minPrice;
  late double _maxPrice;
  late RangeValues _priceRange;

  // FIX 2: stored instead of a getter, so it is rebuilt only when the
  // sort or the range actually changes, not on every single build.
  late List<Car> _filteredCars;

  @override
  void initState() {
    super.initState();
    // FIX 3: reduce() throws on an empty list, so guard it first
    _minPrice = _cars.isEmpty
        ? 0
        : _cars.map((Car car) => car.price).reduce((a, b) => a < b ? a : b);
    _maxPrice = _cars.isEmpty
        ? 0
        : _cars.map((Car car) => car.price).reduce((a, b) => a > b ? a : b);
    _priceRange = RangeValues(_minPrice, _maxPrice);
    _filteredCars = _filterCars();
  }

  List<Car> _filterCars() {
    return _cars
        .where((Car car) =>
            car.price >= _priceRange.start && car.price <= _priceRange.end)
        .toList();
  }

  // Turns 34800.0 into "RM 34,800" without needing the intl package
  String _formatRM(double value) {
    final String digits = value.round().toString();
    final StringBuffer buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digits[i]);
    }
    return 'RM $buffer';
  }

  // Sorts the list by whichever field the tapped column gives back
  void _sort<T>(
    Comparable<T> Function(Car car) getField,
    int columnIndex,
    bool ascending,
  ) {
    // FIX 4: the sort used to run outside setState. State changes belong
    // inside it, otherwise the frame can be built from a half-sorted list.
    setState(() {
      _cars.sort((Car a, Car b) {
        final Comparable<T> aValue = getField(a);
        final Comparable<T> bValue = getField(b);
        return ascending
            ? Comparable.compare(aValue, bValue)
            : Comparable.compare(bValue, aValue);
      });
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
      _filteredCars = _filterCars();
    });
  }

  // Range text, slider and car count shown above the table
  Widget _buildPriceFilter(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int divisions = ((_maxPrice - _minPrice) / _priceStep).round();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Price range', style: textTheme.titleSmall),
          const SizedBox(height: 4),
          Text(
            '${_formatRM(_priceRange.start)} to ${_formatRM(_priceRange.end)}',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          // FIX 5: RangeSlider asserts when min equals max, which happens
          // if every car costs the same. Hide it instead of crashing.
          if (_maxPrice > _minPrice)
            RangeSlider(
              min: _minPrice,
              max: _maxPrice,
              divisions: divisions > 0 ? divisions : null,
              values: _priceRange,
              labels: RangeLabels(
                _formatRM(_priceRange.start),
                _formatRM(_priceRange.end),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _priceRange = values;
                  _filteredCars = _filterCars();
                });
              },
            ),
          Text(
            'Showing ${_filteredCars.length} of ${_cars.length} cars',
            style: textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  // Shown in place of the table when no car fits the range
  Widget _buildEmptyMessage(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.search_off,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 12),
            Text('No cars in this price range', style: textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Try widening the slider to see more cars.',
              style: textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Price List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _buildPriceFilter(context),
          const Divider(height: 1),
          Expanded(
            child: _filteredCars.isEmpty
                ? _buildEmptyMessage(context)
                : SingleChildScrollView(
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
                                _sort<String>((Car car) => car.make,
                                    columnIndex, ascending),
                          ),
                          DataColumn(
                            label: const Text('Model'),
                            onSort: (int columnIndex, bool ascending) =>
                                _sort<String>((Car car) => car.model,
                                    columnIndex, ascending),
                          ),
                          DataColumn(
                            label: const Text('Price (RM)'),
                            numeric: true,
                            onSort: (int columnIndex, bool ascending) =>
                                _sort<num>((Car car) => car.price,
                                    columnIndex, ascending),
                          ),
                        ],
                        rows: _filteredCars.map((Car car) {
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
          ),
        ],
      ),
    );
  }
}