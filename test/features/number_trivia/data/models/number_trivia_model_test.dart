import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  //create model for test
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test text');

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      // assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result,
            tNumberTriviaModel); // expect(result, equals(tNumberTriviaModel))
      },
    );

    test(
      'should return a valid model when the JSON number is a double',
      () async {
        // arrange
        final Map<String, dynamic> jsonMap =
            json.decode(fixture('trivia_double.json'));
        // act
        final result = NumberTriviaModel.fromJson(jsonMap);
        // assert
        expect(result,
            tNumberTriviaModel); // expect(result, equals(tNumberTriviaModel))
      },
    );
  });

  group('toJson', () {
    test(
      'should return a JSON map containing th proper data',
      () async {
        // act
        final result = tNumberTriviaModel.toJson();
        // assert
        final expectedMap = {
          "text": "Test text",
          "number": 1,
        };
        expect(
            result, expectedMap); // expect(result, equals(tNumberTriviaModel))
      },
    );
  });

  //  test(
  //   'should be a subclass of NumberTrivia entity',
  //   () async {
  //     // arrange

  //     // act

  //     // assert
  //   },
  // );
}
