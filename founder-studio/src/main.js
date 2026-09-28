import './styles.css'
import siteContent from '../../src/content/site-content.json'
import siteTheme from '../../src/content/site-theme.json'
import siteMotion from '../../src/content/site-motion.json'
import { LocalDraftAdapter } from './persistence.js'

const root = document.querySelector('#studio')
const persistence = new LocalDraftAdapter()
const baseline = { schemaVersion: 1, content: siteContent, theme: siteTheme, motion: siteMotion, media: {}, layout: {}, effects: {} }
let documentState = await persistence.load(baseline)
let selectedId = 'home.hero.brand'
let viewport = 'desktop'
let undoStack = []
let redoStack = []
let playing = true

const editable = {
  'home.hero.eyebrow': { type: 'text', label: 'Hero eyebrow', path: ['content', 'home', 'hero', 'eyebrow'], themePath: ['theme', 'home', 'hero', 'eyebrow'] },
  'home.hero.brand': { type: 'text', label: 'Hero brand', path: ['content', 'home', 'hero', 'brand'], themePath: ['theme', 'home', 'hero', 'brand'] },
  'home.hero.statement': { type: 'text', label: 'Hero statement', path: ['content', 'home', 'hero', 'statement'], themePath: ['theme', 'home', 'hero', 'statement'] },
  'home.hero.body': { type: 'text', label: 'Hero body', path: ['content', 'home', 'hero', 'body'], themePath: ['theme', 'home', 'hero', 'body'] },
  'home.hero.emblem': { type: 'media', label: 'Hero emblem', path: ['media', 'home.hero.emblem'] }
}

function get(path, fallback = '') {
  return path.reduce((value, key) => value?.[key], documentState) ?? fallback
}

function set(path, value) {
  undoStack.push(structuredClone(documentState))
  if (undoStack.length > 50) undoStack.shift()
  redoStack = []
  let target = documentState
  path.slice(0, -1).forEach((key) => { target[key] ??= {}; target = target[key] })
  target[path.at(-1)] = value
  persistence.persistDraft(documentState)
  render()
}

function escapeHtml(value) {
  return String(value).replace(/[&<>'"]/g, (character) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', "'": '&#39;', '"': '&quot;' }[character]))
}

function selected() { return editable[selectedId] }
function selectedValue() { return get(selected().path) }
function themeValue(key, fallback) { return selected().themePath ? get([...selected().themePath, key], fallback) : fallback }

function preview() {
  const hero = documentState.content.home.hero
  const brand = documentState.theme.home.hero.brand
  const statement = documentState.theme.home.hero.statement
  return `<section class="studio-preview studio-preview--${viewport}" aria-label="${viewport} website preview">
    <div class="preview-site">
      <header class="preview-header">
        <img src="/ck-medallion-silver.png" width="44" height="44" alt="">
        <span><b>crossingkey</b><small>intelligence is the standard.</small></span>
        <i aria-hidden="true"></i>
      </header>
      <main class="preview-hero">
        <img class="preview-emblem ${selectedId === 'home.hero.emblem' ? 'is-selected' : ''}" data-select="home.hero.emblem" src="${escapeHtml(get(['media','home.hero.emblem','draftDataUrl'], '/ck-medallion-silver.png'))}" alt="${escapeHtml(get(['media','home.hero.emblem','alt'], ''))}" width="1254" height="1254" ${get(['layout','home.hero.emblem','hidden'], false) ? 'hidden' : ''}>
        <div class="preview-copy">
          <button class="editable ${selectedId === 'home.hero.eyebrow' ? 'is-selected' : ''}" data-select="home.hero.eyebrow" ${get(['layout','home.hero.eyebrow','hidden'], false) ? 'hidden' : ''}>${escapeHtml(hero.eyebrow)}</button>
          <h1>
            <button class="editable preview-brand ${selectedId === 'home.hero.brand' ? 'is-selected' : ''}" style="font-size:${brand.fontSize};font-weight:${brand.fontWeight};letter-spacing:${brand.letterSpacing};opacity:${brand.opacity};text-align:${brand.alignment}" data-select="home.hero.brand" ${get(['layout','home.hero.brand','hidden'], false) ? 'hidden' : ''}>${escapeHtml(hero.brand)}</button>
            <button class="editable preview-statement ${selectedId === 'home.hero.statement' ? 'is-selected' : ''}" style="font-size:${statement.fontSize};font-weight:${statement.fontWeight};letter-spacing:${statement.letterSpacing};opacity:${statement.opacity};text-align:${statement.alignment}" data-select="home.hero.statement" ${get(['layout','home.hero.statement','hidden'], false) ? 'hidden' : ''}>${escapeHtml(hero.statement)}</button>
          </h1>
          <button class="editable preview-body ${selectedId === 'home.hero.body' ? 'is-selected' : ''}" data-select="home.hero.body" ${get(['layout','home.hero.body','hidden'], false) ? 'hidden' : ''}>${escapeHtml(hero.body)}</button>
        </div>
      </main>
    </div>
  </section>`
}

