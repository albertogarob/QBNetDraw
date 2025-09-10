# QBasic Network Visualizer

> Bridging modern network science with 1991's QBasic: visualize complex network data in glorious 16-color VGA

Transform modern network datasets (GML format) into retro visualizations using QBasic 1.1 and DOSBox. This project demonstrates how cutting-edge algorithms like community detection and force-directed layouts can be rendered with vintage graphics programming.

## What is this?

This project consists of two parts:
1. **Python preprocessor** (`gml2csv.py`) - Converts GML network files to QBasic-friendly CSV format using igraph
2. **QBasic visualizer** (`QBNETDRW.BAS`) - Renders networks in 640x480 VGA with 16-color community detection

## Requirements

- Python 3.6+ with `igraph` library
- DOSBox emulator
- QBasic 1.1 executable (`QBASIC.EXE`) - **not included, must be provided by user**
- Make (optional, for convenience commands)

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/qbasic-network-viz
cd qbasic-network-viz
```

2. Install Python dependencies:
```bash
pip install python-igraph
```

3. Install DOSBox:
   - **Ubuntu/Debian**: `sudo apt install dosbox`
   - **macOS**: `brew install dosbox`
   - **Windows**: Download from [dosbox.com](https://www.dosbox.com/)

4. **Obtain QBasic 1.1**:
   - Place `QBASIC.EXE` in the project root directory
   - QBasic 1.1 was freely distributed by Microsoft (search for "QBasic 1.1 download")

## Quick start

1. Convert a GML network file to CSV:
```bash
python gml2csv.py network.gml network.csv
```

2. Run the QBasic visualizer:
```bash
make run
```

Or manually with DOSBox:
```bash
dosbox -c "mount c ." -c "c:" -c "QBASIC /RUN QBNETDRW.BAS" -c "exit"
```

## File formats

### Input: GML format
```
graph [
  node [
    id 1
    label "Node A"
  ]
  edge [
    source 1
    target 2
  ]
]
```

### Output: CSV format
```
x1,y1,x2,y2,source_cluster,target_cluster
0.451361,0.499280,0.652322,0.204983,8,6
0.542542,0.704034,0.284354,0.576198,10,1
```

Each line represents an edge with normalized coordinates [0,1] and community cluster numbers [0-15].

## Usage

### Python preprocessor

```bash
python gml2csv.py input.gml output.csv
```

The script:
- Extracts the giant component (largest connected component)
- Applies Kamada-Kawai layout algorithm (spring-based, 1989)
- Runs spinglass community detection (targets 16 communities for VGA colors)
- Normalizes coordinates to [0,1] with Y-axis flipped for VGA
- Outputs DOS-compatible CSV (CRLF line endings, ASCII encoding)

### QBasic visualizer

The `QBNETDRW.BAS` script:
- Opens the CSV file
- Scales coordinates to 640x480 VGA resolution
- Draws edges as light gray lines
- Renders nodes as colored circles with white borders
- Uses community detection results for node colors

**QBasic controls:**
- Run: F5
- Stop: Ctrl+Break
- Exit: Alt+F4

**DOSBox controls:**
- Release mouse: Ctrl+F10
- Exit DOSBox: Ctrl+F9
- Toggle fullscreen: Alt+Enter

## Example datasets

Test with classic network datasets:
- **Football**: American college football rivalries
- **C. elegans**: Neural connectome (302 neurons)
- **Dolphins**: Social relationships in Doubtful Sound
- **Les Misérables**: Character co-appearances

Download from the [Newman network collection](http://www-personal.umich.edu/~mejn/netdata/).

## Technical details

### Algorithms used
- **Kamada-Kawai layout**: Spring-based force-directed algorithm from 1989
- **Spinglass community detection**: Physics-inspired clustering using magnetic spin models
- **Giant component extraction**: Focuses on the largest connected subgraph

### Graphics implementation
- **SCREEN 12**: VGA 640x480, 16 colors from 262,144 palette
- **LINE command**: Bresenham's line algorithm
- **CIRCLE command**: Bresenham's circle algorithm  
- **PAINT command**: Flood-fill algorithm

### Data pipeline
```
GML → igraph → Layout → Communities → CSV → QBasic → VGA
```

## Project structure

```
.
├── README.md
├── Makefile
├── gml2csv.py          # Python network preprocessor
├── QBNETDRW.BAS        # QBasic visualization script
├── QBASIC.EXE          # QBasic 1.1 (user must provide)
└──  CSV/               # Converted CSV files
│   ├── CELEGANS.CSV
│   ├── DOLPHINS.CSV
│   ├── LESMIS.CSV
│   └── FOOTBALL.CSV
```

## Makefile commands

- `make run` - Launch QBasic with the network visualizer
- `make convert FILE=network.gml` - Convert GML to CSV
- `make example` - Convert and visualize football network
- `make clean` - Remove generated CSV files

## Troubleshooting

**"QBASIC.EXE not found"**
- Place QBasic 1.1 executable in project root
- Ensure filename is exactly `QBASIC.EXE` (uppercase)

**"No module named 'igraph'"**
- Install: `pip install python-igraph`
- On some systems: `pip install cairocffi` may also be needed

**DOSBox runs but no graphics appear**
- Check that CSV file exists and has data
- Verify CSV format matches expected structure
- Try reducing network size if too large

**"Input/Output Error" in QBasic**
- Ensure CSV uses DOS line endings (CRLF)
- Check file is ASCII-encoded, not UTF-8
- Verify filename matches what's opened in QBNETDRW.BAS

## Contributing

Contributions welcome! Ideas:
- Support for additional network formats
- More layout algorithms
- Enhanced QBasic graphics features
- Performance optimizations
- Additional example datasets

## License

MIT License - see LICENSE file for details.

## Acknowledgments

- igraph library for network analysis
- DOSBox team for DOS emulation
- Microsoft for QBasic (1991)
- Newman et al. for classic network datasets

---

*Read the article about this project on [Medium](https://medium.com/modern-retrocomputing-magazine/time-travel-computing-visualizing-modern-network-data-with-1992s-qbasic-c29ba01c3bdc)*

*Part of the [Modern Retrocomputing Magazine](https://medium.com/modern-retrocomputing-magazine) project - exploring the intersection of vintage computing and contemporary technology.*