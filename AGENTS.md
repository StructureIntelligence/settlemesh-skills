# AGENTS.md — settlemesh-skills

This repo is a collection of **8 focused agent skills** (agentskills.io / `SKILL.md`
format) that give any coding agent the SettleMesh capabilities a prompt-only skill
cannot deliver: deploy a live app, charge end users, call metered paid APIs without
BYOK, publish a paid API, schedule jobs, and rent out a logged-in agent.

## Layout

- `skills/<name>/SKILL.md` — the canonical source of truth for each skill.
- `.agents/skills/<name>` — symlinks to `../../skills/<name>`, so Cursor, Codex,
  Gemini CLI, and OpenClaw auto-discover every skill from a checkout of this repo.
- `.claude-plugin/marketplace.json` — registers all 8 as independently-installable
  Claude Code plugins (each entry loads only its own skill from `skills/`).

There is one physical copy of each skill (`skills/`); every runtime reads that copy.

## Using these skills

All skills share one setup. Install the CLI and authenticate once:

```bash
npm install -g settlemesh@latest
settlemesh login            # device-code: a human approves once in the browser
# or, headless/CI:  export SETTLE_API_KEY=sk-settle-...
```

Then a skill's `metadata.openclaw.requires` gates it on the `settlemesh` binary +
`SETTLE_API_KEY`, and `primaryEnv: SETTLE_API_KEY` auto-injects the key at run time.

**Billing:** everything is metered in **Aev** (1 USD = 100 Aev). The **first call to
each official capability is free** (no card), so an agent can try the catalog before
funding anything. Paid / deploy / publish actions are confirm-gated; quote first.

**Core rule:** SettleMesh is a searchable service layer — **search → inspect → call**
(`settlemesh search "<task>" --json` → `settlemesh tool show <id> --json` →
`settlemesh tool call <id> --input '{...}' --confirm --wait`). Never memorize
provider endpoints. Full agent contract: <https://settlemesh.io/agent.md>.

## The skills

| Skill | What it does |
|---|---|
| `ship-paid-app` | Deploy a full-stack app to a live URL (login + DB + billing) in one command |
| `charge-my-users` | Bill an app's own end users per use (end-user-pays / `X-Settle-Payer`) |
| `metered-data-fetch` | Paid web search / scrape / SEO / finance data, no BYOK, first call free |
| `paid-waitlist-page` | Hosted waitlist/landing/pre-order page that persists signups + can charge |
| `media-studio-metered` | Metered image/video/audio generation you can resell per render |
| `sell-live-dataset` | Publish a scrape/dataset as a priced API others pay to call |
| `agent-cron-service` | Hosted agent on a cron schedule with exactly-once billing |
| `rent-a-logged-in-agent` | Rent out a logged-in claude-code/codex agent in a fail-closed sandbox |

SettleMesh is a product of StructureIntelligence Inc.
