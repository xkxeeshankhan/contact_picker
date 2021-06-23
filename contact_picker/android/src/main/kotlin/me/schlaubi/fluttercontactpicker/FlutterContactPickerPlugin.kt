package me.schlaubi.fluttercontactpicker

import android.app.Activity
import android.content.Context
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.PluginRegistry

class FlutterContactPickerPlugin : AbstractFlutterContactPickerPlugin(), FlutterPlugin, ActivityAware {

    private var activity: ActivityPluginBinding? = null
    private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null
    override val context: PickContext = V2Context()


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = binding
        registerChannel(binding.binaryMessenger)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = null
        unregisterChannel()
    }

    override fun onDetachedFromActivity() {
        activity?.removeActivityResultListener(context)
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding): Unit = onAttachedToActivity(binding)

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        binding.addActivityResultListener(context)
        binding.addRequestPermissionsResultListener(PermissionUtil)
        activity = binding
    }

    override fun onDetachedFromActivityForConfigChanges(): Unit = onDetachedFromActivity()

    companion object {
        @JvmStatic
        @Suppress("unused", "deprecation") // Backwards compatibility for v1 plugins
        fun registerWith(registrar: PluginRegistry.Registrar) = LegacyFlutterContactPickerPlugin(registrar)

        const val PICK_PHONE = 2015
        const val PICK_EMAIL = 2020
        const val PICK_CONTACT = 2029
        const val FLUTTER_CONTACT_PICKER = "me.schlaubi.contactpicker"
    }


    private inner class V2Context : AbstractPickContext() {
        override val activity: Activity
            get() = this@FlutterContactPickerPlugin.activity?.activity ?: error("No Activity")

        override val context: Context
            get() = this@FlutterContactPickerPlugin.pluginBinding?.applicationContext
                    ?: error("No context")

    }

}
