"""Rebuild outputs with Python 3; no external packages required."""
from pathlib import Path
import sqlite3,csv,json
p=Path(__file__).resolve().parent
db=sqlite3.connect(':memory:'); db.execute('PRAGMA foreign_keys=ON')
db.executescript((p/'schema.sql').read_text())
for name in ['affiliation','sales','alerts']:
    with (p/(name+'.csv')).open(newline='') as f:
        reader=csv.reader(f); cols=next(reader); rows=list(reader)
    db.executemany('INSERT INTO '+name+' VALUES ('+','.join('?' for _ in cols)+')',rows)
for q in (p/'data_quality.sql').read_text().split(';'):
    if q.strip(): assert db.execute(q).fetchall()==[], 'Data quality check failed'
cur=db.execute((p/'analysis.sql').read_text()); cols=[x[0] for x in cur.description]; rows=cur.fetchall()
assert len(rows)==240 and len({r[0] for r in rows})==240
with (p/'hcp_prioritization.csv').open('w',newline='') as f:
    w=csv.writer(f);w.writerow(cols);w.writerows(rows)
items=[dict(zip(cols,r)) for r in rows]
summary={'hcps':len(items),'pre_rx':sum(r['pre_rx'] for r in items),'post_rx':sum(r['post_rx'] for r in items),'alerted':sum(r['alert_count']>0 for r in items),'contacted':sum(r['contacted'] for r in items),'contacted_post_prescribers':sum(r['contacted'] and r['post_rx']>0 for r in items),'segments':{s:sum(r['segment']==s for r in items) for s in sorted({r['segment'] for r in items})}}
(p/'summary.json').write_text(json.dumps(summary,indent=2))
print(json.dumps(summary,indent=2))
print('PASS: quality checks, foreign keys and one output row per HCP')
