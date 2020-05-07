package me.schlaubi.fluttercontactpicker

import android.provider.ContactsContract
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

abstract class AbstractFlutterContactPickerPlugin : MethodChannel.MethodCallHandler {

    private var methodChannel: MethodChannel? = null
    abstract val context: PickContext

    protected fun registerChannel(binaryMessenger: BinaryMessenger) {
        methodChannel = MethodChannel(binaryMessenger, FlutterContactPickerPlugin.FLUTTER_CONTACT_PICKER)
        methodChannel?.setMethodCallHandler(this)
    }

    protected fun unregisterChannel() {
        methodChannel?.setMethodCallHandler(null)
        methodChannel = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "pickPhoneContact" -> ContactPicker.requestPicker(FlutterContactPickerPlugin.PICK_PHONE, ContactsContract.CommonDataKinds.Phone.CONTENT_URI, result, context)
            "pickEmailContact" -> ContactPicker.requestPicker(FlutterContactPickerPlugin.PICK_EMAIL, ContactsContract.CommonDataKinds.Email.CONTENT_URI, result, context)
            "pickContact" -> ContactPicker.requestPicker(FlutterContactPickerPlugin.PICK_CONTACT, ContactsContract.Contacts.CONTENT_URI, result, context)
            else -> result.notImplemented();
        }
    }
}
