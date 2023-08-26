import 'package:flutter/widgets.dart';

typedef AtomListener<T> = void Function(T value);
typedef AtomBuilder<T> = Widget Function(BuildContext context, T value);
