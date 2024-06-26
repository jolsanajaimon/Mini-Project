import 'package:flutter/material.dart';

// convert color to hex

const Color kBackgroundColor = Color(0xFF2D2D2D);
const Color kPrimaryColor = Color(0xFFF8D73A);
Color highlightColor = Color(0xFF4C4C4C);
const Color kgold = Color(0xFFE6AF2F);

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor, int i) : super(_getColorFromHex(hexColor));
}

//Headings

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        text,
        style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w900,
            fontSize: 42,
            color: Colors.white),
      ),
    );
  }
}

//custom button

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.buttonName,
    this.onPressed,
  }) : super(key: key);

  final String buttonName;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: HexColor('FFCC01', 1),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              buttonName,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChipBuilder extends StatefulWidget {
  final String label;
  final bool isSelected;
  final Function(bool) onSelected;

  const ChipBuilder({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  _ChipBuilderState createState() => _ChipBuilderState();
}

class _ChipBuilderState extends State<ChipBuilder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelected(!widget.isSelected);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 26, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.isSelected ? kPrimaryColor : Colors.transparent,
          border: Border.all(
            color: kPrimaryColor,
            width: 1,
          ),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            color: widget.isSelected ? Colors.black : kPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
