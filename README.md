# vis-prevfile

Plugin per **vis 0.9 con supporto Lua**. Alterna gli ultimi due file attivi e permette di scorrere i file visitati nella sessione.

## Installazione

1. Copia `vis-prevfile.lua` in `~/.config/vis/` oppure in `$XDG_CONFIG_HOME/vis/` se hai impostato `XDG_CONFIG_HOME`.
2. Aggiungi `require('vis-prevfile')` al tuo `visrc.lua`, dopo `require('vis')`.
3. Riavvia vis.

## Tasti

I tasti funzionano in modalità Normal.

| Tasto | Azione |
| --- | --- |
| `Ctrl+6` | Alterna gli ultimi due file attivi |
| `g[` | Indietro di una posizione, verso i file meno recenti |
| `g]` | Avanti di una posizione, verso i file più recenti |
| `2` poi `Ctrl+6` | Torna indietro di due posizioni nella cronologia |

Puoi anteporre un numero anche a `g[` e `g]`. Per esempio, `2g[` torna indietro di due posizioni. Il plugin riconosce `Ctrl+6` anche quando vis lo legge come `<C-^>`.

## Cronologia

La cronologia tiene in memoria fino a **5 file distinti**, compreso quello attivo se ha un nome. Puoi cambiare il limite modificando `history_limit` all'inizio di `vis-prevfile.lua`.

Quando cambi file con i comandi di vis, il file visitato va in testa alla cronologia. `g[` e `g]` percorrono la lista nell'ordine registrato.

Se apri `a.lua`, `b.lua` e `c.lua` in quest'ordine, da `c.lua` premi `g[` per tornare a `b.lua` e poi ancora `g[` per tornare a `a.lua`. Da lì, `g]` ti riporta a `b.lua`.

Il plugin passa allo split che mostra già il file, se presente. Per riaprire un file chiuso usa `:e` con la normale protezione di vis per le modifiche non salvate.
