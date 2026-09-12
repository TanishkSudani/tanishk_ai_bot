package com.tanishk.aibot

import android.graphics.Color
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class CallAdapter(
    private val items: List<CallItem>,
    private val onClick: (CallItem) -> Unit
) : RecyclerView.Adapter<CallAdapter.VH>() {

    inner class VH(v: View) : RecyclerView.ViewHolder(v) {
        val avatarBg: View = v.findViewById(R.id.avatar_bg)
        val tvInitials: TextView = v.findViewById(R.id.tv_initials)
        val tvName: TextView = v.findViewById(R.id.tv_call_name)
        val tvNumber: TextView = v.findViewById(R.id.tv_call_number)
        val tvPreview: TextView = v.findViewById(R.id.tv_call_preview)
        val tvTime: TextView = v.findViewById(R.id.tv_call_time)
        val tvType: TextView = v.findViewById(R.id.tv_call_type)
        val tvLang: TextView = v.findViewById(R.id.tv_call_lang)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
        val v = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_call, parent, false)
        return VH(v)
    }

    override fun onBindViewHolder(h: VH, pos: Int) {
        val c = items[pos]
        h.tvInitials.text = c.initials
        h.tvName.text = c.name
        h.tvNumber.text = c.number
        h.tvPreview.text = c.preview
        h.tvTime.text = c.time
        h.tvLang.text = c.language

        // Call type indicator
        when (c.type) {
            "in"   -> { h.tvType.text = "↙"; h.tvType.setTextColor(Color.parseColor("#22c55e")) }
            "out"  -> { h.tvType.text = "↗"; h.tvType.setTextColor(Color.parseColor("#3b82f6")) }
            "miss" -> { h.tvType.text = "↙"; h.tvType.setTextColor(Color.parseColor("#ef4444")) }
        }

        // Avatar colors
        val colors = listOf("#3b82f6","#a855f7","#f59e0b","#22c55e","#ef4444","#06b6d4")
        val color = colors[pos % colors.size]
        h.avatarBg.setBackgroundColor(Color.parseColor(color + "33"))

        h.itemView.setOnClickListener { onClick(c) }
    }

    override fun getItemCount() = items.size
}
