import { defineConfig } from 'vite'

export default defineConfig({
  server: {
    host: '0.0.0.0',
    allowedHosts: ['www.crossingkeyintelligence.com', 'crossingkeyintelligence.com'],
  },
})
