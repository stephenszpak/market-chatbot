import React, { useEffect, useRef, useState } from 'react'
import '@fortawesome/fontawesome-free/css/all.min.css'

type Message = { id: string; role: 'assistant' | 'user'; text: string }

function uid() { return Math.random().toString(36).slice(2) }

const AB: React.FC = () => {
  const [open, setOpen] = useState(false)
  const [messages, setMessages] = useState<Message[]>([
    { id: uid(), role: 'assistant', text: 'Hi! Ask about markets or asset classes.' }
  ])
  const [active, setActive] = useState<'bookmark'|'search'|'chat'|null>(null)
  const [indicatorIndex, setIndicatorIndex] = useState<number>(2)
  const [input, setInput] = useState('')
  const inputRef = useRef<HTMLInputElement>(null)
  const bodyRef = useRef<HTMLDivElement>(null)

  useEffect(() => {
    if (open) inputRef.current?.focus()
  }, [open])

  useEffect(() => {
    bodyRef.current?.scrollTo({ top: bodyRef.current.scrollHeight })
  }, [messages, open])

  async function onSend() {
    const q = input.trim()
    if (!q) return
    setInput('')
    const userMsg: Message = { id: uid(), role: 'user', text: q }
    setMessages(prev => [...prev, userMsg])
    try {
      const res = await fetch('/api/ask', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ question: q })
      })
      const data = await res.json()
      const assistantMsg: Message = { id: uid(), role: 'assistant', text: String(data.answer ?? '') }
      setMessages(prev => [...prev, assistantMsg])
    } catch (e) {
      const err: Message = { id: uid(), role: 'assistant', text: 'Sorry, something went wrong.' }
      setMessages(prev => [...prev, err])
    }
  }

  function onKey(e: React.KeyboardEvent<HTMLInputElement>) {
    if (e.key === 'Enter') onSend()
  }

  return (
    <>
      <div className="fab-stack">
        <div
          className={`fab-indicator ${active ? 'visible' : ''}`}
          style={{ top: `${indicatorIndex * (90 + 12)}px` }}
          aria-hidden
        />
        <button className="fab" aria-label="Bookmarks" onClick={() => { setActive('bookmark'); setIndicatorIndex(0) }}>
          <i className="fa-solid fa-bookmark" aria-hidden="true"></i>
        </button>
        <button className="fab" aria-label="Search" onClick={() => { setActive('search'); setIndicatorIndex(1) }}>
          <i className="fa-solid fa-magnifying-glass" aria-hidden="true"></i>
        </button>
        <button className="fab" aria-label="Open assistant" onClick={() => setOpen(v => { const next=!v; if(next){ setActive('chat'); setIndicatorIndex(2);} else { setActive(null);} return next })}>
          <i className="fa-solid fa-robot" aria-hidden="true"></i>
        </button>
      </div>

      {open && (
        <aside className="chat-drawer open" role="dialog" aria-modal="true" aria-label="AB Insights Assistant">
          <div className="chat-header">
            <div>AB Insights Assistant</div>
          <button className="fab" style={{ width: 32, height: 32, borderRadius: 0 }} aria-label="Close" onClick={() => setOpen(false)}>
            ×
          </button>
          </div>
          <div className="chat-body" ref={bodyRef}>
            {messages.map(m => (
              <div key={m.id} className={`msg ${m.role}`}>{m.text}</div>
            ))}
          </div>
          <div className="chat-input">
            <input
              ref={inputRef}
              type="text"
              placeholder="Ask a question..."
              value={input}
              onChange={e => setInput(e.target.value)}
              onKeyDown={onKey}
              aria-label="Your question"
            />
            <button className="fab" style={{ width: 44, height: 44, borderRadius: 0 }} onClick={onSend} aria-label="Send">➤</button>
          </div>
        </aside>
      )}
    </>
  )
}

export default AB
