# Atom
An easy to use Flutter's Value Notifier wrapper with some sugar syntax. It provides a more friendly and semantic syntax for your project's state management.

## Getting started
Add atom as a dependency:

```yaml
    atom_notifier: 1.0.0
```

Or running following command on terminal:
```bash
    flutter pub add atom_notifier
```

Then you can import it
```dart
    import 'package:atom_notifier/atom_notifier.dart';
```
## Atoms

An atom is a Value Notifier wrapper, which it means it holds a single value for each atom object, native or not.

```dart
final atom = AtomNotifier<int>(1);
```

Unlikely value notifiers atoms have different methods, but the same effect as expected, see in the examples below:

### Setting a value
```dart
// With ValueNotifier
final notifier = ValueNotifier(0);
notifier.value = 1;

// With Atom
final atom = AtomNotifier<int>(1);
atom.set(2);
```

### Setting Listeners
By default, listen() already get the atom value as an argument, so there's no need to get it with atom.value everytime you want to listen to changes
```dart
// With ValueNotifier
final notifier = ValueNotifier(0);
notifier.addListener((){
    final value = notifier.value;
    doSomething();
});

// With Atom
final atom = AtomNotifier<int>(1);
atom.listen((value){
    doSomething();
});
```

### Listening to specific state
```dart
// With ValueNotifier
final notifier = ValueNotifier(0);
notifier.addListener((){
    final value = notifier.value;
    if(value is MyType){
        doSomething();
    }
});

// With Atom
final atom = AtomNotifier<int>(1);
atom.on<MyType>((value){
    doSomething();
});
```

## Observers
Observer is a widget which rebuilds everytime your atom value changes.

### Observing a single atom
The most basic way to observe your state within a widget would be using AtomObserver.

```dart
    AtomObserver<int>(
        atom: counterAtom,
        builder: (context, state) {
          return Text(state.toString());
        },
    ); 
```

But, there will be cases where you have more complexes states, a async request status can be a good example, so, with value notifier you usually would need to check your state type and return a widget according to it, but with atom you can use PolymorphicAtomObserver
```dart
    abstract class FutureStatus{}
    class InitialState implements FutureStatus{}
    class LoadingState implements FutureStatus{}
    class SuccessState implements FutureStatus{}
    class ErrorState implements FutureStatus{}

    PolymorphicAtomObserver<FutureStatus>(
        atom: myAtom,
        defaultBuilder: (value) => const Text("Initial or Error"),
        types: [
          TypedAtomHandler(
            type: LoadingState,
            builder: (context, value) => const CircularProgressIndicator(),
          ),
          TypedAtomHandler(
            type: SuccessState,
            builder: (context, value) => const Text("Success, dude!"),
          ),
        ],
    );
```
### Observing multiple atoms at once
You can use MultiAtomObserver to handle more than one atom at once in the same widget, this way, everyime an atom inside atoms prop has it value changed it rebulds
```dart
    MultiAtomObserver(
        atoms: [index, character],
        builder: (context, state) {
          final name = character.value;
          final id = index.value;
          return Text("$id: $name");
        },
    ),
```

## Application States
Usually your controllers will have some kind of behaviour just like the example I showed on PolymorphicAtomObserver, where you want your UI to reflect the usecase/service/whatever status. You can use 
AtomAppState which by default has an extension that makes it easier to add listeners to it.

```dart
    final atom = AtomNotifier<AtomAppState<String, int>>(InitialState());
    atom.onState(
      onError: (e) => counter++,
      onSuccess: (e) => counter--,
      onLoading: () => counter = counter * 2,
    );
```