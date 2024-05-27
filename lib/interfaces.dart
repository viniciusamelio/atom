import 'package:flutter/foundation.dart';

import 'notifier.dart';
import 'types.dart';

abstract class Atom<T> implements ValueListenable<T> {
  const Atom();

  @override
  T get value;

  /// Sets a given value for this atom
  void set(T value);
}

abstract class ListenableAtom<T> extends Atom<T> {
  const ListenableAtom();

  factory ListenableAtom.notifier(T value) => AtomNotifier(value);
  factory ListenableAtom.getxNotifier(T value) => GetxAtomNotifier(value);

  /// Adds a listener to the atom
  void listen(AtomListener<T> listener);

  void dispose();

  /// Adds a listener which executes when value is set as E
  void on<E extends T>(AtomListener<E> listener);

  // Clean all listeners
  void removeListeners();
}
