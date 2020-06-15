package me.schlaubi.fluttercontactpicker

import android.content.pm.PackageManager
import android.provider.ContactsContract
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

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

    @Suppress("ReplaceNotNullAssertionWithElvisReturn")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "pickPhoneContact" -> ContactPicker.requestPicker(FlutterContactPickerPlugin.PICK_PHONE, ContactsContract.CommonDataKinds.Phone.CONTENT_URI, result, context, call.argument<Boolean>("askForPermission")!!)
            "pickEmailContact" -> ContactPicker.requestPicker(FlutterContactPickerPlugin.PICK_EMAIL, ContactsContract.CommonDataKinds.Email.CONTENT_URI, result, context, call.argument<Boolean>("askForPermission")!!)
            "pickContact" -> ContactPicker.requestPicker(FlutterContactPickerPlugin.PICK_CONTACT, ContactsContract.Contacts.CONTENT_URI, result, context, call.argument<Boolean>("askForPermission")!!)
            "hasPermission" -> result.success(PermissionUtil.hasPermission(context.context))
            "requestPermission" -> PermissionUtil.requestPermission(context.activity, object : PluginRegistry.RequestPermissionsResultListener {
                override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
                    if (requestCode == ContactPicker.PERMISSION_REQUEST) {
                        result.success(grantResults.isNotEmpty() && grantResults.first() == PackageManager.PERMISSION_GRANTED)
                        PermissionUtil.remove(this)
                        return true
                    }
                    return false
                }
            })
            else -> result.notImplemented()
        }
    }
}
