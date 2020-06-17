package me.schlaubi.fluttercontactpicker

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.provider.ContactsContract
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry

class ContactPicker private constructor(private val pickContext: PickContext, private val result: MethodChannel.Result, askForPermission: Boolean, private val requestCode: Int, private val type: Uri) : PluginRegistry.ActivityResultListener, PluginRegistry.RequestPermissionsResultListener {

    init {
        val hasPermission = PermissionUtil.hasPermission(pickContext.context) || (Build.VERSION.SDK_INT <= Build.VERSION_CODES.Q && requestCode != FlutterContactPickerPlugin.PICK_CONTACT) // below android 11 there is no need for permissions when only requesting email/phone number
        if (!hasPermission && askForPermission) {
            PermissionUtil.requestPermission(pickContext.activity, this)
        } else if (hasPermission) {
            requestPicker()
        } else {
            result.error("INSUFFICIENT_PERMISSIONS", "The READ_CONTACTS permission has not been granted", null)
        }
    }

    private fun requestPicker() {
        val pickerIntent = Intent(Intent.ACTION_PICK, type)
        pickContext.addActivityResultListener(this)
        pickContext.activity.startActivityForResult(pickerIntent, requestCode)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        if (data == null) {
            pickContext.removeActivityResultListener(this)
            return false
        }

        when (requestCode) {
            FlutterContactPickerPlugin.PICK_EMAIL -> processDisplayNamed(data, "email", ::buildEmailAddress)
            FlutterContactPickerPlugin.PICK_PHONE -> processDisplayNamed(data, "phoneNumber", ::buildPhoneNumber)
            FlutterContactPickerPlugin.PICK_CONTACT -> processContact(data, ::buildContact)
            else -> return false
        }
        return true
    }

    private fun processDisplayNamed(intent: Intent, dataName: String, dataProcessor: (Cursor, Activity) -> Map<String, String>) {
        val processor = { cursor: Cursor, activity: Activity ->
            buildDisplayNamed(cursor, dataName, dataProcessor(cursor, activity))
        }
        return processContact(intent, processor)
    }

    private fun processContact(intent: Intent, dataProcessor: (Cursor, Activity) -> Map<String, Any?>) {
        val data = intent.data ?: return
        val activity = pickContext.activity
        activity.contentResolver.query(data, null, null, null, null).use {
            require(it != null) { "Cursor must not be null" }
            it.moveToFirst()
            val processedData = dataProcessor(it, activity)
            this.result.success(processedData)
        }
        pickContext.removeActivityResultListener(this)
    }

    private fun buildContact(cursor: Cursor, activity: Activity): Map<String, Any?> {
        val contactId = cursor.getLong(cursor.getColumnIndex(ContactsContract.Contacts._ID))
        var name: Map<String, String>? = null
        val instantMessengers = mutableListOf<Map<String, String>>()
        val emails = mutableListOf<Map<String, String>>()
        val phones = mutableListOf<Map<String, String>>()
        val addresses = mutableListOf<Map<String, String>>()
        activity.contentResolver.query(ContactsContract.RawContactsEntity.CONTENT_URI, null, "${ContactsContract.Data.CONTACT_ID} = ?", arrayOf(contactId.toString()), null, null).use {
            require(it != null && it.moveToFirst()) { "Contact could not be found" }
            do {
                when (it.getString(it.getColumnIndex(ContactsContract.RawContactsEntity.MIMETYPE))) {
                    ContactsContract.CommonDataKinds.Im.CONTENT_ITEM_TYPE -> instantMessengers += buildInstantMessenger(it, activity)
                    ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE -> emails += buildEmailAddress(it, activity)
                    ContactsContract.CommonDataKinds.StructuredPostal.CONTENT_ITEM_TYPE -> addresses += buildAddress(it, activity)
                    ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE -> phones += buildPhoneNumber(it, activity)
                    ContactsContract.CommonDataKinds.StructuredName.CONTENT_ITEM_TYPE -> name = buildName(it)
                }
            } while (it.moveToNext())
        }
        return mapOf("name" to name, "instantMessengers" to instantMessengers, "phones" to phones, "addresses" to addresses, "emails" to emails)
    }

