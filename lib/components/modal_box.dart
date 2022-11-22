import 'package:flutter/material.dart';
import 'package:my_crypto_wallet/size_config.dart';
import '../constants.dart';

class ModalBox extends StatefulWidget {
  const ModalBox({
    Key? key,
    required this.refresh,
    required this.modalWidget,
  }) : super(key: key);
  final Function() refresh;
  final Widget modalWidget;
  @override
  State<ModalBox> createState() => ModalBoxState();
}

class ModalBoxState extends State<ModalBox> {
  @override
  void initState() {
    widget.refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      constraints: BoxConstraints(
        minWidth: MediaQuery.of(context).size.width,
        maxWidth: MediaQuery.of(context).size.width,
        minHeight: 100.0,
        maxHeight: getProportionateScreenHeight(550),
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kBackgroundWhite,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const AlwaysScrollableScrollPhysics(),
          child: widget.modalWidget),
    );
  }
}
