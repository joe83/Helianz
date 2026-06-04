package com.helianz.qrismirror

import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import androidx.activity.result.contract.ActivityResultContracts
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.view.Menu
import android.view.MenuItem
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import com.journeyapps.barcodescanner.ScanContract
import com.journeyapps.barcodescanner.ScanOptions
import com.google.android.material.color.MaterialColors
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.helianz.qrismirror.databinding.ActivityMainBinding
import com.helianz.qrismirror.databinding.SheetSetupBinding
import org.json.JSONObject
import java.io.BufferedInputStream
import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.SocketException
import java.net.URI
import java.net.URL
import java.net.UnknownHostException
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.concurrent.ExecutorService
import java.util.concurrent.Executors

class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding
    private var setupSheet: BottomSheetDialog? = null
    private var setupBinding: SheetSetupBinding? = null
    private val scanLauncher = registerForActivityResult(ScanContract()) { result ->
        val scannedValue = result.contents?.trim().orEmpty()
        if (scannedValue.isBlank()) {
            return@registerForActivityResult
        }
        connectWithUrl(scannedValue)
    }
    private val executor: ExecutorService = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())
    private val pollRunnable = object : Runnable {
        override fun run() {
            if (isRefreshing || sessionUrl.isNullOrBlank()) {
                mainHandler.postDelayed(this, POLL_INTERVAL_MS)
                return
            }
            refreshSession(showLoading = false)
        }
    }

    private var sessionUrl: String? = null
    private var session: MirrorSession? = null
    private var lastUpdatedAt: Date? = null
    private var isConnecting = false
    private var isRefreshing = false
    private var lastImageKey: String? = null
    private var isStandby = false
    private var standbyImageUri: Uri? = null
    private lateinit var prefs: android.content.SharedPreferences

    private val imagePickerLauncher = registerForActivityResult(ActivityResultContracts.GetContent()) { uri: Uri? ->
        uri ?: return@registerForActivityResult
        try {
            contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
        } catch (_: Exception) {}
        prefs.edit().putString(PREF_STANDBY_IMAGE, uri.toString()).apply()
        standbyImageUri = uri
        setupBinding?.imageStandbyPreview?.setImageURI(uri)
        setupBinding?.imageStandbyPreview?.visibility = View.VISIBLE
        renderState()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        setSupportActionBar(binding.toolbar)
        prefs = getPreferences(Context.MODE_PRIVATE)
        // Restore saved standby image
        prefs.getString(PREF_STANDBY_IMAGE, null)?.let { uriStr ->
            try { standbyImageUri = Uri.parse(uriStr) } catch (_: Exception) {}
        }
        // Restore saved connection URL
        val savedUrl = prefs.getString(PREF_SESSION_URL, null)
        if (!savedUrl.isNullOrBlank()) {
            sessionUrl = savedUrl
        }
        bindActions()
        renderState()
        if (sessionUrl != null) {
            refreshSession(showLoading = true)
        }
    }

    override fun onDestroy() {
        mainHandler.removeCallbacksAndMessages(null)
        executor.shutdownNow()
        super.onDestroy()
    }

    private fun bindActions() {
        binding.fabScan.setOnClickListener { scanQrCode() }
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.menu_main, menu)
        return true
    }

    override fun onPrepareOptionsMenu(menu: Menu): Boolean {
        menu.findItem(R.id.action_disconnect)?.isEnabled = sessionUrl != null
        return super.onPrepareOptionsMenu(menu)
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        return when (item.itemId) {
            R.id.action_setup -> { showSetupSheet(); true }
            R.id.action_disconnect -> { disconnect(); true }
            else -> super.onOptionsItemSelected(item)
        }
    }

    private fun showSetupSheet() {
        val sb = setupBinding ?: SheetSetupBinding.inflate(layoutInflater).also { setupBinding = it }
        val sheet = setupSheet ?: BottomSheetDialog(this).also {
            it.setContentView(sb.root)
            setupSheet = it
        }
        sb.editSessionUrl.setText(sessionUrl.orEmpty())
        sb.buttonPaste.setOnClickListener { pasteFromClipboard() }
        sb.buttonScanQr.setOnClickListener { sheet.dismiss(); scanQrCode() }
        sb.buttonConnect.setOnClickListener { connect(); sheet.dismiss() }
        sb.buttonDisconnect.setOnClickListener { disconnect(); sheet.dismiss() }
        // Standby image picker
        standbyImageUri?.let { uri ->
            try {
                sb.imageStandbyPreview.setImageURI(uri)
                sb.imageStandbyPreview.visibility = View.VISIBLE
            } catch (_: Exception) {}
        }
        sb.buttonPickStandbyImage.setOnClickListener {
            imagePickerLauncher.launch("image/*")
        }
        renderState()
        sheet.show()
    }

    private fun scanQrCode() {
        hideError()
        val scanOptions = ScanOptions().apply {
            setDesiredBarcodeFormats(ScanOptions.QR_CODE)
            setPrompt(getString(R.string.scan_prompt))
            setBeepEnabled(false)
            setOrientationLocked(true)
        }
        scanLauncher.launch(scanOptions)
    }

    private fun pasteFromClipboard() {
        val clipboardManager = getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
        val clipData = clipboardManager.primaryClip ?: return
        if (clipData.itemCount == 0) {
            return
        }
        val pasted = clipData.getItemAt(0).coerceToText(this)?.toString()?.trim().orEmpty()
        if (pasted.isNotEmpty()) {
            setupBinding?.editSessionUrl?.setText(pasted)
        }
    }

    private fun connectWithUrl(rawUrl: String) {
        val normalizedUrl = normalizeSessionUrl(rawUrl)
        if (normalizedUrl == null) {
            showError(getString(R.string.error_invalid_link))
            return
        }
        stopPolling()
        sessionUrl = normalizedUrl
        isStandby = false
        session = null
        lastUpdatedAt = null
        lastImageKey = null
        prefs.edit().putString(PREF_SESSION_URL, normalizedUrl).apply()
        binding.imageQr.setImageDrawable(null)
        refreshSession(showLoading = true)
    }

    private fun connect() {
        connectWithUrl(setupBinding?.editSessionUrl?.text?.toString().orEmpty())
    }

    private fun disconnect() {
        stopPolling()
        sessionUrl = null
        session = null
        isStandby = false
        lastUpdatedAt = null
        lastImageKey = null
        isConnecting = false
        isRefreshing = false
        prefs.edit().remove(PREF_SESSION_URL).apply()
        setupBinding?.editSessionUrl?.text?.clear()
        binding.imageQr.setImageDrawable(null)
        hideError()
        invalidateOptionsMenu()
        renderState()
    }

    private fun refreshSession(showLoading: Boolean) {
        val url = sessionUrl ?: return
        if (showLoading) {
            isConnecting = true
        } else {
            isRefreshing = true
        }
        renderState()
        executor.execute {
            try {
                val nextSession = fetchSession(url) // null = standby state
                val imageBitmap = if (nextSession != null) loadBitmapIfNeeded(nextSession) else null
                mainHandler.post {
                    val oldSession = session
                    val nowStandby = (nextSession == null)
                    isStandby = nowStandby
                    session = nextSession
                    if (!nowStandby) {
                        lastUpdatedAt = Date()
                        if (imageBitmap != null) {
                            binding.imageQr.setImageBitmap(imageBitmap)
                        }
                    } else if (oldSession != null) {
                        // Cashier closed the form — clear QR so it reloads fresh next payment
                        binding.imageQr.setImageDrawable(null)
                        lastImageKey = null
                    }
                    hideError()
                    finishRefresh(nextSession?.isTerminal ?: false)
                }
            } catch (exception: Exception) {
                mainHandler.post {
                    showError(exception.message ?: getString(R.string.error_generic))
                    finishRefresh(stopPolling = false)
                }
            }
        }
    }

    private fun finishRefresh(stopPolling: Boolean) {
        isConnecting = false
        isRefreshing = false
        invalidateOptionsMenu()
        renderState()
        if (stopPolling) {
            stopPolling()
        } else if (sessionUrl != null) {
            // Continue polling even after an error so the phone auto-reconnects
            // when the cashier reopens the QR form
            startPolling()
        }
    }

    private fun startPolling() {
        mainHandler.removeCallbacks(pollRunnable)
        mainHandler.postDelayed(pollRunnable, POLL_INTERVAL_MS)
    }

    private fun stopPolling() {
        mainHandler.removeCallbacks(pollRunnable)
    }

    private fun fetchSession(url: String): MirrorSession? {
        val connection = (URL(url).openConnection() as HttpURLConnection).apply {
            requestMethod = "GET"
            connectTimeout = 5000
            readTimeout = 5000
            setRequestProperty("Accept", "application/json")
        }
        return try {
            val responseCode = connection.responseCode
            val stream = if (responseCode in 200..299) connection.inputStream else connection.errorStream
            val responseBody = stream?.use { input ->
                BufferedReader(InputStreamReader(input)).use { reader ->
                    reader.readText()
                }
            }.orEmpty()
            if (responseCode !in 200..299) {
                throw IllegalStateException(getString(R.string.error_unreachable, responseCode))
            }
            MirrorSession.fromJson(JSONObject(responseBody), url) // null when state=standby
        } catch (_: SocketException) {
            throw IllegalStateException(getString(R.string.error_socket))
        } catch (_: UnknownHostException) {
            throw IllegalStateException(getString(R.string.error_socket))
        } finally {
            connection.disconnect()
        }
    }

    private fun loadBitmapIfNeeded(session: MirrorSession): Bitmap? {
        val imageKey = session.primaryQrUrl ?: session.backupQrUrl ?: return null
        if (imageKey == lastImageKey && binding.imageQr.drawable != null) {
            return null
        }
        val bitmap = downloadBitmap(session.primaryQrUrl)
            ?: downloadBitmap(session.backupQrUrl)
            ?: return null
        lastImageKey = imageKey
        return bitmap
    }

    private fun downloadBitmap(url: String?): Bitmap? {
        if (url.isNullOrBlank()) {
            return null
        }
        val connection = (URL(url).openConnection() as HttpURLConnection).apply {
            requestMethod = "GET"
            connectTimeout = 5000
            readTimeout = 5000
        }
        return try {
            if (connection.responseCode !in 200..299) {
                null
            } else {
                BufferedInputStream(connection.inputStream).use { input ->
                    BitmapFactory.decodeStream(input)
                }
            }
        } catch (_: Exception) {
            null
        } finally {
            connection.disconnect()
        }
    }

    private fun showError(message: String) {
        binding.textError.text = message
        binding.cardError.visibility = View.VISIBLE
    }

    private fun hideError() {
        binding.cardError.visibility = View.GONE
        binding.textError.text = ""
    }

    private fun renderState() {
        val currentSession = session
        val sb = setupBinding
        val connected = sessionUrl != null

        // QR card display states
        val showQr = connected && !isStandby && currentSession != null
        binding.imageQr.visibility = if (showQr) View.VISIBLE else View.GONE
        binding.viewIdleOverlay.visibility = if (!connected) View.VISIBLE else View.GONE
        binding.viewStandbyOverlay.visibility = if (connected && isStandby) View.VISIBLE else View.GONE

        if (connected && isStandby) {
            val hasImage = standbyImageUri != null
            binding.imageStandby.visibility = if (hasImage) View.VISIBLE else View.GONE
            binding.textStandbyHint.visibility = if (!hasImage) View.VISIBLE else View.GONE
            if (hasImage) {
                try {
                    binding.imageStandby.setImageURI(standbyImageUri)
                } catch (_: Exception) {
                    binding.imageStandby.visibility = View.GONE
                    binding.textStandbyHint.visibility = View.VISIBLE
                }
            }
        }

        // Status and details only visible during an active payment
        binding.cardStatus.visibility = if (currentSession != null && !isStandby) View.VISIBLE else View.GONE
        binding.layoutQrDetails.visibility = if (currentSession != null && !isStandby) View.VISIBLE else View.GONE

        // Setup sheet controls (null-safe when sheet not yet opened)
        val loading = isConnecting || isRefreshing
        sb?.progressConnect?.visibility = if (loading) View.VISIBLE else View.GONE
        sb?.buttonConnect?.isEnabled = !isConnecting
        sb?.buttonPaste?.isEnabled = !isConnecting
        sb?.buttonScanQr?.isEnabled = !isConnecting
        sb?.buttonDisconnect?.isEnabled = connected || currentSession != null
        sb?.cardDetails?.visibility = if (currentSession != null) View.VISIBLE else View.GONE

        if (currentSession == null) {
            binding.textStatusHeadline.text = getString(R.string.status_idle_headline)
            binding.textStatusBody.text = getString(R.string.status_idle_body)
            sb?.textOrderValue?.text = getString(R.string.value_placeholder)
            sb?.textAmountValue?.text = getString(R.string.value_placeholder)
            sb?.textStateValue?.text = getString(R.string.value_placeholder)
            sb?.textExpiresValue?.text = getString(R.string.value_placeholder)
            binding.textLastSync.text = if (isStandby)
                getString(R.string.last_sync_standby)
            else
                getString(R.string.last_sync_waiting)
            return
        }

        binding.textStatusHeadline.text = currentSession.statusHeadline(this)
        binding.textStatusBody.text = currentSession.statusDisplay
        binding.textQrAmount.text = formatIdr(currentSession.amountIdr)
        binding.textQrOrderId.text = "Ref. ID: ${currentSession.orderId}"
        binding.textQrExpiry.text = if (currentSession.isExpired)
            "Expired: ${currentSession.expiryLabel(this)}"
        else
            "Expires: ${currentSession.expiryLabel(this)}"
        sb?.textOrderValue?.text = currentSession.orderId
        sb?.textAmountValue?.text = formatIdr(currentSession.amountIdr)
        sb?.textStateValue?.text = currentSession.status
        sb?.textExpiresValue?.text = currentSession.expiryLabel(this)
        binding.textLastSync.text = lastUpdatedAt?.let {
            getString(R.string.last_sync_format, SimpleDateFormat("HH:mm:ss", Locale.US).format(it))
        } ?: getString(R.string.last_sync_waiting)

        val backgroundColor = currentSession.statusBackgroundColor(this)
        val foregroundColor = currentSession.statusForegroundColor(this)
        binding.cardStatus.setCardBackgroundColor(backgroundColor)
        binding.textStatusHeadline.setTextColor(foregroundColor)
        binding.textStatusBody.setTextColor(foregroundColor)
    }

    private fun normalizeSessionUrl(rawValue: String): String? {
        val trimmed = rawValue.trim()
        if (trimmed.isEmpty()) {
            return null
        }
        val parsedUri = try {
            URI(trimmed)
        } catch (_: Exception) {
            return null
        }
        if (parsedUri.scheme.isNullOrBlank() || parsedUri.host.isNullOrBlank()) {
            return null
        }
        if (parsedUri.scheme != "http" && parsedUri.scheme != "https") {
            return null
        }
        val normalizedPath = parsedUri.path.trimEnd('/')
        return URI(
            parsedUri.scheme,
            parsedUri.userInfo,
            parsedUri.host,
            parsedUri.port,
            normalizedPath,
            parsedUri.query,
            parsedUri.fragment
        ).toString()
    }

    private fun formatIdr(amount: Int): String {
        val rawDigits = kotlin.math.abs(amount).toString()
        val builder = StringBuilder()
        rawDigits.forEachIndexed { index, char ->
            val remaining = rawDigits.length - index
            builder.append(char)
            if (remaining > 1 && remaining % 3 == 1) {
                builder.append('.')
            }
        }
        val prefix = if (amount < 0) "-Rp " else "Rp "
        return prefix + builder.toString()
    }

    companion object {
        private const val POLL_INTERVAL_MS = 1000L
        private const val PREF_SESSION_URL = "session_url"
        private const val PREF_STANDBY_IMAGE = "standby_image_uri"
    }
}

