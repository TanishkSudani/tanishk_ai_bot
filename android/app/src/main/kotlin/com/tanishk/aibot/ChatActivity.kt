package com.tanishk.aibot

import android.os.Bundle
import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import java.text.SimpleDateFormat
import java.util.*

class ChatActivity : AppCompatActivity() {

    private lateinit var tvName: TextView
    private lateinit var tvStatus: TextView
    private lateinit var tvInitials: TextView
    private lateinit var recycler: RecyclerView
    private lateinit var etMessage: EditText
    private lateinit var btnSend: ImageButton
    private lateinit var btnBack: ImageButton

    private val messages = mutableListOf<ChatMessage>()
    private lateinit var adapter: ChatAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_chat)

        val name = intent.getStringExtra("name") ?: "Unknown"
        val number = intent.getStringExtra("number") ?: ""
        val language = intent.getStringExtra("language") ?: ""
        val initials = intent.getStringExtra("initials") ?: "?"
        val lastMsg = intent.getStringExtra("lastMsg") ?: ""

        initViews()

        tvName.text = name
        tvStatus.text = "$number · $language · AI handled"
        tvInitials.text = initials

        // Add AI summary bubble
        messages.add(ChatMessage(
            text = "📞 Call Summary\n\n" +
                   "👤 Name: $name\n" +
                   "📱 Contact: $number\n" +
                   "🌐 Language: $language\n" +
                   "⏱ Duration: 2m 14s\n\n" +
                   "📋 Query: $lastMsg\n\n" +
                   "🤖 Bot handled this call successfully.\n" +
                   "✅ Status: Resolved",
            isBot = true,
            time = getCurrentTime(),
            label = "AI Summary"
        ))

        adapter = ChatAdapter(messages)
        recycler.layoutManager = LinearLayoutManager(this).apply {
            stackFromEnd = true
        }
        recycler.adapter = adapter

        btnBack.setOnClickListener {
            finish()
            overridePendingTransition(android.R.anim.fade_in, android.R.anim.slide_out_right)
        }

        btnSend.setOnClickListener { sendMessage() }

        etMessage.setOnEditorActionListener { _, _, _ ->
            sendMessage()
            true
        }
    }

    private fun initViews() {
        tvName = findViewById(R.id.tv_chat_name)
        tvStatus = findViewById(R.id.tv_chat_status)
        tvInitials = findViewById(R.id.tv_chat_initials)
        recycler = findViewById(R.id.chat_recycler)
        etMessage = findViewById(R.id.et_message)
        btnSend = findViewById(R.id.btn_send)
        btnBack = findViewById(R.id.btn_back)
    }

    private fun sendMessage() {
        val text = etMessage.text.toString().trim()
        if (text.isEmpty()) return
        messages.add(ChatMessage(text = text, isBot = false, time = getCurrentTime()))
        etMessage.setText("")
        adapter.notifyItemInserted(messages.size - 1)
        recycler.scrollToPosition(messages.size - 1)

        // Simulate bot reply
        recycler.postDelayed({
            messages.add(ChatMessage(
                text = "✅ Got it! I'll look into this for you and update you shortly.",
                isBot = true,
                time = getCurrentTime(),
                label = "BotHub AI"
            ))
            adapter.notifyItemInserted(messages.size - 1)
            recycler.scrollToPosition(messages.size - 1)
        }, 1000)
    }

    private fun getCurrentTime(): String {
        return SimpleDateFormat("hh:mm a", Locale.getDefault()).format(Date())
    }

    override fun onBackPressed() {
        super.onBackPressed()
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.slide_out_right)
    }
}

data class ChatMessage(
    val text: String,
    val isBot: Boolean,
    val time: String,
    val label: String = ""
)
