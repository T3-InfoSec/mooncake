
package com.t3.mooncake.mooncake

import android.view.KeyEvent
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

fun ActivityPluginBinding.addOnKeyEventListener(listener: (KeyEvent) -> Boolean) {
    activity.window.callback = object : android.view.Window.Callback by activity.window.callback {
        override fun dispatchKeyEvent(event: KeyEvent): Boolean {
            return if (listener(event)) {
                true
            } else {
                activity.window.callback.dispatchKeyEvent(event)
            }
        }
    }
}