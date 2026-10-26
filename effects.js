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

  // Scroll reveal
  const targets = document.querySelectorAll('.section-head, .featured-card, .metrics div, .kpis, .chart-wrap, .skills article, .contact');
  if (reduce || !('IntersectionObserver' in window)) return;
  const io = new IntersectionObserver(entries => entries.forEach(en => {
    if (!en.isIntersecting) return;
    en.target.classList.add('in');
    const num = en.target.querySelector('[data-count]'); if (num) countUp(num);
    io.unobserve(en.target);
  }), { threshold: .15 });
  targets.forEach((el, i) => { el.classList.add('reveal'); el.style.transitionDelay = (i % 3) * 90 + 'ms'; io.observe(el); });
})();
