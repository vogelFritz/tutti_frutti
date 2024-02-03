import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutti_frutti/models/suggestion.dart';

final fieldSuggestionsProvider =
    StateNotifierProvider<FieldSuggestionsNotifier, Map<String, Suggestion>>(
        (_) => FieldSuggestionsNotifier());

class FieldSuggestionsNotifier extends StateNotifier<Map<String, Suggestion>> {
  final Map<String, String> _votes = {};
  final List<String> defaultFields = [
    'Nombres',
    'Colores',
    'Animales',
    'Paises',
    'Comidas'
  ];

  List<String> get mostVotedFields {
    String? mostVotedUser;
    int max = -1;
    for (Suggestion suggestion in state.values) {
      if (suggestion.votes > max) {
        max = suggestion.votes;
        mostVotedUser = suggestion.userName;
      }
    }
    return mostVotedUser != null ? state[mostVotedUser]!.fields : defaultFields;
  }

  FieldSuggestionsNotifier() : super({});

  void onVote(String voter, String vote) {
    _votes[voter] = vote;
    final Map<String, int> votesPerUser = {};
    for (String vote in _votes.values) {
      votesPerUser[vote] = (votesPerUser[vote] ?? 0) + 1;
    }
    Map<String, Suggestion> stateCopy = {...state};
    for (String user in stateCopy.keys) {
      stateCopy[user] =
          stateCopy[user]!.copyWith(votes: votesPerUser[user] ?? 0);
    }
    state = stateCopy;
  }

  void newSuggestion(Suggestion suggestion) {
    state = {...state, suggestion.userName: suggestion};
  }
}
