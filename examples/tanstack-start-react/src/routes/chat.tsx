import { useConnectionStatus, useMutation, useQuery } from "@lunora/react";
import { createFileRoute } from "@tanstack/react-router";
import { useState } from "react";

import { api } from "#lunora/_generated/api.js";
import type { Doc, Id } from "#lunora/_generated/dataModel.js";

export const Route = createFileRoute("/chat")({
    component: ChatPage,
});

const CHANNELS = ["general", "random", "lunora"];

function ChatPage() {
    const [channelId, setChannelId] = useState(CHANNELS[0]);
    const [author, setAuthor] = useState("anon");
    const [text, setText] = useState("");
    const [error, setError] = useState<string | null>(null);

    const status = useConnectionStatus();
    const result = useQuery(api.messages.list, { channelId }, { shardKey: channelId, onError: (e) => setError(String(e)) });
    const { mutate: send, pending } = useMutation(api.messages.send);
    const { mutate: remove } = useMutation(api.messages.remove);

    const submit = async (event: React.FormEvent) => {
        event.preventDefault();
        const body = text.trim();

        if (!body) {
            return;
        }

        setText("");
        setError(null);

        try {
            await send(
                { channelId, text: body, author },
                {
                    shardKey: channelId,
                    optimisticUpdate: (store) => {
                        const current = store.getQuery(api.messages.list, { channelId });
                        const provisional: Doc<"messages"> = {
                            _id: `optimistic_${Date.now()}` as Id<"messages">,
                            _creationTime: Date.now(),
                            channelId,
                            text: body,
                            author,
                        };
                        store.setQuery(api.messages.list, { channelId }, { channelId, messages: [...(current?.messages ?? []), provisional] });
                    },
                },
            );
        } catch (e) {
            setError(e instanceof Error ? e.message : String(e));
        }
    };

    return (
        <main style={{ fontFamily: "system-ui", maxWidth: 640, margin: "2rem auto", padding: "0 1rem" }}>
            <h1>Chat</h1>
            <p data-testid="status">connection: {JSON.stringify(status)}</p>

            <nav style={{ display: "flex", gap: 8, marginBottom: 12 }}>
                {CHANNELS.map((c) => (
                    <button key={c} type="button" onClick={() => setChannelId(c)} disabled={c === channelId}>
                        #{c}
                    </button>
                ))}
            </nav>

            {result === undefined ? (
                <p>Loading…</p>
            ) : result.messages.length === 0 ? (
                <p data-testid="empty">No messages in #{channelId} yet.</p>
            ) : (
                <ul data-testid="messages" style={{ listStyle: "none", padding: 0 }}>
                    {result.messages.map((m) => (
                        <li key={m._id} style={{ display: "flex", justifyContent: "space-between", padding: "4px 0" }}>
                            <span>
                                <b>{m.author ?? "anon"}</b>: {m.text}
                            </span>
                            <button type="button" aria-label="delete" onClick={() => remove({ channelId, id: m._id }, { shardKey: channelId })}>
                                ×
                            </button>
                        </li>
                    ))}
                </ul>
            )}

            <form onSubmit={submit} style={{ display: "flex", gap: 8 }}>
                <input aria-label="name" value={author} onChange={(e) => setAuthor(e.target.value)} style={{ width: 90 }} />
                <input aria-label="message" value={text} onChange={(e) => setText(e.target.value)} placeholder={`Message #${channelId}`} style={{ flex: 1 }} />
                <button type="submit" disabled={pending}>
                    Send
                </button>
            </form>

            {error && (
                <p data-testid="error" style={{ color: "crimson" }}>
                    {error}
                </p>
            )}
        </main>
    );
}
