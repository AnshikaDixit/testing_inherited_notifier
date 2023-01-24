import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Inherited Notifier',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    debugShowCheckedModeBanner: false,
    home: const MyHomePage(),
  ));
}

class SliderData extends ChangeNotifier {
  double _value = 0.0;
  double get value => _value; //getter for private value
  set value(double newValue) {
    //setter fpr private value
    if (newValue != _value) {
      _value = newValue;
      notifyListeners();
    }
  }
}

//to access sliderdata to set its value, we will expose our function to inherited notifier
final sliderData =  SliderData(); //globally expose it, get access to sliderdata class instance directly and set value using setter

class SliderInheritedNotifier extends InheritedNotifier<SliderData> {
  const SliderInheritedNotifier({
    Key? key,
    required SliderData sliderData,
    required Widget child,
  }) : super(child: child, key: key, notifier: sliderData);

  static double of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<SliderInheritedNotifier>()
          ?.notifier
          ?.value ??
      0.0;
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SliderInheritedNotifier(
        sliderData: sliderData,
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                Slider(
                    value: 0.0,
                    onChanged: (value) {
                      sliderData.value = value;
                    }),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        height: 200,
                        color: Colors.yellow,
                      ),
                    ),
                    Opacity(
                      opacity: SliderInheritedNotifier.of(context),
                      child: Container(
                        height: 200,
                        color: Colors.blue,
                      ),
                    )
                  ].expandedEqually().toList(),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}

extension ExpandedEqually on Iterable<Widget> {
  Iterable<Widget> expandedEqually() => map((w) => Expanded(
        child: w,
      ));
}
