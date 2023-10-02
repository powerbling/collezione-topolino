import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:collezione_topolino/blocs/search_screen_bloc.dart';
import 'package:collezione_topolino/events/search_screen_event.dart';
import 'package:collezione_topolino/state/search_screen_state.dart';
import 'package:collezione_topolino/screens/search_screen/components/result_element.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _changeTimeout;
  late SearchScreenBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<SearchScreenBloc>();
    bloc.add(const SearchScreenEmptySearchEvent());
  }

  void _contentChanged(int? number) {
    if (_changeTimeout != null && _changeTimeout!.isActive) {
      _changeTimeout!.cancel();
    }
    _changeTimeout = Timer(const Duration(seconds: 1), () {
      if (number == null) {
        bloc.add(const SearchScreenEmptySearchEvent());
      } else {
        bloc.add(SearchScreenFetchDataEvent(issueNumber: number));
      }
    });
  }

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
                _contentChanged(number);

                // TODO Implement saved copies counter on result item
                // // Widget may already be unmounted (after async call) so any
                // // code running could cause unwanted behavior
                // if (!mounted) return;

                // // Ask for saved copies
                // Provider.of<DatabaseBloc>(
                //   context,
                //   listen: false,
                // ).querySink.add(FetchByNumberEvent(number));
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
                    _contentChanged(null);
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
          child: BlocConsumer<SearchScreenBloc, SearchScreenState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is SearchScreenLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SearchScreenErrorFetchingState) {
                return const Center(
                  child: Text("Nessun risultato per la ricerca effettuata,"
                      "\ncontrolla il numero inserito."),
                );
              }
              if (state is SearchScreenSuccessFetchingState) {
                return ResultElement(issue: state.issue);
              }
              return const Center(
                child: Text("Inserisci un numero per cercare."),
              );
            },
          ),
        ),
      ),
    );
  }
}
