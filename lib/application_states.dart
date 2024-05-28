import 'interfaces.dart';

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

extension DefaultState<E, S> on ListenableAtom<AtomAppState<E, S>> {
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

extension TypedListenableAtomAppState<L, R>
    on ListenableAtom<AtomAppState<L, R>> {
  bool get isLoading => value.isLoading();
  bool get isSuccess => value.isSuccess();
  bool get isError => value.isLoading();
  bool get isInitial => value.isInitial();

  LoadingState<L, R> asLoading() => (value as LoadingState<L, R>);
  SuccessState<L, R> asSuccess() => (value as SuccessState<L, R>);
  ErrorState<L, R> asError() => (value as ErrorState<L, R>);
}

extension TypedState<L, R> on AtomAppState<L, R> {
  SuccessState<L, R> asSuccess() => (this as SuccessState<L, R>);
  ErrorState<L, R> asError() => (this as ErrorState<L, R>);
  LoadingState<L, R> asLoading() => (this as LoadingState<L, R>);

  bool isSuccess() => (this is SuccessState<L, R>);
  bool isError() => (this is ErrorState<L, R>);
  bool isLoading() => (this is LoadingState<L, R>);
  bool isInitial() => (this is InitialState<L, R>);
}
