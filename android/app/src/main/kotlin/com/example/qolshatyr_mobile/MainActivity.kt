package com.example.qolshatyr_mobile
import android.telephony.SmsManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.sms_sender"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSms") {
                val phoneNumber = call.argument<String>("phoneNumber")
                val message = call.argument<String>("message")
                sendSms(phoneNumber, message)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun sendSms(phoneNumber: String?, message: String?) {
        val smsManager = SmsManager.getDefault()
        smsManager.sendTextMessage(phoneNumber, null, message, null, null)
    }
}
