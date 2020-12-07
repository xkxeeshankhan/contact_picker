library contact_picker_web;

import 'package:contact_picker_web/src/contact_picker_plugin.dart';

export 'src/contact_picker_plugin.dart';
export 'src/picker_not_available_exception.dart';

/// Proxy class to avoid importing web only class WebContactPickerPlugin on non web platforms
/// See [WebContactPickerPlugin] for more
class FlutterContactPickerPlugin {
  static void registerWith(dynamic registrar) =>
      WebContactPickerPlugin.registerWith(registrar);
}
