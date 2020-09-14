import 'package:flutter/material.dart';

import 'done_widget.dart';

class KeyboardDoneExample extends StatefulWidget {
  KeyboardDoneExample({Key key}) : super(key: key);

  @override
  _KeyboardDoneExampleState createState() => _KeyboardDoneExampleState();
}

class _KeyboardDoneExampleState extends State<KeyboardDoneExample> {
  FocusNode numberFocusNode = new FocusNode();

  OverlayEntry overlayEntry;

  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView());
    });

    overlayState.insert(overlayEntry);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry.remove();
      overlayEntry = null;
    }
  }

  @override
  void initState() {
    super.initState();

    numberFocusNode.addListener(() {
      if (numberFocusNode.hasFocus) {
        showOverlay(context);
      } else {
        removeOverlay();
      }
    });
  }

  @override
  void dispose() {
    numberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('keyboard'),
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'click to input number'),
            // focusNode: numberFocusNode,
            keyboardAppearance: Brightness.light,
          ),
        ),
      ),
    );
  }
}
