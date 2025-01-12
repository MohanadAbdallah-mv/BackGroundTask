package com.bgtask.backgroundtask

import android.Manifest
import android.content.Intent
import android.os.Bundle
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(){
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION,
                Manifest.permission.ACCESS_COARSE_LOCATION),
            0
            )
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine){
        super.configureFlutterEngine(flutterEngine)
        val channel="flutter_channel"

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,channel)
            .setMethodCallHandler{call,result ->
                when (call.method){
                    "getLocation"->{
                        val location=Intent(applicationContext,LocationService::class.java).apply {
                            action=LocationService.ACTION_START
                            startService(this)
                        }
                        result.success(location.toString())
                    }
                    "stopLocation"->{
                        val location=Intent(applicationContext,LocationService::class.java).apply {
                            action=LocationService.ACTION_STOP
                            startService(this)
                        }
                        result.success(location.toString())
                    }
                }
            }
    }
}
