import 'dart:convert';

import 'package:bloc_test/bloc_test.dart';
import 'package:demo_app_bloc/bloc/postBloc/post_bloc.dart';
import 'package:demo_app_bloc/bloc/postBloc/post_event.dart';
import 'package:demo_app_bloc/bloc/postBloc/post_state.dart';
import 'package:demo_app_bloc/services/post_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostsService extends Mock implements PostService {}

void main() {
  late PostsBloc sut;
  late MockPostsService mockNewsService;
  // Initialize everything pertaining to your individual test.
  // setUp() method Runs before each and every test.
  setUp(() {
    // Do not introduce third party variables. Create a mock of the real instant of the Service.
    mockNewsService = MockPostsService();
    sut = PostsBloc(mockNewsService);
  });

  group("fetchPost", () {
    blocTest(
      'get posts using the PostService',
      build: () => sut,
      act: (PostsBloc bloc) => bloc.add(LoadPostEvent()),
      verify: ((_) {
        verify(() => mockNewsService.getPosts()).called(1);
      }),
    );

    blocTest(
      'emits [LoadingPostState(), LoadedPostState()] when post is fetched',
      build: () => sut,
      act: (PostsBloc bloc) => bloc.add(LoadPostEvent()),
      expect: () => [LoadingPostState(), const LoadedPostState()],
    );
  });
}
