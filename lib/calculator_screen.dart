import 'package:flutter/material.dart';
import 'dart:math';
import 'buttons.dart';
class CalcScreen extends StatefulWidget {
  const CalcScreen({super.key});

  @override
  State<CalcScreen> createState() => _CalcScreenState();
}

class _CalcScreenState extends State<CalcScreen> {
  String numb1 = ''; // . 0-9
  String operand = ''; // + - * / ^
  String numb2 = ''; // . 0-9
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column
          (children: [
        // вывод
         Expanded(
           child: SingleChildScrollView(
             reverse: true,
             child: Container(
               alignment: Alignment.bottomRight,
               padding: const EdgeInsets.all(15),
               child: Text('$numb1$operand$numb2'.isEmpty?'0':'$numb1$operand$numb2',
                 style: const TextStyle(
                 fontSize: 50,
                 fontWeight: FontWeight.bold,
               ),
               textAlign: TextAlign.end,
               ),
             ),
           ),
         ),

        // кнопки
        Wrap(
          children: Button.buttonValues.map(
                (value) => SizedBox(
                    width: screenSize.width/4,
                    height: screenSize.width/5,
                    child: buildButton(value))
            ,).toList(),
        )
          ],
        ),
      ),
    );
  }
  Widget buildButton(value){
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: ButtonColor(value),
        shape: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0x51F1D1D)),
            borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => ButtonTap(value),
          child: Center(
              child: Text(value, style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25),),
          ),
        ),
      ),
    );
  }
  void ButtonTap(String value){

      if(value==Button.del){
        delete();
        return;
      }
      if(value == Button.clear){
        clearAll();
        return;
      }
      if(value == Button.per){
        percentage();
        return;
      }
      if(value == Button.calc){
        calculate();
        return;
      }

      AppendValue(value);
  }
  void calculate(){
    if(numb1.isEmpty) return;
    if(operand.isEmpty) return;
    if(numb2.isEmpty) return;

    final double num1 = double.parse(numb1);
    final double num2 = double.parse(numb2);
    num result = 0.0;
    switch (operand){
      case Button.add:
        result = num1 + num2;
        break;
      case Button.subtract:
        result = num1 - num2;
        break;
      case Button.multi:
        result = num1 * num2;
        break;
      case Button.divide:
        if (num2 != 0) {
          result = num1 / num2;
        } else {
          result = 0;}
        break;
      case Button.pow:
        result = pow(num1, num2);
        break;
      default:
    }
    setState(() {
     numb1 = '$result';

     if (numb1.endsWith('.0')) {
       numb1 = numb1.substring(0,numb1.length-2);
     }

     operand = '';
     numb2 = '';
    });
  }
  void percentage(){
    if(numb1.isNotEmpty && operand.isNotEmpty && numb2.isNotEmpty){
    }
    if(operand.isNotEmpty){
      return;
    }
    final number = double.parse(numb1);
    setState(() {
      numb1 = '${(number / 100)}';
      operand = '';
      numb2 = '';
    });
  }

  void clearAll() {
    setState(() {
      numb1 = '';
      operand = '';
      numb2 = '';
    });
  }
  void delete(){
    if(numb2.isNotEmpty){
      numb2 = numb2.substring(0, numb2.length-1);
    }else if(operand.isNotEmpty){
      operand = '';
    }else if(numb1.isNotEmpty){
      numb1 = numb1.substring(0, numb1.length-1);
    }
    setState(() {});
  }
  void AppendValue(String value) {
    if (value != Button.dot && int.tryParse(value) == null) {
      operand = value;
    } else if (numb1.isEmpty || operand.isEmpty) {
      if (value == Button.dot && numb1.contains(Button.dot)) return;
      if (value == Button.dot && numb1.isEmpty) {
        value = "0.";
      } else if (numb1 == Button.n0 && value == Button.n0) {
        return;
      }
      numb1 += value;
    } else if (numb2.isEmpty || operand.isNotEmpty) {
      if (value == Button.dot && numb2.contains(Button.dot)) return;
      if (value == Button.dot && numb2.isEmpty) {
        value = "0.";
      } else if (numb2 == Button.n0 && value == Button.n0) {
        return;
      }
      numb2 += value;
    }
    setState(() {});
  }
  Color ButtonColor(value){
    return [Button.del,Button.clear].contains(value)?Colors.grey:
           [Button.per,Button.pow,Button.subtract,
            Button.divide,Button.add,Button.multi].contains(value)?Color(0xD0FC9831):
           [Button.calc].contains(value)?Color(0xFF57A64F):Colors.white30;
  }
}
