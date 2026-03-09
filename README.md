# Epistemic Knowledge Substrate

A suite of web-deployable, interactable models of the foundational formalisms through which knowledge is represented, organized, and reasoned about.

Open `index.html` in a browser (or serve with any static host) — no backend required.

---

## Models

| Model | Formalism | Key Features |
|-------|-----------|-------------|
| **Knowledge Graph Explorer** | Entity–Relation Graph | Force-directed, click to inspect, add/remove nodes & edges, filter, search |
| **Semantic Network Visualizer** | Typed-Edge Concept Network | Curved typed edges, BFS path finding, domain clustering |
| **Ontology Browser** | OWL-style Class Hierarchy | Tree + force graph dual view, inherited properties, instances |
| **Bayesian Belief Network** | Probabilistic Graphical Model | Exact inference, evidence setting, real-time belief propagation |

---

## Quick Start

```bash
# Option 1: open directly
open index.html

# Option 2: serve locally
python3 -m http.server 8080
# then visit http://localhost:8080
```

## Deploy to GitHub Pages

1. Push to `main` branch
2. Settings → Pages → Source: root
3. Access at `https://nickjoven.github.io/l/`

---

## Tech Stack

- Vanilla HTML5 / CSS3 / ES6 JavaScript
- [D3.js v7](https://d3js.org/) via CDN
- No build tools, no framework, no backend

## Structure

```
├── index.html                 # Hub page
├── css/styles.css             # Shared dark-theme design system
├── js/graph-utils.js          # Shared D3 utilities
├── data/
│   ├── knowledge-graph.json   # 20 nodes, 30 edges
│   ├── semantic-network.json  # 25 concepts, typed edges
│   ├── ontology.json          # 15 OWL-style classes
│   └── bayesian-network.json  # 8 propositions + CPTs
└── models/
    ├── knowledge-graph.html
    ├── semantic-network.html
    ├── ontology-browser.html
    └── bayesian-network.html
```
