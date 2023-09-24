import 'package:ai_chat_app/models/chat_model.dart';
import 'package:ai_chat_app/providers/chats_provider.dart';
import 'package:ai_chat_app/services/ai_handler.dart';
import 'package:ai_chat_app/services/voice_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// TextAndVoiceFieldウィジェットは、ConsumerStatefulWidgetを継承します。
class TextAndVoiceField extends ConsumerStatefulWidget {
  const TextAndVoiceField({Key? key}) : super(key: key);

  @override
  ConsumerState<TextAndVoiceField> createState() => _TextAndVoiceFieldState();
}

// 列挙型で音声入力とテキスト入力の2つのモードを定義します。
enum InputMode {
  text,
  voice,
}

// _TextAndVoiceFieldStateはConsumerStateを継承し、TickerProviderStateMixinも使用しています。
class _TextAndVoiceFieldState extends ConsumerState<TextAndVoiceField>
    with TickerProviderStateMixin {
  // 入力モードを示すenumを定義します。
  InputMode _inputMode = InputMode.voice;
  // メッセージ入力用のTextEditingControllerを作成します。
  final _messageController = TextEditingController();
  // AIHandlerとVoiceHandlerをインスタンス化します。
  final AIHandler _openAI = AIHandler();
  final VoiceHandler voiceHandler = VoiceHandler();
  // 返信およびリスニング状態を管理するbool変数を定義します。
  var _isReplying = false;
  var _isListening = false;
  // 入力中のアニメーションを定義します。
  late AnimationController _typingAnimationController;
  late Animation<double> _typingAnimation;

  @override
  void initState() {
    // VoiceHandlerを初期化します。
    voiceHandler.initSpeech();
    // 入力中のアニメーションを設定します。
    _typingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _typingAnimation =
        Tween<double>(begin: 0, end: 1).animate(_typingAnimationController);
    super.initState();
  }

  @override
  void dispose() {
    // 各コントローラとハンドラを破棄します。
    _messageController.dispose();
    _typingAnimationController.dispose();
    _openAI.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Stackを使ってメッセージ入力欄と送信ボタンを重ねます。
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Row(
            children: [
              // TextFieldでメッセージ入力欄を作成します。
              Expanded(
                child: TextField(
                  minLines: 1,
                  maxLines: 4,
                  controller: _messageController,
                  onChanged: (value) {
                    value.isNotEmpty
                        ? setInputMode(InputMode.text)
                        : setInputMode(InputMode.voice);
                  },
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  decoration: InputDecoration(
                    hintText: 'メッセージを入力...',
                    hintStyle: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
            ],
          ),
        ),
        // ToggleButtonウィジェットを右下に配置します。
        Positioned(
          right: 0,
          bottom: 0,
          top: 0,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.15,
            height: MediaQuery.of(context).size.height * 0.08,
            child: ToggleButton(
              isListening: _isListening,
              isReplying: _isReplying,
              inputMode: _inputMode,
              sendTextMessage: () {
                final message = _messageController.text;
                _messageController.clear();
                sendTextMessage(message);
              },
              sendVoiceMessage: sendVoiceMessage,
            ),
          ),
        ),
      ],
    );
  }

// 入力モードを更新するメソッドを定義します。
  void setInputMode(InputMode inputMode) {
    setState(() {
      _inputMode = inputMode;
    });
  }

  // 音声メッセージを送信するメソッドを定義します。
  void sendVoiceMessage() async {
    if (!voiceHandler.isEnabled) {
      return;
    }
    if (voiceHandler.speechToText.isListening) {
      await voiceHandler.stopListening();
      setListeningState(false);
    } else {
      setListeningState(true);
      final result = await voiceHandler.startListening();
      setListeningState(false);
      sendTextMessage(result);
    }
  }

  // テキストメッセージを送信するメソッドを定義します。
  void sendTextMessage(String message) async {
    setReplyingState(true);
    addToChatList(message, true, DateTime.now().toString());
    addToChatList('...', false, 'typing');
    setInputMode(InputMode.voice);
    final aiResponse = await _openAI.getResponse(message);
    removeTyping();
    addToChatList(aiResponse, false, DateTime.now().toString());
    setReplyingState(false);
  }

  // 返信状態を更新するメソッドを定義します。
  void setReplyingState(bool isReplying) {
    setState(() {
      _isReplying = isReplying;
    });
  }

  // リスニング状態を更新するメソッドを定義します。
  void setListeningState(bool isListening) {
    setState(() {
      _isListening = isListening;
    });
  }

  // チャットリストから入力中のアイテムを削除するメソッドを定義します。
  void removeTyping() {
    final chats = ref.read(chatsProvider.notifier);
    chats.removeTyping();
  }

  // チャットリストに新しいアイテムを追加するメソッドを定義します。
  void addToChatList(String message, bool isMe, String id) {
    final chats = ref.read(chatsProvider.notifier);
    chats.add(ChatModel(
      id: id,
      message: message,
      isMe: isMe,
      typingAnimation: _typingAnimation,
    ));
  }
}
