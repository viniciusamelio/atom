import 'package:flutter/material.dart';

import 'types.dart';

abstract class Atom<T> implements Listenable {
  const Atom();

  T get value;

  /// Sets a given value for this atom
  void set(T value);
}

abstract class ListenableAtom<T> extends Atom<T> {
  const ListenableAtom();

  /// Adds a listener to the atom
  void listen(AtomListener<T> listener);

  void dispose();

  /// Adds a listener which executes whee value is set as E
  void on<E extends T>(AtomListener<E> listener);

  // Clean all listeners
  void removeListeners();
}
