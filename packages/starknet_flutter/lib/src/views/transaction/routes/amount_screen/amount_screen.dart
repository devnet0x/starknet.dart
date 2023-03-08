import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:starknet_flutter/src/views/transaction/routes/amount_screen/widgets/misc_entry.dart';
import 'package:starknet_flutter/src/views/transaction/routes/amount_screen/widgets/number_entry.dart';
import 'package:starknet_flutter/src/views/transaction/routes/recipient_screen.dart';
import 'package:starknet_flutter/src/views/transaction/transaction_presenter.dart';
import 'package:starknet_flutter/src/views/transaction/transaction_viewmodel.dart';
import 'package:starknet_flutter/src/views/widgets/bouncing_button.dart';
import 'package:starknet_flutter/src/views/widgets/bouncing_widget.dart';
import 'package:starknet_flutter/starknet_flutter.dart';

class AmountScreen extends StatefulWidget {
  static const routeName = '/amount';

  final TransactionViewModel model;
  final TransactionPresenter presenter;
  const AmountScreen({
    Key? key,
    required this.model,
    required this.presenter,
  }) : super(key: key);

  @override
  State<AmountScreen> createState() => _AmountScreenState();
}

class _AmountScreenState extends State<AmountScreen> {
  String _amountStr = '';
  double get amount => _amountStr.isNotEmpty ? double.parse(_amountStr) : 0;
  double get ethDollarPrice => widget.model.ethExchangeRate != null
      ? amount * widget.model.ethExchangeRate!
      : 0;

  @override
  Widget build(BuildContext context) {
    const kVerticalSpacing = 20.0;
    const kHorizontalSpacing = 20.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 15),
      child: Column(
        children: [
          Column(
            children: [
              // TODO: add an auto size text instead
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _amountStr.isEmpty ? '0' : _amountStr,
                      style: GoogleFonts.fjallaOne(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'ETH',
                      style: GoogleFonts.fjallaOne(
                        fontSize: 55,
                        color: Colors.black.withOpacity(0.3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '\$${ethDollarPrice.truncateBalance(precision: 2)}',
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 3),
              BouncingWidget(
                onTap: () {
                  setState(() {
                    _amountStr = widget.model.ethBalance.toString();
                  });
                },
                child: Text(
                  '${widget.model.ethBalance?.truncateBalance() ?? '--'} ETH available',
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 290, minWidth: 150),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GridView.count(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      crossAxisSpacing: kHorizontalSpacing,
                      mainAxisSpacing: kVerticalSpacing,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      children: List.generate(9, (index) {
                        final number = index + 1;
                        return NumberEntryWidget(
                          entry: number.toString(),
                          onTap: () => _onNumberTap(number),
                        );
                      }),
                    ),
                    const SizedBox(height: 20),
                    GridView.count(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      crossAxisSpacing: kHorizontalSpacing,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      children: List.generate(3, (index) {
                        switch (index) {
                          case 0:
                            return MiscEntryWidget(
                              onTap: _onDotTap,
                              child: Text(
                                '.',
                                style: GoogleFonts.fjallaOne(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          case 1:
                            return NumberEntryWidget(
                              entry: '0',
                              onTap: () => _onNumberTap(0),
                            );
                          case 2:
                            return MiscEntryWidget(
                              onTap: _onBackSpaceTap,
                              child: const Icon(Icons.backspace_rounded),
                            );
                          default:
                            return const SizedBox.shrink();
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BouncingButton.plain(
            text: 'Next',
            onTap: amount > 0
                ? () {
                    widget.presenter.setAmount(amount);
                    Navigator.of(context).pushNamed(RecipientScreen.routeName);
                  }
                : null,
          ),
        ],
      ),
    );
  }

  _onDotTap() {
    if (_amountStr.contains('.')) return;

    if (_amountStr.isEmpty) {
      setState(() {
        _amountStr = '0.';
      });
      return;
    }

    setState(() {
      _amountStr = '$_amountStr.';
    });
  }

  _onBackSpaceTap() {
    if (_amountStr.isEmpty) return;
    setState(() {
      _amountStr = _amountStr.substring(0, _amountStr.length - 1);
    });
  }

  _onNumberTap(int number) {
    if (_amountStr.startsWith('0') && _amountStr.length == 1) {
      setState(() {
        _amountStr = number.toString();
      });
      return;
    }

    if (number == 0 &&
        _amountStr.isNotEmpty &&
        _amountStr.characters.first == '0' &&
        !_amountStr.contains('.')) return;

    setState(() {
      _amountStr = _amountStr + number.toString();
    });
  }
}
