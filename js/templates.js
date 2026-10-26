/** Plantillas HTML de tarjetas y diálogo de proyecto. */
import { powerbiRepos, reviewStatus } from './data/projects.js';
import { repoUrl } from './catalog.js';

export const showcaseLink = p => p.showcase
  ? `<a class="showcase-link" href="${p.showcase}" target="_blank" rel="noopener noreferrer">No Country Showcase ↗</a>` : '';

export const teamCredits = p => p.team ? `<section class="team-credits"><h3>Equipo y créditos</h3><p><span>Edición No Country:</span> <span>${p.edition}</span> · ${p.official}</p><ul>${p.team.map(([name, role]) => `<li><strong>${name}</strong> · <span>${role}</span></li>`).join('')}</ul><p class="caption">Nombres públicos del showcase y de la documentación del equipo. Los roles de EquineLead siguen el README del proyecto.</p>${showcaseLink(p)}</section>` : '';

export const componentLinks = p => p.components
  ? `<div class="card-actions">${p.components.map(c => `<a href="${c.url}" target="_blank" rel="noopener">${c.name} ↗</a>`).join('')}</div>` : '';

const powerbiLink = p => powerbiRepos.has(p.url)
  ? `<a class="powerbi-link" href="https://github.com/dodysalim/${p.url}/tree/main/powerbi" target="_blank" rel="noopener">Power BI · PC y móvil ↗</a>` : '';

export const projectCard = (p, i) => `<img class="project-cover" src="${p.cover}" alt="" loading="lazy" decoding="async" width="960" height="540"><div class="card-top"><span>${p.label}</span><span>${String(p.order).padStart(2, '0')}</span></div><h3>${p.name}</h3><p>${p.description}</p>${reviewStatus[p.url] ? `<span class="review-status">${reviewStatus[p.url]}</span>` : ''}<div class="tags">${p.tags.map(t => `<span>${t}</span>`).join('')}</div><div class="card-actions"><button data-project="${i}" aria-label="Ver caso: ${p.name}">Ver caso</button><a href="${repoUrl(p)}" target="_blank" rel="noopener">Repositorio</a></div>${componentLinks(p)}${showcaseLink(p)}${powerbiLink(p)}`;

export const projectDetail = p => `<p class="eyebrow">${p.label}</p><h2>${p.name}</h2><h3>Problema</h3><p>${p.problem}</p><h3>Enfoque</h3><p>${p.approach}</p><h3>Evidencia disponible</h3><ul>${p.evidence.map(t => `<li>${t}</li>`).join('')}</ul>${p.image ? `<img src="${p.image}" alt="Informe ejecutivo del proyecto Cliente360" loading="lazy">` : ''}${teamCredits(p)}<h3>Contexto y alcance</h3><p>${p.note}</p>${componentLinks(p)}${p.url ? `<a class="button" href="${repoUrl(p)}" target="_blank" rel="noopener">Abrir repositorio</a>` : ''}`;
