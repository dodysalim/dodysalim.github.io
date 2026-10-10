import pathlib,json,hashlib,zipfile,urllib.request,sys,warnings
import jsonschema
warnings.filterwarnings('ignore',category=DeprecationWarning)
a=pathlib.Path(__file__).resolve().parents[2]; root=a/'historico/entrega_anterior'
cache=a/'scripts/verificacion/esquemas'; cache.mkdir(exist_ok=True)
store={}
def load(p): return json.loads(p.read_text(encoding='utf-8-sig'))
def fetch(url):
 # Microsoft publishes embedded schemas with a hyphen; some $id values use a dot.
 url=url.replace("/schema.embedded.json", "/schema-embedded.json")
 if url in store: return store[url]
 name=cache/(hashlib.sha256(url.encode()).hexdigest()+'.json')
 if name.exists(): data=load(name)
 else:
  print('Esquema:',url,flush=True)
  req=urllib.request.Request(url,headers={'User-Agent':'TechCore-Validator/1.0'})
  with urllib.request.urlopen(req,timeout=30) as response: data=json.load(response)
  name.write_text(json.dumps(data,ensure_ascii=False),encoding='utf-8')
 store[url]=data; return data
errors=[]; count=0; geometry=[]; templates=[]
for mode in ['Escritorio','Movil']:
 d=a/('src/avance_04/PBIR_'+mode)
 for f in d.rglob('*.json'):
  obj=load(f)
  if '$schema' in obj:
   schema=fetch(obj['$schema']); cls=jsonschema.validators.validator_for(schema)
   resolver=jsonschema.RefResolver(base_uri=obj['$schema'],referrer=schema,handlers={'https':fetch,'http':fetch})
   validator=cls(schema,resolver=resolver)
   for error in validator.iter_errors(obj): errors.append({'archivo':str(f.relative_to(a)),'ruta':list(error.path),'error':error.message})
   count+=1
 order=load(d/'pages/pages.json')['pageOrder']; assert len(order)==10
 for name in order:
  pd=d/'pages'/name; page=load(pd/'page.json'); native=[]
  for f in pd.glob('visuals/*/visual.json'):
   v=load(f); p=v['position']
   assert p['x']>=0 and p['y']>=0 and p['x']+p['width']<=page['width']+0.01 and p['y']+p['height']<=page['height']+0.01,(mode,page['displayName'],v['name'],'bounds')
   mp=f.parent/'mobile.json'
   if mp.exists():
    m=load(mp)['position']; assert m['x']>=0 and m['x']+m['width']<=323
    native.append(m)
   # Verify analytical queries and filters against the source report.
   original=root/'Diseno/PBIR/pages'/name/'visuals'/v['name']/'visual.json'
   if original.exists():
    old=load(original)
    assert v.get('filterConfig')==old.get('filterConfig')
    for key in ['query','drillFilterOtherVisuals']: assert v['visual'].get(key)==old['visual'].get(key),(mode,key)
  native.sort(key=lambda p:p['y'])
  logo=[load(f) for f in pd.glob('visuals/*/visual.json') if load(f)['visual']['visualType']=='image' and (f.parent/'mobile.json').exists() and load(f.parent/'mobile.json')['position']['y']==0]
  assert len(logo)==1,(mode,name,'missing logo')
  assert logo[0]['visual']['objects']['general'][0]['properties']['imageUrl']['expr']['ResourcePackageItem']['ItemName']=='Recurso-1logo-tech-140990183911996236.png'
  for left,right in zip(native,native[1:]): assert left['y']+left['height']<=right['y'],(mode,name,'mobile overlap')
  geometry.append({'vista':mode,'pagina':page['displayName'],'moviles':len(native),'limitesCorrectos':True,'sinSolapamientosMoviles':True,'logotipoOriginalPresente':True})
 p=a/('dashboards/avance_04/'+mode.lower()+'/TechCore_'+mode+'_Avance_4.pbit')
 with zipfile.ZipFile(p) as z:
  assert z.testzip() is None
  assert 'Report/Layout' not in z.namelist()
  model=json.loads(z.read('DataModelSchema').decode('utf-16'))
  old=load(root/'Diseno/Modelo/Model/database.json')
  orig=old.get('model',old); compiled=model.get('model',model)
  for key in ['relationships','roles']: assert orig.get(key)==compiled.get(key),key
  oldtables={t['name']:t for t in orig['tables']}; newtables={t['name']:t for t in compiled['tables']}
  assert oldtables.keys()==newtables.keys()
  for name,table in oldtables.items():
   for key in ['measures','columns']: assert table.get(key)==newtables[name].get(key),(mode,name,key)
  for f in d.rglob('*.json'): assert json.loads(z.read('Report/definition/'+f.relative_to(d).as_posix()))==load(f)
  for pkg in load(d/'report.json')['resourcePackages']:
   for item in pkg['items']: assert 'Report/StaticResources/'+pkg['name']+'/'+item['path'] in z.namelist(),item['path']
 templates.append({'vista':mode,'archivo':p.name,'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'modeloMedidasRelacionesRolesConservados':True,'definicionesSincronizadas':True,'recursosPresentes':True})
hashes=load(a/'docs/validacion/historico-sha256.json')
for name,digest in hashes.items(): assert hashlib.sha256((a/name).read_bytes()).hexdigest()==digest,name
assert (a/'src/avance_04/Modelo/Model/database.json').read_bytes()==(root/'Diseno/Modelo/Model/database.json').read_bytes()
report={'archivosPBIRValidados':count,'erroresEsquema':errors,'archivosHistoricosIntactos':len(hashes),'paginas':geometry,'plantillas':templates,'revisionEnPowerBIDesktop':'Pendiente de apertura y actualización nativa','revisionEnTelefono':'Pendiente en Power BI Mobile'}
provenance=a/'comparacion/procedencia.json'
if provenance.exists():
 report['revisionEnPowerBIDesktop']='Capturas nativas disponibles con la instantanea del PBIX original; actualizacion de fuentes, Azure Maps autenticado y RLS publicado pendientes'
 report['comparacionVisual']='comparacion/procedencia.json'
(a/'docs/validacion/avance_04.json').write_text(json.dumps(report,ensure_ascii=False,indent=2),encoding='utf-8')
print(json.dumps({'validados':count,'errores':len(errors),'historicosIntactos':len(hashes),'plantillas':templates},ensure_ascii=True),flush=True)
if errors:
 print(json.dumps(errors[:15],ensure_ascii=True,indent=2),flush=True); sys.exit(1)