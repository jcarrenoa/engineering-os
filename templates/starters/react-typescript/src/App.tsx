import { useState } from 'react';
import styles from './App.module.css';

export default function App() {
  const [status, setStatus] = useState('');
  const [ok, setOk]         = useState(false);

  async function checkHealth() {
    setStatus('Connecting...');
    try {
      const res  = await fetch('/health');
      const data = await res.json();
      setOk(true);
      setStatus('✓  ' + JSON.stringify(data));
    } catch (e) {
      setOk(false);
      setStatus('✗  ' + (e as Error).message);
    }
  }

  return (
    <div className={styles.container}>
      <h1>__PROJECT_NAME__</h1>
      <button onClick={checkHealth}>GET /health</button>
      {status && <p className={ok ? styles.ok : styles.err}>{status}</p>}
    </div>
  );
}
