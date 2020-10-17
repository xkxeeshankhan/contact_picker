package me.schlaubi.fluttercontactpicker

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.PluginRegistry

class LegacyFlutterContactPickerPlugin(private val registrar: PluginRegistry.Registrar) : AbstractFlutterContactPickerPlugin() {

    override val context: PickContext = V1Context()

    init {
        registrar.addRequestPermissionsResultListener(PermissionUtil)
        registrar.addActivityResultListener(context)
        registerChannel(registrar.messenger())
    }

    private inner class V1Context : AbstractPickContext() {
        override val activity: Activity
            get() = registrar.activity()
        override val context: Context
            get() = registrar.context()
    }
}
