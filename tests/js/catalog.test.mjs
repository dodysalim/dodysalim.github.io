// Pruebas de la lógica pura del portafolio:  node --test tests/js/
import test from 'node:test';
import assert from 'node:assert/strict';
import { matchesQuery, normalizeText, origin, prepareProjects, repoUrl } from '../../js/catalog.js';
import { aggregate } from '../../js/bank-analysis.js';
import { projectPresentation, projects } from '../../js/data/projects.js';

test('cada proyecto tiene portada y orden', () => {
  for (const p of projects) assert.ok(projectPresentation[p.url], `falta presentación para ${p.url}`);
});

test('prepareProjects ordena Henry → No Country → Personales y asigna créditos', () => {
  const list = prepareProjects(structuredClone(projects));
  const groups = list.map(origin);
  assert.deepEqual(groups, [...groups].sort((a, b) => ['henry', 'nocountry', 'personal'].indexOf(a) - ['henry', 'nocountry', 'personal'].indexOf(b)));
  assert.equal(list.length, 13);
  assert.ok(list.every(p => p.cover.endsWith('.webp')));
  assert.ok(list.find(p => p.name === 'ConversaAI').team.length === 4);
});

test('enlaces a repositorios locales y externos', () => {
  assert.equal(repoUrl({ url: '@bank' }), 'https://github.com/dodysalim/dodysalim.github.io/tree/main/projects/bank-transactions-powerbi');
  assert.equal(repoUrl({ url: 'FleetLogix-Master' }), 'https://github.com/dodysalim/FleetLogix-Master');
});

test('búsqueda sin tildes ni mayúsculas', () => {
  assert.equal(normalizeText('Análisis ÉXITO'), 'analisis exito');
  const p = { name: 'KrioMetrics', label: 'PERSONAL', description: 'Refrigerantes', tags: ['Python', 'Power BI'] };
  assert.ok(matchesQuery(p, 'power bi') && matchesQuery(p, '') && !matchesQuery(p, 'xgboost'));
});

test('aggregate filtra y agrega por mes', () => {
  const rows = [
    { month: '2022-02', domain: 'A', location: 'X', records: 1, Transaction_count: 10, Value: 100 },
    { month: '2022-01', domain: 'A', location: 'Y', records: 2, Transaction_count: 5, Value: 50 },
    { month: '2022-01', domain: 'B', location: 'X', records: 3, Transaction_count: 1, Value: 7 },
  ];
  const all = aggregate(rows, 'all', 'all');
  assert.deepEqual(all.totals, { rows: 6, transactions: 16, value: 157 });
  assert.deepEqual(all.series.map(s => s.month), ['2022-01', '2022-02']);
  assert.equal(aggregate(rows, 'A', 'X').totals.value, 100);
});
