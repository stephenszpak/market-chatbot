import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'node:path'

// Build as a single JS (main.js) + styles.css to dist/
export default defineConfig(({ mode }) => ({
  define: {
    'process.env.NODE_ENV': JSON.stringify(mode === 'production' ? 'production' : 'development')
  },
  plugins: [react()],
  build: {
    outDir: process.env.AB_WIDGET_OUTDIR || 'dist',
    assetsDir: '.',
    sourcemap: mode !== 'production',
    lib: {
      entry: path.resolve(__dirname, 'src/index.tsx'),
      name: 'ABInsightsAssistant',
      fileName: () => 'main.js',
      formats: ['iife']
    },
    rollupOptions: {
      output: {
        entryFileNames: 'main.js',
        assetFileNames: (assetInfo) => {
          const name = assetInfo.name || ''
          if (name.endsWith('.css') || name === 'style.css') return 'styles.css'
          return name
        }
      }
    }
  }
}))
