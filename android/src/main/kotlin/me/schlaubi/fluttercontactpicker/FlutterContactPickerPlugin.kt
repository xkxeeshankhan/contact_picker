package me.schlaubi.fluttercontactpicker

import android.app.Activity
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.provider.ContactsContract
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class FlutterContactPickerPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {

    private var activityBinding: ActivityBinding? = null

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "pickPhoneContact" -> requestPicker(PICK_PHONE, ContactsContract.CommonDataKinds.Phone.CONTENT_URI, result)
            "pickEmailContact" -> requestPicker(PICK_EMAIL, ContactsContract.CommonDataKinds.Email.CONTENT_URI, result)
            else -> result.notImplemented()
        }
    }

    private fun requestPicker(requestCode: Int, type: Uri, result: Result) {
        val pickerIntent = Intent(Intent.ACTION_PICK, type)
        val binding = activityBinding ?: error("Missing activity")
        binding.addActivityResultListener(ContactPickerDelegate(result))
        binding.activity.startActivityForResult(pickerIntent, requestCode)
    }

    private inner class ContactPickerDelegate(private val flutterResult: Result) : PluginRegistry.ActivityResultListener {

        override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent): Boolean {
            when (requestCode) {
                PICK_EMAIL -> processContact(data, "email", ::buildEmailAddress)
                PICK_PHONE -> processContact(data, "phoneNumber", ::buildPhoneNumber)
                else -> return false
            }
            return true
        }

        private fun processContact(intent: Intent, dataName: String, dataProcessor: (Cursor, Activity) -> Map<String, String>) {
            val data = intent.data!!
            val activityBinding = activityBinding ?: error("Activity missing")
            val activity = activityBinding.activity
            activity.contentResolver.query(data, null, null, null, null).use {
                require(it != null) { "Cursor must not be null" }
                it.moveToFirst()
                val processedData = dataProcessor(it, activity)
                val fullName = it.getString(it.getColumnIndex(ContactsContract.CommonDataKinds.Identity.DISPLAY_NAME))
                val result = mapOf("fullName" to fullName, dataName to processedData)
                flutterResult.success(result)
            }
            activityBinding.removeActivityResultListener(this)
        }

        private fun buildPhoneNumber(cursor: Cursor, activity: Activity): Map<String, String> {
            val phoneType = cursor.getInt(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE))
            val customLabel = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.LABEL))
            val label = ContactsContract.CommonDataKinds.Phone.getTypeLabel(activity.resources, phoneType, customLabel) as String
            val number = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER))
            return mapOf("phoneNumber" to number, "label" to label)
        }

        private fun buildEmailAddress(cursor: Cursor, activity: Activity): Map<String, String> {
            val phoneType = cursor.getInt(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.TYPE))
            val customLabel = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.LABEL))
            val label = ContactsContract.CommonDataKinds.Email.getTypeLabel(activity.resources, phoneType, customLabel) as String
            val address = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA))
            return mapOf("email" to address, "label" to label)
        }
    }

    fun setupActivity(binding: ActivityBinding) {
        activityBinding = binding
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        registerChannel(binding.binaryMessenger, this)
    }


    override fun onDetachedFromActivity() {
        activityBinding = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) =
            setupActivity(ActivityBinding.fromPluginBinding(binding))

    override fun onAttachedToActivity(binding: ActivityPluginBinding) = setupActivity(ActivityBinding.fromPluginBinding(binding))

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) = Unit

    override fun onDetachedFromActivityForConfigChanges() = Unit

    interface ActivityBinding {
        val activity: Activity
        fun addActivityResultListener(listener: PluginRegistry.ActivityResultListener)
        fun removeActivityResultListener(listener: PluginRegistry.ActivityResultListener)

        companion object {
            fun fromPluginBinding(binding: ActivityPluginBinding) = object : ActivityBinding {
                override val activity: Activity
                    get() = binding.activity

                override fun addActivityResultListener(listener: PluginRegistry.ActivityResultListener) = binding.addActivityResultListener(listener)

                override fun removeActivityResultListener(listener: PluginRegistry.ActivityResultListener) = binding.removeActivityResultListener(listener)
            }
        }
    }

    companion object {

        @JvmStatic
        @Suppress("unused") // Backwards compatibility for v1 plugins
        fun registerWith(registrar: PluginRegistry.Registrar) {
            registerChannel(registrar.messenger(), FlutterContactPickerPlugin()).apply {
                setupActivity(object : ActivityBinding {

                    init {
                        Log.w("FlutterContactPicker", "Using Flutter v1 plugins is not recommended consider upgrading")
                    }

                    override val activity: Activity
                        get() = registrar.activity()

                    override fun addActivityResultListener(listener: PluginRegistry.ActivityResultListener) {
                        registrar.addActivityResultListener(listener)
                    }

                    override fun removeActivityResultListener(listener: PluginRegistry.ActivityResultListener) {
                        Log.w("FlutterContactPicker", "Consider Upgrading to v2 embedded plugins")
                    }

                })
            }
        }

        private fun registerChannel(binaryMessenger: BinaryMessenger, plugin: FlutterContactPickerPlugin): FlutterContactPickerPlugin {
            val channel = MethodChannel(binaryMessenger, "fluttercontactpicker")
            channel.setMethodCallHandler(plugin)
            return plugin
        }

        private const val PICK_PHONE = 2015
        private const val PICK_EMAIL = 2020
    }
}
