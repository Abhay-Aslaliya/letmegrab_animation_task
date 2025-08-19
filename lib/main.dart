import 'package:flutter/material.dart';

class PageModel {
  final Color bgColor;
  final String first;
  final String? second;
  final String? third;

  PageModel({
    required this.bgColor,
    required this.first,
    this.second,
    this.third,
  });
}

class AnimatedPageView extends StatefulWidget {
  const AnimatedPageView({super.key});

  @override
  State<AnimatedPageView> createState() => _AnimatedPageViewState();
}

class _AnimatedPageViewState extends State<AnimatedPageView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _showBottom = false;

  final List<PageModel> pages = [
    PageModel(
      bgColor: Color(0xff28A765),
      first: "How much\nof my earnings\ndo I get to keep?",
      second: "100%.",
      third: "We charge zero commission on your sales.",
    ),
    PageModel(
      bgColor: Color(0xff2E86C1),
      first: "Will I get paid\non time,\nand is it safe?",
      second: "Always.",
      third: "Payments are secure and on-time,\nevery time.",
    ),
    PageModel(
      bgColor: Color(0xff8E44AD),
      first: "Can I reach more\ncustomers beyond\nmy area?",
      second: "Yes!",
      third: "We deliver to 20,000+ pin codes across India.",
    ),
    PageModel(
      bgColor: Color(0xffE67E22),
      first: "What if most of my\nsales happen offline?",
      second: "No Worries",
      third: "offline exposure is part of the plan.",
    ),
    PageModel(
      bgColor: Color(0xffE5524A),
      first: "How do I minimize\nreturns and losses?",
      second: "With us,",
      third: "you get fewer\nreturns and more profit.",
    ),
  ];

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) setState(() => _showBottom = true);
    });
    _startAutoScroll();
  }

  void _startAutoScroll() {
    Future.delayed(const Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % pages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
      _startAutoScroll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
            _showBottom = false;
          });
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              setState(() => _showBottom = true);
            }
          });
        },
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final m = pages[index];
          final bool isActive = index == _currentPage;
          final bool hasBottom = m.second != null || m.third != null;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            color: m.bgColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // First text (size + position animation)
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      offset: (hasBottom && isActive && _showBottom)
                          ? const Offset(0, -0.25)
                          : Offset.zero,
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        style: TextStyle(
                          fontSize: (hasBottom && isActive && _showBottom)
                              ? 26
                              : 32,
                          fontWeight: FontWeight.bold,
                          color: (hasBottom && isActive && _showBottom)
                              ? Colors.black
                              : Colors.white,
                        ),
                        child: Text(m.first),
                      ),
                    ),

                    if (hasBottom)
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: (isActive && _showBottom) ? 1 : 0,
                        child: AnimatedSlide(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          offset: (isActive && _showBottom)
                              ? Offset.zero
                              : const Offset(1.0, 0.3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (m.second != null)
                                Text(
                                  m.second!,
                                  style: const TextStyle(
                                    fontSize: 46,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              if (m.third != null) ...[
                                // const SizedBox(height: 8),
                                Text(
                                  m.third!,
                                  style: const TextStyle(
                                    height: 1.2,
                                    fontSize: 38,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnimatedPageView(),
    ),
  );
}
