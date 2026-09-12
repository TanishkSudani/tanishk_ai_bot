package com.tanishk.aibot

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView

class ChatAdapter(private val items: List<ChatMessage>) :
    RecyclerView.Adapter<ChatAdapter.VH>() {

    companion object {
        const val VIEW_BOT = 0
        const val VIEW_ME = 1
    }

    inner class VH(v: View) : RecyclerView.ViewHolder(v) {
        val tvLabel: TextView? = v.findViewById(R.id.tv_bubble_label)
        val tvText: TextView = v.findViewById(R.id.tv_bubble_text)
        val tvTime: TextView = v.findViewById(R.id.tv_bubble_time)
    }

    override fun getItemViewType(position: Int) =
        if (items[position].isBot) VIEW_BOT else VIEW_ME

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
        val layout = if (viewType == VIEW_BOT) R.layout.item_bubble_bot else R.layout.item_bubble_me
        return VH(LayoutInflater.from(parent.context).inflate(layout, parent, false))
    }

    override fun onBindViewHolder(h: VH, pos: Int) {
        val msg = items[pos]
        h.tvLabel?.text = if (msg.label.isNotEmpty()) msg.label else "AI Summary"
        h.tvLabel?.visibility = if (msg.isBot && msg.label.isNotEmpty()) View.VISIBLE else View.GONE
        h.tvText.text = msg.text
        h.tvTime.text = msg.time + if (!msg.isBot) " ✓✓" else ""
    }

    override fun getItemCount() = items.size
}
