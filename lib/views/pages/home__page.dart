import 'package:flutter/material.dart';
import 'package:flutter_learning/data/constrants.dart';
import 'package:flutter_learning/views/pages/course_page.dart';

import 'package:flutter_learning/views/widgets/container_widget.dart';
import 'package:flutter_learning/views/widgets/hero_widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> list = [
      KValue.basicLayout,
      KValue.cleanUi,
      KValue.fixBugs,
      KValue.keyConcepts,
    ];
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            HeroWidgets(
              title: 'TrackIt',
              nextPage: CoursePage(),
            ),
            ...List.generate(list.length, (
              index,
            ) {
              return ContainerWidget(
                title: list.elementAt(index),
                description:
                    'the disciption of this',
              );
            }),
          ],
        ),
      ),
    );
  }
}
