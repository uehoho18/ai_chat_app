import 'package:flutter/material.dart';

// ChatItemは、個々のチャットメッセージを表示するウィジェットです。
class ChatItem extends StatefulWidget {
  // メッセージの内容です。
  final String message;
  // 自分が送信したメッセージかどうかです。
  final bool isMe;
  // 入力中のアニメーションです。
  final Animation<double> typingAnimation;

  // 必要なプロパティを受け取るコンストラクタです。
  const ChatItem({
    Key? key,
    required this.message,
    required this.isMe,
    required this.typingAnimation,
  }) : super(key: key);

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  // 入力中のドットアニメーションを作成する関数です。
  Widget _buildColoredDot(int index, Animation<double> animation) {
    double animationValue = (animation.value * 3) - index;
    if (animationValue < 0) animationValue = 0;
    if (animationValue > 1) animationValue = 1;
    return Icon(
      Icons.circle,
      size: 10,
      color: Color.lerp(
        Theme.of(context).colorScheme.onSecondary,
        Colors.grey.shade600,
        animationValue,
      ),
    );
  }

  // チャットアイテムのレイアウトを構築します。
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // 左側にユーザーアイコンを表示します。
          if (!widget.isMe) ProfileContainer(isMe: widget.isMe),
          if (!widget.isMe) const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            decoration: BoxDecoration(
              color: widget.isMe
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey.shade800,
              borderRadius: BorderRadius.circular(12),
            ),
            // 入力中のアニメーション表示です。
            child: widget.message == '...'
                ? SizedBox(
                    width: 48,
                    height: 24,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(3, (index) {
                        return AnimatedBuilder(
                          animation: widget.typingAnimation,
                          builder: (context, child) {
                            return _buildColoredDot(
                              index,
                              widget.typingAnimation,
                            );
                          },
                        );
                      }),
                    ),
                  )
                : SelectableText(
                    widget.message,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
          ),
          // 右側にユーザーアイコンを表示します。
          if (widget.isMe) const SizedBox(width: 12),
          if (widget.isMe) ProfileContainer(isMe: widget.isMe),
        ],
      ),
    );
  }
}

// プロフィールアイコンを表示するウィジェットです。
class ProfileContainer extends StatelessWidget {
  // 自分のプロフィールかどうかを示すフラグです。
  final bool isMe;
  // コンストラクタでisMeを受け取ります。
  const ProfileContainer({
    Key? key,
    required this.isMe,
  }) : super(key: key);

  // ユーザーアイコンを表示するウィジェットです。
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        // isMeがtrueの場合、自分のアイコンに対して適用するスタイルです。
        color: isMe
            ? Theme.of(context).colorScheme.secondary
            : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isMe
          // isMeがtrueの場合、自分のアイコンを表示します（お好みのアイコンを配置してください）。
          ? Icon(
              Icons.face,
              color: Theme.of(context).colorScheme.onSecondary,
              size: 26,
            )
          // isMeがfalseの場合、AIのアイコンを表示します（お好みのアイコンを配置してください）。
          : Icon(
              Icons.android,
              color: Theme.of(context).colorScheme.onSecondary,
              size: 24,
            ),
    );
  }
}
