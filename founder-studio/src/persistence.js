const DRAFT_KEY = 'crossingkey-founder-studio:draft:v1'
const HISTORY_KEY = 'crossingkey-founder-studio:history:v1'

export class LocalDraftAdapter {
  async load(fallback) {
    const saved = localStorage.getItem(DRAFT_KEY)
    return saved ? JSON.parse(saved) : structuredClone(fallback)
  }

  async save(document) {
    const snapshot = { version: crypto.randomUUID(), savedAt: new Date().toISOString(), document }
    localStorage.setItem(DRAFT_KEY, JSON.stringify(document))
    const history = JSON.parse(localStorage.getItem(HISTORY_KEY) || '[]')
    localStorage.setItem(HISTORY_KEY, JSON.stringify([snapshot, ...history].slice(0, 25)))
    return snapshot
  }

  async persistDraft(document) {
    localStorage.setItem(DRAFT_KEY, JSON.stringify(document))
  }

  async history() {
    return JSON.parse(localStorage.getItem(HISTORY_KEY) || '[]')
  }

  async publish() {
    throw new Error('Production publishing is disabled. Use a future authenticated, confirmation-gated server adapter.')
  }
}

export class SecurePersistenceAdapter {
  async load() { throw new Error('Secure persistence adapter is not configured.') }
  async save() { throw new Error('Secure persistence adapter is not configured.') }
  async persistDraft() { throw new Error('Secure persistence adapter is not configured.') }
  async history() { throw new Error('Secure persistence adapter is not configured.') }
  async publish() { throw new Error('Secure persistence adapter is not configured.') }
}
