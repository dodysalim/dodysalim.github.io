'use strict';
(() => {
  const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
  const words = {
    es: { lead: 'Hago ', items: ['dashboards en Power BI', 'modelos de machine learning', 'análisis con Python y SQL', 'pipelines ETL', 'NLP en español'],
          labels: ['proyectos publicados', 'registros analizados', 'pruebas automatizadas', 'idiomas · ES / EN'] },
    en: { lead: 'I build ', items: ['Power BI dashboards', 'machine learning models', 'Python & SQL analysis', 'ETL pipelines', 'Spanish NLP'],
          labels: ['published projects', 'records analyzed', 'automated tests', 'languages · ES / EN'] }
  };
  const lang = () => (document.documentElement.lang || 'es').startsWith('en') ? 'en' : 'es';

  // Rotating role text
  const rot = document.getElementById('rotator');
  const line = rot && rot.parentElement;
  let idx = 0, char = 0, deleting = false, current = lang();
  const applyLang = () => {
    const l = lang();
    if (line) line.firstChild.nodeValue = words[l].lead;
    document.querySelectorAll('.metrics span').forEach((s, i) => { s.textContent = words[l].labels[i]; });
    if (l !== current) { current = l; idx = 0; char = 0; deleting = false; }
  };
  const tick = () => {
    const list = words[current].items, w = list[idx % list.length];
    char += deleting ? -1 : 1;
    rot.textContent = w.slice(0, char);
    let wait = deleting ? 35 : 70;
    if (!deleting && char === w.length) { deleting = true; wait = 1700; }
    else if (deleting && char === 0) { deleting = false; idx++; wait = 300; }
    setTimeout(tick, wait);
  };
  if (rot) { applyLang(); if (reduce) rot.textContent = words[current].items[0]; else tick(); }
  new MutationObserver(applyLang).observe(document.documentElement, { attributes: true, attributeFilter: ['lang'] });

  // Count-up metrics
  const fmt = n => n.toLocaleString(lang() === 'en' ? 'en-US' : 'es-ES');
  const countUp = el => {
    const target = +el.dataset.count, suffix = el.dataset.suffix || '', t0 = performance.now(), dur = 1400;
    const step = t => { const p = Math.min(1, (t - t0) / dur), e = 1 - Math.pow(1 - p, 3);
      el.textContent = fmt(Math.round(target * e)) + suffix; if (p < 1) requestAnimationFrame(step); };
    requestAnimationFrame(step);
  };


  // Timeline + nav translations
  const tl = {
    es: {'tl-eyebrow':'TRAYECTORIA','tl-title':'Formación y experiencia práctica.','tl-sub':'Aprendizaje estructurado y proyectos en equipo con entregables reales.','tl-1':'Data Scientist en equipo de 4. Pipeline NLP bilingüe con XLM-R y dashboard Streamlit.','tl-2':'Predicción de abandono en e-commerce con XGBoost, segmentación RFM y Supabase.','tl-3':'Data Analyst: audiencias y oportunidades comerciales en el mercado ecuestre.','tl-4':'Scraping y análisis de habilidades en vacantes de datos con Python, SQL y Supabase.','tl-5h':'Bootcamp de Data Science','tl-5':'Cinco proyectos integradores: ETL y PostgreSQL, Power BI y DAX, clasificación, segmentación y riesgo crediticio.','nav-tl':'Trayectoria'},
    en: {'tl-eyebrow':'JOURNEY','tl-title':'Training and hands-on experience.','tl-sub':'Structured learning and team projects with real deliverables.','tl-1':'Data Scientist in a team of 4. Bilingual NLP pipeline with XLM-R and a Streamlit dashboard.','tl-2':'E-commerce churn prediction with XGBoost, RFM segmentation and Supabase.','tl-3':'Data Analyst: audiences and business opportunities in the equestrian market.','tl-4':'Scraping and skills analysis of data job postings with Python, SQL and Supabase.','tl-5h':'Data Science Bootcamp','tl-5':'Five capstone projects: ETL and PostgreSQL, Power BI and DAX, classification, segmentation and credit risk.','nav-tl':'Journey'}
  };
  const translateTl = () => { const d = tl[lang()]; document.querySelectorAll('[data-t]').forEach(el => { if (d[el.dataset.t]) el.textContent = d[el.dataset.t]; }); };
  translateTl();
  new MutationObserver(translateTl).observe(document.documentElement, { attributes: true, attributeFilter: ['lang'] });

  // Active nav link
  const links = [...document.querySelectorAll('nav a[href^="#"]')];
  const secs = links.map(a => document.querySelector(a.getAttribute('href'))).filter(Boolean);
  if ('IntersectionObserver' in window) {
    const nio = new IntersectionObserver(es => es.forEach(e => { if (e.isIntersecting) links.forEach(a => a.classList.toggle('active', a.getAttribute('href') === '#' + e.target.id)); }), { rootMargin: '-45% 0px -50% 0px' });
    secs.forEach(s => nio.observe(s));
  }

  // Scroll reveal
  const targets = document.querySelectorAll('.section-head, .featured-card, .metrics div, .kpis, .chart-wrap, .skills article, .timeline li, .contact');
  if (reduce || !('IntersectionObserver' in window)) return;
  const io = new IntersectionObserver(entries => entries.forEach(en => {
    if (!en.isIntersecting) return;
    en.target.classList.add('in');
    const num = en.target.querySelector('[data-count]'); if (num) countUp(num);
    io.unobserve(en.target);
  }), { threshold: .15 });
  targets.forEach((el, i) => { el.classList.add('reveal'); el.style.transitionDelay = (i % 3) * 90 + 'ms'; io.observe(el); });
})();
