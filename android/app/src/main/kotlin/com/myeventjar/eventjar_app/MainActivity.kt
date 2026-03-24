package com.myeventjar.eventjar_app

import android.app.PendingIntent
import android.content.Intent
import android.content.IntentFilter
import android.nfc.NdefMessage
import android.nfc.NfcAdapter
import android.nfc.tech.Ndef
import android.nfc.tech.NdefFormatable
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.myeventjar.eventjar_app/nfc"
    private var methodChannel: MethodChannel? = null

    // Store NFC intents - can be initial or from onNewIntent
    private var pendingNfcIntent: Intent? = null

    private var nfcAdapter: NfcAdapter? = null
    private var pendingIntent: PendingIntent? = null
    private var intentFilters: Array<IntentFilter>? = null
    private var techLists: Array<Array<String>>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        Log.d("NfcMainActivity", "configureFlutterEngine called")

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        Log.d("NfcMainActivity", "MethodChannel created: $methodChannel")

        methodChannel?.setMethodCallHandler { call, result ->
            Log.d("NfcMainActivity", "Method call from Flutter: ${call.method}")
            when (call.method) {
                "getNfcIntent" -> {
                    // Return any pending NFC intent (initial or from onNewIntent)
                    val intentData = pendingNfcIntent?.let { extractNfcData(it) }
                    Log.d("NfcMainActivity", "getNfcIntent called, returning: $intentData")
                    pendingNfcIntent = null // Clear after reading
                    result.success(intentData)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Setup NFC adapter and foreground dispatch
        nfcAdapter = NfcAdapter.getDefaultAdapter(this)

        // Create pending intent for foreground dispatch
        val nfcPendingIntent = Intent(this, javaClass).apply {
            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP)
        }
        pendingIntent = PendingIntent.getActivity(
            this, 0, nfcPendingIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
        )

        // Setup intent filters for NFC
        val ndefFilter = IntentFilter(NfcAdapter.ACTION_NDEF_DISCOVERED).apply {
            try {
                addDataType("text/vcard")
                addDataType("text/x-vcard")
                addDataType("*/*")
            } catch (e: IntentFilter.MalformedMimeTypeException) {
                throw RuntimeException("Failed to add MIME type", e)
            }
        }

        val techFilter = IntentFilter(NfcAdapter.ACTION_TECH_DISCOVERED)
        val tagFilter = IntentFilter(NfcAdapter.ACTION_TAG_DISCOVERED)

        intentFilters = arrayOf(ndefFilter, techFilter, tagFilter)

        // Tech lists for TECH_DISCOVERED
        techLists = arrayOf(
            arrayOf(Ndef::class.java.name),
            arrayOf(NdefFormatable::class.java.name)
        )

        // Store initial intent if it's an NFC intent
        if (isNfcIntent(intent)) {
            pendingNfcIntent = intent
        }
    }

    override fun onResume() {
        super.onResume()
        // Enable foreground dispatch to claim all NFC tags
        nfcAdapter?.enableForegroundDispatch(this, pendingIntent, intentFilters, techLists)
    }

    override fun onPause() {
        super.onPause()
        // Disable foreground dispatch when app is paused
        nfcAdapter?.disableForegroundDispatch(this)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)

        Log.d("NfcMainActivity", "onNewIntent called, action: ${intent.action}")

        // Handle NFC intent when app is already running
        if (isNfcIntent(intent)) {
            Log.d("NfcMainActivity", "NFC intent detected")
            // Store the intent
            pendingNfcIntent = intent
            // Also try to notify Flutter immediately (with small delay to ensure Flutter is ready)
            val nfcData = extractNfcData(intent)
            Log.d("NfcMainActivity", "Extracted NFC data: $nfcData")

            // Use Handler to ensure we're on main thread and give Flutter a moment
            Handler(Looper.getMainLooper()).postDelayed({
                Log.d("NfcMainActivity", "Invoking onNfcIntent on Flutter, methodChannel: $methodChannel")
                methodChannel?.invokeMethod("onNfcIntent", nfcData)
            }, 100)
        }
    }

    private fun isNfcIntent(intent: Intent?): Boolean {
        return intent?.action in listOf(
            NfcAdapter.ACTION_NDEF_DISCOVERED,
            NfcAdapter.ACTION_TECH_DISCOVERED,
            NfcAdapter.ACTION_TAG_DISCOVERED
        )
    }

    private fun extractNfcData(intent: Intent): Map<String, Any?> {
        val action = intent.action
        var payload: String? = null
        var mimeType: String? = null

        // Extract NDEF messages
        val rawMessages = intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES)
        if (rawMessages != null && rawMessages.isNotEmpty()) {
            val ndefMessage = rawMessages[0] as NdefMessage
            val records = ndefMessage.records

            if (records.isNotEmpty()) {
                val record = records[0]
                mimeType = String(record.type, Charsets.UTF_8)
                payload = String(record.payload, Charsets.UTF_8)
            }
        }

        return mapOf(
            "action" to action,
            "payload" to payload,
            "mimeType" to mimeType
        )
    }
}
