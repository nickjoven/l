# l — Epistemic Knowledge Substrate Interactive Explorer

**Purpose:** Interactive browser-based visualizations of six formal knowledge representation models, demonstrating how the same domain knowledge looks under different epistemic lenses.

N. Joven — 2026 — [Live demo](https://nickjoven.github.io/l/)

---

## What This Is

A zero-build-step, single-page web app that lets you explore six knowledge representation formalisms side by side, each applied to the same underlying domain (the synchronization-gravity framework from [201](https://github.com/nickjoven/201)):

| Model | File | What It Shows |
|-------|------|---------------|
| Knowledge Graph | `models/knowledge-graph.html` | Entity-relation triples, graph traversal |
| Semantic Network | `models/semantic-network.html` | Typed links (is-a, causes, implements) between concepts |
| Ontology Browser | `models/ontology-browser.html` | Class hierarchies, properties, domain/range constraints |
| Bayesian Network | `models/bayesian-network.html` | Conditional dependencies, belief propagation |
| ISO Explorer | `models/iso-explorer.html` | Standards-aligned metadata structure |
| Retrieval Compare | `models/retrieval-compare.html` | Side-by-side retrieval strategies over the same corpus |

Each model is backed by a JSON data file in `data/` and rendered client-side with D3/Canvas.

## Structure

```
l/
├── index.html              ← Landing page with model cards
├── models/                 ← One HTML page per formalism
├── data/                   ← JSON data files for each model
├── js/                     ← Shared JavaScript
├── css/                    ← Shared styles
├── data_structures.rb      ← Ruby model for data structure exploration
├── learn.rb                ← Learning mode scaffold
└── browser_update_model.rb ← Browser state management
```

## Context

This is the interactive companion to the paper [*A Content-Addressed Adaptive Knowledge Substrate for Distributed Epistemic Coordination*](https://github.com/nickjoven/jfk-dsa/blob/main/joven_knowledge_substrate.md) (Joven, 2026). The [ket](https://github.com/nickjoven/ket) substrate implements the infrastructure described in that paper; this repo demonstrates the epistemic formalisms it supports.

## License

CC0 1.0 Universal — No rights reserved.