private data class MirrorSession(
    val orderId: String,
    val amountIdr: Int,
    val status: String,
    val statusDisplay: String,
    val isSettled: Boolean,
    val isExpired: Boolean,
    val expiresAtRaw: String?,
    val primaryQrUrl: String?,
    val backupQrUrl: String?
) {

    val isTerminal: Boolean
        get() = isSettled || isExpired || status.equals("cancel", true) || status.equals("deny", true) || status.equals("error", true)

    fun statusHeadline(context: Context): String {
        return when {
            isSettled -> context.getString(R.string.status_paid_headline)
            isExpired -> context.getString(R.string.status_expired_headline)
            status.equals("cancel", true) -> context.getString(R.string.status_cancelled_headline)
            status.equals("deny", true) -> context.getString(R.string.status_denied_headline)
            status.equals("error", true) -> context.getString(R.string.status_error_headline)
            else -> context.getString(R.string.status_waiting_headline)
        }
    }

    fun statusBackgroundColor(context: Context): Int {
        return when {
            isSettled -> Color.parseColor("#E7F6EE")
            isExpired -> Color.parseColor("#FFF1E3")
            status.equals("cancel", true) || status.equals("deny", true) || status.equals("error", true) -> Color.parseColor("#FFE9E7")
            else -> MaterialColors.getColor(context, com.google.android.material.R.attr.colorPrimaryContainer, Color.parseColor("#DDEFEA"))
        }
    }

    fun statusForegroundColor(context: Context): Int {
        return when {
            isSettled -> Color.parseColor("#0E6A47")
            isExpired -> Color.parseColor("#A45A15")
            status.equals("cancel", true) || status.equals("deny", true) || status.equals("error", true) -> Color.parseColor("#A3342C")
            else -> MaterialColors.getColor(context, com.google.android.material.R.attr.colorOnPrimaryContainer, Color.parseColor("#123A34"))
        }
    }

    fun expiryLabel(context: Context): String {
        if (expiresAtRaw.isNullOrBlank()) {
            return context.getString(R.string.value_unknown)
        }
        return try {
            val instant = java.time.Instant.parse(expiresAtRaw)
            val local = java.time.ZonedDateTime.ofInstant(instant, java.time.ZoneId.systemDefault())
            String.format(Locale.US, "%02d:%02d", local.hour, local.minute)
        } catch (_: Exception) {
            context.getString(R.string.value_unknown)
        }
    }

    companion object {
        fun fromJson(jsonObject: JSONObject, baseUrl: String): MirrorSession? {
            val state = jsonObject.optString("state", "active")
            if (state == "standby") return null
            val expiresAtRaw = if (jsonObject.has("expiresAt") && !jsonObject.isNull("expiresAt")) {
                jsonObject.optString("expiresAt")
            } else {
                null
            }
            return MirrorSession(
                orderId = jsonObject.optString("orderId", "Unknown"),
                amountIdr = jsonObject.optInt("amountIdr", 0),
                status = jsonObject.optString("status", "Unknown"),
                statusDisplay = jsonObject.optString("statusDisplay", "Waiting for payment..."),
                isSettled = jsonObject.optBoolean("isSettled", false),
                isExpired = jsonObject.optBoolean("isExpired", false),
                expiresAtRaw = expiresAtRaw,
                primaryQrUrl = resolveUrl(baseUrl, jsonObject.optString("qrImageUrl", "")),
                backupQrUrl = resolveUrl(baseUrl, jsonObject.optString("remoteQrCodeUrl", ""))
            )
        }

        private fun resolveUrl(baseUrl: String, raw: String?): String? {
            if (raw.isNullOrBlank()) {
                return null
            }
            return try {
                URI(baseUrl).resolve(raw).toString()
            } catch (_: Exception) {
                raw
            }
        }
    }
}