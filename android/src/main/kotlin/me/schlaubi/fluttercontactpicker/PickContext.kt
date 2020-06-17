package me.schlaubi.fluttercontactpicker

import android.app.Activity
import android.content.Context
import io.flutter.plugin.common.PluginRegistry

interface PickContext : PluginRegistry.ActivityResultListener {

    val activity: Activity
    val context: Context

    fun removeActivityResultListener(listener: PluginRegistry.ActivityResultListener)

    fun addActivityResultListener(listener: PluginRegistry.ActivityResultListener)

}
