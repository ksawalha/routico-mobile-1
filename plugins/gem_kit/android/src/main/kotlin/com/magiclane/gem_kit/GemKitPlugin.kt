/*
 * SPDX-FileCopyrightText: 1995-2025 Magic Lane Intellectual Property B.V. <info@magiclane.com>
 * SPDX-License-Identifier: LicenseRef-MagicLane-Proprietary
 *
 * Magic Lane Intellectual Property B.V, its affiliates and licensors retain all 
 * intellectual property and proprietary rights in and to this material, related
 * documentation and any modifications thereto. Any use, reproduction,
 * disclosure or distribution of this material and related documentation
 * without an express license agreement from Magic Lane Intellectual Property B.V. 
 * or its affiliates is strictly prohibited.
 */

package com.magiclane.gem_kit

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.app.Application
import android.app.Activity
import android.content.Context
import android.os.Bundle
import android.os.Environment
import com.magiclane.sdk.util.SdkCall
import com.magiclane.sdk.core.GemSdk
import com.magiclane.sdk.core.ApiCallLogger
import com.magiclane.sdk.core.SdkSettings
import com.magiclane.sdk.core.ProgressListener
import com.magiclane.sdk.core.ProxyDetails
import com.magiclane.sdk.flutter.FlutterChannel
import com.magiclane.sdk.flutter.FlutterMethodListener
import com.magiclane.sdk.core.GemError
import com.magiclane.sdk.util.Util
import org.json.JSONArray
import org.json.JSONObject
import com.magiclane.sdk.core.DataBuffer
import com.magiclane.sdk.util.*
import com.magiclane.sdk.core.SoundPlayingListener
import com.magiclane.sdk.core.SoundPlayingPreferences
import com.magiclane.sdk.core.SoundPlayingService
import com.magiclane.sdk.core.INetworkListener
import com.magiclane.sdk.core.NetworkListener
import com.magiclane.sdk.core.ENetworkType
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.io.File

