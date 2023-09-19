import 'package:ai_chat_app/providers/active_theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyAppBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  // scaffoldKeyを渡すことで、MyAppBarからScaffoldの状態にアクセスできるようにしています。
  final GlobalKey<ScaffoldState> scaffoldKey;

  // コンストラクタ
  const MyAppBar({required this.scaffoldKey, super.key});

  // createStateメソッドをオーバーライドし、_MyAppBarStateを返します。
  @override
  ConsumerState<MyAppBar> createState() => _MyAppBarState();

  // preferredSizeプロパティをオーバーライドし、サイズを定義します。
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// _MyAppBarStateはConsumerStateを継承しています。
class _MyAppBarState extends ConsumerState<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    // AppBarウィジェットを構築します。
    return AppBar(
      // メニューボタンを追加し、タップされたときにドロワーを開くように設定します。
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () => widget.scaffoldKey.currentState?.openDrawer(),
      ),
      // タイトルを設定します。
      title: Text(
        'AIChats',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      // タイトルを中央に配置します。
      centerTitle: true,
      // 右側のアクションボタンを追加します。
      actions: [
        // テーマ切り替えボタンを追加します。
        IconButton(
          icon: Icon(
            // 現在のテーマに応じてアイコンを変更します。
            ref.watch(activeThemeProvider) == Themes.dark
                ? Icons.brightness_4
                : Icons.brightness_7,
          ),
          // ボタンがタップされたときの処理です。新しいテーマを適用します。
          onPressed: () async {
            Themes newTheme = ref.read(activeThemeProvider) == Themes.dark
                ? Themes.light
                : Themes.dark;
            ref.read(activeThemeProvider.notifier).state = newTheme;
          },
        ),
      ],
    );
  }
}