function range(label, key, min, max, step, value = 0) {
  return `<label>${label}<input type="range" min="${min}" max="${max}" step="${step}" value="${value}" data-setting="${key}"><output>${value}</output></label>`
}

function inspector() {
  const item = selected()
  const textControls = item.type === 'text' ? `
    <label>Content<textarea data-content>${escapeHtml(selectedValue())}</textarea></label>
    <label>Font size<input data-theme="fontSize" value="${escapeHtml(themeValue('fontSize', '1rem'))}"></label>
    <label>Weight<select data-theme="fontWeight">${[400,500,600,700,800,900].map((v) => `<option ${String(themeValue('fontWeight', 400)) === String(v) ? 'selected' : ''}>${v}</option>`).join('')}</select></label>
    <label>Letter spacing<input data-theme="letterSpacing" value="${escapeHtml(themeValue('letterSpacing', '0em'))}"></label>
    <label>Color<input type="color" data-theme="color" value="${escapeHtml(themeValue('color', '#d7d7df'))}"></label>
    ${range('Opacity', 'opacity', 0, 1, .05, themeValue('opacity', 1))}
    <label>Alignment<select data-theme="alignment">${['left','center','right'].map((v) => `<option ${themeValue('alignment', 'left') === v ? 'selected' : ''}>${v}</option>`).join('')}</select></label>
    ${range('Glow', 'glow', 0, 100, 1, themeValue('glow', 0))}
  ` : `
    <label>Replace asset<input type="file" accept="image/png,image/webp,image/svg+xml" data-media-file></label>
    <label>Alt text<input data-media="alt" value="${escapeHtml(get(['media', selectedId, 'alt'], ''))}"></label>
    ${range('Crop', 'crop', 0, 100, 1, get(['media', selectedId, 'crop'], 0))}
    ${range('Scale', 'scale', .25, 3, .05, get(['media', selectedId, 'scale'], 1))}
    ${range('Horizontal position', 'x', -100, 100, 1, get(['media', selectedId, 'x'], 0))}
    ${range('Vertical position', 'y', -100, 100, 1, get(['media', selectedId, 'y'], 0))}
    ${range('Rotate', 'rotate', -180, 180, 1, get(['media', selectedId, 'rotate'], 0))}
    ${range('Opacity', 'opacity', 0, 1, .05, get(['media', selectedId, 'opacity'], 1))}
    ${range('Blur', 'blur', 0, 40, 1, get(['media', selectedId, 'blur'], 0))}
    <label>Layer / z-index<input type="number" data-media="zIndex" value="${get(['media', selectedId, 'zIndex'], 0)}"></label>
  `
  return `<aside class="inspector">
    <header><p>Selected element</p><h2>${item.label}</h2><code>${selectedId}</code></header>
    <details open><summary>${item.type === 'text' ? 'Text' : 'Image / media'}</summary><div class="control-grid">${textControls}</div></details>
    <details><summary>Layout</summary><div class="control-grid">
      ${['margin','padding','width','height','flexPlacement','gridPlacement','zIndex'].map((key) => `<label>${key}<input data-layout="${key}" value="${escapeHtml(get(['layout', selectedId, viewport, key], ''))}"></label>`).join('')}
    </div></details>
    <details><summary>Effects</summary><div class="control-grid">
      ${range('Background strength', 'backgroundStrength', 0, 100, 1, get(['effects','backgroundStrength'], 100))}
      ${range('Circuit visibility', 'circuitVisibility', 0, 100, 1, get(['effects','circuitVisibility'], 100))}
      ${range('Particle density', 'particleDensity', 0, 100, 1, get(['effects','particleDensity'], 100))}
      ${range('Glow intensity', 'glowIntensity', 0, 100, 1, get(['effects','glowIntensity'], 35))}
      ${range('Grain', 'grain', 0, 100, 1, get(['effects','grain'], 0))}
      ${range('Parallax amount', 'parallax', 0, 100, 1, get(['effects','parallax'], 0))}
    </div></details>
    <details><summary>Animation</summary><div class="control-grid">
      <label class="check"><input type="checkbox" data-motion="enabled" ${get(['motion','home','hero','enabled'], false) ? 'checked' : ''}> Enabled</label>
      ${['durationMs','speed','delayMs','iterations','easing'].map((key) => `<label>${key}<input data-motion="${key}" value="${escapeHtml(get(['motion','home','hero',key], ''))}"></label>`).join('')}
      <button data-play>${playing ? 'Pause' : 'Play'}</button>
    </div></details>
    <details><summary>Component</summary><div class="button-grid">
      <button data-action="show-hide">Show / hide</button><button data-action="duplicate">Duplicate</button>
      <button data-action="up">Move up</button><button data-action="down">Move down</button><button data-action="reset">Reset</button>
    </div></details>
  </aside>`
}

