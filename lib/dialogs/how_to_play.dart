import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HowToPlay extends StatefulWidget {
  const HowToPlay({super.key});

  @override
  State<HowToPlay> createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.55;
    final height = MediaQuery.of(context).size.height * 0.8;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: width,
        height: height,
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
                                  "Taxhavistan",
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
                                          Text(
                                            "This is how to play",
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
