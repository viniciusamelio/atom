import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'interfaces.dart';
import 'types.dart';

class GetxAtomNotifier<T> implements ListenableAtom<T> {
  GetxAtomNotifier(T value) : _rx = Rx(value);

  final Rx<T> _rx;

  @override
  void addListener(VoidCallback listener) {
    _rx.listen((p0) {
      listener();
    });
  }

  @override
  void dispose() {
    _rx.close();
  }

  @override
  void listen(AtomListener<T> listener) {
    _rx.listen(listener);
  }

  @override
  void on<E extends T>(AtomListener<E> listener) {
    _rx.listen((value) {
      if (value is E) {
        listener(value);
      }
    });
  }

  @override
  void removeListener(VoidCallback listener) {
    _rx.close();
  }

  @override
  void removeListeners() {
    _rx.close();
  }

  @override
  void set(T value) {
    _rx.value = value;
  }

  @override
  T get value => _rx.value;
}

class AtomNotifier<T> extends ValueNotifier<T> implements ListenableAtom<T> {
  AtomNotifier(T value) : super(value);
  final List<VoidCallback> _listeners = <VoidCallback>[];
  bool _disposed = false;
  @override
  void set(T value) {
    if (_disposed) return;
    this.value = value;
  }

  @override
  void listen(AtomListener<T> listener) {
    callback() {
      listener(value);
    }

    super.addListener(callback);
    _listeners.add(callback);
  }

  @override
  void on<E extends T>(AtomListener<E> listener) {
    callback() {
      if (value is E) {
        listener((value as E));
      }
    }

    super.addListener(callback);
    _listeners.add(callback);
  }

  @override
  void removeListeners() {
    for (var callback in _listeners) {
      super.removeListener(callback);
    }
  }

  @override
  void dispose() {
    _disposed = true;
    removeListeners();
    super.dispose();
  }
}

class AtomObserver<T> extends StatelessWidget {
  const AtomObserver({
    super.key,
    required this.atom,
    required this.builder,
  });
  final ListenableAtom<T> atom;
  final AtomBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: atom,
      builder: (context, state, _) => builder(context, state),
    );
  }
}

class MultiAtomObserver extends StatelessWidget {
  const MultiAtomObserver({
    super.key,
    required this.atoms,
    required this.builder,
  });
  final List<ListenableAtom> atoms;
  final Widget Function(BuildContext context) builder;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(atoms),
      builder: (context, widget) => builder(context),
    );
  }
}

typedef TypedAtomBuilder<T> = Widget Function(BuildContext context, T state);

class TypedAtomHandler<T> {
  const TypedAtomHandler({
    required this.builder,
  });

  final TypedAtomBuilder builder;
  Type get type => T;
}

class PolymorphicAtomObserver<T> extends StatelessWidget {
  /// It rebuilds according to mapped atom types
  const PolymorphicAtomObserver({
    super.key,
    this.defaultBuilder,
    required this.atom,
    required this.types,
  });

  /// Default widget to be used when current type is not handled
  final Widget Function(T? value)? defaultBuilder;
  final List<TypedAtomHandler<T>> types;
  final ListenableAtom<T> atom;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: atom,
      builder: (context, value, _) {
        for (var event in types) {
          if (event.type == value.runtimeType) {
            return event.builder(context, value);
          }
        }

        return defaultBuilder?.call(value) ?? const SizedBox.shrink();
      },
    );
  }
}