async function render() {
  const history = await persistence.history()
  root.innerHTML = `<div class="studio-shell">
    <header class="studio-topbar">
      <div class="studio-brand"><img src="/ck-medallion-silver.png" width="46" height="46" alt=""><span><b>Founder Studio</b><small>CrossingKey Intelligence · local draft</small></span></div>
      <div class="history-controls"><button data-undo ${undoStack.length ? '' : 'disabled'}>Undo</button><button data-redo ${redoStack.length ? '' : 'disabled'}>Redo</button></div>
      <div class="studio-actions"><button data-save>Save draft</button><button data-preview>Preview</button><button class="publish" data-publish>Publish</button></div>
    </header>
    <nav class="viewport-tabs" aria-label="Responsive preview"><button data-viewport="desktop">Desktop</button><button data-viewport="tablet">Tablet</button><button data-viewport="mobile">Mobile</button><span data-status>Local draft · ${history.length} saved versions</span></nav>
    <main class="studio-workspace">${preview()}${inspector()}</main>
    <section class="version-history"><h2>Version history</h2>${history.length ? history.slice(0,5).map((entry) => `<button data-version="${entry.version}"><b>${entry.savedAt}</b><small>${entry.version}</small></button>`).join('') : '<p>No saved versions yet.</p>'}</section>
  </div>`
  bind()
}

function bind() {
  root.querySelectorAll('[data-select]').forEach((element) => element.addEventListener('click', () => { selectedId = element.dataset.select; render() }))
  root.querySelectorAll('[data-viewport]').forEach((button) => button.addEventListener('click', () => { viewport = button.dataset.viewport; render() }))
  root.querySelector('[data-content]')?.addEventListener('change', (event) => set(selected().path, event.target.value))
  root.querySelectorAll('[data-theme]').forEach((input) => input.addEventListener('change', () => set([...selected().themePath, input.dataset.theme], input.type === 'number' ? Number(input.value) : input.value)))
  root.querySelectorAll('[data-setting]').forEach((input) => input.addEventListener('input', () => {
    input.nextElementSibling.textContent = input.value
    const base = input.closest('details')?.querySelector('summary')?.textContent
    const path = base === 'Effects' ? ['effects', input.dataset.setting] : selected().type === 'media' ? ['media', selectedId, input.dataset.setting] : [...selected().themePath, input.dataset.setting]
    set(path, Number(input.value))
  }))
  root.querySelectorAll('[data-media]').forEach((input) => input.addEventListener('change', () => set(['media', selectedId, input.dataset.media], input.type === 'number' ? Number(input.value) : input.value)))
  root.querySelectorAll('[data-layout]').forEach((input) => input.addEventListener('change', () => set(['layout', selectedId, viewport, input.dataset.layout], input.value)))
  root.querySelectorAll('[data-motion]').forEach((input) => input.addEventListener('change', () => set(['motion','home','hero',input.dataset.motion], input.type === 'checkbox' ? input.checked : input.value)))
  root.querySelector('[data-media-file]')?.addEventListener('change', (event) => {
    const file = event.target.files[0]
    if (!file) return
    const reader = new FileReader()
    reader.onload = () => set(['media', selectedId, 'draftDataUrl'], reader.result)
    reader.readAsDataURL(file)
  })
  root.querySelector('[data-undo]')?.addEventListener('click', () => { redoStack.push(structuredClone(documentState)); documentState = undoStack.pop(); render() })
  root.querySelector('[data-redo]')?.addEventListener('click', () => { undoStack.push(structuredClone(documentState)); documentState = redoStack.pop(); render() })
  root.querySelector('[data-play]')?.addEventListener('click', () => { playing = !playing; render() })
  root.querySelector('[data-save]')?.addEventListener('click', async () => { await persistence.save(documentState); render() })
  root.querySelector('[data-preview]')?.addEventListener('click', () => root.querySelector('.studio-preview')?.requestFullscreen())
  root.querySelector('[data-publish]')?.addEventListener('click', async () => {
    try { await persistence.publish(documentState) } catch (error) { root.querySelector('[data-status]').textContent = error.message }
  })
  root.querySelectorAll('[data-action]').forEach((button) => button.addEventListener('click', () => {
    const action = button.dataset.action
    if (action === 'reset') { undoStack.push(structuredClone(documentState)); documentState = structuredClone(baseline); render(); return }
    if (action === 'show-hide') { set(['layout', selectedId, 'hidden'], !get(['layout', selectedId, 'hidden'], false)); return }
    if (action === 'duplicate') {
      const duplicates = get(['layout', selectedId, 'duplicates'], 0)
      set(['layout', selectedId, 'duplicates'], duplicates + 1)
      return
    }
    const order = get(['layout', selectedId, 'order'], 0)
    set(['layout', selectedId, 'order'], action === 'up' ? order - 1 : order + 1)
  }))
}

render()
