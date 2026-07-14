import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue';

export default defineConfig({
  plugins: [vue()],
  resolve: { alias: { '@': '/src' } },
  server: {
    proxy: {
      '/health': 'http://localhost:8000',
      '/api':    'http://localhost:8000',
    },
  },
});
