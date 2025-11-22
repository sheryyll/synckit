# Choosing the Right SyncKit Variant

SyncKit ships with two optimized variants to balance bundle size with functionality. This guide helps you choose the right one for your use case.

---

## 🎯 Quick Decision Tree

```
Start here
│
└─ Will you need network synchronization in the future?
   │
   ├─ YES or MAYBE → Use Default variant
   │                 ✅ 49 KB gzipped
   │                 ✅ WASM includes protocol support (ready for v0.2.0+)
   │                 ✅ Future-proof for server sync
   │                 ✅ Recommended for most apps (95% of use cases)
   │                 ⚠️  v0.1.0: Local-first only (network sync coming soon)
   │
   └─ NO, NEVER → Use Lite variant
                  ✅ 44 KB gzipped (smallest)
                  ✅ Local-only sync
                  ✅ Perfect for offline-first apps without backend
                  ✅ 5 KB smaller than Default
                  ⚠️  v0.1.0: Same features as Default (both local-only)
```

---

## 📦 Variant Comparison

### Default Variant - 49 KB gzipped (Recommended)

**Import:**
```typescript
import { SyncKit } from '@synckit/sdk'
```

**SDK v0.1.0 Features (What You Can Use Today):**
- ✅ Document sync (Last-Write-Wins)
- ✅ Vector clocks (causality tracking)
- ✅ Conflict resolution (automatic)
- ✅ Offline-first (local storage only)
- ✅ IndexedDB & Memory storage
- ❌ Network sync *(WASM ready, SDK coming in v0.2.0)*
- ❌ Text CRDT *(WASM ready, SDK coming in v0.2.0)*
- ❌ Counters *(WASM ready, SDK coming in v0.2.0)*
- ❌ Sets *(WASM ready, SDK coming in v0.2.0)*

**WASM Binary Includes (Ready for Future SDK):**
- ✅ Network protocol (Protocol Buffers)
- ✅ Delta computation
- ✅ DateTime serialization
- ✅ Text/Counter/Set CRDT implementations

**Note:** v0.1.0 is LOCAL-FIRST ONLY. The WASM binary includes protocol support, but the TypeScript SDK doesn't expose network features yet. This means Default variant is future-proof for when network sync is added in v0.2.0+.

**Perfect for (v0.1.0 - Local-First):**
- Todo applications (local storage)
- Note-taking apps
- Offline-first PWAs
- Browser extensions
- Electron apps with local storage
- Apps planning to add server sync later (future-proof)

**Future (v0.2.0+ with network sync):**
- CRM systems with server sync
- Project management with team collaboration
- Dashboards syncing across devices
- E-commerce with cloud sync
- **Any app that syncs structured data (JSON objects) with a server**

**Real-world examples:**
- [Todo App](../../examples/todo-app/) - Simple CRUD with filters
- [Project Management App](../../examples/project-management/) - Kanban board with drag-and-drop
- [Collaborative Editor](../../examples/collaborative-editor/) - Real-time document editing

**Code example (v0.1.0 - Local-First):**
```typescript
import { SyncKit } from '@synckit/sdk'

const sync = new SyncKit({
  storage: 'indexeddb',
  name: 'my-app'
  // serverUrl accepted but not used in v0.1.0
})

await sync.init()

// Create a document
const task = sync.document<Task>('task-123')
await task.update({
  title: 'Build feature',
  status: 'in-progress',
  assignee: 'alice@example.com'
})

// ✅ Works: Local storage with IndexedDB
// ✅ Works: Offline-first, instant writes
// ✅ Works: Conflict resolution (if using multiple tabs)
// ❌ v0.1.0: No server sync (coming in v0.2.0)
```

**When to use:**
- ✅ You might need server sync in the future (future-proof)
- ✅ Data is structured (objects, arrays, primitives)
- ✅ You want the latest features as they're added
- ✅ 5 KB difference doesn't matter to you
- ✅ **This is the recommended default for 95% of applications**

**When NOT to use:**
- ❌ You're 100% sure you'll never need server sync → Use Lite variant (save 5 KB)
- ❌ Bundle size is absolutely critical → Use Lite variant

**Bundle size:** 49 KB (WASM) + ~4 KB (SDK) = **~53 KB total**

---

### Lite Variant - 44 KB gzipped (Smallest)

**Import:**
```typescript
import { SyncKit } from '@synckit/sdk/lite'
```

