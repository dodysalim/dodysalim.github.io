/** Vista interactiva de agregados bancarios: filtros, KPIs, tabla y gráfico en canvas. */

const locale = () => document.documentElement.lang === 'en' ? 'en-US' : 'es-EC';
const number = n => new Intl.NumberFormat(locale(), { maximumFractionDigits: 0 }).format(n);
const decimal = n => new Intl.NumberFormat(locale(), { maximumFractionDigits: 2 }).format(n);
const CHART = { left: 60, right: 20, top: 20, bottom: 42, bar: '#75e6ce', text: '#a7b5ce', grid: '#293449' };

/** Filtra filas y agrega por mes (función pura). */
export function aggregate(rows, domain, location) {
  const monthly = new Map();
  const totals = { rows: 0, transactions: 0, value: 0 };
  for (const r of rows) {
    if ((domain !== 'all' && r.domain !== domain) || (location !== 'all' && r.location !== location)) continue;
    totals.rows += r.records;
    totals.transactions += r.Transaction_count;
    totals.value += r.Value;
    const m = monthly.get(r.month) || { month: r.month, Value: 0, Transaction_count: 0 };
    m.Value += r.Value;
    m.Transaction_count += r.Transaction_count;
    monthly.set(r.month, m);
  }
  return { totals, series: [...monthly.values()].sort((a, b) => a.month.localeCompare(b.month)) };
}

function drawChart(canvas, series, metric, title) {
  const ratio = window.devicePixelRatio || 1, w = canvas.clientWidth, h = canvas.clientHeight;
  canvas.width = w * ratio; canvas.height = h * ratio;
  const ctx = canvas.getContext('2d'); ctx.scale(ratio, ratio);
  const { left, right, top, bottom } = CHART;
  const max = Math.max(...series.map(r => r[metric]), 1) * 1.12;
  ctx.font = '12px system-ui'; ctx.fillStyle = CHART.text; ctx.strokeStyle = CHART.grid;
  for (let i = 0; i <= 4; i++) {
    const y = top + (h - top - bottom) * i / 4;
    ctx.beginPath(); ctx.moveTo(left, y); ctx.lineTo(w - right, y); ctx.stroke();
    ctx.fillText(new Intl.NumberFormat(document.documentElement.lang, { notation: 'compact', maximumFractionDigits: 1 }).format(max * (1 - i / 4)), 2, y + 4);
  }
  const step = (w - left - right) / Math.max(series.length, 1);
  series.forEach((r, i) => {
    const bh = r[metric] / max * (h - top - bottom), bw = Math.max(step * .65, 1), x = left + step * i + step * .18;
    ctx.fillStyle = CHART.bar; ctx.fillRect(x, h - bottom - bh, bw, bh);
    if (w > 550 || i % 2 === 0) {
      ctx.fillStyle = CHART.text; ctx.textAlign = 'center';
      ctx.fillText(r.month.slice(5), x + bw / 2, h - bottom + 24); ctx.textAlign = 'left';
    }
  });
  canvas.setAttribute('aria-label', `${title}; ${series.length} meses. Valores exactos en la tabla.`);
}

export function createBankAnalysis(doc = document, source = 'bank-data.json') {
  const $ = id => doc.getElementById(id);
  let bank;

  function update() {
    if (!bank) return;
    const metric = $('metric').value;
    const { totals, series } = aggregate(bank.rows, $('domain').value, $('location').value);
    $('rows').textContent = number(totals.rows);
    $('transactions').textContent = number(totals.transactions);
    $('value').textContent = number(totals.value);
    $('average').textContent = totals.transactions ? decimal(totals.value / totals.transactions) : '—';
    $('period').textContent = series.length ? series[0].month + ' — ' + series[series.length - 1].month : '—';
    $('chart-title').textContent = metric === 'Value' ? 'Valor agregado por mes' : 'Transacciones por mes';
    $('monthly-table').innerHTML = series.map(r => `<tr><th scope="row">${r.month}</th><td>${number(r.Transaction_count)}</td><td>${number(r.Value)}</td></tr>`).join('');
    window.translateTree?.($('chart-title'));
    drawChart($('chart'), series, metric, $('chart-title').textContent);
  }

  fetch(source).then(r => { if (!r.ok) throw Error('data'); return r.json(); }).then(data => {
    bank = data;
    for (const name of ['domain', 'location']) {
      const select = $(name);
      data[name + 's'].forEach(t => { const o = doc.createElement('option'); o.value = t; o.textContent = t; select.append(o); });
      select.addEventListener('change', update);
    }
    $('metric').addEventListener('change', update);
    update();
  }).catch(() => { $('chart-title').textContent = 'No se pudieron cargar los datos. Recarga la página.'; });

  window.addEventListener('resize', update);
  return { update };
}