    private fun buildInstantMessenger(cursor: Cursor, activity: Activity): Map<String, String> {
        val type = cursor.getInt(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Im.TYPE))
        val customLabel = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Im.LABEL))

        val label = ContactsContract.CommonDataKinds.Im.getTypeLabel(activity.resources, type, customLabel).toString()
        val im = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Im.DATA))

        val protocol = cursor.getInt(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Im.PROTOCOL))
        val customProtocol = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Im.CUSTOM_PROTOCOL))
        val actualProtocol = ContactsContract.CommonDataKinds.Im.getProtocolLabel(activity.resources, protocol, customProtocol).toString()
        return mapOf(label(label),
                "im" to im,
                "protocol" to actualProtocol
        )
    }

    private fun buildAddress(cursor: Cursor, activity: Activity): Map<String, String> {
        val type = cursor.getInt(cursor.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.TYPE))
        val customLabel = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.LABEL))

        val label = ContactsContract.CommonDataKinds.StructuredPostal.getTypeLabel(activity.resources, type, customLabel).toString()
        val street = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.STREET))
        val pobox = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.POBOX))
        val neighborhood = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.NEIGHBORHOOD))
        val city = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.CITY))
        val region = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.REGION))
        val postcode = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.POSTCODE))
        val country = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.StructuredPostal.COUNTRY))

        return mapOf(
                label(label),
                "street" to street,
                "pobox" to pobox,
                "neighborhood" to neighborhood,
                "city" to city,
                "region" to region,
                "postcode" to postcode,
                "country" to country
        )
    }

    private fun buildName(cursor: Cursor): Map<String, String> {
        val firstName = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.StructuredName.GIVEN_NAME))
        val middleName = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.StructuredName.MIDDLE_NAME))
        val nickname = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Nickname.NAME))
        val lastName = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.StructuredName.FAMILY_NAME))
        return mapOf("firstName" to firstName, "middleName" to middleName, "nickname" to nickname, "lastName" to lastName)
    }

    private fun buildDisplayNamed(cursor: Cursor, dataName: String, data: Map<String, String>): Map<String, Any> {
        val fullName = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Identity.DISPLAY_NAME))
        return mapOf("fullName" to fullName, dataName to data)
    }

    private fun buildPhoneNumber(cursor: Cursor, activity: Activity): Map<String, String> {
        val number = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER))
        return buildLabeledItem(cursor, activity, ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.LABEL, "phoneNumber", number)
    }

    private fun buildEmailAddress(cursor: Cursor, activity: Activity): Map<String, String> {
        val address = cursor.getString(cursor.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA))
        return buildLabeledItem(cursor, activity, ContactsContract.CommonDataKinds.Email.TYPE, ContactsContract.CommonDataKinds.Email.LABEL, "email", address)
    }

    private fun buildLabeledItem(cursor: Cursor, activity: Activity, typeContract: String, labelContract: String, dataName: String, data: String): Map<String, String> {
        val type = cursor.getInt(cursor.getColumnIndex(typeContract))
        val customLabel = cursor.getString(cursor.getColumnIndex(labelContract))
        val label = ContactsContract.CommonDataKinds.Email.getTypeLabel(activity.resources, type, customLabel) as String
        return mapOf(dataName to data, label(label))
    }

    private fun label(label: String) = "label" to label

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray): Boolean {
        if (requestCode == PERMISSION_REQUEST) {
            if (grantResults.isNotEmpty() &&
                    grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                requestPicker()
            } else {
                result.error("INSUFFICIENT_PERMISSIONS", "The READ_CONTACTS permission has not been granted", null)
            }
            PermissionUtil.remove(this)
            return true
        }
        return false
    }

    companion object {

        const val PERMISSION_REQUEST = 5498

        fun requestPicker(requestCode: Int, type: Uri, result: MethodChannel.Result, context: PickContext, askForPermission: Boolean) =
                ContactPicker(context, result, askForPermission, requestCode, type)

    }
}
