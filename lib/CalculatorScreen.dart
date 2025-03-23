import 'package:calculatorappflutter/buttonhere.dart';
import 'package:flutter/material.dart';
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1="";
  String operand="";
  String number2="";
  @override
  Widget build(BuildContext context) {
    final screen=MediaQuery.of(context).size;
    return Scaffold(
      body:SafeArea(
        bottom: false,
        child: Column(children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "$number1$operand$number2".isEmpty?"0":"$number1$operand$number2",
                    style: TextStyle(fontSize: 60),
                      textAlign: TextAlign.end,),
                ),
              ),
            ),
          ),
          Wrap(children:
            Button.buttonValue.map((value) => SizedBox(
                width: value==Button.n0?(screen.width/2):(screen.width/4),
                height: screen.width/5,
                child: setButton(value))).toList(),
          )
        ],),
      ),
    );
  }
  Widget setButton(value){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Material(
        color: buttonColor(value),
        clipBehavior: Clip.hardEdge,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: Colors.white24
          )
        ),
        child: InkWell(
          onTap: ()=>getButtonTap(value),
            child: Center(child: Text(value,style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold),))),
      ),
    );
  }
  Color buttonColor(value){
    return [Button.del,Button.clr].contains(value)?Colors.blueGrey:
    [Button.per,Button.multiplys,Button.add,Button.subtractions,Button.divition,Button.calculation].contains(value)?Colors.orange:Colors.black;
  }
  void getButtonTap(value){
    if(value==Button.del){
      delete(value);
      return;
    }
    if(value==Button.clr){
      clearButton(value);
      return;
    }
    if(value==Button.per){
      percentageValue(value);
      return;
    }
    if(value==Button.calculation){
      calculate(value);
      return;
    }
    if(value!=Button.dot&&int.tryParse(value)==null){
      if(operand.isNotEmpty&&number2.isNotEmpty){
        //code
        calculate(value);
      }
      operand=value;
    }
    else if(number1.isEmpty ||  operand.isEmpty){
      if(value==Button.dot&&number1.contains(Button.dot)) return;
      if(value==Button.dot&&number1.isEmpty || number1==Button.n0){
        value="0.";
      }
      number1+=value;
    }
    else if(number2.isEmpty || operand.isNotEmpty){
      if(value==Button.dot&&number2.contains(Button.dot)) return;
      if(value==Button.dot&&number2.isEmpty || number2==Button.n0){
        value="0.";
      }
      number2+=value;
    }
    setState(() {
    });
  }
  void delete(value){
    if(number2.isNotEmpty){
      number2=number2.substring(0,number2.length-1);
    }
    else if(operand.isNotEmpty){
      operand="";
    }
    else if(number1.isNotEmpty){
      number1=number1.substring(0,number1.length-1);
    }
    setState(() {
    });
  }
  void clearButton(value){
    setState(() {
      number1="";
      operand="";
      number2="";
    });
  }
  void percentageValue(value){
    if(number1.isNotEmpty&&number2.isNotEmpty&&operand.isNotEmpty){
      calculate(value);
    }
    if(operand.isNotEmpty){
      return;
    }
    final number=double.parse(number1);
    setState(() {
      number1="${(number/100)}";
      operand="";
      number2="";
    });
  }
  void calculate(value){
    if(number1.isEmpty) return;
    if(operand.isEmpty) return;
    if(number2.isEmpty) return;

    final double num1=double.parse(number1);
    final double num2=double.parse(number2);

    var result=0.0;
    switch(operand){
      case Button.add:
        result=num1+num2;
        break;
      case Button.subtractions:
        result=num1-num2;
        break;
      case Button.divition:
        result=num1/num2;
        break;
      case Button.multiplys:
        result=num1*num2;
        break;
      default:
    }
    setState(() {
      number1="$result";
      if(number1.endsWith(".0")){
        number1=number1.substring(0,number1.length-2);
      }
      operand="";
      number2="";
    });
  }
}
