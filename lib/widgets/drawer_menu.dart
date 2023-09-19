import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// プライバシーポリシー、利用規約、ヘルプ＆サポートのURLを定義します（お好きなURLを配置してください）。
final Uri policyUrl = Uri.parse('https://');

final Uri ruleUrl = Uri.parse('https://');

final Uri helpUrl = Uri.parse('https://docs.google.com');

// DrawerMenuウィジェットを定義します。
class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  Widget build(BuildContext context) {
    // ドロワーメニューを作成します。
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ドロワーヘッダー部分
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // アプリのロゴ（お好きなロゴを配置してください）
                Icon(
                  Icons.chat_bubble_outline,
                  color: Theme.of(context).colorScheme.onSecondary,
                  size: 40,
                ),
                const SizedBox(height: 4),
                // アプリ名
                Text(
                  'AIChats',
                  style: TextStyle(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                // AIの情報
                Text(
                  'Powered by ChatGPT',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context)
                        .colorScheme
                        .onSecondary
                        .withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          // アプリをシェアするリストタイル
          ListTile(
            leading: const Icon(Icons.share_outlined),
            title: const Text('アプリをシェアする'),
            onTap: () {
              Navigator.pop(context);
              _shareApp();
            },
          ),
          // プライバシーポリシーのリストタイル
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('プライバシーポリシー'),
            onTap: _launchPolicyUrl,
          ),
          // 利用規約のリストタイル
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('利用規約'),
            onTap: _launchRuleUrl,
          ),
          const Divider(),
          // ヘルプ＆サポートのリストタイル
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: const Text('ヘルプ＆サポート'),
            onTap: _launchHelpUrl,
          ),
        ],
      ),
    );
  }

  // アプリをシェアするための関数
  void _shareApp() async {
    await Share.share(
      'AIChatsで最先端のAIとチャットしよう！日常のタスクや質問をサポートします。人工知能の力で快適な日々を過ごしましょう！ https://onl.bz/3tQXG7k',
    );
  }

  // プライバシーポリシーのURLを開くための関数
  Future<void> _launchPolicyUrl() async {
    if (!await launchUrl(policyUrl)) {
      throw Exception('無効なURLです。');
    }
  }

  // 利用規約のURLを開くための関数
  Future<void> _launchRuleUrl() async {
    if (!await launchUrl(ruleUrl)) {
      throw Exception('無効なURLです。');
    }
  }

  // ヘルプ＆サポートのURLを開くための関数
  Future<void> _launchHelpUrl() async {
    if (!await launchUrl(helpUrl)) {
      throw Exception('無効なURLです。');
    }
  }
}
