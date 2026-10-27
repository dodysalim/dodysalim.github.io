"""Genera assets/Dody_Duenas_CV.pdf (dos páginas, texto seleccionable y apto para ATS).

    python docs/cv/build_cv.py

El contenido vive en este archivo: para actualizar el CV se edita aquí y se vuelve a generar.
"""
from pathlib import Path

from reportlab.lib.colors import HexColor
from reportlab.lib.enums import TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib.units import mm
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (HRFlowable, KeepTogether, ListFlowable, ListItem, Paragraph,
                                SimpleDocTemplate, Spacer)

OUT = Path(__file__).resolve().parents[2] / "assets" / "Dody_Duenas_CV.pdf"
FONT_DIR = Path("/usr/share/fonts/truetype/dejavu")
pdfmetrics.registerFont(TTFont("Sans", str(FONT_DIR / "DejaVuSans.ttf")))
pdfmetrics.registerFont(TTFont("Sans-Bold", str(FONT_DIR / "DejaVuSans-Bold.ttf")))
pdfmetrics.registerFontFamily("Sans", normal="Sans", bold="Sans-Bold")

INK, ACCENT, MUTED, LINE = HexColor("#142C3D"), HexColor("#086961"), HexColor("#526574"), HexColor("#C9D6DE")
GH = "https://github.com/dodysalim/"

S = {
    "name": ParagraphStyle("name", fontName="Sans-Bold", fontSize=22, leading=26, textColor=INK),
    "role": ParagraphStyle("role", fontName="Sans", fontSize=11.5, leading=15, textColor=ACCENT, spaceAfter=4),
    "meta": ParagraphStyle("meta", fontName="Sans", fontSize=8.6, leading=12, textColor=MUTED),
    "h": ParagraphStyle("h", fontName="Sans-Bold", fontSize=10, leading=13, textColor=ACCENT, spaceBefore=9, spaceAfter=2),
    "body": ParagraphStyle("body", fontName="Sans", fontSize=8.8, leading=12.2, textColor=INK, alignment=TA_LEFT),
    "title": ParagraphStyle("title", fontName="Sans-Bold", fontSize=9.6, leading=12.5, textColor=INK, spaceBefore=5),
    "date": ParagraphStyle("date", fontName="Sans", fontSize=8, leading=11, textColor=MUTED),
    "note": ParagraphStyle("note", fontName="Sans", fontSize=7.8, leading=10.5, textColor=MUTED, spaceBefore=4),
}


def link(text, url):
    return f'<a href="{url}" color="#086961">{text}</a>'


def section(title):
    return [Paragraph(title.upper(), S["h"]), HRFlowable(width="100%", thickness=0.6, color=LINE, spaceAfter=4)]


def bullets(items):
    return ListFlowable([ListItem(Paragraph(t, S["body"]), leftIndent=10, value="•") for t in items],
                        bulletType="bullet", start="•", leftIndent=10, bulletFontSize=8, bulletColor=ACCENT)


def project(title, date, items, repo=None):
    block = [Paragraph(title, S["title"]), Paragraph(date, S["date"]), bullets(items)]
    if repo:
        block.append(Paragraph(link("Repositorio ↗", GH + repo), S["body"]))
    return KeepTogether(block)


def footer(canvas, doc):
    canvas.saveState()
    canvas.setStrokeColor(LINE)
    canvas.line(18 * mm, 14 * mm, A4[0] - 18 * mm, 14 * mm)
    canvas.setFont("Sans", 7.5)
    canvas.setFillColor(MUTED)
    canvas.drawString(18 * mm, 10 * mm, "Dody Dueñas Remache · Analítica y ciencia de datos")
    canvas.drawRightString(A4[0] - 18 * mm, 10 * mm, str(doc.page))
    canvas.restoreState()


