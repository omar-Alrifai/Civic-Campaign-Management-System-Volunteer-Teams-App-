import 'package:flutter/material.dart';

class ConfirmationForm extends StatefulWidget {
  final void Function(String) onVerificationCodeEntered;

  const ConfirmationForm({required this.onVerificationCodeEntered, Key? key})
    : super(key: key);

  @override
  _ConfirmationFormState createState() => _ConfirmationFormState();
}

class _ConfirmationFormState extends State<ConfirmationForm> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  String code = "";

  @override
  void initState() {
    super.initState();
    _focusNodes[0].requestFocus();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void nextField(String value, int index) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.length == 1 && index == 5) {
      _focusNodes[index].unfocus();
      code = _controllers.map((controller) => controller.text).join();
      widget.onVerificationCodeEntered(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 50,
                child: TextFormField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  obscureText: true,
                  style: const TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onChanged: (value) => nextField(value, index),
                ),
              );
            }),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          ElevatedButton(
            onPressed: () {
              code = _controllers.map((controller) => controller.text).join();
              widget.onVerificationCodeEntered(code);
            },
            child: const Text("تأكيد"),
          ),
        ],
      ),
    );
  }
}
