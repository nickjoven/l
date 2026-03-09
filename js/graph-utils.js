/**
 * graph-utils.js — Shared D3 utilities for epistemic knowledge visualizations
 */

/**
 * Attach zoom+pan behavior to an SVG.
 * @param {d3.Selection} svg - The outer SVG element
 * @param {d3.Selection} g   - The inner <g> that will be transformed
 * @param {object} [opts]
 * @returns {d3.ZoomBehavior}
 */
export function createZoom(svg, g, opts = {}) {
  const { scaleMin = 0.1, scaleMax = 8 } = opts;
  const zoom = d3.zoom()
    .scaleExtent([scaleMin, scaleMax])
    .on('zoom', (event) => g.attr('transform', event.transform));
  svg.call(zoom);
  return zoom;
}

/**
 * Reset zoom to fit the content in the viewport.
 * @param {d3.Selection} svg
 * @param {d3.ZoomBehavior} zoom
 * @param {d3.Selection} g
 */
export function resetZoom(svg, zoom, g) {
  const { width, height } = svg.node().getBoundingClientRect();
  svg.transition().duration(600).call(
    zoom.transform,
    d3.zoomIdentity.translate(width / 2, height / 2)
  );
}

/**
 * Create a floating tooltip.
 * @returns {{ show: Function, move: Function, hide: Function, el: HTMLElement }}
 */
export function createTooltip() {
  const el = document.createElement('div');
  el.className = 'tooltip';
  el.style.opacity = '0';
  el.style.pointerEvents = 'none';
  document.body.appendChild(el);

  return {
    el,
    show(html, event) {
      el.innerHTML = html;
      el.style.opacity = '1';
      this.move(event);
    },
    move(event) {
      const x = event.clientX + 16;
      const y = event.clientY - 10;
      const rect = el.getBoundingClientRect();
      el.style.left = Math.min(x, window.innerWidth - rect.width - 8) + 'px';
      el.style.top = Math.max(8, Math.min(y, window.innerHeight - rect.height - 8)) + 'px';
    },
    hide() {
      el.style.opacity = '0';
    }
  };
}

/**
 * Create drag behavior for force-directed nodes.
 * @param {d3.Simulation} simulation
 * @returns {d3.DragBehavior}
 */
export function createDrag(simulation) {
  return d3.drag()
    .on('start', (event, d) => {
      if (!event.active) simulation.alphaTarget(0.3).restart();
      d.fx = d.x;
      d.fy = d.y;
    })
    .on('drag', (event, d) => {
      d.fx = event.x;
      d.fy = event.y;
    })
    .on('end', (event, d) => {
      if (!event.active) simulation.alphaTarget(0);
      d.fx = null;
      d.fy = null;
    });
}

/**
 * Map relation/type strings to colors.
 */
export const RELATION_COLORS = {
  'is-a':     '#58a6ff',
  'part-of':  '#56d364',
  'causes':   '#f78166',
  'enables':  '#39d0d8',
  'opposes':  '#f0a500',
  'requires': '#d2a8ff',
  'defines':  '#e8c77a',
  'supports': '#7ee8a2',
  'implies':  '#c4a3f5',
  'has':      '#9ecfff',
  'default':  '#8b949e'
};

export function relationColor(type) {
  return RELATION_COLORS[type] || RELATION_COLORS.default;
}

/**
 * Map node types to fill colors.
 */
export const NODE_TYPE_COLORS = {
  'mental-state':    '#58a6ff',
  'epistemic':       '#d2a8ff',
  'logical':         '#56d364',
  'cognitive':       '#39d0d8',
  'social':          '#f0a500',
  'metaphysical':    '#f78166',
  'linguistic':      '#e8c77a',
  'default':         '#8b949e'
};

export function nodeTypeColor(type) {
  return NODE_TYPE_COLORS[type] || NODE_TYPE_COLORS.default;
}

/**
 * Define SVG arrowhead marker(s).
 * @param {d3.Selection} svg
 * @param {string} [id='arrow']
 * @param {string} [color='#8b949e']
 */
export function defineArrow(svg, id = 'arrow', color = '#8b949e') {
  const defs = svg.append('defs');
  defs.append('marker')
    .attr('id', id)
    .attr('viewBox', '0 -5 10 10')
    .attr('refX', 20)
    .attr('refY', 0)
    .attr('markerWidth', 6)
    .attr('markerHeight', 6)
    .attr('orient', 'auto')
    .append('path')
    .attr('d', 'M0,-5L10,0L0,5')
    .attr('fill', color);
  return defs;
}

/**
 * Define a named arrow marker with a given color.
 */
export function defineColoredArrow(defs, id, color) {
  defs.append('marker')
    .attr('id', id)
    .attr('viewBox', '0 -5 10 10')
    .attr('refX', 20)
    .attr('refY', 0)
    .attr('markerWidth', 6)
    .attr('markerHeight', 6)
    .attr('orient', 'auto')
    .append('path')
    .attr('d', 'M0,-5L10,0L0,5')
    .attr('fill', color);
}

/**
 * BFS shortest path between two node IDs in an adjacency graph.
 * @param {string} startId
 * @param {string} endId
 * @param {Array} edges - array of {source: id, target: id}
 * @returns {string[]|null} Array of node IDs on shortest path, or null
 */
export function bfsPath(startId, endId, edges) {
  // Build undirected adjacency map
  const adj = {};
  for (const e of edges) {
    const s = typeof e.source === 'object' ? e.source.id : e.source;
    const t = typeof e.target === 'object' ? e.target.id : e.target;
    if (!adj[s]) adj[s] = [];
    if (!adj[t]) adj[t] = [];
    adj[s].push(t);
    adj[t].push(s);
  }
  // BFS
  const visited = new Set([startId]);
  const queue = [[startId]];
  while (queue.length) {
    const path = queue.shift();
    const node = path[path.length - 1];
    if (node === endId) return path;
    for (const neighbor of (adj[node] || [])) {
      if (!visited.has(neighbor)) {
        visited.add(neighbor);
        queue.push([...path, neighbor]);
      }
    }
  }
  return null;
}

/**
 * Wrap long text into multiple <tspan> elements inside an SVG <text>.
 * @param {d3.Selection} textSel - d3 selection of <text> elements
 * @param {number} width - max pixel width per line
 */
export function wrapText(textSel, width) {
  textSel.each(function() {
    const text = d3.select(this);
    const words = text.text().split(/\s+/).reverse();
    const lineHeight = 1.2;
    const y = text.attr('y') || 0;
    const dy = parseFloat(text.attr('dy') || 0);
    let line = [];
    let lineNumber = 0;
    let word;
    let tspan = text.text(null).append('tspan')
      .attr('x', 0).attr('y', y).attr('dy', dy + 'em');
    while ((word = words.pop())) {
      line.push(word);
      tspan.text(line.join(' '));
      if (tspan.node().getComputedTextLength() > width) {
        line.pop();
        tspan.text(line.join(' '));
        line = [word];
        tspan = text.append('tspan')
          .attr('x', 0)
          .attr('y', y)
          .attr('dy', ++lineNumber * lineHeight + dy + 'em')
          .text(word);
      }
    }
  });
}
