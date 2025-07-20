import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Masks {
  Masks._();
  static final instance = Masks._();
  final dataMask = MaskTextInputFormatter(mask: '##/##/####');
  final timeMask = MaskTextInputFormatter(mask: '##:##');
  final cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');
}
