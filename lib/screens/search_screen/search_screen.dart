import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:collezione_topolino/blocs/publication_bloc.dart';
import 'package:collezione_topolino/models/publication.dart';
import 'package:collezione_topolino/screens/search_screen/components/result_element.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Publication? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Center(
            child: TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                // Max 5 digits
                LengthLimitingTextInputFormatter(5),
                // Allow only numbers
                FilteringTextInputFormatter.allow(RegExp(r'\d')),
              ],
              onChanged: (value) async {
                final number = int.tryParse(value);
                if (number == null) {
                  setState(() {
                    _result = null;
                  });

                  return;
                }

                // Take parsed publications
                final pubList = await Provider.of<PublicationBloc>(
                  context,
                  listen: false,
                ).results.first;

                // Filter publication by number
                final filtered = pubList
                    .where((publication) => publication.number == number);

                if (filtered.isEmpty) {
                  setState(() {
                    _result = null;
                  });
                  return;
                }

                // TODO Implement saved copies counter on result item
                // // Widget may already be unmounted (after async call) so any
                // // code running could cause unwanted behavior
                // if (!mounted) return;

                // // Ask for saved copies
                // Provider.of<DatabaseBloc>(
                //   context,
                //   listen: false,
                // ).querySink.add(FetchByNumberEvent(number));

                setState(() {
                  _result = filtered.first;
                });
              },
              decoration: InputDecoration(
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).focusColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.cancel,
                    color: Theme.of(context).focusColor,
                  ),
                  onPressed: () {
                    _controller.text = "";
                    setState(() {
                      _result = null;
                    });
                  },
                ),
                hintText: "Inserisci il numero...",
                border: null,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SizedBox(
          width: double.infinity,
          height: 150.0,
          child: () {
            if (_result == null) {
              return const Center(child: Text("Nessun risultato"));
            }
            return ResultElement(publ: _result!);
          }(),
        ),
      ),
    );
  }
}
