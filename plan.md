# Plan

## Objective

Upgrade Puppeteer on NZSL Online from v2.1.1 to a modern release (latest stable is v25.x) to clear the high-severity `extract-zip` vulnerability, while keeping vocab sheet PDF download working on Heroku staging and production.

## Scope

**In scope**

- Bump `puppeteer` in `package.json` / `yarn.lock`
- Update `bin/render-pdf.js` for current Puppeteer API if needed
- Configure Heroku for modern Puppeteer (buildpacks, `heroku-postbuild` cache relocation, `--no-sandbox`)
- CI green via `spec/services/pdf_rendering_service_spec.rb`
- Manual QA of vocab sheet PDF download on staging, then production

**Out of scope**

- Replacing Puppeteer with another PDF renderer
- Heroku stack migration (`app.json` still references heroku-18)

## Background

### Current usage

Puppeteer is used only for vocab sheet PDF downloads:

- `VocabSheetsController#download_pdf` → `PdfRenderingService` → `bin/render-pdf.js` → `puppeteer.launch`
- Declared: `^2.0.0`; locked: `2.1.1`
- Hosting: Heroku apps `nzsl-staging` and `nzsl` (production)

### Security

`yarn audit` reports one high-severity issue: `extract-zip` (transitive via puppeteer) — unvalidated symlink path traversal ([npm advisory 1139346](https://www.npmjs.com/advisories/1139346)). No patch on the current tree; fix is upgrading Puppeteer. Same class of issue as [CC-955](https://ackama.atlassian.net/browse/CC-955) (Safeplus Puppeteer v2, 2020).

### Prior failed upgrade (must not rediscover)

1. Dependabot upgraded Puppeteer v2 → v5 (2020).
2. Production broke: vocab sheet PDFs downloaded as **0-byte files** ([CCSD-1563](https://ackama.atlassian.net/browse/CCSD-1563)).
3. Reverted to v2.0.0 and excluded from Dependabot/Renovate ([#1210](https://github.com/ODNZSL/nzsl-online/pull/1210), [#1285](https://github.com/ODNZSL/nzsl-online/pull/1285)).
4. Those ignore configs were later removed ([#1441](https://github.com/ODNZSL/nzsl-online/pull/1441), [#1442](https://github.com/ODNZSL/nzsl-online/pull/1442)) — automated upgrades may resurface.

### In-progress branch

Gareth pushed `origin/update-puppeteer` (commit `2ff8767a`, 25 Aug 2026) targeting `puppeteer@^21.0.0` (not yet v25), including:

- `heroku-postbuild` cache relocation script
- Hardened `bin/render-pdf.js` (try/finally, error exit code, extra Chrome args, `headless: "new"`)

Treat this as the starting point; may still need a further bump to latest stable.

### Heroku / hosting risk

The dependency bump is the easy part; deployment is the risk:

- `app.json` documents only `heroku/ruby` and `heroku-18` — no Node or Puppeteer buildpack in repo. Actual buildpacks likely live in the Heroku dashboard.
- Modern Puppeteer (v19+) caches browsers outside the slug unless relocated. Needs [jontewks/puppeteer-heroku-buildpack](https://elements.heroku.com/buildpacks/jontewks/puppeteer-heroku-buildpack) + `heroku-postbuild` (drafted on `update-puppeteer`).
- `--no-sandbox` required on Heroku (already documented in `bin/render-pdf.js`).
- App requires Node 24 (`engines.node`) but Ruby-only buildpack in `app.json` — Node buildpack must be present on Heroku.
- CI installs `google-chrome-stable` manually; production relies on Puppeteer's bundled Chromium + Heroku system deps. CI PDF specs do **not** validate Heroku slug behaviour.
- MDCEL / energy-efficiency loans apps on Heroku share the same Puppeteer-on-Heroku constraints (buildpack + cache + sandbox); prior Ackama experience with that model is the source of caution.

### Code notes

- `google_chrome_path` in `PdfRenderingService` is unused dead code — Puppeteer manages its own binary.

## Next steps

1. Create CC board Jira ticket for the upgrade work.
2. When executing: review/extend `origin/update-puppeteer`, verify Heroku buildpacks on staging, deploy and QA PDF download before production.