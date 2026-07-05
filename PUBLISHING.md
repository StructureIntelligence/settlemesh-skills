# PUBLISHING.md — how to publish these 8 skills

Current as of 2026-07. Confidence flags: **[H]** confirmed across canonical docs,
**[M]** verify once before bulk-running. These steps need **your** accounts
(GitHub / ClawHub / Agensi / Stripe) — the repo itself is already publish-ready.

## Prerequisites / gates

- **GitHub account ≥ 1 week old** — ClawHub's upload age-gate uses the immutable
  account id, so username swaps don't bypass it. **[H]**
- **Decide the `@owner` handle** (e.g. `@settlemesh`). Org handles may need to
  pre-exist / you to have rights. **[M]**
- **Security scan:** ClawHub runs automated **ClawScan + VirusTotal** on publish; a
  release can land in a scan-held state. These skills are plain text (no scripts, no
  secrets) → low risk. Keep folders lean — don't add large binaries. **[H]**
- These skills wrap the **paid** SettleMesh CLI, so strict "no SaaS wrapper"
  awesome-lists (karanb192, travisvn) will likely reject them. Target the
  commercial-friendly channels below instead. **[H]**

## Priority order

| # | Channel | Effort × Reach | Notes |
|---|---|---|---|
| 1 | agentskills.io spec validate | S × enabler | already passing (see repo checks); optional `skills-ref validate` |
| 2 | **ClawHub** | M × L | one publish per skill; welcomes commercial |
| 3 | **Claude Code marketplace** | S × L | `.claude-plugin/marketplace.json` already in repo |
| 4 | **Agensi** (agensi.io) | M × M–L | 70% creator share; list free as a funnel |
| 5 | **skillregistry.io** | S × S–M | upload form, download tracking, no anti-commercial filter |
| 6 | auto-crawl (ClaudeSkills.info, skills.sh) | XS × S | just be a clean public repo |
| 7 | VoltAgent/awesome-agent-skills | S × L | **wait** — requires demonstrated usage; queue after some stars |

## 1. Push the repo

```bash
cd /Users/cal/Desktop/SI-DEV/ecology
git init && git add -A && git commit -m "settlemesh-skills: 8 deploy/monetize skills"
# create the GitHub repo (needs your account), e.g.:
gh repo create StructureIntelligence/settlemesh-skills --public --source=. --push
```

## 2. ClawHub (each skill = its own `@owner/slug`)

```bash
npm i -g clawhub
clawhub login && clawhub whoami
clawhub skill publish --help          # [M] confirm whether --slug/--name are needed or derived (docs mirrors disagree)
clawhub skill publish skills/ship-paid-app --owner settlemesh --dry-run --json   # preview one
for d in skills/*; do clawhub skill publish "$d" --owner settlemesh; done        # publish all 8
#   (or: clawhub sync --all  — publishes every new/changed skill under skills/)
openclaw skills install @settlemesh/ship-paid-app                                # verify install
openclaw skills verify  @settlemesh/ship-paid-app
```
Bare `SKILL.md` is a valid publish unit — no `.claude-plugin`/`.mcp.json` wrapper
needed. `primaryEnv: SETTLE_API_KEY` auto-injects the key via `openclaw.json`
`apiKey source:env`. **[H]**

## 3. Claude Code marketplace

```
/plugin marketplace add StructureIntelligence/settlemesh-skills
/plugin install ship-paid-app@settlemesh-skills
```
`.claude-plugin/marketplace.json` already lists all 8 (`strict:false`, each entry
loads only its own `skills/<name>`). **[H]**

## 4. Agensi (commercial-friendly, 70% share)

1. Create an account at agensi.io, connect **Stripe (Stripe Connect)**.
2. For each skill, zip its folder (`cd skills && zip -r ship-paid-app.zip ship-paid-app`).
3. Creator Dashboard → **Submit a Skill** → upload zip, set price (**Free** is
   allowed and recommended as a funnel), tags, listing description.
4. Passes an 8-point security scan (will note the network calls to SettleMesh —
   document them). Approval ~24–48h. **[M]**

## 5. skillregistry.io

Go to `https://skillregistry.io/upload`, sign in with GitHub, paste each `SKILL.md`,
set `tags` + `homepage` (point back to settlemesh.io), Submit for Review. Has
per-skill download counts. **[M]**

## 6. Auto-crawl directories

No action — once the repo is public and well-formed, **ClaudeSkills.info** and
**skills.sh** pick it up automatically.

## 7. VoltAgent/awesome-agent-skills (later)

Fork, add an entry per skill (`- **[StructureIntelligence/settlemesh-skills](url)**
- <=10-word desc`) under **Development and Testing**, PR. **Only after** the skills
show real usage/stars — the list rejects brand-new skills. **[H]**

## Known gaps / to verify

- **Single-skill `git:` install** (`openclaw skills install git:owner/repo@ref`)
  wants `SKILL.md` at the **repo root** — a monorepo can't satisfy that. If that
  channel matters, generate thin per-skill mirror repos (root `SKILL.md`) via CI.
- **Windows symlinks:** `.agents/skills/*` symlinks need `core.symlinks=true`; if
  Windows checkouts matter, replace symlinks with a CI copy step (keep `skills/` the
  single source). On macOS/Linux they work as-is.
- Run `clawhub skill publish --help` once to lock the exact flag surface before the
  bulk loop.
