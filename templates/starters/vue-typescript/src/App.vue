<script setup lang="ts">
import { ref } from 'vue';

const PROJECT = '__PROJECT_NAME__';

const status   = ref('');
const response = ref('');
const ok       = ref(false);
const loading  = ref(false);

async function checkHealth() {
  loading.value  = true;
  status.value   = '';
  response.value = '';
  try {
    const res  = await fetch('/health');
    const data = await res.json();
    ok.value       = true;
    status.value   = 'healthy';
    response.value = JSON.stringify(data, null, 2);
  } catch (e) {
    ok.value       = false;
    status.value   = 'unreachable';
    response.value = (e as Error).message;
  } finally {
    loading.value = false;
  }
}

const stackItems = [
  { label: 'Framework',    value: 'Engineering OS' },
  { label: 'Frontend',     value: 'Vue + Vite'     },
  { label: 'Architecture', value: 'MVVM + Clean'   },
  { label: 'Backend',      value: ':8000'           },
];
</script>

<template>
  <div class="shell">

    <!-- Header -->
    <header class="header">
      <div class="header-inner">
        <div class="brand">
          <span class="brand-dot" />
          <span class="brand-name">Engineering OS</span>
        </div>
        <span class="project-badge">{{ PROJECT }}</span>
      </div>
    </header>

    <!-- Main -->
    <main class="main">
      <div class="content">

        <!-- Hero -->
        <section class="hero">
          <p class="eyebrow">Project</p>
          <h1 class="hero-title">{{ PROJECT }}</h1>
          <p class="hero-sub">Design for evolution. Build software that survives change.</p>
        </section>

        <!-- Health Check -->
        <section class="card">
          <div class="card-header">
            <span class="card-label">Backend Status</span>
            <span class="endpoint">GET /health</span>
          </div>
          <div class="card-body">
            <button class="btn" :disabled="loading" @click="checkHealth">
              <span v-if="!loading">Check Health</span>
              <span v-else class="spinner" />
            </button>

            <div v-if="status" class="result" :class="ok ? 'result--ok' : 'result--err'">
              <div class="result-header">
                <span class="result-status">{{ ok ? '● HEALTHY' : '● UNREACHABLE' }}</span>
              </div>
              <pre class="result-body">{{ response }}</pre>
            </div>
          </div>
        </section>

        <!-- Stack -->
        <div class="stack">
          <div v-for="item in stackItems" :key="item.label" class="stack-item">
            <span class="stack-label">{{ item.label }}</span>
            <span class="stack-value">{{ item.value }}</span>
          </div>
        </div>

      </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
      Built with <span class="footer-brand">Engineering OS</span>
      &nbsp;·&nbsp;
      <a class="footer-link" href="https://github.com/jcarrenoa" target="_blank" rel="noreferrer">
        github.com/jcarrenoa
      </a>
    </footer>

  </div>
</template>

<style>
*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
html, body { height: 100%; }
body {
  font-family: 'Inter', system-ui, -apple-system, sans-serif;
  background: #f8fafc; color: #0f172a;
  -webkit-font-smoothing: antialiased;
}
</style>

<style scoped>
.shell {
  --surface:    #ffffff;
  --surface-2:  #f1f5f9;
  --border:     #e2e8f0;
  --primary:    #4f46e5;
  --primary-h:  #4338ca;
  --text:       #0f172a;
  --text-muted: #64748b;
  --green:      #16a34a;
  --green-bg:   rgba(22, 163, 74, 0.08);
  --red:        #dc2626;
  --red-bg:     rgba(220, 38, 38, 0.08);
  --radius:     12px;
  --radius-sm:  8px;

  display: flex; flex-direction: column; min-height: 100vh;
}

.header { position: sticky; top: 0; z-index: 10; border-bottom: 1px solid var(--border); background: rgba(255,255,255,0.9); backdrop-filter: blur(12px); }
.header-inner { max-width: 860px; margin: 0 auto; padding: 0 24px; height: 56px; display: flex; align-items: center; justify-content: space-between; }
.brand        { display: flex; align-items: center; gap: 8px; }
.brand-dot    { width: 8px; height: 8px; border-radius: 50%; background: var(--primary); box-shadow: 0 0 8px rgba(79,70,229,0.5); }
.brand-name   { font-size: 14px; font-weight: 600; letter-spacing: -0.2px; }
.project-badge { font-size: 12px; font-weight: 500; font-family: monospace; padding: 3px 10px; border-radius: 999px; background: var(--surface-2); border: 1px solid var(--border); color: var(--text-muted); }

