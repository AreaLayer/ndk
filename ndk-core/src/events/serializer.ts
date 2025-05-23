import type { NDKEvent, NostrEvent } from ".";

export type NDKEventSerialized = string;

/**
 * Serializes an event object into a string representation.
 *
 * @param this - The event object to serialize.
 * @returns A string representation of the serialized event.
 */
export function serialize(this: NDKEvent | NostrEvent, includeSig = false, includeId = false): NDKEventSerialized {
    const payload = [0, this.pubkey, this.created_at, this.kind, this.tags, this.content];
    if (includeSig) payload.push(this.sig);
    if (includeId) payload.push(this.id);
    return JSON.stringify(payload);
}

/**
 * Deserialize a nostr event from a string
 * @param serializedEvent string
 * @returns NostrEvent
 */
export function deserialize(serializedEvent: NDKEventSerialized): NostrEvent {
    const eventArray = JSON.parse(serializedEvent);
    const ret: NostrEvent = {
        pubkey: eventArray[1],
        created_at: eventArray[2],
        kind: eventArray[3],
        tags: eventArray[4],
        content: eventArray[5],
    };

    if (eventArray.length >= 7) {
        const first = eventArray[6];
        const second = eventArray[7];

        if (first && first.length === 128) {
            // it's a signature
            ret.sig = first;
            if (second && second.length === 64) {
                // it's an id
                ret.id = second;
            }
        } else if (first && first.length === 64) {
            // it's an id
            ret.id = first;
            if (second && second.length === 128) {
                // it's a signature
                ret.sig = second;
            }
        }
    }

    return ret;
}
