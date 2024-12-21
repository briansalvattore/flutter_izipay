package com.briansalvattore.flutter_izipay

import android.app.Activity
import android.content.Intent
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.izipay.izipay_pw_sdk.data.model.ConfigRequest
import com.izipay.izipay_pw_sdk.data.model.OrderPaymentIzipay
import com.izipay.izipay_pw_sdk.data.model.PayOption
import com.izipay.izipay_pw_sdk.data.model.TokenPaymentIzipay
import com.izipay.izipay_pw_sdk.data.model.BillingPaymentIzipay
import com.izipay.izipay_pw_sdk.data.model.ShippingPaymentIzipay
import com.izipay.izipay_pw_sdk.data.model.AppearencePaymentIzipay
import com.izipay.izipay_pw_sdk.data.model.AppearenceControlsPaymentIzipay
import com.izipay.izipay_pw_sdk.data.model.AppearenceVisualSettingsPaymentIzipay
import com.izipay.izipay_pw_sdk.data.model.CustomThemePaymentIzipay
import com.izipay.izipay_pw_sdk.ui.fullscreend.ContainerActivity

class FlutterIzipayPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware {
  private lateinit var methodChannel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null

  private var activity: Activity? = null

  companion object {
    const val REQUEST_CODE_IZIPAY = 1001
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addActivityResultListener { requestCode, resultCode, data ->
      handleActivityResult(requestCode, resultCode, data)
      true
    }
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel = MethodChannel(binding.binaryMessenger, "flutter_izipay/method_channel")
    methodChannel.setMethodCallHandler(this)

    eventChannel = EventChannel(binding.binaryMessenger, "flutter_izipay/event_channel")
    eventChannel.setStreamHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
        "openFormToSaveCard" -> {
            val data = call.arguments as Map<String, String>
            openFormToSaveCard(data)
        }
        else -> {
            result.notImplemented()
        }
    }
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
    
    val eventData = mapOf(
      "success" to false,
      "cardToken" to null,
    )
    sendEvent(eventData)
  }

  override fun onCancel(arguments: Any?) {
      eventSink = null
  }

  private fun sendEvent(data: Map<String, Any?>) {
      eventSink?.success(data)
  }

  private fun openFormToSaveCard(map: Map<String, String>) {
      for ((key, value) in map) {
        println("Key: $key, Value: $value")
      }

      val transactionId = map["transactionId"] as String

      val request = ConfigRequest(
        map["environment"] as String,
        "register",
        map["publicKey"] as String,
        transactionId,
        map["merchantCode"] as String,
        "",
        OrderPaymentIzipay(
          "10$$transactionId",
          "PEN",
          "0.00",
          arrayListOf(PayOption.CARD),
          "mobile",
          "autorize",
          map["userId"] as String,
          System.currentTimeMillis().toString(),
        ),
        TokenPaymentIzipay(
          "",
        ),
        BillingPaymentIzipay(
          map["firstName"] as String,
          map["lastName"] as String,
          map["email"] as String,
          map["phoneNumber"] as String,
          map["street"] as String,
          map["city"] as String,
          map["state"] as String,
          map["country"] as String,
          map["postalCode"] as String,
          map["documentType"] as String,
          map["documentNumber"] as String,
        ),
        ShippingPaymentIzipay(
          "Juan", 
          "Perez", 
          "jperez@example.com", 
          "995999052", 
          "Calle 123", 
          "Lima", 
          "Lima", 
          "PE", 
          "12345", 
          "DNI", 
          "12345678"
        ),
        AppearencePaymentIzipay(
          "ESP",
          AppearenceControlsPaymentIzipay(
            false,
            false,
          ),
          AppearenceVisualSettingsPaymentIzipay(
            true,
          ),
          "purple",
          CustomThemePaymentIzipay(
            "#FF0000",
            "#FF0000",
            "#FF0000",
          ),
          map["logoUrl"] as String,
        ),
        "https://ezipay.com...",
      )

      println("request: $request")

      val intent = Intent(activity!!, ContainerActivity::class.java)
      intent.putExtra(ContainerActivity.REQUEST, request) // request es una instancia de CONFIGREQUEST
      activity!!.startActivityForResult(intent, REQUEST_CODE_IZIPAY)
  }

  private fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
      println("requestCode: $requestCode")
      println("resultCode: $resultCode")
      println("data: $data")
  }
}
