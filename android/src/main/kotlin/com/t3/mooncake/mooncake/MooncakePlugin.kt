// In android/src/main/kotlin/com/t3/mooncake/mooncake/MooncakePlugin.kt

package com.t3.mooncake.mooncake

import android.app.Activity
import android.view.KeyEvent
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*

class MooncakePlugin: FlutterPlugin, ActivityAware {
    private lateinit var methodChannel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private var activity: Activity? = null
    private var lastKeyDownTime: Long = 0
    private var isLongPressDetected = false
    private val LONG_PRESS_TIMEOUT = 800L // 800ms for long press
    private val handler = Handler(Looper.getMainLooper())
    private var longPressRunnable: Runnable? = null
    private var currentKeyCode: Int? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel = MethodChannel(binding.binaryMessenger, "mooncake")
        eventChannel = EventChannel(binding.binaryMessenger, "mooncake/events")
        
        methodChannel.setMethodCallHandler { call, result ->
            when (call.method) {
                "initialize" -> {
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        eventChannel.setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
                eventSink = events
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        binding.addOnKeyEventListener { event -> handleKeyEvent(event) }
    }

    private fun handleKeyEvent(event: KeyEvent): Boolean {
        when (event.keyCode) {
            KeyEvent.KEYCODE_VOLUME_UP, KeyEvent.KEYCODE_VOLUME_DOWN -> {
                when (event.action) {
                    KeyEvent.ACTION_DOWN -> {
                        if (currentKeyCode != event.keyCode) {
                            // New key press, reset state
                            lastKeyDownTime = System.currentTimeMillis()
                            isLongPressDetected = false
                            currentKeyCode = event.keyCode
                            
                            // Schedule long press detection
                            longPressRunnable = Runnable {
                                if (!isLongPressDetected) {
                                    isLongPressDetected = true
                                    val button = if (currentKeyCode == KeyEvent.KEYCODE_VOLUME_UP) "1" else "0"
                                    sendEvent(button, "LONG_PRESS")
                                }
                            }
                            handler.postDelayed(longPressRunnable!!, LONG_PRESS_TIMEOUT)
                        }
                        return true
                    }
                    KeyEvent.ACTION_UP -> {
                        // Remove long press callback
                        longPressRunnable?.let { handler.removeCallbacks(it) }
                        
                        if (!isLongPressDetected) {
                            // Only send short press if we haven't sent a long press
                            val button = if (event.keyCode == KeyEvent.KEYCODE_VOLUME_UP) "1" else "0"
                            sendEvent(button, "SHORT_PRESS")
                        }
                        
                        // Reset state
                        isLongPressDetected = false
                        currentKeyCode = null
                        return true
                    }
                }
            }
        }
        return false
    }

    private fun sendEvent(button: String, type: String) {
        CoroutineScope(Dispatchers.Main).launch {
            eventSink?.success(mapOf(
                "button" to button,
                "type" to type
            ))
        }
    }

    override fun onDetachedFromActivity() {
        longPressRunnable?.let { handler.removeCallbacks(it) }
        activity = null
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        methodChannel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        onAttachedToActivity(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        onDetachedFromActivity()
    }
}