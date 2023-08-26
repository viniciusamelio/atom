import 'notifier.dart';

/// A default application state. E represents an Error class and S represents a Success class
abstract class AtomAppState<E, S> {
  const AtomAppState();
}

class InitialState<E, S> extends AtomAppState<E, S> {}

class LoadingState<E, S> extends AtomAppState<E, S> {}

class SuccessState<E, S> extends AtomAppState<E, S> {
  const SuccessState(this.data);
  final S data;
}

class ErrorState<E, S> extends AtomAppState<E, S> {
  const ErrorState(this.error);
  final E error;
}

extension DefaultState<E, S> on AtomNotifier<AtomAppState<E, S>> {
  void fromSuccess(S data) => set(SuccessState(data));
  void fromError(E error) => set(ErrorState(error));

  void onState({
    void Function()? onInitial,
    void Function()? onLoading,
    void Function(S value)? onSuccess,
    void Function(E error)? onError,
  }) {
    if (onInitial != null) {
      on<InitialState<E, S>>((value) {
        onInitial();
      });
    }

    if (onLoading != null) {
      on<LoadingState<E, S>>((value) {
        onLoading();
      });
    }

    if (onSuccess != null) {
      on<SuccessState<E, S>>((value) {
        onSuccess(value.data);
      });
    }

    if (onError != null) {
      on<ErrorState<E, S>>((value) {
        onError(value.error);
      });
    }
  }
}
