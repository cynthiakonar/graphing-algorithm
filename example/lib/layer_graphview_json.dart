import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class LayerGraphPageFromJson extends StatefulWidget {
  @override
  _LayerGraphPageFromJsonState createState() => _LayerGraphPageFromJsonState();
}

class _LayerGraphPageFromJsonState extends State<LayerGraphPageFromJson> {
  var json = {
    'nodes': [
      {'id': 1, 'name': 'Raja', 'relation': 'Son'},
      {'id': 2, 'name': 'Ronit', 'relation': 'Father'},
      {'id': 4, 'name': 'Haresh', 'relation': 'Grandfather'},
      {'id': 5, 'name': 'Malini', 'relation': 'Grandmother'},
      {'id': 6, 'name': 'Jagendra', 'relation': 'Grandfather'},
      {'id': 7, 'name': 'Khushi', 'relation': 'Grandmother'},
      {'id': 9, 'name': 'Heena', 'relation': 'Daughter'},
      {'id': 10, 'name': 'Rani', 'relation': 'Mother'},
      {'id': 11, 'name': 'Kiara', 'relation': 'Daughter'},
      {'id': 12, 'name': 'Jenny', 'relation': 'Daughter'},
      {'id': 13, 'name': 'John', 'relation': 'Son'},
      {'id': 14, 'name': 'Puja', 'relation': 'Aunt'},
    ],
    'edges': [
      {'child': 1, 'parent': 2},
      {'child': 1, 'parent': 10},
      {'child': 9, 'parent': 2},
      {'child': 9, 'parent': 10},
      {'child': 2, 'parent': 4},
      {'child': 2, 'parent': 5},
      {'child': 11, 'parent': 2},
      {'child': 11, 'parent': 10},
      {'child': 12, 'parent': 2},
      {'child': 12, 'parent': 10},
      {'child': 13, 'parent': 2},
      {'child': 13, 'parent': 10},
      {'child': 10, 'parent': 6},
      {'child': 10, 'parent': 7},
      {'child': 14, 'parent': 6},
      {'child': 14, 'parent': 7},
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Wrap(
              children: [
                Container(
                  width: 100,
                  child: TextFormField(
                    initialValue: builder.nodeSeparation.toString(),
                    decoration: InputDecoration(labelText: 'Node Separation'),
                    onChanged: (text) {
                      builder.nodeSeparation = int.tryParse(text) ?? 100;
                      this.setState(() {});
                    },
                  ),
                ),
                Container(
                  width: 100,
                  child: TextFormField(
                    initialValue: builder.levelSeparation.toString(),
                    decoration: InputDecoration(labelText: 'Level Separation'),
                    onChanged: (text) {
                      builder.levelSeparation = int.tryParse(text) ?? 100;
                      this.setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: InteractiveViewer(
                  constrained: false,
                  boundaryMargin: const EdgeInsets.all(double.infinity),
                  minScale: 0.01,
                  maxScale: 5.6,
                  child: GraphView(
                    graph: graph,
                    algorithm: SugiyamaAlgorithm(builder),
                    paint: Paint()
                      ..color = Colors.green
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      // I can decide what widget should be shown here based on the id
                      var a = node.key!.value;
                      return rectangleWidget(a.toString(), node);
                    },
                  )),
            ),
          ],
        ));
  }

  Widget rectangleWidget(String? a, Node node) {
    return Container(
      color: Colors.amber,
      child: InkWell(
        onTap: () {
          print('clicked');
        },
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
              ],
            ),
            child: Text('${a}')),
      ),
    );
  }

  final Graph graph = Graph()..isTree = true;
  @override
  void initState() {
    var edges = json['edges']!;
    var currentParent = edges[0]['parent'];
    edges.forEach((element) {
      var childNodeId = element['child'];
      var parentNodeId = element['parent'];
      var source = Node.Id(childNodeId);
      if (currentParent != parentNodeId) {
        source.position = Offset(0110, 40);
        currentParent = parentNodeId;
      }
      graph.addEdge(source, Node.Id(parentNodeId));
    });

    builder
      ..nodeSeparation = (10)
      ..levelSeparation = (20)
      ..orientation = SugiyamaConfiguration.ORIENTATION_BOTTOM_TOP;
  }
}

var builder = SugiyamaConfiguration();
