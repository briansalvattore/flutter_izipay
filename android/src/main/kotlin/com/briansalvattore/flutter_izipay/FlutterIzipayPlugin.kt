package com.briansalvattore.flutter_izipay

import android.app.Activity
import android.content.Intent
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import com.google.gson.Gson
import com.google.gson.reflect.TypeToken

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
import com.izipay.izipay_pw_sdk.domain.model.PaymentResponse
import com.izipay.izipay_pw_sdk.ui.fullscreend.ContainerActivity

class FlutterIzipayPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler, ActivityAware {
  private lateinit var methodChannel: MethodChannel
  private lateinit var eventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null

  private var activity: Activity? = null

  companion object {
    const val REQUEST_CODE_IZIPAY = 1001

    const val IZIPAY_PAY = "pay"
    const val IZIPAY_REGISTER = "register"

    const val TAG = "FlutterIzipayPlugin"
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
        "payWithCard" -> {
            val data = call.arguments as Map<String, String>
            payWithCard(data)
        }
        "payWithYape" -> {
            val data = call.arguments as Map<String, String>
            payWithYape(data)
        }
        else -> {
            result.notImplemented()
        }
    }
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
      eventSink = null
  }

  private fun sendEvent(data: Map<String, Any?>) {
      eventSink?.success(data)
  }

  private fun payWithYape(map: Map<String, String>) {
      val request = ConfigRequest(
        map["environment"] as String,
        IZIPAY_PAY,
        map["publicKey"] as String,
        map["transactionId"] as String,
        map["merchantCode"] as String,
        "",
        OrderPaymentIzipay(
          map["orderNumber"] as String, //siempre debe tener 13 dígitos
          "PEN",
          map["amount"] as String,  // siempre debe tener el formato verificar 00.00
          arrayListOf(PayOption.YAPE),
          "mobile",
          "autorize",
          map["userId"] as String, // siempre debe tener una letra
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
        null,
        AppearencePaymentIzipay(
          "ESP",
          AppearenceControlsPaymentIzipay(
            true,
            false,
          ),
          AppearenceVisualSettingsPaymentIzipay(
            true,
          ),
          "purple",
          CustomThemePaymentIzipay(
            "#333399",
            "#333399",
            "#333399",
          ),
          map["logoUrl"] as String,
        ),
        map["webhookUrl"] as String,
      )

      Log.d("FlutterTapAndPayPlugin", "ConfigRequest ${request}")

      val intent = Intent(activity!!, ContainerActivity::class.java)
      intent.putExtra(ContainerActivity.REQUEST, request)
      activity!!.startActivityForResult(intent, REQUEST_CODE_IZIPAY)
  }

  private fun payWithCard(map: Map<String, String>) {
      val request = ConfigRequest(
        map["environment"] as String,
        IZIPAY_PAY,
        map["publicKey"] as String,
        map["transactionId"] as String,
        map["merchantCode"] as String,
        "",
        OrderPaymentIzipay(
          map["orderNumber"] as String, //siempre debe tener 13 dígitos
          "PEN",
          map["amount"] as String,  // siempre debe tener el formato verificar 00.00
          arrayListOf(PayOption.CARD),
          "mobile",
          "autorize",
          map["userId"] as String, // siempre debe tener una letra
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
        null,
        AppearencePaymentIzipay(
          "ESP",
          AppearenceControlsPaymentIzipay(
            true,
            false,
          ),
          AppearenceVisualSettingsPaymentIzipay(
            true,
          ),
          "purple",
          CustomThemePaymentIzipay(
            "#333399",
            "#333399",
            "#333399",
          ),
          map["logoUrl"] as String,
        ),
        map["webhookUrl"] as String,
      )

      Log.d("FlutterTapAndPayPlugin", "ConfigRequest ${request}")

      val intent = Intent(activity!!, ContainerActivity::class.java)
      intent.putExtra(ContainerActivity.REQUEST, request)
      activity!!.startActivityForResult(intent, REQUEST_CODE_IZIPAY)
  }

  private fun openFormToSaveCard(map: Map<String, String>) {
      val request = ConfigRequest(
        map["environment"] as String,
        IZIPAY_REGISTER,
        map["publicKey"] as String,
        map["transactionId"] as String,
        map["merchantCode"] as String,
        "",
        OrderPaymentIzipay(
          map["orderNumber"] as String, //siempre debe tener 13 dígitos
          "PEN",
          "0.00",
          arrayListOf(PayOption.CARD),
          "mobile",
          "autorize",
          map["userId"] as String, // siempre debe tener una letra
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
        null,
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
            "#333399",
            "#333399",
            "#333399",
          ),
          map["logoUrl"] as String,
        ),
        map["webhookUrl"] as String,
      )

      Log.d("FlutterTapAndPayPlugin", "ConfigRequest ${request}")

      val intent = Intent(activity!!, ContainerActivity::class.java)
      intent.putExtra(ContainerActivity.REQUEST, request)
      activity!!.startActivityForResult(intent, REQUEST_CODE_IZIPAY)
  }

  private fun handleActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
      if (requestCode == REQUEST_CODE_IZIPAY) {
        if (resultCode == Activity.RESULT_OK) {
            val dataPayLoad: PaymentResponse = Gson().fromJson(data?.getStringExtra(ContainerActivity.RESPONSEPAYLOAD).orEmpty(), object: TypeToken<PaymentResponse>(){}.type)
            
            Log.d("FlutterTapAndPayPlugin", "PaymentResponse ${dataPayLoad}")
            
            val eventData = mapOf(
              "success" to true,
              "code" to dataPayLoad.code,
              "cardToken" to dataPayLoad.response?.token?.cardToken,
              "cardPan" to dataPayLoad.response?.card?.pan,
              "cardBrand" to dataPayLoad.response?.card?.brand,
            )
            sendEvent(eventData)
        } 
        else {
            val eventData = mapOf(
              "success" to false,
            )
            sendEvent(eventData)
        }
      }
  }
}
