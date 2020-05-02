package me.schlaubi.fluttercontactpicker

import android.app.Activity
import android.provider.ContactsContract
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class LegacyFlutterContactPickerPlugin(private val registrar: PluginRegistry.Registrar) : MethodChannel.MethodCallHandler {

    private val context: PickContext = V1Context()

    init {
        registrar.addActivityResultListener(context)
        MethodChannel(registrar.messenger(), FlutterContactPickerPlugin.FLUTTER_CONTACT_PICKER).setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "pickPhoneContact" -> ContactPicker.requestPicker(FlutterContactPickerPlugin.PICK_PHONE, ContactsContract.CommonDataKinds.Phone.CONTENT_URI, result, context)
            "pickEmailContact" -> ContactPicker.requestPicker(FlutterContactPickerPlugin.PICK_EMAIL, ContactsContract.CommonDataKinds.Email.CONTENT_URI, result, context)
            else -> result.notImplemented()
        }
    }


    private inner class V1Context : AbstractPickContext() {
        override val activity: Activity
            get() = registrar.activity()
    }
}
