#!/usr/bin/env python3
"""
gml2csv.py
Read a GML graph with python-igraph, compute a layout, run community detection,
and export a CSV for the QBasic network drawer.

Output format (headless CSV):
    x1,y1,x2,y2,source_cluster,target_cluster

Notes:
- Coordinates are normalized to [0,1].
- Y axis is flipped so (0,0) is top-left, like VGA/DOS screen coords.
- Newlines are CRLF (\r\n).
- Encoding is ASCII for QBasic compatibility.
- Last two columns contain cluster numbers (0-N) for source and target nodes.
"""

import sys
import csv
from igraph import Graph


def normalize(coords):
    xs = [x for x, _ in coords]
    ys = [y for _, y in coords]
    xmin, xmax = min(xs), max(xs)
    ymin, ymax = min(ys), max(ys)
    xr = xmax - xmin or 1.0
    yr = ymax - ymin or 1.0

    out = []
    for x, y in coords:
        xn = (x - xmin) / xr
        yn = 1.0 - (y - ymin) / yr  # flip Y
        out.append((max(0.0, min(1.0, xn)),
                    max(0.0, min(1.0, yn))))
    return out


def main(inp, outp):
    g: Graph = Graph.Read_GML(inp)
    g = g.connected_components().giant()


    # Compute deterministic layout
    #layout = g.layout_fruchterman_reingold()
    layout = g.layout_kamada_kawai()
    coords = normalize([tuple(p) for p in layout])

    # Run community detection using spinglass method
    communities = g.community_spinglass(spins=16)
    cluster_membership = communities.membership

    with open(outp, "w", newline="", encoding="ascii", errors="ignore") as f:
        w = csv.writer(f, lineterminator="\r\n")
        for e in g.es:
            u, v = e.source, e.target
            x1, y1 = coords[u]
            x2, y2 = coords[v]
            source_cluster = cluster_membership[u]
            target_cluster = cluster_membership[v]
            w.writerow([f"{x1:.6f}", f"{y1:.6f}",
                        f"{x2:.6f}", f"{y2:.6f}",
                        str(source_cluster), str(target_cluster)])


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python gml2csv_igraph.py input.gml edges.csv", file=sys.stderr)
        sys.exit(1)
    main(sys.argv[1], sys.argv[2])