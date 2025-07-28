import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/services.dart';
import '../../../../widgets/common/webview.dart';
import '../../models/authentication_model.dart';

class VendorChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = context.read<VendorAdminAuthenticationModel>().user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('صفحة سحب الاموال'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet), // Wallet icon
            onPressed: () {
              _navigateToWithdrawScreen(context);
            },
          ),
        ],
      ),
      body: const Center(
        child: Icon(
          CupertinoIcons.money_dollar_circle,
          color: Colors.green,
          key: Key('chatListTab'),
          size: 100,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _navigateToWithdrawScreen(context);
        },
        icon: const Icon(Icons.money,color: Colors.white,), // Money icon
        label: const Text('Withdraw',style: TextStyle(color: Colors.white),),
      ),
    );
  }

  void _navigateToWithdrawScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WithdrawWebViewScreen(),
      ),
    );
  }
}

// Separate WebView Screen
class WithdrawWebViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
        'https://moreh.app/dashboard/withdraw/',
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(Icons.arrow_back_ios),
          ),
          title: const Text('صفحة سحب الاموال'),
        ),
      ),
    );
  }
}
