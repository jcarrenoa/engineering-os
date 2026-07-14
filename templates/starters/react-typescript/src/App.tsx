import { useState } from 'react';
import styles from './App.module.css';

const PROJECT = '__PROJECT_NAME__';

export default function App() {
  const [status,   setStatus]   = useState('');
  const [response, setResponse] = useState('');
  const [ok,       setOk]       = useState(false);
  const [loading,  setLoading]  = useState(false);

  async function checkHealth() {
    setLoading(true);
    setStatus('');
    setResponse('');
    try {
      const res  = await fetch('/health');
      const data = await res.json();
      setOk(true);
      setStatus('healthy');
      setResponse(JSON.stringify(data, null, 2));
    } catch (e) {
      setOk(false);
      setStatus('unreachable');
      setResponse((e as Error).message);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className={styles.shell}>

      {/* Header */}
      <header className={styles.header}>
        <div className={styles.headerInner}>
          <div className={styles.brand}>
            <span className={styles.brandDot} />
            <span className={styles.brandName}>Engineering OS</span>
          </div>
          <span className={styles.projectBadge}>{PROJECT}</span>
        </div>
      </header>

      {/* Main */}
      <main className={styles.main}>
        <div className={styles.content}>

          {/* Hero */}
          <section className={styles.hero}>
            <p className={styles.eyebrow}>Project</p>
            <h1 className={styles.heroTitle}>{PROJECT}</h1>
            <p className={styles.heroSub}>
              Design for evolution. Build software that survives change.
            </p>
          </section>

          {/* Health Check */}
          <section className={styles.card}>
            <div className={styles.cardHeader}>
              <span className={styles.cardLabel}>Backend Status</span>
              <span className={styles.endpoint}>GET /health</span>
            </div>
            <div className={styles.cardBody}>
              <button className={styles.btn} onClick={checkHealth} disabled={loading}>
                {loading ? <span className={styles.spinner} /> : 'Check Health'}
              </button>

              {status && (
                <div className={`${styles.result} ${ok ? styles.resultOk : styles.resultErr}`}>
                  <div className={styles.resultHeader}>
                    <span className={styles.resultStatus}>
                      {ok ? '● HEALTHY' : '● UNREACHABLE'}
                    </span>
                  </div>
                  <pre className={styles.resultBody}>{response}</pre>
                </div>
              )}
            </div>
          </section>

          {/* Stack */}
          <div className={styles.stack}>
            {[
              { label: 'Framework',    value: 'Engineering OS' },
              { label: 'Frontend',     value: 'React + Vite'   },
              { label: 'Architecture', value: 'MVVM + Clean'   },
              { label: 'Backend',      value: ':8000'          },
            ].map(({ label, value }) => (
              <div key={label} className={styles.stackItem}>
                <span className={styles.stackLabel}>{label}</span>
                <span className={styles.stackValue}>{value}</span>
              </div>
            ))}
          </div>

        </div>
      </main>

      {/* Footer */}
      <footer className={styles.footer}>
        Built with <span className={styles.footerBrand}>Engineering OS</span>
        {' · '}
        <a className={styles.footerLink} href="https://github.com/jcarrenoa" target="_blank" rel="noreferrer">
          github.com/jcarrenoa
        </a>
      </footer>

    </div>
  );
}
