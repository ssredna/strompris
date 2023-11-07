import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:strom/screens/strompriser.dart';

Future<Strompriser> fetchStrompriser() async {
  final now = DateTime.now();
  final year = now.year;
  final month = now.month.toString().padLeft(2, "0");
  final day = now.day.toString().padLeft(2, "0");

  final response = await http.get(Uri.parse(
      'https://www.hvakosterstrommen.no/api/v1/prices/$year/$month-${day}_NO3.json'));

  if (response.statusCode == 200) {
    final strompriser = jsonDecode(response.body) as List<dynamic>;
    final strompriserList =
        strompriser.map((json) => Strompris.fromJson(json)).toList();
    return Strompriser(strompriser: strompriserList);
  } else {
    throw Exception('Failed to load strompriser');
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Strompriser> _futureStrompriser;

  void _refresh() {
    setState(() {
      _futureStrompriser = fetchStrompriser();
    });
  }

  @override
  void initState() {
    super.initState();
    _futureStrompriser = fetchStrompriser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<Strompriser>(
                future: _futureStrompriser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Text(
                          'Strømprisen kl ${snapshot.data!.current.timeStart.hour + 1} - ${snapshot.data!.current.timeEnd.hour + 1}:',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                              '${snapshot.data!.nokPerKwhWithNettleie.toStringAsFixed(2)} NOK',
                              style: Theme.of(context).textTheme.displayMedium),
                        ),
                        Text.rich(TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              const TextSpan(
                                text: '2000 kW: ',
                              ),
                              TextSpan(
                                text: (snapshot.data!.nokPerKwhWithNettleie * 2)
                                    .toStringAsFixed(1),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const TextSpan(
                                text: ' kr/t',
                              )
                            ])),
                        Text.rich(TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              const TextSpan(
                                text: '1250 kW: ',
                              ),
                              TextSpan(
                                text: (snapshot.data!.nokPerKwhWithNettleie *
                                        1.25)
                                    .toStringAsFixed(1),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const TextSpan(
                                text: ' kr/t',
                              )
                            ])),
                        Text.rich(TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              const TextSpan(
                                text: '750 kW: ',
                              ),
                              TextSpan(
                                text: (snapshot.data!.nokPerKwhWithNettleie *
                                        0.75)
                                    .toStringAsFixed(1),
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const TextSpan(
                                text: ' kr/t',
                              )
                            ])),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return const CircularProgressIndicator();
                }),
            if (validUntil.isBefore(DateTime.now()))
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Text(
                  'Nettleien kan ha endret seg',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
