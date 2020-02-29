import 'package:flutter/material.dart';
import './answer.dart';
import './question.dart';

class Query extends StatelessWidget {
  
  final List<Map<String, Object>> details;
  final Function answerQuestion;
  final int listIndex;

  Query(this.answerQuestion, this.details, this.listIndex);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Question(
          details[listIndex]['question'],
        ),
        ...(details[listIndex]['answer'] as List<Map<String, Object>>)
            .map((ans) {
          return Answer(() => answerQuestion(ans['position']), ans['txt']);
        }).toList(),
      ],
    );
  }
}
