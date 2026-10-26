/** Cuadrícula de proyectos: búsqueda, filtros por origen y diálogo de detalle. */
import { matchesQuery, normalizeText, origin } from './catalog.js';
import { projectCard, projectDetail } from './templates.js';

const translate = el => window.translateTree?.(el);

export function createProjectsView(projects, doc = document) {
  const grid = doc.getElementById('project-grid');
  const search = doc.getElementById('project-search');
  const dialog = doc.getElementById('project-dialog');
  let activeFilter = 'all';

  function render(filter = activeFilter) {
    activeFilter = filter;
    grid.replaceChildren();
    const query = normalizeText(search.value.trim());
    let count = 0;
    projects.forEach((p, i) => {
      if ((filter !== 'all' && origin(p) !== filter) || !matchesQuery(p, query)) return;
      count++;
      const article = doc.createElement('article');
      article.className = 'project-card';
      article.dataset.origin = origin(p);
      article.innerHTML = projectCard(p, i);
      grid.append(article);
      translate(article);
    });
    doc.getElementById('project-count').textContent = String(count);
    doc.getElementById('empty-projects').hidden = count > 0;
  }

  function openDetail(p) {
    doc.getElementById('project-detail').innerHTML = projectDetail(p);
    translate(dialog);
    dialog.showModal();
  }

  search.addEventListener('input', () => render());
  doc.querySelectorAll('[data-filter]').forEach(button => button.addEventListener('click', () => {
    doc.querySelectorAll('[data-filter]').forEach(b => {
      b.classList.toggle('active', b === button);
      b.setAttribute('aria-pressed', String(b === button));
    });
    render(button.dataset.filter);
  }));
  grid.addEventListener('click', e => {
    const button = e.target.closest('[data-project]');
    if (button) openDetail(projects[Number(button.dataset.project)]);
  });
  dialog.querySelector('.close').addEventListener('click', () => dialog.close());
  dialog.addEventListener('click', e => {   // cerrar al hacer clic fuera del contenido
    if (e.target !== dialog) return;
    const r = dialog.getBoundingClientRect();
    if (e.clientX < r.left || e.clientX > r.right || e.clientY < r.top || e.clientY > r.bottom) dialog.close();
  });

  render();
  return { render, close: () => dialog.close(), get filter() { return activeFilter; } };
}
