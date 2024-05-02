import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Event
abstract class LoanEvent {}

class CalculateRepayment extends LoanEvent {
  final double amount;
  final int tenure;
  final double rate;

  CalculateRepayment(this.amount, this.tenure, this.rate);
}

// State
class LoanState {
  final double repaymentAmount;

  LoanState(this.repaymentAmount);
}

// Bloc
class LoanBloc extends Bloc<LoanEvent, LoanState> {
  LoanBloc() : super(LoanState(0.0));

  @override
  Stream<LoanState> mapEventToState(LoanEvent event) async* {
    if (event is CalculateRepayment) {
      double emi =
          (event.amount * event.rate * pow(1 + event.rate, event.tenure)) /
              (pow(1 + event.rate, event.tenure) - 1);
      double totalAmount = emi * event.tenure;
      yield LoanState(totalAmount);
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();
  final TextEditingController rateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoanBloc(),
      child: BlocBuilder<LoanBloc, LoanState>(
        builder: (context, state) {
          double principleAmount = 0.0;
          if (amountController.text.isNotEmpty) {
            principleAmount = double.parse(amountController.text);
          }

          return Scaffold(
            appBar: AppBar(
              title: const Text("Loan Calculator"),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Principle Amount: ${amountController.text}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Interest Amount: ${(state.repaymentAmount - principleAmount).toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Monthly Home Loan EMI: ${(state.repaymentAmount / 12).toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      state.repaymentAmount.toString().isEmpty
                          ? "Repayment Amount: 0"
                          : "Repayment Amount: ${state.repaymentAmount.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Loan Amount',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: tenureController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Tenure(in years)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: rateController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Interest Rate (%)',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 0, 47, 255),
                      ),
                      onPressed: () {
                        context.read<LoanBloc>().add(
                              CalculateRepayment(
                                double.parse(amountController.text),
                                int.parse(tenureController.text) * 12,
                                double.parse(rateController.text) / 12 / 100,
                              ),
                            );
                      },
                      child: const Text(
                        "Calculate",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
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