**SDK v0.1.0 Features (Same as Default in v0.1.0):**
- ✅ Document sync (Last-Write-Wins)
- ✅ Vector clocks (causality tracking)
- ✅ Conflict resolution (automatic)
- ✅ Offline-first (local storage only)
- ✅ IndexedDB & Memory storage
- ❌ Network sync *(not in WASM, not in SDK)*
- ❌ Text/Counter/Set *(not in WASM, not in SDK)*

**WASM Binary Does NOT Include:**
- ❌ Network protocol (Protocol Buffers)
- ❌ Delta computation
- ❌ DateTime serialization
- ❌ Text/Counter/Set CRDT implementations

**Note:** v0.1.0 Lite has the SAME features as Default - both are local-only. The only difference is bundle size (5 KB smaller) and future-proofing (Default will get network features in v0.2.0+, Lite won't).

**Perfect for:**
- Local-only applications
- Offline-first apps without backend sync
- Browser extensions
- Electron apps with file-based storage
- Progressive Web Apps (PWAs) with local data
- Apps where bundle size is critical

**Real-world examples:**
- Todo apps with local storage only
- Note-taking apps (without real-time collaboration)
- Settings/preferences management
- Form data persistence (local draft)
- Shopping carts (local-only)

**Code example (v0.1.0):**
```typescript
import { SyncKit } from '@synckit/sdk/lite'

const sync = new SyncKit({
  storage: 'indexeddb',
  name: 'todo-app'
})

await sync.init()

// Create a document
const todo = sync.document<Todo>('todo-123')
await todo.update({
  text: 'Buy milk',
  completed: false,
  priority: 'high'
})

// ✅ Works: Local storage with IndexedDB
// ✅ Works: Offline-first, instant writes
// ✅ Same functionality as Default in v0.1.0
// 💡 5 KB smaller than Default
```

**When to use:**
- ✅ You're 100% sure you'll never need server sync
- ✅ Local-only storage is all you need
- ✅ Want the absolute smallest bundle (5 KB matters)
- ✅ Building offline-first without backend

**When NOT to use:**
- ❌ You might need server sync someday → Use Default variant (future-proof)
- ❌ Not sure about requirements → Use Default variant (only 5 KB larger)

**Bundle size:** 44 KB (WASM) + ~4 KB (SDK) = **~48 KB total**

**Bundle size savings:** 5 KB smaller than Default (10% reduction)

---

## 🔄 Switching Between Variants

Switching between variants is seamless - just change the import:

```typescript
// Before (lite)
import { SyncKit } from '@synckit/sdk/lite'

// After (need server sync)
import { SyncKit } from '@synckit/sdk'

// All core APIs remain exactly the same!
// No breaking changes, just additional features available
```

**Important:** Don't mix imports from different variants in the same app:

```typescript
// ❌ BAD: Imports from multiple variants (duplicates WASM)
import { SyncKit } from '@synckit/sdk'
import { SyncDocument } from '@synckit/sdk/lite'  // Imports separate WASM!

// ✅ GOOD: Import everything from one variant
import { SyncKit, SyncDocument } from '@synckit/sdk'
```

**Migration is non-breaking:**
- Data format is the same across both variants
- A document created with Lite can be opened with Default
- You can upgrade anytime without data migration

---

## 📊 Bundle Size Impact

Understanding the size trade-offs:

| Variant | WASM (gzipped) | SDK (gzipped) | Total | What You Get |
|---------|----------------|---------------|-------|--------------|
| Lite | 44 KB | ~4 KB | **~48 KB** | Local-only sync |
| Default | 49 KB | ~4 KB | **~53 KB** | + Server sync (recommended) |

**Key insights:**
1. SDK overhead is minimal (~4 KB). WASM dominates bundle size.
2. Lite to Default: +5 KB for network protocol support
3. For most apps, the 5 KB is worth it for server sync capability

**Comparison to alternatives (gzipped):**

| Library | Size | Type | Notes |
|---------|------|------|-------|
| **Yjs** | **~19 KB** | Pure JS | Text CRDT, lightest |
| **SyncKit Lite** | **~48 KB** | WASM + JS | Local-only |
| **SyncKit Default** | **~53 KB** | WASM + JS | Recommended |
| **Automerge** | **~60-78 KB** | WASM + JS | Full CRDT suite |
| **Firebase SDK** | **~150 KB** | Pure JS | Plus server dependency |

**SyncKit's Position:**
- 2.8x larger than Yjs (trade-off: WASM portability for multi-language servers)
- Competitive with Automerge (similar size, simpler API for structured data)
- 2.8x smaller than Firebase

---

## 🎓 Common Scenarios

### Scenario 1: Todo Application (Local or Future Server Sync)

**Recommended:** Default variant

**Why:**
- Structured data (tasks, status, due dates)
- Future-proof for server sync (v0.2.0+)
- v0.1.0: Works great as local-first app

**Bundle:** ~53 KB (SyncKit) + ~130 KB (React) = ~183 KB total

**Example:** [Todo App](../../examples/todo-app/) - Currently local-only, ready for server sync

---

### Scenario 1b: Todo Application (Never Needs Server)

**Recommended:** Lite variant (save 5 KB)

**Why:**
- Same features as Default in v0.1.0
- 5 KB smaller if you're certain you won't need server sync

**Bundle:** ~48 KB (SyncKit) + ~130 KB (React) = ~178 KB total

---

### Scenario 2: Local-Only Todo Application

**Recommended:** Lite variant

**Why:**
- No server needed
- Local storage only
- Smallest bundle size

**Bundle:** ~48 KB (SyncKit) + ~130 KB (React) = ~178 KB total

---

### Scenario 3: Project Management (Kanban)

**Recommended:** Default variant

**Why:**
- Cards are structured data (title, description, status)
- Future team collaboration with server sync (v0.2.0+)
- v0.1.0: Works as single-user local app
- Future-proof for multi-user features

**Bundle:** ~53 KB (SyncKit) + ~130 KB (React) + ~28 KB (dnd-kit) = ~211 KB total

**Example:** [Project Management App](../../examples/project-management/) - Currently local-only

---

### Scenario 4: Collaborative Editor

**Recommended:** Default variant

**Why:**
- Document-level sync for editor content
- Future real-time collaboration (v0.2.0+)
- v0.1.0: Single-user editor with local persistence
- Future-proof for multi-user editing

**Bundle:** ~53 KB (SyncKit) + ~130 KB (React) + ~124 KB (CodeMirror) = ~307 KB total

**Example:** [Collaborative Editor](../../examples/collaborative-editor/) - Currently local-only

**Note:** v0.1.0 uses document-level sync (LWW), not character-level Text CRDT. True collaborative editing with character-level CRDTs is coming in v0.2.0.

---

### Scenario 5: Offline-First Browser Extension

**Recommended:** Lite variant

**Why:**
- Bundle size is critical for extensions
- Local-only storage (chrome.storage)
- No server sync needed
- Fastest performance

**Bundle:** ~48 KB (smallest possible)

---

### Scenario 6: Cross-Platform Desktop App (Electron)

**Decision depends on sync needs:**

**Use Default if:**
- Need cloud sync across devices
- Multiple users collaborate
- Data backup to server required

**Use Lite if:**
- Local files only (no cloud sync)
- Single user application
- Want smallest bundle

---

## 💡 Best Practices

### 1. Start with Default

Use the Default variant unless you have a specific reason not to. It's the recommended default for 95% of applications.

```typescript
import { SyncKit } from '@synckit/sdk'
```

You only need to consider Lite if:
- Bundle size is absolutely critical (saving 5 KB matters)
- You're 100% sure you'll never need server sync

### 2. Don't Over-Optimize

**Rule of thumb:**
- If you're unsure → Use Default variant
- 5 KB difference is negligible for most apps
- Server sync is valuable even if you don't use it immediately

**Example of premature optimization:**
```typescript
// ❌ BAD: Using Lite to save 5 KB, then realizing you need sync
import { SyncKit } from '@synckit/sdk/lite'
// Later: "We need cross-device sync now..."
// Now you have to refactor

// ✅ GOOD: Use Default from the start
import { SyncKit } from '@synckit/sdk'
// Works offline, adds server sync later with zero code changes
```

### 3. Profile Your App

Use browser dev tools to measure actual bundle impact:

```bash
# Chrome DevTools → Network tab → Filter: WASM
# Look for synckit_core_bg.wasm size (should match variant size)
```

### 4. Consider Your Use Case

| If your app is... | Use variant |
|-------------------|-------------|
| Like Trello | Default |
| Like Todoist | Default |
| Like Notion | Default |
| Like Airtable | Default |
| Like Obsidian (cloud sync) | Default |
| Like Obsidian (local-only) | Lite |
| Browser extension (local) | Lite |
| Offline-first PWA (no server) | Lite |

---

## ❓ FAQ

### Q: Which variant should most apps use?

**A:** Default variant. It's only 5 KB larger than Lite and is future-proof for server sync (coming in v0.2.0+). In v0.1.0, both variants have the same features (local-only), but Default will get network sync when it's ready.

### Q: What's missing from Lite?

**A:** Lite's WASM binary excludes:
- Protocol Buffers (network protocol): ~3 KB
- DateTime library (chrono): ~2 KB

**Important:** In v0.1.0, BOTH variants are local-only. Default includes these in the WASM binary for future use, but the SDK doesn't expose them yet. They'll be used when network sync is added in v0.2.0+.

### Q: Will my bundle really be ~50 KB?

**A:** Yes:
- Lite: ~48 KB total (WASM + SDK)
- Default: ~53 KB total (WASM + SDK)

This is just SyncKit. Your total bundle includes:
- SyncKit: ~48-53 KB
- React (if used): ~130 KB
- Other libraries: varies
- Your code: varies

### Q: Can I switch variants later?

**A:** Yes! Switching is seamless:
1. Change your import statement
2. Rebuild your app
3. No data migration needed
4. All existing data works with the new variant

### Q: Do variants affect data format?

**A:** No. Both variants use the same storage format. Data created with one variant can be opened with the other.

### Q: Can I use both variants in one app?

**A:** Not recommended. Each variant includes its own WASM binary, so using both duplicates code (~50 KB overhead). Choose one variant for your entire app.

### Q: What happened to Text/Counter/Set CRDTs?

**A:** These features are implemented in the Rust core but not yet exposed in the SDK. They're planned for v0.2.0. Currently, SyncKit focuses on document-level sync (LWW), which covers 95% of use cases.

### Q: Why is the Collaborative Editor example using Default?

**A:** In v0.1.0, the collaborative editor is actually a SINGLE-USER editor with local persistence (not truly collaborative yet). It uses document-level sync to store the content. True multi-user collaboration with character-level Text CRDT is coming in v0.2.0. Default variant is recommended because it's future-proof for when network sync is added.

### Q: Is 5 KB really worth worrying about?

**A:** Usually no. For most web apps, 5 KB is negligible. Only optimize for this if:
- You're building a browser extension (strict size limits)
- You're targeting low-end devices with slow networks
- Your total bundle is already very large

Otherwise, use Default and get server sync capability.

---

## 🚀 Next Steps

Ready to build? Here's what to do next:

1. **Choose your variant** using the decision tree above
2. **Install SyncKit:** `npm install @synckit/sdk`
3. **Import your variant:**
   ```typescript
   // Most apps
   import { SyncKit } from '@synckit/sdk'

   // Local-only apps
   import { SyncKit } from '@synckit/sdk/lite'
   ```
4. **Build your app:** Follow our [Getting Started Guide](./getting-started.md)

**Recommended reading:**
- [Getting Started Guide](./getting-started.md) - Build your first app
- [API Reference](../api/SDK_API.md) - Complete API documentation
- [Performance Guide](./performance.md) - Optimization tips
- [Examples](../../examples/) - Real-world applications

---

## 📚 Further Reading

- [Todo App Example](../../examples/todo-app/) - Simple CRUD
- [Project Management Example](../../examples/project-management/) - Kanban board
- [Collaborative Editor Example](../../examples/collaborative-editor/) - Real-time editing
- [Performance Optimization Guide](./performance.md)
- [Offline-First Architecture](./offline-first.md)
- [Conflict Resolution](./conflict-resolution.md)

---

**Still have questions?**
- [GitHub Issues](https://github.com/Dancode-188/synckit/issues)
- [GitHub Discussions](https://github.com/Dancode-188/synckit/discussions)
- Email: danbitengo@gmail.com

---

## 📝 Summary

### Two Variants Available

**Default (Recommended):**
```typescript
import { SyncKit } from '@synckit/sdk'
```
- 49 KB gzipped WASM
- Includes server sync, protocol support
- Perfect for 95% of applications
- Use this unless you have a specific reason not to

**Lite (Size-Optimized):**
```typescript
import { SyncKit } from '@synckit/sdk/lite'
```
- 44 KB gzipped WASM
- Local-only, no server sync
- 5 KB smaller than Default
- Use for offline-first apps without backend

### Decision Matrix

| Need server sync? | Use variant |
|-------------------|-------------|
| Yes or Maybe | Default |
| No, never | Lite |
| Unsure | Default |

**When in doubt, choose Default.** The 5 KB difference is worth the flexibility.