def content():
    f = [
        Paragraph("DODY DUEÑAS REMACHE", S["name"]),
        Paragraph("Analista de Datos | Business Intelligence | Data Scientist Jr.", S["role"]),
        Paragraph("Guayaquil, Ecuador · +593 98 274 4895 · " + link("dodydurema67@gmail.com", "mailto:dodydurema67@gmail.com"), S["meta"]),
        Paragraph(" · ".join([link("LinkedIn", "https://www.linkedin.com/in/dody-duenas/"), link("GitHub", "https://github.com/dodysalim"),
                              link("Portafolio", "https://dodysalim.github.io/")]), S["meta"]),
        Paragraph("Disponible: presencial en Guayaquil y remoto desde Ecuador / Latinoamérica.", S["meta"]),
    ]
    f += section("Perfil profesional")
    f.append(Paragraph(
        "Analista de datos junior con formación en Data Science (Henry, 480 horas) y estudios de Ingeniería de la "
        "Producción. Trabajo con Python, SQL y Power BI para limpiar datos, construir modelos y comunicar resultados. "
        "Mantengo mis proyectos con código modular, pruebas automatizadas, integración continua y control de versiones "
        "(más de 150 pruebas en el portafolio). He colaborado en cuatro proyectos con equipos remotos multidisciplinarios. "
        "Mi formación en seguridad industrial y refrigeración aporta contexto para analizar operaciones y procesos industriales.",
        S["body"]))
    f += section("Habilidades técnicas")
    for label, text in [
        ("BI y visualización", "Power BI, DAX, Power Query, Excel/VBA, Streamlit y Plotly."),
        ("Análisis y bases de datos", "Python, pandas, NumPy, SQL, PostgreSQL, SQLite, Snowflake, EDA, estadística, RFM y KPIs."),
        ("Machine Learning", "scikit-learn, XGBoost, LightGBM, CatBoost, K-Means, SHAP y NLP con Hugging Face Transformers."),
        ("Ingeniería y colaboración", "ETL, scraping, FastAPI, Docker, GitHub Actions, pytest, principios SOLID, Supabase, Git y Scrum."),
    ]:
        f.append(Paragraph(f"<b>{label}:</b> {text}", S["body"]))
    f += section("Experiencia en proyectos de datos")
    f += [
        project("ConversaAI | No Country", "Abr. 2026 - may. 2026 · Data Scientist en proyecto remoto en equipo", [
            "Participé en un sistema NLP con XLM-RoBERTa para sentimiento e intención (9 clases) en español y portugués; "
            "el equipo documenta aproximadamente 92 % de exactitud en sentimiento.",
            "Scoring heurístico de abandono y dashboard en Hugging Face Spaces; versión local con motores intercambiables "
            "que funciona sin GPU y 12 pruebas automatizadas."], "ConversaAI-NLP-Support-Analytics"),
        project("Churn Intelligence | No Country", "Mar. 2026 - abr. 2026 · Data Analyst en proyecto remoto en equipo", [
            "Participé en segmentación RFM y modelado XGBoost explicado con SHAP. La evaluación documentada del equipo "
            "reporta AUC-ROC de 0,912.",
            "Análisis de cartera de USD 3,1 M y escenarios de retención con ROI potencial de 3,6x; dashboard Streamlit "
            "conectado a Supabase y 25 pruebas automatizadas."], "-E-commerce-Churn-Model-S03-26-Equipo-40-Data-Science"),
        project("EquineLead | No Country", "Feb. 2026 - mar. 2026 · Data Analyst en proyecto de equipo", [
            "Análisis del embudo de un marketplace y oportunidades de conversión. El proyecto incluye lead scoring, "
            "API FastAPI, dashboard y componentes de monitoreo y CI/CD."], "S02-26-E45-Data_Science_EquineLead"),
        project("Market Scraper · LatAm Insights | No Country", "Nov. 2025 - dic. 2025 · Data Analyst en proyecto remoto en equipo", [
            "Web scraping de 926 vacantes de 472 empresas en 8 países; análisis por seniority, tecnología y país.",
            "Dashboard Streamlit organizado por capas (repositorio, procesamiento, servicios e interfaz) con 27 pruebas."],
            "Proyecto-No-Country"),
        Paragraph("No Country: simulaciones profesionales en equipo. Las métricas citadas corresponden a las evaluaciones "
                  "documentadas por los proyectos; ROI y beneficios representan escenarios estimados.", S["note"]),
    ]
    henry_header = section("Proyectos Henry") + [
        Paragraph("Proyectos integradores de Data Science · Jul. 2025 - abr. 2026", S["date"])]
    f += [
        KeepTogether(henry_header + [project("Cliente360 · Segmentación y analítica de clientes", "Proyecto integrador", [
            "Análisis de 30.000 clientes con K-Means. El análisis documentado identifica que el 38 % concentra "
            "aproximadamente el 76 % del valor; pipeline ETL con 7 pruebas e informe en Power BI."], "Cliente360-Predictive-Insight")]),
        project("FleetLogix · Ingeniería de datos y analítica logística", "Módulo 2", [
            "Generación y carga de ~535.000 registros sintéticos en PostgreSQL con generadores inyectables (SOLID), "
            "8 vistas analíticas, modelo dimensional, dashboard Streamlit e informe Power BI."], "FleetLogix-Master"),
        project("FinanceGuard · Churn bancario", "Módulo 4", [
            "Comparación de modelos sobre 10.000 clientes (AUC documentada de 0,78 a 0,87), paquete Python reutilizable "
            "y umbral de decisión por costos: beneficio estimado en prueba de USD 58.400 a USD 111.700."],
            "churn-prediction-financeguard"),
        project("Riesgo crediticio · Evaluación, API y monitoreo", "Módulo 5", [
            "Corrección de fuga de datos, API con FastAPI/Docker, dashboard modular de data drift (KS, PSI, Chi²), "
            "26 pruebas automatizadas e informe de monitoreo en Power BI."], "Proyecto_Integrador_M5"),
    ]
    f += section("Proyectos personales")
    f.append(bullets([
        "<b>KrioMetrics:</b> ETL y modelo dimensional en SQLite con 55 gases refrigerantes; arquitectura por capas, "
        "59 pruebas y dashboards Streamlit/Power BI. " + link("Repositorio ↗", GH + "refrigerant-gas-dashboard"),
        "<b>Bank Transactions:</b> modelado y validación de integridad de más de un millón de registros en Power BI.",
        "<b>Analytics Toolkit:</b> módulos Python para calidad de datos, NLP, pruebas A/B y estadística; dashboard "
        "interactivo de 7 vistas e informe Power BI. " + link("Repositorio ↗", GH + "data-science-analytics-toolkit"),
    ]))
    f += section("Educación")
    for title, date in [
        ("Data Science (480 horas) | Henry", "Jul. 2025 - abr. 2026 · Estadística, ML, SQL, ETL, Power BI y despliegue."),
        ("Ingeniería de la Producción (estudios) | Universidad de Guayaquil",
         "Dic. 2021 - ago. 2024 · Estadística, métodos numéricos, calidad, física y química."),
        ("Bachiller en Ciencias | Unidad Educativa Babahoyo", "May. 2015 - feb. 2021."),
    ]:
        f += [Paragraph(title, S["title"]), Paragraph(date, S["date"])]
    f += section("Certificaciones por competencias (SETEC)")
    f.append(bullets([
        "Asistencia en Seguridad Industrial · COREC · 2025 (vigente hasta 2030).",
        "Operaciones de Sistemas de Refrigeración o Aire Acondicionado · Colegio de Ingenieros Mecánicos del Guayas · 2024.",
        "Asistencia Administrativa con Manejo de Ofimática · LAS S.A.S. · 2025.",
    ]))
    f += section("Idiomas")
    f.append(Paragraph("Español: nativo. Inglés: básico (A2), en formación activa.", S["body"]))
    return f


def build(out: Path = OUT) -> Path:
    doc = SimpleDocTemplate(str(out), pagesize=A4, leftMargin=18 * mm, rightMargin=18 * mm,
                            topMargin=16 * mm, bottomMargin=20 * mm, title="Dody Dueñas - CV profesional",
                            author="Dody Dueñas Remache", subject="Analista de Datos · Data Scientist Jr.")
    doc.build(content(), onFirstPage=footer, onLaterPages=footer)
    return out


if __name__ == "__main__":
    print(build())
