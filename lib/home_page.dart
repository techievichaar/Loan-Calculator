import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController amountController = TextEditingController();

  TextEditingController tenureController = TextEditingController();

  TextEditingController rateController = TextEditingController();

  double repaymentAmount = 0.0;

  void caclculateRepayment() {
    double amount = double.parse(amountController.text);
    int tenure =
        int.parse(tenureController.text) * 12; // Convert years to months
    double rate =
        double.parse(rateController.text) / 12 / 100; // Monthly interest rate

    double emi =
        (amount * rate * pow(1 + rate, tenure)) / (pow(1 + rate, tenure) - 1);
    double totalAmount = emi * tenure;

    double interest = repaymentAmount - double.parse(amountController.text);

    setState(() {
      repaymentAmount = totalAmount;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                textAlign: TextAlign.center,
                "Principle Amount: ${amountController.text}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                textAlign: TextAlign.center,
                "Intrest Amount: ${(repaymentAmount - double.parse(amountController.text)).toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                textAlign: TextAlign.center,
                "Monthly Home Loan EMI: ${(repaymentAmount / 12).toStringAsFixed(0)}",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                textAlign: TextAlign.center,
                repaymentAmount.toString().isEmpty
                    ? "Repayment Amount: 0"
                    : "Repayment Amount: ${repaymentAmount.toStringAsFixed(0)}",
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
                  labelText: 'Intrest Rate (%)',
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
                  caclculateRepayment();
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
  }
}
