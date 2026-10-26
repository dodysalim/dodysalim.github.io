/**
 * Reglas del catálogo: origen de cada proyecto, enlaces y preparación de las fichas.
 * Funciones puras (sin acceso al DOM).
 */
import { noCountryCredits, projectPresentation, projects } from './data/projects.js';

const GITHUB = 'https://github.com/dodysalim/';
const LOCAL_PROJECTS = {
  '@health': 'dodysalim.github.io/tree/main/projects/healthpredict',
  '@techcore': 'dodysalim.github.io/tree/main/projects/techcore-sales-powerbi',
  '@bank': 'dodysalim.github.io/tree/main/projects/bank-transactions-powerbi',
};
const GROUP_ORDER = { henry: 0, nocountry: 1, personal: 2 };

export const origin = p => p.label.startsWith('HENRY') ? 'henry' : p.label.startsWith('NO COUNTRY') ? 'nocountry' : 'personal';

export const repoUrl = p => GITHUB + (LOCAL_PROJECTS[p.url] ?? p.url);

export const normalizeText = text => text.normalize('NFD').replace(/[̀-ͯ]/g, '').toLowerCase();

export const matchesQuery = (p, query) =>
  !query || normalizeText([p.name, p.label, p.description, ...p.tags].join(' ')).includes(query);

/** Enriquece las fichas (créditos, portada, orden) y las ordena por grupo. */
export function prepareProjects(list = projects) {
  list.forEach(p => {
    if (noCountryCredits[p.url]) Object.assign(p, noCountryCredits[p.url]);
    const [asset, order] = projectPresentation[p.url];
    p.cover = `assets/project-covers/${asset}.webp`;
    p.order = order;
  });
  return list.sort((a, b) => GROUP_ORDER[origin(a)] - GROUP_ORDER[origin(b)] || a.order - b.order);
}
