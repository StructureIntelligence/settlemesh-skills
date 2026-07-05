# settlemesh-skills — the "do a real, money-bearing thing" collection

Focused, ClawHub / agentskills.io-compatible skills that give any coding agent
(Claude Code, Codex, Cursor, Gemini CLI, OpenClaw, Goose, …) the SettleMesh
capabilities that **prompt-only skills structurally cannot deliver**: deploy a
live app, charge end users, call metered paid APIs without BYOK, publish a paid
API, run scheduled jobs with idempotent billing, and rent out a logged-in agent.

One `SETTLE_API_KEY` unlocks all of them; the first call to each official
capability is **free** (no card), so an agent can try the catalog before funding
anything.

## The skills

| Skill | What it does | Moat (AIsa can't) |
|---|---|---|
| [`ship-paid-app`](./skills/ship-paid-app) | One command → a live app with login + managed DB + billing, at `*.run.settlemesh.io` | ✅ deploy |
| [`charge-my-users`](./skills/charge-my-users) | Turn a deployed app into a product that bills **its own end users** (`X-Settle-Payer`) | ✅ end-user-pays |
| [`metered-data-fetch`](./skills/metered-data-fetch) | Paid web search / scrape / SEO / finance data, no BYOK, quote up front, first call free | ⚠️ contested |
| [`paid-waitlist-page`](./skills/paid-waitlist-page) | A hosted landing/waitlist/pre-order page that persists signups and can take payment | ✅ deploy+DB+pay |
| [`media-studio-metered`](./skills/media-studio-metered) | Metered image/video/audio generation you can resell per render | ✅ metered+resell |
| [`sell-live-dataset`](./skills/sell-live-dataset) | Publish a scrape/dataset as a priced API others pay to call | ✅ publish+bill |
| [`agent-cron-service`](./skills/agent-cron-service) | Scheduled/stateful jobs with exactly-once idempotent billing | ✅ hosted+cron |
| [`rent-a-logged-in-agent`](./skills/rent-a-logged-in-agent) | Lend a logged-in claude-code/codex into a fail-closed sandbox for pay | ✅ worker-lend |

## Repository layout

```
settlemesh-skills/
├── .claude-plugin/marketplace.json   # 8 Claude Code plugin entries (one per skill)
├── skills/<name>/SKILL.md            # canonical source of truth (8 skills)
├── .agents/skills/<name> -> ../../skills/<name>   # symlinks: Cursor / Codex / Gemini CLI / OpenClaw read .agents/skills
├── AGENTS.md                         # cross-tool conventions
└── README.md
```

One physical copy of each skill lives in `skills/`; every runtime reads that copy
(no 4-way duplication). All 8 pass the agentskills.io spec (name matches folder,
`description` ≤ 1024 chars, body < 500 lines, `compatibility` declared).

## Setup (shared by every skill)

1. `npm install -g settlemesh@latest`
2. Authenticate **once**, either:
   - `settlemesh login` — device-code flow: a human approves in the browser (the
     URL + code can be approved on any device), then the CLI stores the key; or
   - set `SETTLE_API_KEY=sk-settle-...` for headless / CI.

**Billing unit: Aev** (1 USD = 100 Aev), funded via Stripe (`settlemesh aev topup
--aev <n>`; balance: `settlemesh aev balance`). Every paid/deploy/publish/
destructive action is **confirm-gated** — quote first, confirm before spend.

## Core rule (all skills follow it)

SettleMesh is a searchable service layer. **Search → inspect → call.**
`settlemesh search "<task>" --json` → `settlemesh tool show <id> --json` →
`settlemesh tool call <id> --input '{...}' --confirm --wait`. Do not memorize
provider endpoints. Full agent contract: <https://settlemesh.io/agent.md>.

## Installing a skill

**Claude Code** (from this repo's marketplace):
```
/plugin marketplace add StructureIntelligence/settlemesh-skills
/plugin install ship-paid-app@settlemesh-skills
```

**OpenClaw / ClawHub** (after the skills are published):
```
openclaw skills install @settlemesh/ship-paid-app
```

**Cursor / Codex / Gemini CLI:** any workspace containing this repo auto-discovers
every skill via `.agents/skills/`. Gemini can also install one directly:
```
gemini skills install https://github.com/StructureIntelligence/settlemesh-skills.git --path skills/ship-paid-app --consent
```

## Publishing (see PUBLISHING.md)

Highest-leverage channels (both welcome commercial skills): **ClawHub**
(`clawhub skill publish skills/<name> --owner settlemesh`, one per skill) and
**Agensi** (agensi.io, 70% creator share, free-as-funnel). Plus **skillregistry.io**
(upload form, download tracking) and auto-crawl directories (a clean public repo is
picked up automatically). The strict awesome-lists filter out "SaaS wrappers", so
skip those. Step-by-step runbook lives in [`PUBLISHING.md`](./PUBLISHING.md).

> All commands here are real `settlemesh` CLI commands. SettleMesh is a product of
> StructureIntelligence Inc.
