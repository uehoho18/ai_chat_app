import 'package:ai_chat_app/widgets/text_and_voice_field.dart';
import 'package:flutter/material.dart';

// ToggleButtonは、テキストメッセージを送信するか、音声メッセージを録音するかを切り替えるカスタムウィジェットです。
class ToggleButton extends StatefulWidget {
  final VoidCallback _sendTextMessage;
  final VoidCallback _sendVoiceMessage;
  final InputMode _inputMode;
  final bool _isReplying;
  final bool _isListening;

  // 以下のプロパティを引数として受け取ります。
  // - inputMode: ユーザーがテキストまたは音声入力モードを選択するためのInputMode
  // - sendTextMessage: テキストメッセージを送信するための関数
  // - sendVoiceMessage: 音声メッセージを送信するための関数
  // - isReplying: AIが返信中かどうかを示すブール値
  // - isListening: 音声入力がリスニング中かどうかを示すブール値
  const ToggleButton({
    Key? key,
    required InputMode inputMode,
    required VoidCallback sendTextMessage,
    required VoidCallback sendVoiceMessage,
    required bool isReplying,
    required bool isListening,
  })  : _inputMode = inputMode,
        _sendTextMessage = sendTextMessage,
        _sendVoiceMessage = sendVoiceMessage,
        _isReplying = isReplying,
        _isListening = isListening,
        super(key: key);

  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).colorScheme.onSecondary;
    final padding = MediaQuery.of(context).size.width * 0.025;

    // ElevatedButtonを使って、テキストまたは音声入力モードに応じて異なるアイコンを表示し、
    // それぞれのモードに対応する関数を実行できるようにします。
    // また、AIが返信中である場合、ボタンは無効化されます。
    return Stack(
      alignment: Alignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: widget._isReplying ? Colors.grey : iconColor,
            shape: const CircleBorder(),
            padding: EdgeInsets.all(padding),
          ),
          onPressed: widget._isReplying
              ? null
              : (widget._inputMode == InputMode.text
                  ? widget._sendTextMessage
                  : () {
                      widget._sendVoiceMessage();
                    }),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                if (widget._isListening)
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.4),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
              ],
            ),
            // テキスト入力モードの場合は、送信アイコン(Icons.send)を表示
            // 音声入力モードの場合は、音声入力がリスニング中であればマイクオフアイコン(Icons.mic_off)を表示し、
            // そうでなければマイクアイコン(Icons.mic)を表示します。
            child: Icon(
              widget._inputMode == InputMode.text
                  ? Icons.send
                  : widget._isListening
                      ? Icons.mic_off
                      : Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
