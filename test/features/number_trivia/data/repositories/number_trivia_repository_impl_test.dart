import 'dart:convert';
import 'package:clean_architecture_tdd_course/core/platform/network_info.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_course/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dartz/dartz.dart';

import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl repository;
  MockRemoteDataSource remoteDataSource;
  MockLocalDataSource localDataSource;
  MockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    localDataSource = MockLocalDataSource();
    networkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel(number: tNumber, text: "test trivia");
    final NumberTrivia tNumberTrivia = tNumberTriviaModel; //cast to entity type

    test('should check if the device is online', () async {
      // arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // act
      repository.getConcreteNumberTrivia(1);
      // assert
      verify(networkInfo.isConnected);
    });

    group('device is online', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      //repository should return remote data

      test(
          'should return remote data when the call to remote data source is succesful',
          () async {
        // arrange
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        // act
        final result = await repository.getConcreteNumberTrivia(tNumber);
        // assert
        // repo returns actual entity
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(
            result,
            equals(Right(
                tNumberTrivia))); //we can omit equals here, but prefer to put it
      });

      test(
          'should cache the data locally when the call to remote data source is successful',
          () async {
        // arrange
        when(remoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);

        // act
        await repository.getConcreteNumberTrivia(tNumber);
        // assert
        // repo returns actual entity
        verify(remoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(localDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
    });

    group('device is offline', () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
    });
  });
}