.main    { flex: 1; }
.content { max-width: 860px; margin: 0 auto; padding: 0 24px; }

.hero       { padding: 72px 0 48px; }
.eyebrow    { font-size: 11px; font-weight: 600; letter-spacing: 2.5px; text-transform: uppercase; color: var(--primary); margin-bottom: 14px; }
.hero-title { font-size: clamp(2.4rem, 5vw, 3.8rem); font-weight: 700; letter-spacing: -2px; line-height: 1.05; margin-bottom: 16px; }
.hero-sub   { font-size: 16px; color: var(--text-muted); line-height: 1.65; max-width: 460px; }

.card        { background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius); overflow: hidden; margin-bottom: 20px; box-shadow: 0 1px 4px rgba(0,0,0,0.06); }
.card-header { display: flex; align-items: center; justify-content: space-between; padding: 14px 20px; border-bottom: 1px solid var(--border); background: var(--surface-2); }
.card-label  { font-size: 13px; font-weight: 600; }
.endpoint    { font-size: 12px; font-family: monospace; color: var(--primary); background: rgba(79,70,229,0.08); padding: 3px 8px; border-radius: 4px; border: 1px solid rgba(79,70,229,0.2); }
.card-body   { padding: 20px; display: flex; flex-direction: column; gap: 16px; }

.btn { display: inline-flex; align-items: center; justify-content: center; gap: 8px; min-width: 140px; height: 40px; padding: 0 20px; font-size: 14px; font-weight: 500; font-family: inherit; background: var(--primary); color: #fff; border: none; border-radius: var(--radius-sm); cursor: pointer; transition: all 0.15s; }
.btn:hover:not(:disabled) { background: var(--primary-h); transform: translateY(-1px); box-shadow: 0 4px 12px rgba(79,70,229,0.3); }
.btn:disabled { opacity: 0.5; cursor: not-allowed; }
.spinner { display: block; width: 16px; height: 16px; border-radius: 50%; border: 2px solid rgba(255,255,255,0.35); border-top-color: #fff; animation: spin 0.65s linear infinite; }
@keyframes spin { to { transform: rotate(360deg); } }

.result        { border-radius: var(--radius-sm); border: 1px solid var(--border); overflow: hidden; }
.result--ok    { border-color: rgba(22,163,74,0.3); }
.result--err   { border-color: rgba(220,38,38,0.3); }
.result-header { padding: 10px 14px; }
.result--ok  .result-header { background: var(--green-bg); }
.result--err .result-header { background: var(--red-bg); }
.result-status { font-size: 12px; font-weight: 600; font-family: monospace; letter-spacing: 0.5px; }
.result--ok  .result-status { color: var(--green); }
.result--err .result-status { color: var(--red); }
.result-body { padding: 14px; font-size: 13px; font-family: monospace; line-height: 1.65; background: var(--surface-2); border-top: 1px solid var(--border); white-space: pre-wrap; word-break: break-word; }

.stack      { display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 64px; }
.stack-item { flex: 1; min-width: 140px; display: flex; flex-direction: column; gap: 5px; padding: 14px 16px; background: var(--surface); border: 1px solid var(--border); border-radius: var(--radius-sm); box-shadow: 0 1px 3px rgba(0,0,0,0.04); }
.stack-label { font-size: 10px; font-weight: 600; letter-spacing: 1.5px; text-transform: uppercase; color: var(--text-muted); }
.stack-value { font-size: 14px; font-weight: 500; }

.footer       { border-top: 1px solid var(--border); padding: 20px 24px; text-align: center; font-size: 13px; color: var(--text-muted); }
.footer-brand { color: var(--primary); font-weight: 500; }
.footer-link  { color: var(--text-muted); text-decoration: none; }
.footer-link:hover { color: var(--text); }
</style>