/** GemKitPlugin */
class GemKitPlugin : FlutterPlugin, MethodCallHandler, Application.ActivityLifecycleCallbacks,ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var defaultNetworkManager: NetworkManager
    private lateinit var customApiCallLogger: CustomApiCallLogger
    lateinit var flutterPluginBinding: FlutterPluginBinding
    private lateinit var gemEngineChannel: MethodChannel
    private val networkProvider = DefaultNetworkProvider // Make networkProvider a member of the class
    var eventQueue = mutableListOf<EventCustom>()
    var lockEvent = Any()
    var isPosting = false
    private var activity : Activity? = null
    private val networkListeners = mutableListOf<NetworkListener>()

    private val flutterNetworkListener = object : NetworkListener() {
        private val mainHandler = Handler(Looper.getMainLooper())

        override fun onConnectFinished(
            connectResult: Int,
            networkType: ENetworkType,
            https: ProxyDetails,
            http: ProxyDetails
        ) {
            mainHandler.post {
                val data = mapOf(
                    "event" to "onConnectFinished",
                    "result" to connectResult,
                    "networkType" to networkType.name,
                    "https" to https.toString(),
                    "http" to http.toString()
                )
                gemEngineChannel.invokeMethod("networkEvent", data)
            }
        }

        override fun onNetworkFailed(errorCode: Int) {
            mainHandler.post {
                val data = mapOf(
                    "event" to "onNetworkFailed",
                    "errorCode" to errorCode
                )
                gemEngineChannel.invokeMethod("networkEvent", data)
            }
        }

        override fun onMobileCountryCodeChanged(mcc: Int) {
            mainHandler.post {
                val data = mapOf(
                    "event" to "onMobileCountryCodeChanged",
                    "mcc" to mcc
                )
                gemEngineChannel.invokeMethod("networkEvent", data)
            }
        }
    }

    init {
        addNetworkListener(flutterNetworkListener)
    }

    fun addNetworkListener(listener: NetworkListener) {
        networkListeners.add(listener)
        DefaultNetworkProvider.addListener(listener)
    }

    fun removeNetworkListener(listener: NetworkListener) {
        networkListeners.remove(listener)
        DefaultNetworkProvider.removeListener(listener)
    }

    private fun setDefaultNetworkProvider(context: Context, lambdaAllowConnection: Boolean? = null) {
        try {
            defaultNetworkManager = NetworkManager(context.applicationContext)

            defaultNetworkManager.onConnectionTypeChangedCallback = { type: NetworkManager.EConnectionType, https: ProxyDetails, http: ProxyDetails ->
                networkProvider.onNetworkConnectionTypeChanged(type, https, http)
            }

            SdkSettings.networkProvider = networkProvider
            lambdaAllowConnection?.let { SdkSettings.setAllowConnection(it) }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }

     private fun getUseInternalPath(context: Context): Boolean {
        return try {
            val appPackageName = context.packageName
            val buildConfigClass = Class.forName("$appPackageName.BuildConfig")
            val field = buildConfigClass.getField("USE_INTERNAL_PATH")
            field.getBoolean(null)
        } catch (e: Exception) {
            // Fallback to plugin's default
            BuildConfig.USE_INTERNAL_PATH
        }
    }
  fun initializeGemSdkIfNeeded(context: Context, activity: Activity?, setNetworkProvider: Boolean = true) {
        if (!GemSdk.isInitialized()) {
            SdkCall.reinit()
            SdkSettings.setAllowAutoMapUpdate(true)
            val sdkInitProgress = ProgressListener.create(
                onCompleted = { _, _ -> GemSdk.notifyEngineInit() },
            )
            if(SdkCall.isLocked()) {
                SdkCall.reinit()
            }

          val internalPath = if (getUseInternalPath(flutterPluginBinding.applicationContext)) getInternalPath(flutterPluginBinding.applicationContext) else null
            SdkCall.execute {
                GemSdk.initialize(
                    context = context,
                    activity = activity,
                    listener = sdkInitProgress,
                    internalPath = internalPath,
                )
            }
        }
        SdkCall.execute {
            if (setNetworkProvider) {
                setDefaultNetworkProvider(context, true)
            }
        }
    }

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
        this.flutterPluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.flutter.dev/gem_maps")
        channel.setMethodCallHandler(this)
//       initializeGemSdkIfNeeded(
//           context = flutterPluginBinding.applicationContext,
//           activity = null,
//           setNetworkProvider = true
//       )

        flutterPluginBinding
            .platformViewRegistry
            .registerViewFactory("plugins.flutter.dev/gem_maps", GemMapViewFactory(this, flutterPluginBinding.flutterAssets))

        gemEngineChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.flutter.dev/gem_engine")
        gemEngineChannel.setMethodCallHandler { call, result ->
            handleGemEngineMethodCall(call, result)
        }

        val appContext = flutterPluginBinding.applicationContext as Application
        appContext.registerActivityLifecycleCallbacks(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        if (call.method == "getPlatformVersion") {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
        } else {
            result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        val appContext = binding.applicationContext as Application
        appContext.unregisterActivityLifecycleCallbacks(this)
    }

    override fun onActivityPaused(activity: Activity) {
        SdkCall.execute {
            if (GemSdk.isInitialized())
                GemSdk.notifyBackgroundEvent(GemSdk.EBackgroundEvent.EnterBackground)
        }
    }

    override fun onActivityResumed(activity: Activity) {
        SdkCall.execute {
            if (GemSdk.isInitialized())
                GemSdk.notifyBackgroundEvent(GemSdk.EBackgroundEvent.LeaveBackground)
        }
    }

    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
       initializeGemSdkIfNeeded(
           context = activity.applicationContext,
           activity = activity,
           setNetworkProvider = true
        )
    }

    override fun onActivityStarted(activity: Activity) {
        // Called when the activity is started
    }

    override fun onActivityStopped(activity: Activity) {
        // Called when the activity is stopped
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
    }

    override fun onActivityDestroyed(activity: Activity) {
    }

    private fun handleGemEngineMethodCall(call: MethodCall, result: Result) {
        if (call.arguments != null) {
            if (call.method == "networkProviderCall") {
                handleNetworkProviderCall(call.arguments as String, result)
                return
            }
            if (call.method == "setLogLevel") {
                val jsonString = call.arguments as? String
                if (jsonString == null) {
                    result.error("NO_ARGUMENT", "Expected a JSON string", null)
                    return
                }
            
                val jsonResult = runCatching {
                    JSONObject(jsonString)
                }
            
                val json = jsonResult.getOrNull()
                if (json == null) {
                    result.error("INVALID_JSON", "Could not parse JSON", null)
                    return
                }
            
                val level = json.optInt("level", 0)
                customApiCallLogger.logLevel = level
            
                result.success(true)
                return
            }
            if(call.method =="releaseEngine"){
                SdkCall.execute {
                    GemSdk.release()
                    result.success(true)
                }
                return
            }
            if(call.method == "initializeGemSdk"){
                val context = flutterPluginBinding.applicationContext
                val activity = context as? Activity
                initializeGemSdkIfNeeded(context, activity, true)
                result.success(true)
                return
            }

            val flutterMethodListener = FlutterMethodListener.create(
                onNotifyComplete = { err, retDetails, _ ->
                    if (err == GemError.NoError) {
                        val returnedResult = retDetails.bytes?.let { String(it) } ?: ""
                        result.success(returnedResult)
                    } else {
                        result.error(err.toString(), GemError.getMessage(err), null)
                    }
                },
                onNotifyEvent = { eventName, eventDetails, _ ->
                    if (eventName.isNotEmpty()) {
                        val arguments = eventDetails.bytes?.let { String(it) } ?: ""
                        if (!isPosting) {
                            isPosting = true
                            synchronized(lockEvent) {
                                eventQueue.add(EventCustom(eventName, arguments, true))
                            }
                            Util.postOnMainDelayed({
                                val jsonArray = JSONArray()
                                synchronized(lockEvent) {
                                    for (eventCustom in eventQueue) {
                                        if (eventCustom != null) {
                                            val jsonObject = JSONObject()
                                            jsonObject.put("eventName", eventCustom.eventName)
                                            jsonObject.put("arguments", eventCustom.arguments)
                                            jsonArray.put(jsonObject)
                                            eventCustom.valid = false
                                        }
                                    }
                                    eventQueue.removeIf { eventCustom -> !eventCustom.valid }
                                }
                                val jsonArrayAsString = jsonArray.toString()
                                gemEngineChannel.invokeMethod("notifyEvents", jsonArrayAsString)
                                isPosting = false
                            })
                        } else {
                            synchronized(lockEvent) {
                                eventQueue.add(EventCustom(eventName, arguments, true))
                            }
                        }
                    }
                },
                onNotifyException = { _, _ ->
                    return@create GemError.NotSupported.toLong()
                }
            )

            SdkCall.execute {
                val args = DataBuffer((call.arguments as String).toByteArray())

                val ret = FlutterChannel.parseMethod(call.method, args, flutterMethodListener)
                if (ret != GemError.NoError) {
                    if (ret == GemError.NotSupported) {
                        result.notImplemented()
                    } else {
                        result.error(ret.toString(), GemError.getMessage(ret), null)
                    }
                }
            }
        }
    }

    private fun handleNetworkProviderCall(jsonCall: String, result: Result) {
        try {
            val jsonObject = JSONObject(jsonCall)
            val action = jsonObject.getString("action")

            when (action) {
                "isConnected" -> {
                    result.success(networkProvider.isConnected())
                }
                "isWifiConnected" -> {
                    result.success(networkProvider.isWifiConnected())
                }
                "isMobileDataConnected" -> {
                    result.success(networkProvider.isMobileDataConnected())
                }
                "getNetworkName" -> {
                    val connected = jsonObject.getBoolean("connected")
                    val networkType = ENetworkType.valueOf(jsonObject.getString("networkType"))
                    result.success(networkProvider.getNetworkName(connected, networkType))
                }
                "refreshNetwork" ->{
                    if(networkProvider.isMobileDataConnected())
                    defaultNetworkManager.refreshConnection(NetworkManager.EConnectionType.Mobile)
                    else
                    defaultNetworkManager.refreshConnection(NetworkManager.EConnectionType.Wifi)
                     result.success(true);
                }
                else -> {
                    result.error("INVALID_ACTION", "Action $action is not supported", null)
                }
            }
        } catch (e: Exception) {
            result.error("JSON_ERROR", "Failed to parse JSON: ${e.message}", null)
        }
    }

private fun getInternalPath(context: Context): String {
        try
        {
            val fileList = context.getExternalFilesDirs(Environment.DIRECTORY_DOWNLOADS)
            if (fileList != null)
            {
                for (i in fileList.indices)
                {
                    if ((fileList[i] != null) && fileList[i].absolutePath.isNotEmpty() && isValidStorage(
                            fileList[i]
                        )
                    )
                    {
                        val file = File(fileList[i].absolutePath, "MAGICEARTH")
                        return file.absolutePath ?: ""
                    }
                }
            }
        }
        catch (_: Throwable)
        {
        }

        return ""
    }


    private fun isValidStorage(path: File): Boolean
    {
         val testFolderName = "qazxywqazwsx"


        try
        {
            if (path.isDirectory && path.canRead() && path.canWrite())
            {
                val file = File(path, testFolderName)

                    file.delete()

                if (file.mkdir())
                {

                      return  file.delete()

                }

                GEMLog.debug(
                    this,
                    "AppUtils.isValidStorage(): path ${path.absolutePath} is not valid"
                )
            }
        }
        catch (_: Exception)
        {
        }
        return false
    }
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        initializeGemSdkIfNeeded(
            context = activity!!.applicationContext,
            activity = activity,
            setNetworkProvider = true
        )
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        activity = null
    }
}
