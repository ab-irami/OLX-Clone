import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .25,
        color: Colors.cyan,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10.0,
                        ),
                        const Text(
                          'CARS',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        SizedBox(
                          height: 45.0,
                          child: DefaultTextStyle(
                            style: const TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Lato'
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                FadeAnimatedText(
                                  'Reach 10 Lakh+\nInterested buyers',
                                  duration: const Duration(
                                    seconds: 4,
                                  ),
                                ),
                                FadeAnimatedText(
                                  'New way to\nBuy or sell cars',
                                  duration: const Duration(
                                    seconds: 4,
                                  ),
                                ),
                                FadeAnimatedText(
                                  'Over 1 Lakh\nCars to Buy',
                                  duration: const Duration(
                                    seconds: 4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Neumorphic(
                      style: const NeumorphicStyle(
                        color: Colors.white,
                        oppositeShadowLightSource: true,                        
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                            'https://firebasestorage.googleapis.com/v0/b/ecom-app-88ef0.appspot.com/o/banner%2Ficons8-car-100.png?alt=media&token=3582749e-c0fc-48ac-b90c-53cabaab28e0'),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: () {},
                      style: const NeumorphicStyle(
                        color: Colors.white,
                      ),
                      child: const Text(
                        'Buy Car',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: NeumorphicButton(
                      onPressed: () {},
                      style: const NeumorphicStyle(
                        color: Colors.white,
                      ),
                      child: const Text(
                        'Sell Car',
                        textAlign: TextAlign.center,
                      ),
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
}