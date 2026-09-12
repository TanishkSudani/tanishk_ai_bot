package com.tanishk.aibot

import android.content.Intent
import android.os.Bundle
import android.view.MenuItem
import android.view.View
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.google.android.material.bottomnavigation.BottomNavigationView
import com.google.android.material.card.MaterialCardView
import com.google.android.material.floatingactionbutton.FloatingActionButton
import java.util.*

class MainActivity : AppCompatActivity() {

    private lateinit var bottomNav: BottomNavigationView
    private lateinit var dashboardView: View
    private lateinit var callsView: View
    private lateinit var liveView: View

    // Stats
    private lateinit var tvTotalCalls: TextView
    private lateinit var tvWaSent: TextView
    private lateinit var tvLanguages: TextView
    private lateinit var tvUptime: TextView
    private lateinit var tvGreeting: TextView
    private lateinit var tvLiveTimer: TextView
    private lateinit var tvLiveCallerName: TextView
    private lateinit var tvLiveCallerNum: TextView

    private lateinit var callsRecycler: RecyclerView
    private lateinit var homeCallsRecycler: RecyclerView

    private var callSeconds = 134
    private val timerHandler = android.os.Handler(android.os.Looper.getMainLooper())

    private val callList = listOf(
        CallItem("Rahul Shah", "+91 98765 43210", "Gujarati", "in", "Delivery query · Resolved ✅", "2m ago", true, "RS"),
        CallItem("Priya Patel", "+91 77001 22334", "Hindi", "miss", "Missed · Summary sent ⚠️", "8m ago", false, "PP"),
        CallItem("Amit Verma", "+91 90012 33445", "Gujarati", "in", "New order enquiry · Action needed", "18m ago", false, "AV"),
        CallItem("Maria D'Souza", "+91 88997 66554", "English", "in", "Business hours query · Done ✅", "1h ago", true, "MD"),
        CallItem("Ravi Kumar", "+91 70011 88223", "Tamil", "out", "Callback scheduled", "2h ago", true, "RK"),
        CallItem("Anjali Mehta", "+91 95555 12312", "Gujarati", "in", "Refund request · Escalated", "3h ago", true, "AM"),
        CallItem("Unknown", "+91 80033 99001", "Hindi", "miss", "Dropped call · 22 seconds", "4h ago", true, "?"),
    )

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        initViews()
        setupBottomNav()
        setupRecyclers()
        setupGreeting()
        startTimer()
        setupClickListeners()
        showDashboard()
    }

    private fun initViews() {
        bottomNav = findViewById(R.id.bottom_nav)
        dashboardView = findViewById(R.id.view_dashboard)
        callsView = findViewById(R.id.view_calls)
        liveView = findViewById(R.id.view_live)

        tvTotalCalls = findViewById(R.id.tv_total_calls)
        tvWaSent = findViewById(R.id.tv_wa_sent)
        tvLanguages = findViewById(R.id.tv_languages)
        tvUptime = findViewById(R.id.tv_uptime)
        tvGreeting = findViewById(R.id.tv_greeting)
        tvLiveTimer = findViewById(R.id.tv_live_timer)
        tvLiveCallerName = findViewById(R.id.tv_live_caller_name)
        tvLiveCallerNum = findViewById(R.id.tv_live_caller_num)

        callsRecycler = findViewById(R.id.calls_recycler)
        homeCallsRecycler = findViewById(R.id.home_calls_recycler)
    }

    private fun setupGreeting() {
        val hour = Calendar.getInstance().get(Calendar.HOUR_OF_DAY)
        val greeting = when {
            hour < 12 -> "Good morning ☀️ Bot is active"
            hour < 17 -> "Good afternoon 🌤️ Bot is active"
            else -> "Good evening 🌙 Bot is active"
        }
        tvGreeting.text = greeting

        // Animate stats
        animateCount(tvTotalCalls, 247)
        animateCount(tvWaSent, 89)
        tvLanguages.text = "12"
        tvUptime.text = "98%"
    }

    private fun animateCount(tv: TextView, target: Int) {
        var current = 0
        val step = (target / 40).coerceAtLeast(1)
        val r = Runnable {  }
        val handler = android.os.Handler(android.os.Looper.getMainLooper())
        fun tick() {
            current = (current + step).coerceAtMost(target)
            tv.text = current.toString()
            if (current < target) handler.postDelayed({ tick() }, 25)
        }
        tick()
    }

    private fun setupRecyclers() {
        val adapter = CallAdapter(callList) { call -> openChat(call) }
        callsRecycler.layoutManager = LinearLayoutManager(this)
        callsRecycler.adapter = adapter
        callsRecycler.isNestedScrollingEnabled = false

        val homeAdapter = CallAdapter(callList.take(4)) { call -> openChat(call) }
        homeCallsRecycler.layoutManager = LinearLayoutManager(this)
        homeCallsRecycler.adapter = homeAdapter
        homeCallsRecycler.isNestedScrollingEnabled = false
    }

    private fun setupBottomNav() {
        bottomNav.setOnItemSelectedListener { item: MenuItem ->
            when (item.itemId) {
                R.id.nav_home -> { showDashboard(); true }
                R.id.nav_calls -> { showCalls(); true }
                R.id.nav_live -> { showLive(); true }
                R.id.nav_settings -> {
                    startActivity(Intent(this, SettingsActivity::class.java))
                    true
                }
                else -> false
            }
        }
    }

    private fun setupClickListeners() {
        // Live call card tap -> go to live view
        findViewById<MaterialCardView>(R.id.card_live_call).setOnClickListener {
            bottomNav.selectedItemId = R.id.nav_live
        }
        // FAB settings
        try {
            findViewById<FloatingActionButton>(R.id.fab_settings)?.setOnClickListener {
                startActivity(Intent(this, SettingsActivity::class.java))
            }
        } catch (_: Exception) {}
    }

    private fun openChat(call: CallItem) {
        val intent = Intent(this, ChatActivity::class.java).apply {
            putExtra("name", call.name)
            putExtra("number", call.number)
            putExtra("language", call.language)
            putExtra("initials", call.initials)
            putExtra("lastMsg", call.preview)
        }
        startActivity(intent)
        overridePendingTransition(android.R.anim.slide_in_left, android.R.anim.fade_out)
    }

    private fun showDashboard() {
        dashboardView.visibility = View.VISIBLE
        callsView.visibility = View.GONE
        liveView.visibility = View.GONE
    }

    private fun showCalls() {
        dashboardView.visibility = View.GONE
        callsView.visibility = View.VISIBLE
        liveView.visibility = View.GONE
    }

    private fun showLive() {
        dashboardView.visibility = View.GONE
        callsView.visibility = View.GONE
        liveView.visibility = View.VISIBLE
    }

    private fun startTimer() {
        timerHandler.post(object : Runnable {
            override fun run() {
                callSeconds++
                val m = (callSeconds / 60).toString().padStart(2, '0')
                val s = (callSeconds % 60).toString().padStart(2, '0')
                try {
                    tvLiveTimer.text = "$m:$s"
                } catch (_: Exception) {}
                timerHandler.postDelayed(this, 1000)
            }
        })
    }

    override fun onDestroy() {
        super.onDestroy()
        timerHandler.removeCallbacksAndMessages(null)
    }
}

data class CallItem(
    val name: String,
    val number: String,
    val language: String,
    val type: String, // "in", "out", "miss"
    val preview: String,
    val time: String,
    val resolved: Boolean,
    val initials: String
)
