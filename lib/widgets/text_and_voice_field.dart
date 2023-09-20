import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TextAndVoiceField extends ConsumerStatefulWidget {
  const TextAndVoiceField({Key? key}) : super(key: key);

  @override
  ConsumerState<TextAndVoiceField> createState() => _TextAndVoiceFieldState();
}

enum InputMode {
  text,
  voice,
}
