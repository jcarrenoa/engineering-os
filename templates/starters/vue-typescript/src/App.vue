<script setup lang="ts">
import { ref } from 'vue';

const status = ref('');
const ok     = ref(false);

async function checkHealth() {
  status.value = 'Connecting...';
  try {
    const res  = await fetch('/health');
    const data = await res.json();
    ok.value     = true;
    status.value = '✓  ' + JSON.stringify(data);
  } catch (e) {
    ok.value     = false;
    status.value = '✗  ' + (e as Error).message;
  }
}
</script>

<template>
  <div class="container">
    <h1>__PROJECT_NAME__</h1>
    <button @click="checkHealth">GET /health</button>
    <p v-if="status" :class="ok ? 'ok' : 'err'">{{ status }}</p>
  </div>
</template>

<style scoped>
.container {
  display: flex; flex-direction: column; align-items: center;
  justify-content: center; min-height: 100vh;
  background: #f8fafc; gap: 24px;
  font-family: system-ui, -apple-system, sans-serif;
}
h1 { font-size: 2rem; color: #1e293b; letter-spacing: -0.5px; }
button {
  padding: 12px 28px; font-size: 15px; font-weight: 500;
  background: #4f46e5; color: #fff; border: none;
  border-radius: 8px; cursor: pointer; transition: background 0.15s;
}
button:hover { background: #4338ca; }
.ok  { font-size: 14px; color: #16a34a; }
.err { font-size: 14px; color: #dc2626; }
</style>
