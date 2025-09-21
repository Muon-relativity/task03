package com.example.task03

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.util.Log

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.payment/bridge"
    private val REQUEST_CODE_PAYMENT = 1002
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->

            Log.d("MainActivity", "Method called: ${call.method}")

            if (call.method == "openPaymentApp") {
                val args = call.arguments as Map<*, *>
                val provider = args["provider"] as? String ?: "unknown"
                val amount = args["amount"] as? Int ?: 0
                val orderId = args["orderId"] as? String ?: ""

                val intent = when (provider.lowercase()) {
                    "toss" -> Intent(
                        Intent.ACTION_VIEW,
                        Uri.parse("supertoss://pay?amount=$amount&orderId=$orderId")
                    )
                    "payco" -> Intent(
                        Intent.ACTION_VIEW,
                        Uri.parse("payco://payment?amount=$amount&orderId=$orderId")
                    )
                    "kakaopay" -> Intent(
                        Intent.ACTION_VIEW,
                        Uri.parse("kakaotalk://kakaopay?amount=$amount&orderId=$orderId")
                    )
                    else -> Intent.createChooser(
                        Intent(Intent.ACTION_VIEW, Uri.parse("https://example.com/pay?amount=$amount&orderId=$orderId")),
                        "결제 앱을 선택하세요"
                    )
                }

                Log.d("MainActivity", "Opening payment app for provider: $provider")

                try {
                    pendingResult = result
                    startActivityForResult(intent, REQUEST_CODE_PAYMENT)
                } catch (e: ActivityNotFoundException) {
                    result.success(mapOf("status" to "not_installed", "message" to "$provider 앱이 설치되어 있지 않습니다."))
                    // 앱 미설치 시 pendingResult를 설정하지 않음
                    pendingResult = null
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE_PAYMENT && pendingResult != null) {
            val response = when (resultCode) {
                RESULT_OK -> mapOf("status" to "success", "message" to "결제 성공")
                RESULT_CANCELED -> mapOf("status" to "cancelled", "message" to "사용자 취소")
                else -> mapOf("status" to "failed", "message" to "결제 실패 또는 알 수 없음")
            }
            pendingResult?.success(response)
            pendingResult = null
        }
    }

}

