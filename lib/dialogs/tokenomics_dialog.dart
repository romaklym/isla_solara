import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:taxhavistan/widgets/copy_text.dart';

class Tokenomics extends StatefulWidget {
  const Tokenomics({super.key});

  @override
  State<Tokenomics> createState() => _TokenomicsState();
}

class _TokenomicsState extends State<Tokenomics> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: 850,
        height: 600,
        decoration: BoxDecoration(
          color: const Color(0xFF86b9e1), // Blue passport color
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF704214), // Retro brown color
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF704214),
              offset: const Offset(-9, 9),
              blurRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Column(
                children: [
                  // Content Area
                  Expanded(
                    child: Row(
                      children: [
                        // Left Page
                        Expanded(
                          flex: 1,
                          child: Container(
                            color: Colors.transparent,
                            padding: const EdgeInsets.symmetric(
                              vertical: 32.0,
                              horizontal: 16.0,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Passport",
                                  style: const TextStyle(
                                    fontFamily: "Audiowide",
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                                FaIcon(
                                  FontAwesomeIcons.passport,
                                  size: 150,
                                  color: Colors.white70,
                                ),
                                Text(
                                  "Isla Solara",
                                  style: const TextStyle(
                                    fontFamily: "Audiowide",
                                    fontSize: 20,
                                    color: Colors.white70,
                                  ),
                                ),
                                SvgPicture.asset(
                                  "assets/passport.svg",
                                  width: 50,
                                  height: 25,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white70,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Divider
                        Expanded(
                          flex: 0,
                          child: Container(
                            width: 2,
                            color: const Color(0xFF704214),
                          ),
                        ),
                        // Right Page with PageView
                        Expanded(
                          flex: 1,
                          child: PageView(
                            controller: _pageController,
                            children: [
                              // Page 1
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          CopyTextWidget(
                                            addressFontSize: 11.0,
                                            addressIconSize: 12.0,
                                            contWidth: 400,
                                            copyText:
                                                "0x532f27101965dd16442E59d40670FaF5eBB142E4",
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: IconButton(
                                        icon: const FaIcon(
                                          FontAwesomeIcons.chevronRight,
                                          size: 16,
                                          color: Colors.white70,
                                        ),
                                        onPressed: () {
                                          _pageController.nextPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              // Page 2
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Page 2 content here",
                                            style: const TextStyle(
                                              fontFamily: "Audiowide",
                                              fontSize: 14,
                                              color: Colors.white70,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: IconButton(
                                        icon: const FaIcon(
                                          FontAwesomeIcons.chevronLeft,
                                          size: 16,
                                          color: Colors.white70,
                                        ),
                                        onPressed: () {
                                          _pageController.previousPage(
                                            duration: const Duration(
                                                milliseconds: 300),
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Page Flip Button
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     IconButton(
                  //       icon: const Icon(
                  //         Icons.arrow_forward_ios,
                  //         size: 16,
                  //         color: Colors.white,
                  //       ),
                  //       onPressed: () {
                  //         if (_pageController.page == 0) {
                  //           _pageController.nextPage(
                  //             duration: const Duration(milliseconds: 300),
                  //             curve: Curves.easeInOut,
                  //           );
                  //         } else {
                  //           _pageController.previousPage(
                  //             duration: const Duration(milliseconds: 300),
                  //             curve: Curves.easeInOut,
                  //           );
                  //         }
                  //       },
                  //     ),
                  //   ],
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
