// Credits to nice ppls working on pub.dev: https://github.com/dart-lang/pub-dev/blob/master/pkg/web_app/lib/src/google_auth_js.dart#L13-L34

@JS()
library contact_picker_promise;

import 'dart:async';

import 'package:js/js.dart';

/// Minimal interface for promise.
@JS('Promise')
class Promise<T> {
  external Promise then(
    void Function(T) onAccept,
    void Function(Exception) onReject,
  );
}

/// Convert a promise to a future.
Future<T> promiseAsFuture<T>(Promise<T> promise) {
  ArgumentError.checkNotNull(promise, 'promise');

  final c = Completer<T>();
  promise.then(allowInterop(Zone.current.bindUnaryCallback((T result) {
    c.complete(result);
  })), allowInterop(Zone.current.bindUnaryCallback((Object e) {
    c.completeError(e);
  })));
  return c.future;
}
