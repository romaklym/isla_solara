import 'package:flutter/material.dart';
import 'package:taxhavistan/screens/globe_widget.dart';
import 'package:taxhavistan/screens/map_screen.dart';
import 'package:taxhavistan/services/wallet_services.dart';
import 'package:taxhavistan/widgets/app_bar.dart';
import 'package:taxhavistan/widgets/custom_button.dart';
import 'package:taxhavistan/widgets/footer.dart';

class MapToggleScreen extends StatefulWidget {
  const MapToggleScreen({super.key});

  @override
  State<MapToggleScreen> createState() => _MapToggleScreenState();
}

class _MapToggleScreenState extends State<MapToggleScreen> {
  bool _showMap = false;
  final WalletService _walletService = WalletService();

  String _status = "Not connected";
  String _publicKey = "";

  Future<void> connectWallet() async {
    setState(() {
      _status = "Connecting...";
    });

    try {
      final publicKey = await _walletService.connectWallet();

      final solBalance = await _walletService.getSolBalance(publicKey);

      setState(() {
        _publicKey = publicKey;
        _status = "Connected!";
        _showMap = true; // Show the map on successful connection
      });

      print("Public Key: $_publicKey");
      print("Sol Balance: $solBalance");
    } catch (e) {
      setState(() {
        _status = "You don't have Phantom wallet installed!";
        _showMap = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_showMap) {
      // Show globe with button when not connected
      return Scaffold(
        body: Stack(
          children: [
            // Interactive Globe
            Center(
              child: GlobeWidget(
                zoomIn: 10.5,
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
                    color: Color(0xFF86b9e1),
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

    // Show the map if connected
    return Scaffold(
      body: MapScreen(
        publicKey: _publicKey,
        tokenBalance: 2.0,
      ),
    );
  }
}
