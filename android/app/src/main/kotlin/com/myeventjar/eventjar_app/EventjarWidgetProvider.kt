package com.myeventjar.eventjar_app

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class EventjarWidgetProvider : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.eventjar_widget).apply {
                setOnClickPendingIntent(
                    R.id.widget_action_scan_qr,
                    launchFor(context, "scan_qr")
                )
                setOnClickPendingIntent(
                    R.id.widget_action_add_contact,
                    launchFor(context, "add_contact")
                )
                setOnClickPendingIntent(
                    R.id.widget_action_nfc,
                    launchFor(context, "nfc_tap")
                )
                setOnClickPendingIntent(
                    R.id.widget_action_scan_card,
                    launchFor(context, "scan_card")
                )
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun launchFor(context: Context, action: String): PendingIntent {
        val uri = Uri.parse("myeventjar://widget?action=$action")
        return HomeWidgetLaunchIntent.getActivity(
            context,
            MainActivity::class.java,
            uri
        )
    }
}
