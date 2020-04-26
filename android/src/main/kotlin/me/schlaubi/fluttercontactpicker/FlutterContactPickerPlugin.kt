package me.schlaubi.fluttercontactpicker

import android.app.Activity
import android.provider.ContactsContract
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class FlutterContactPickerPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    private var channel: MethodChannel? = null
    private var activity: ActivityPluginBinding? = null
    private val context: PickContext = V2Context()


    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "pickPhoneContact" -> ContactPicker.requestPicker(PICK_PHONE, ContactsContract.CommonDataKinds.Phone.CONTENT_URI, result, context)
            "pickEmailContact" -> ContactPicker.requestPicker(PICK_EMAIL, ContactsContract.CommonDataKinds.Email.CONTENT_URI, result, context)
            else -> result.notImplemented()
        }
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, FLUTTER_CONTACT_PICKER)
        channel?.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel?.setMethodCallHandler(null)
        channel = null
    }

    override fun onDetachedFromActivity() {
        activity?.removeActivityResultListener(context)
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) = onAttachedToActivity(binding)

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addActivityResultListener(context)
        activity = binding
    }

    override fun onDetachedFromActivityForConfigChanges() = onDetachedFromActivity()

    companion object {

        @JvmStatic
        @Suppress("unused") // Backwards compatibility for v1 plugins
        fun registerWith(registrar: PluginRegistry.Registrar) = LegacyFlutterContactPickerPlugin(registrar)


        const val PICK_PHONE = 2015
        const val PICK_EMAIL = 2020
        const val FLUTTER_CONTACT_PICKER = "me.schlaubi.contactpicker"
    }


    private inner class V2Context : AbstractPickContext() {
        override val activity: Activity
            get() = this@FlutterContactPickerPlugin.activity?.activity ?: error("No Activity")

    }
}
