import 'package:flutter/material.dart';
import 'package:taxhavistan/screens/globe_widget.dart';
import 'package:taxhavistan/services/wallet_services.dart';
import 'package:taxhavistan/widgets/app_bar.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
import 'package:taxhavistan/widgets/footer.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final WalletService _walletService = WalletService();

  String _status = "Not connected";
  String _publicKey = "";
  double _tokenBalance = 0.0;

  Future<void> connectWallet() async {
    setState(() {
      _status = "Connecting...";
    });

    try {
      String mintAddress = "ED5nyyWEzpPPiWimP8vYm7sD7TD3LAt3Q3gRTWHzPJBY";
      // Attempt to connect the wallet
      final publicKey = await _walletService.connectWallet();
      final tokenBalance =
          await _walletService.getTokenBalance(publicKey, mintAddress);

      // Update state and navigate after the state is updated
      if (!mounted) return; // Safeguard against widget unmounting
      setState(() {
        _publicKey = publicKey;
        _tokenBalance = tokenBalance;
        _status = "Connected!";
      });

      if (mounted) {
        context.go('/map',
            extra: {'publicKey': _publicKey, 'tokenBalance': _tokenBalance});
      }
    } catch (e) {
      setState(() {
        _status = "Failed to connect. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Interactive Globe
          Center(
            child: GlobeWidget(
              zoomIn: 12.5,
            ),
          ),
          CustomAppBar(),
          Footer(),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_status != "Connected!") // Show status if not connected
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _status == "Not connected"
                          ? "Claim your land to earn free \$TAX!"
                          : _status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 26.0,
                          fontFamily: "Audiowide",
                          color: Colors.amber,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
                CustomButton(
                  svgPath: "assets/Phantom.svg",
                  color: const Color(0xFFAB9FF2),
                  label: _status == "Connecting..."
                      ? 'Connecting...'
                      : 'Connect Wallet',
                  onTap: _status == "Connecting..." ? null : connectWallet,
                  fontSize: 16.0,
                  iconSize: 20.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
