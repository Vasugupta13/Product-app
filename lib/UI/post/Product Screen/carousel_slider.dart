import 'dart:async';
import 'package:flutter/material.dart';

class SliderBar extends StatefulWidget {
  const SliderBar({super.key});

  @override
  State<SliderBar> createState() => _SliderBarState();
}

class _SliderBarState extends State<SliderBar> {

List<String> images = [
  "img/1.png",
  "img/2.png",
  "img/3.png",
  "img/4.png",
  "img/5.png",
];

  late final PageController pageController;
  int pageNo = 0;
  Timer? carouselTimer ;

  Timer getTimer() {
    return Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        if (pageNo == 4) {
          pageNo = 0;
        }
        pageController.animateToPage(
          pageNo,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOutCirc,
        );
        pageNo++;
      },
    );
  }

  @override
  void initState() {
    carouselTimer = getTimer();
    pageController = PageController(initialPage: 0, viewportFraction: 0.85);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: pageController,
              itemCount: 5,
              onPageChanged: (index) {
                pageNo = index;
                setState(() {});
              },
              itemBuilder: (_, index) {
                return AnimatedBuilder(
                  animation: pageController,
                  builder: (ctx, child) {
                    return child!;
                  },
                  child: GestureDetector(
                    onTap:(){
                    },
                    onPanDown: (d){
                      carouselTimer?.cancel();
                      carouselTimer = null;
                    },
                    onPanCancel: (){
                      carouselTimer = getTimer();
                    },
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image(
                          height: 200,
                          width: double.infinity,
                          image: AssetImage(
                            images[index],
                          ),fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) => Container(
                margin: const EdgeInsets.all(2),
                child: Icon(
                  Icons.circle,
                  size: 12,
                  color: pageNo == index
                      ? Colors.deepPurple
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
