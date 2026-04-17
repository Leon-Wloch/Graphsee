module

public meta import ProofWidgets.Component.GraphDisplay
public meta import ProofWidgets.Component.Panel.Basic
public meta import ProofWidgets.Component.OfRpcMethod
import Lean4Graphsee.graph_options

public meta section

open Lean Meta ProofWidgets Jsx

-- Check if an expression is of the form T → T → Prop.
def isRelationType (e : Expr) : MetaM (Option Expr) := do
  match e with
  | .forallE _ t1 (.forallE _ t2 (.sort .zero) _) _ =>
    if ← isDefEq t1 t2 then
      return some t1
    else
      return none
  | _ => return none

-- Stores a relation and its corresponding world type.
structure RelationInfo where
  relation : Expr
  worldType : Expr

-- Build the Kripke frame graph from the local context.
def drawKripkeGraph (lctx : LocalContext) : MetaM Html := do
  let mut relations : Array RelationInfo := #[]
  -- Find all relations and their corresponding worldtyle in the local context.
  for decl in lctx do
    if let some t ← isRelationType decl.type then
      relations := relations.push {
        relation := mkFVar decl.fvarId
        worldType := t
      }

  if relations.isEmpty then
    return <span>No relation of the form R: T → T → Prop found.</span>

  -- Use the relations to find all worlds.
  let mut worlds : Std.HashSet String := {}
  for info in relations do
    for decl in lctx do
      if ← isDefEq decl.type info.worldType then
        worlds := worlds.insert decl.userName.toString

  -- Create GraphDisplay vertices from found worlds.
  let vertices : Array GraphDisplay.Vertex := worlds.toArray.map ({id := ·})

  -- Create GraphDisplay edges from found relations.
  let mut edges : Array GraphDisplay.Edge := #[]
  for info in relations do
    for decl in lctx do
      match decl.type with
      | .app (.app r w1) w2 =>
        if ← isDefEq r info.relation then
          let w1str := toString (← ppExpr w1)
          let w2str := toString (← ppExpr w2)
          edges := edges.push {source := w1str, target := w2str}
      | _ => pure ()

  return <GraphDisplay
    vertices={vertices}
    edges={edges}
    showDetails={false}
  />


open Lean Server ProofWidgets in
@[server_rpc_method]
def KripkeGraph.rpc (props : PanelWidgetProps) : RequestM (RequestTask Html) :=
  RequestM.asTask do
    let inner : Html ← do
      if props.goals.isEmpty then
        return <span>No goals.</span>
      let some g := props.goals[0]? | unreachable!
      g.ctx.val.runMetaM {} do
        let md ← g.mvarId.getDecl
        let lctx := md.lctx |>.sanitizeNames.run' {options := (← getOptions)}
        let options ← getOptions
        if !options.getBool `Kripke.showGraph then
          return <span></span>
        Meta.withLCtx lctx md.localInstances do
          drawKripkeGraph lctx
    return <details «open»={true}>
      <summary className="mv2 pointer">Graph Display</summary>
      <div className="ml1">{inner}</div>
    </details>

@[widget_module]
def KripkeGraph : Component ProofWidgets.PanelWidgetProps :=
  mk_rpc_widget% KripkeGraph.rpc

show_panel_widgets [KripkeGraph]
