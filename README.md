# Graphsee
Graphsee is a [Lean 4](https://github.com/leanprover/lean4) library which introduces a widget for visualising relational structures which can be represented as graphs. Currently, only Kripke model visualisation has been implemented. 

The library utilises [ProofWidgets](https://github.com/leanprover-community/ProofWidgets4) as a dependency, building upon its [GraphDisplay](https://github.com/leanprover-community/ProofWidgets4/blob/main/ProofWidgets/Component/GraphDisplay.lean) component. In order to allow for self-loops, we use a [forked version of ProofWidgets](https://github.com/Leon-Wloch/ProofWidgets4) with the necessary change made.

This library is part of Leonard Wloch's Capstone Thesis. 

## Usage

For visualising Kripke models, the widget assumes that:
- Relations (edges) are in the form `h : R w1 w2` where `R` is in the form `R : W → W → Prop`
- Worlds (vertices) are inferred from relation instances.
- Atomic Propositions are in the form `h: P w1` where `P` is in the form `P: W → Prop`

This is done so that the visualisation is automatic and doesn't require additional user annotation. However, this does mean that you must use this specific representation of Kripke models for the widget to work.

For more specifics about the implementation, refer to [this paper which explains the design decisions behind Graphsee]().

### Getting Started

To use Graphsee in your project, clone this repository and run `lake build`, as shown below:
```
git clone https://github.com/Leon-Wloch/Graphsee
cd Graphsee/
lake build
```
### Demos
<img width="1795" height="886" alt="image" src="https://github.com/user-attachments/assets/9d13e6d3-1959-49bc-a5fb-98a58a4abc0c" />

The screenshot above shows a basic use-case for Graphsee, visualising three worlds and the three relations between them. 

For more demonstrations, see `Demo/GraphseeDemos.lean`.

### Options

Graphsee includes settings the user can change using `set_option` e.g. `set_option graphsee.edgeLength 200`, or specify options on a per-theorem basis using `set_option ... in`. 

Below is a table of the available options:

| Option | Default | Description |
|--------|---------|-------------|
| `showGraph` | `true` | Enable or disable the graph display |
| `showGoal` | `true` | Visualise the goal as a dashed arrow |
| `showHeteroRelations` | `false` | Enable heterogeneous relation display |
| `edgeColours` | `"default"` | Colour palette for relation edges |
| `edgeLength` | `125` | Length of edges in pixels |
| `edgeThickness` | `2` | Thickness of edges in pixels |
| `edgeFontSize` | `11` | Font size for edge labels in pixels |
| `vertexRadius` | `12` | Minimum radius of vertex circles in pixels |
| `vertexFontSize` | `11` | Font size for vertex labels in pixels |
| `atomicPropsFontSize` | `11` | Font size for atomic proposition labels in pixels |

##


