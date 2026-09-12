package com.tanishk.aibot

import android.os.Bundle
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import androidx.preference.PreferenceManager
import com.google.android.material.switchmaterial.SwitchMaterial

class SettingsActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_settings)

        val prefs = PreferenceManager.getDefaultSharedPreferences(this)

        // Back button
        findViewById<ImageButton>(R.id.btn_settings_back).setOnClickListener { finish() }

        // Load saved values
        val etBotName = findViewById<EditText>(R.id.et_bot_name)
        val etBusiness = findViewById<EditText>(R.id.et_business_name)
        val etWaNumber = findViewById<EditText>(R.id.et_wa_number)
        val etTwilioSid = findViewById<EditText>(R.id.et_twilio_sid)
        val etTwilioToken = findViewById<EditText>(R.id.et_twilio_token)
        val etClaudeKey = findViewById<EditText>(R.id.et_claude_key)
        val etDeepgramKey = findViewById<EditText>(R.id.et_deepgram_key)
        val swAutoLang = findViewById<SwitchMaterial>(R.id.sw_auto_lang)
        val swSendWa = findViewById<SwitchMaterial>(R.id.sw_send_wa)
        val swRecord = findViewById<SwitchMaterial>(R.id.sw_record)
        val swUrgent = findViewById<SwitchMaterial>(R.id.sw_urgent)
        val btnSave = findViewById<Button>(R.id.btn_save_settings)

        etBotName.setText(prefs.getString("bot_name", "Priya"))
        etBusiness.setText(prefs.getString("business_name", ""))
        etWaNumber.setText(prefs.getString("wa_number", ""))
        etTwilioSid.setText(prefs.getString("twilio_sid", ""))
        etTwilioToken.setText(prefs.getString("twilio_token", ""))
        etClaudeKey.setText(prefs.getString("claude_key", ""))
        etDeepgramKey.setText(prefs.getString("deepgram_key", ""))
        swAutoLang.isChecked = prefs.getBoolean("auto_lang", true)
        swSendWa.isChecked = prefs.getBoolean("send_wa", true)
        swRecord.isChecked = prefs.getBoolean("record", true)
        swUrgent.isChecked = prefs.getBoolean("urgent_flag", true)

        btnSave.setOnClickListener {
            prefs.edit().apply {
                putString("bot_name", etBotName.text.toString())
                putString("business_name", etBusiness.text.toString())
                putString("wa_number", etWaNumber.text.toString())
                putString("twilio_sid", etTwilioSid.text.toString())
                putString("twilio_token", etTwilioToken.text.toString())
                putString("claude_key", etClaudeKey.text.toString())
                putString("deepgram_key", etDeepgramKey.text.toString())
                putBoolean("auto_lang", swAutoLang.isChecked)
                putBoolean("send_wa", swSendWa.isChecked)
                putBoolean("record", swRecord.isChecked)
                putBoolean("urgent_flag", swUrgent.isChecked)
                apply()
            }
            Toast.makeText(this, "✅ Settings saved!", Toast.LENGTH_SHORT).show()
            finish()
        }
    }
}
