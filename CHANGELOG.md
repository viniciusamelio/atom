## 1.4.0
- Changed AtomNotifier class to extended from value notifier instead of controlling it over a private argument

## 1.3.0
- Added debounce method to ListenableAtom

## 1.2.0
- Added GetxAtomNotifier class
- Added notifier() and getxNotifier() factories to ListenableAtom
## 1.1.0
- Added TypedState extension, to get & check atom app stats easier than before
- BREAKING CHANGE: set() method to listen() on [AtomInputController] 
- BREAKING CHANGE: removing type property from [TypedAtomHandler]. You should be able now to set the state type with generics
## 1.0.4
- Added AtomInputController which extends TextEditingController

## 1.0.3
- Changed: Making Atom an Listenable by implementing ValueListenable<T>

## 1.0.1
- Fix: Removed unexisting state parameter reference from MultiAtomObserver
- Added removeListeners() to AtomNotifier, which is meant to remove all listeners

## 1.0.0
- Added default reactive components
- Added default application states