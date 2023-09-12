import 'package:ai_chat_app/models/chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatNotifier extends StateNotifier<List<ChatModel>> {
  ChatNotifier() : super([]);

  void add(ChatModel chat) {
    state = [...state, chat];
  }

  void remove(ChatModel chat) {
    state = state.where((element) => element.id != chat.id).toList();
  }
}

final chatsProvider = StateNotifierProvider<ChatNotifier, List<ChatModel>>(
  (ref) => ChatNotifier(),
);
