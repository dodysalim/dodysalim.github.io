/** Punto de entrada: arma el catálogo, la cuadrícula y el análisis interactivo. */
import { prepareProjects } from './catalog.js';
import { createProjectsView } from './projects-view.js';
import { createBankAnalysis } from './bank-analysis.js';

const view = createProjectsView(prepareProjects());
const analysis = createBankAnalysis();

window.addEventListener('portfolio-language', () => {
  view.render(document.querySelector('[data-filter].active').dataset.filter);
  view.close();
  analysis.update();
});
