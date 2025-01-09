import 'package:flutter/material.dart';
import 'package:taxhavistan/screens/globe_widget.dart';
import 'package:taxhavistan/services/wallet_services.dart';
import 'package:taxhavistan/widgets/app_bar.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
import 'package:taxhavistan/widgets/footer.dart';
import 'package:go_router/go_router.dart';

class MapToggleScreen extends StatefulWidget {
  const MapToggleScreen({super.key});

  @override
  State<MapToggleScreen> createState() => _MapToggleScreenState();
}

class _MapToggleScreenState extends State<MapToggleScreen> {
  final WalletService _walletService = WalletService();

  String _status = "Not connected";
  String _publicKey = "";
  double _solBalance = 0.0;
  double _tokenBalance = 0.0;

  Future<void> connectWallet() async {
    setState(() {
      _status = "Connecting...";
    });

    try {
      String mintAddress = "ED5nyyWEzpPPiWimP8vYm7sD7TD3LAt3Q3gRTWHzPJBY";
      // Attempt to connect the wallet
      final publicKey = await _walletService.connectWallet();
      final solBalance = await _walletService.getSolBalance(publicKey);
      final tokenBalance =
          await _walletService.getTokenBalance(publicKey, mintAddress);

      // Update state and navigate after the state is updated
      if (!mounted) return; // Safeguard against widget unmounting
      setState(() {
        _publicKey = publicKey;
        _solBalance = solBalance;
        _tokenBalance = tokenBalance;
        _status = "Connected!";
      });

      context.go('/map',
          extra: {'publicKey': _publicKey, 'tokenBalance': tokenBalance});

      print("Public Key: $_publicKey");
      print("Sol Balance: $_solBalance");
      print("Moo Deng Balance: $_tokenBalance");
    } catch (e) {
      if (!mounted) return; // Safeguard against widget unmounting
      setState(() {
        _status = "You don't have Phantom wallet installed!";
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
              zoomIn: 13,
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
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      _status == "Not connected"
                          ? "You need to connect to your wallet first."
                          : _status,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        fontFamily: "Audiowide",
                        color: Colors.white70,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                CustomButton(
                  svgPath: "assets/Phantom.svg",
                  color: const Color(0xFF86b9e1),
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
