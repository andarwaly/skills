# Candidate CSV Schema

One CSV file per Resource, at `.agents/slipbox/candidates/<resource-slug>.csv`.

| Column | Meaning |
|---|---|
| `slug` | Internal bookkeeping key. Never used as the literature note's filename. |
| `status` | `pending` \| `discussed` \| `dismissed` |
| `timestamp` | Set at extraction time, not updated later. |
| `reason` | The question + motivation surfaced for this candidate. Blank for candidates dismissed at pick time (never written for a dismissal). |
| `literature_note` | Path to the resulting note once `status` becomes `discussed`. Blank otherwise. |

No separate index file exists. Queries:
- Single Resource: `grep ',pending,' .agents/slipbox/candidates/<resource-slug>.csv`
- Cross-resource backlog: `grep -r ',pending,' .agents/slipbox/candidates/`
- Time-ordered: pipe either of the above through `sort` on the timestamp field.

This file is duplicated (not shared) with `write-literature-note`'s copy of the same schema — see that skill's own `references/candidate-schema.md` for why.
