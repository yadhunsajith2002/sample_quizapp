import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_app/models/questions.dart';
import 'package:quiz_app/screens/result_screen.dart';
import 'package:quiz_app/widgets/answer_card.dart';
import 'package:quiz_app/widgets/next_button.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int? selectedAnswerIndex;
  int questionIndex = 0;
  int score = 0;

  void pickAnswer(int value) {
    selectedAnswerIndex = value;

    if (selectedAnswerIndex == questions[questionIndex].correctAnswerIndex) {
      score++;
    }
    setState(() {});
  }

  void goToNextQuestion() {
    if (questionIndex < questions.length - 1) {
      questionIndex++;
      selectedAnswerIndex = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[questionIndex];
    bool isLastQuestion = questionIndex == questions.length - 1;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.5), Colors.white])),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: 150,
                width: 350,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      question.question,
                      style: const TextStyle(fontSize: 21, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Stack(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: question.options.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: selectedAnswerIndex == null
                            ? () => pickAnswer(index)
                            : null,
                        child: AnswerCard(
                          currentIndex: index,
                          question: question.options[index],
                          isSelected: selectedAnswerIndex == index,
                          selectedAnswerIndex: selectedAnswerIndex,
                          correctAnswerIndex: question.correctAnswerIndex,
                        ),
                      );
                    },
                  ),
                  selectedAnswerIndex == question.correctAnswerIndex
                      ? Positioned(
                          right: 100,
                          top: 100,
                          bottom: 100,
                          child: Lottie.asset("assets/animation_ln065erc.json"))
                      : SizedBox()
                ],
              ),
              isLastQuestion
                  ? RectangularButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) => ResultScreen(
                              score: score,
                            ),
                          ),
                        );
                      },
                      label: 'Finish',
                    )
                  : RectangularButton(
                      onPressed:
                          selectedAnswerIndex != null ? goToNextQuestion : null,
                      label: 'Next',
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
