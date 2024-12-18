import 'package:bloc/bloc.dart';
import 'package:bloc_suite/bloc_suite.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';


// Mock classes
class MockLogger extends Mock implements Logger {}

class MockBloc extends Mock implements Bloc {}

void main() {
  late MockLogger mockLogger;
  late FlutterBlocObserver observer;
  late MockBloc mockBloc;

  setUp(() {
    mockLogger = MockLogger();
    mockBloc = MockBloc();
    observer = FlutterBlocObserver(logger: mockLogger);
  });

  group('FlutterBlocObserver', () {
    test('logs event when printEvents is enabled', () {
      final event = 'TestEvent';
      observer.onEvent(mockBloc, event);

      verify(() => mockLogger.i(any())).called(1);
    });

    test('does not log event when printEvents is disabled', () {
      observer = FlutterBlocObserver(logger: mockLogger, printEvents: false);

      observer.onEvent(mockBloc, 'TestEvent');
      verifyNever(() => mockLogger.i(any()));
    });

    test('logs transition when printTransitions is enabled', () {
      final transition = Transition(
        currentState: 'StateA',
        event: 'EventA',
        nextState: 'StateB',
      );

      observer.onTransition(mockBloc, transition);
      verify(() => mockLogger.i(any())).called(1);
    });

    test('does not log transition when printTransitions is disabled', () {
      observer = FlutterBlocObserver(logger: mockLogger, printTransitions: false);

      final transition = Transition(
        currentState: 'StateA',
        event: 'EventA',
        nextState: 'StateB',
      );

      observer.onTransition(mockBloc, transition);
      verifyNever(() => mockLogger.i(any()));
    });

    test('logs error with stack trace', () {
      final error = Exception('Test error');
      final stackTrace = StackTrace.current;

      observer.onError(mockBloc, error, stackTrace);
      verify(() => mockLogger.e(any(), error: error, stackTrace: stackTrace)).called(1);
    });

    test('logs creation when printCreations is enabled', () {
      observer = FlutterBlocObserver(logger: mockLogger, printCreations: true);

      observer.onCreate(mockBloc);
      verify(() => mockLogger.i(any())).called(1);
    });

    test('does not log creation when printCreations is disabled', () {
      observer = FlutterBlocObserver(logger: mockLogger, printCreations: false);
      observer.onCreate(mockBloc);
      verifyNever(() => mockLogger.i(any()));
    });

    test('logs closing when printClosings is enabled', () {
      observer = FlutterBlocObserver(logger: mockLogger, printClosings: true);

      observer.onClose(mockBloc);
      verify(() => mockLogger.i(any())).called(1);
    });

    test('does not log closing when printClosings is disabled', () {
      observer = FlutterBlocObserver(logger: mockLogger, printClosings: false);

      observer.onClose(mockBloc);
      verifyNever(() => mockLogger.i(any()));
    });

    test('respects transitionFilter', () {
      observer = FlutterBlocObserver(
        logger: mockLogger,
        transitionFilter: (bloc, transition) => false,
      );

      final transition = Transition(
        currentState: 'StateA',
        event: 'EventA',
        nextState: 'StateB',
      );

      observer.onTransition(mockBloc, transition);
      verifyNever(() => mockLogger.i(any()));
    });

    test('respects eventFilter', () {
      observer = FlutterBlocObserver(
        logger: mockLogger,
        eventFilter: (bloc, event) => false,
      );

      observer.onEvent(mockBloc, 'TestEvent');
      verifyNever(() => mockLogger.i(any()));
    });
  });
}
