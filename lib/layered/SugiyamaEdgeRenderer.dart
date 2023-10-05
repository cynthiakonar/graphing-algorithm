part of graphview;

class SugiyamaEdgeRenderer extends ArrowEdgeRenderer {
  Map<Node, SugiyamaNodeData> nodeData;
  SugiyamaConfiguration configuration;

  SugiyamaEdgeRenderer(this.nodeData, this.configuration);

  var linePath = Path();

  @override
  void render(Canvas canvas, Graph graph, Paint paint) {
    var levelSeparationHalf = configuration.levelSeparation / 2;

    graph.nodes.forEach((node) {
      var children = graph.successorsOf(node);

      children.forEach((child) {
        var layer = nodeData[child]!.layer;
        var edge = graph.getEdgeBetween(node, child);
        var edgePaint = (edge?.paint ?? paint)..style = PaintingStyle.stroke;
        linePath.reset();

        linePath.moveTo(child.x + child.width / 2, child.y + child.height);
        linePath.lineTo(child.x + child.width / 2,
            child.y + child.height + levelSeparationHalf);
        linePath.lineTo(node.x + node.width / 2,
            child.y + child.height + levelSeparationHalf);

        linePath.moveTo(node.x + node.width / 2,
            child.y + child.height + levelSeparationHalf);
        linePath.lineTo(node.x + node.width / 2, node.y + node.height);
        canvas.drawPath(linePath, edgePaint);
      });
    });
  }
}
