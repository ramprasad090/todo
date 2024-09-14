package com.example.todo

import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: android.os.Bundle?) {
        super.onCreate(savedInstanceState)

        // Create notification channel for Android 8.0 and higher
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "001"
            val channelName = "NotificationChannel"
            val channelDescription = "Scheduled Notifications"

            val notificationChannel = NotificationChannel(
                channelId,
                channelName,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = channelDescription
            }

            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(notificationChannel)
        }
    }
}
