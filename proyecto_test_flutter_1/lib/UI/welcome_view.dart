import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.white,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Image.asset('assets/people_drawing.jpg'),
      ),
      Center(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Opacity(
                opacity: 0.95,
                child: Card(
                  color: Colors.lightBlue.shade100,
                  child: Column(
                    children: [
                      const BoxRow(true),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                        child: Text(
                          'Bienvenid@ a la app de las relaciones',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.deliciousHandrawn(
                              fontSize: 30, fontWeight: FontWeight.w300),
                        ),
                      ),
                      const BoxRow(false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}

class BoxRow extends StatelessWidget {
  const BoxRow(this.firstColored, {super.key});

  final bool firstColored;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          15,
          (index) => SizedBox(
            width: 25,
            height: 25,
            child: (firstColored ? index.isEven : index.isOdd)
                ? Container(color: Colors.orange.shade400)
                : null,
          ),
        ),
      ),
    );
  }
}
