import 'package:flutter/material.dart';
import 'models.dart';

export 'dart:convert';
export 'package:flutter/material.dart';
export 'components.dart';
export 'api.dart';
export 'models.dart';

Route<Widget> buildRoute(Widget page) =>
    MaterialPageRoute(builder: (_) => Material(child: page));

typedef SelectBookCallback = void Function(ReadHistory);
