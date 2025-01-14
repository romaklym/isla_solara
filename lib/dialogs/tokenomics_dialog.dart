import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taxhavistan/widgets/custom_button.dart';

class Tokenomics extends StatefulWidget {
  const Tokenomics({super.key});

  @override
  State<Tokenomics> createState() => _TokenomicsState();
}

class _TokenomicsState extends State<Tokenomics> {
  final PageController _pageController = PageController();
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: 850,
        height: 600,
        decoration: BoxDecoration(
          color: const Color(0xFF86b9e1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF704214),
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
                        // Audiowideht Page with PageView
                        Expanded(
                          flex: 1,
                          child: PageView(
                            controller: _pageController,
                            children: [
                              // Page 1: Tokenomics
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Total \$LAND Supply:",
                                      style: const TextStyle(
                                        fontFamily: "Audiowide",
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 8),
                                    CustomButton(
                                      label: "3,025,000,000 \$LAND",
                                      icon: FontAwesomeIcons.coins,
                                      onTap: () {},
                                      color: const Color(0xFFFFC978),
                                      fontSize: 16.0,
                                      iconSize: 20.0,
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: PieChart(
                                              PieChartData(
                                                pieTouchData: PieTouchData(
                                                  touchCallback:
                                                      (event, response) {
                                                    setState(() {
                                                      if (!event
                                                              .isInterestedForInteractions ||
                                                          response == null ||
                                                          response.touchedSection ==
                                                              null) {
                                                        touchedIndex = -1;
                                                        return;
                                                      }
                                                      touchedIndex = response
                                                          .touchedSection!
                                                          .touchedSectionIndex;
                                                    });
                                                  },
                                                ),
                                                sectionsSpace: 0,
                                                centerSpaceRadius: 40,
                                                sections: _showingSections(),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Indicator(
                                                color: Color(0xFFB8D6A1),
                                                text: "Liquidity",
                                                isSquare: true,
                                              ),
                                              SizedBox(height: 8),
                                              Indicator(
                                                color: Color(0xFF957BBA),
                                                text: "Team & Dev",
                                                isSquare: true,
                                              ),
                                              SizedBox(height: 8),
                                              Indicator(
                                                color: Color(0xFFE88799),
                                                text: "Marketing",
                                                isSquare: true,
                                              ),
                                              SizedBox(height: 8),
                                              Indicator(
                                                color: Color(0xFFF4CF90),
                                                text: "Community",
                                                isSquare: true,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
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
                                    ),
                                  ],
                                ),
                              ),
                              // Page 2: Lore
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            "The Tale of Isla Solara",
                                            style: const TextStyle(
                                              fontFamily: "Audiowide",
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white70,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            "Far in the heart of the vast Southern Ocean lies Isla Solara—a paradise where freedom, opportunity, and wealth belong to all who seek it.\n\nIsla Solara is a nation without borders, where every citizen shares in the prosperity of its vast resources and groundbreaking economy. With \$LAND tokens, you gain citizenship, land ownership, and the chance to shape this digital utopia.",
                                            style: const TextStyle(
                                              fontFamily: "Audiowide",
                                              fontSize: 16,
                                              color: Colors.white70,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            "Earn passive income from resource wealth, claim your share of the island, and join a global community united by freedom and opportunity. Welcome to the future!",
                                            style: const TextStyle(
                                              fontFamily: "Audiowide",
                                              fontSize: 16,
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
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    return List.generate(4, (index) {
      final isTouched = index == touchedIndex;
      final fontSize = isTouched ? 18.0 : 12.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black54, blurRadius: 2)];
      switch (index) {
        case 0:
          return PieChartSectionData(
            color: Color(0xFFB8D6A1),
            value: 10,
            title: "10%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              shadows: shadows,
              fontFamily: "Audiowide",
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xFF957BBA),
            value: 10,
            title: "10%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              shadows: shadows,
              fontFamily: "Audiowide",
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Color(0xFFE88799),
            value: 5,
            title: "5%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              shadows: shadows,
              fontFamily: "Audiowide",
            ),
          );
        case 3:
          return PieChartSectionData(
            color: Color(0xFFF4CF90),
            value: 75,
            title: "75%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
              shadows: shadows,
              fontFamily: "Audiowide",
            ),
          );
        default:
          throw Error();
      }
    });
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    required this.color,
    required this.text,
    required this.isSquare,
    super.key,
  });

  final Color color;
  final String text;
  final bool isSquare;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: isSquare ? 16 : 16,
          height: isSquare ? 16 : 16,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontFamily: "Audiowide",
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
