import 'dart:async';
import 'dart:convert';
import 'dart:js' as js;
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class WalletService {
  String _publicKey = "";

  String get publicKey => _publicKey;

  Future<String> connectWallet() async {
    final solana = js.context['solana'];
    if (solana == null || solana['isPhantom'] != true) {
      throw Exception("Phantom wallet not found!");
    }

    final promise = solana.callMethod('request', [
      js.JsObject.jsify({'method': 'connect'}),
    ]);

    if (promise == null) {
      throw Exception("Failed to connect to the wallet.");
    }

    // Await the promise and ensure successful execution
    await _jsPromiseToFuture(promise);

    // Retrieve the public key
    final publicKeyObj = solana['publicKey'];
    final pubKeyString = publicKeyObj?.callMethod('toString') ?? "";

    if (pubKeyString.isEmpty) {
      throw Exception("Failed to retrieve public key.");
    }

    _publicKey = pubKeyString;
    return pubKeyString;
  }

  Future<double> getTokenBalance(String publicKey, String mintAddress) async {
    // final url = "https://api.devnet.solana.com"; // Solana DevNet URL
    final url =
        "https://solana-mainnet.g.alchemy.com/v2/zjEU66LAtdq7zRGDCgzWlUxuPY1UW8KL";

    final request = {
      "jsonrpc": "2.0",
      "id": 1,
      "method": "getTokenAccountsByOwner",
      "params": [
        publicKey,
        {"mint": mintAddress}, // Filter by the specific token mint address
        {"encoding": "jsonParsed"}
      ]
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Extract token accounts
      final accounts = data['result']['value'];
      if (accounts == null || accounts.isEmpty) {
        // Return 0 if the token is not found
        return 0.0;
      }

      // Fetch token balance from the first account
      final tokenAmount =
          accounts[0]['account']['data']['parsed']['info']['tokenAmount'];

      // Convert balance to a human-readable format using decimals
      final balance = tokenAmount['uiAmount'] as double? ?? 0.0;
      return balance;
    } else {
      throw Exception('Failed to fetch token balance: ${response.body}');
    }
  }

  Future<double> getSolBalance(String publicKey) async {
    final url =
        "https://solana-mainnet.g.alchemy.com/v2/zjEU66LAtdq7zRGDCgzWlUxuPY1UW8KL";
    // final url = "https://api.devnet.solana.com";

    final request = {
      "jsonrpc": "2.0",
      "id": 1,
      "method": "getBalance",
      "params": [publicKey]
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final lamports = data['result']['value'] as int;
      return lamports / 1000000000;
    } else {
      throw Exception('Failed to fetch balance: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getTokenAccounts(String publicKey) async {
    // final url = "https://api.devnet.solana.com";
    final url =
        "https://solana-mainnet.g.alchemy.com/v2/zjEU66LAtdq7zRGDCgzWlUxuPY1UW8KL";

    final request = {
      "jsonrpc": "2.0",
      "id": 1,
      "method": "getTokenAccountsByOwner",
      "params": [
        publicKey,
        {"programId": "TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA"},
        {"encoding": "jsonParsed"}
      ]
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request),
    );

    // Log the full response
    print("Full Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List accounts = data['result']['value'];

      return accounts.map((account) {
        final info = account['account']['data']['parsed']['info'];
        final tokenAmount = info['tokenAmount'];
        return {
          "mint": info['mint'],
          "amount": tokenAmount['uiAmount'],
          "decimals": tokenAmount['decimals'],
        };
      }).toList();
    } else {
      throw Exception('Failed to fetch token accounts: ${response.body}');
    }
  }

  Future<dynamic> _jsPromiseToFuture(dynamic jsPromise) {
    final completer = Completer<dynamic>();
    jsPromise.callMethod('then', [
      js.allowInterop((result) => completer.complete(result)),
      js.allowInterop((error) => completer.completeError(error)),
    ]);
    return completer.future;
  }

  Future<bool> isWalletAvailable() async {
    // Simulate checking if Phantom wallet is available
    // Replace with actual implementation based on your wallet API
    return html.window.navigator.userAgent.contains('Phantom');
  }
}
