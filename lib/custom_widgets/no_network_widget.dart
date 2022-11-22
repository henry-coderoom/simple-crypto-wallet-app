import 'package:flutter/material.dart';
import '../components/default_button.dart';

class NoNetworkWidget extends StatefulWidget {
  final bool isConnected;
  final Function() reLoad;
  const NoNetworkWidget(
      {Key? key, required this.isConnected, required this.reLoad})
      : super(key: key);
  @override
  State<NoNetworkWidget> createState() => NoNetworkWidgetState();
}

class NoNetworkWidgetState extends State<NoNetworkWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: widget.isConnected == false
          ? IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Icon(
                          Icons.signal_cellular_off_outlined,
                          size: 25,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'ERR: Check your internet connection and try again.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  DefaultButton(
                      onTap: () async {
                        await widget.reLoad();
                        setState(() {});
                      },
                      padding: 10,
                      icon: Icons.refresh_rounded,
                      radius: 8,
                      withIcon: true,
                      textColor: Colors.white,
                      bgColor: Colors.blue,
                      borderColor: Colors.transparent,
                      buttonText: 'Retry')
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
