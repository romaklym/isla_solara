import 'dart:async';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cube/flutter_cube.dart';

class GlobeWidget extends StatefulWidget {
  final double zoomIn;
  const GlobeWidget({
    super.key,
    this.zoomIn = 12.5,
  });

  @override
  GlobeWidgetState createState() => GlobeWidgetState();
}

class GlobeWidgetState extends State<GlobeWidget>
    with SingleTickerProviderStateMixin {
  late Scene _scene;
  Object? _earth;
  late Object _stars;
  late AnimationController _controller;
  String _currentTexture = 'assets/4096_earth.jpg';
  late ui.Image earthTexture;
  late ui.Image nightTexture;
  late ui.Image starsTexture;
  bool _texturesLoaded = false;

  Future<ui.Image> loadTexture(String path) async {
    final ByteData data = await rootBundle.load(path);
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(Uint8List.view(data.buffer), (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  @override
  void initState() {
    super.initState();

    // Determine whether to show day or night texture
    final now = DateTime.now();
    final isDayTime = now.hour >= 6 && now.hour < 18; // Between 6 AM and 6 PM
    _currentTexture =
        isDayTime ? 'assets/4096_earth.jpg' : 'assets/4096_night_lights.jpg';

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      earthTexture = await loadTexture('assets/4096_earth.jpg');
      nightTexture = await loadTexture('assets/4096_night_lights.jpg');
      starsTexture = await loadTexture('assets/2k_stars.jpg');

      setState(() {
        _texturesLoaded = true;
      });

      // Initialize Earth and Stars only after textures are loaded
      _initializeEarth();
      _initializeStars();
    });

    _controller =
        AnimationController(duration: const Duration(seconds: 360), vsync: this)
          ..addListener(() {
            if (_earth != null) {
              _earth!.rotation.y = _controller.value * 360;
              _earth!.updateTransform();
              _scene.update();
            }
          })
          ..repeat();
  }

  void generateSphereObject(
    Object parent,
    String name,
    double radius,
    bool backfaceCulling,
    String texturePath,
  ) async {
    final Mesh mesh =
        await generateSphereMesh(radius: radius, texturePath: texturePath);
    parent
        .add(Object(name: name, mesh: mesh, backfaceCulling: backfaceCulling));
    _scene.updateTexture();
  }

  Future<void> generateSphereObjectPreloaded(
    Object parent,
    String name,
    double radius,
    bool backfaceCulling,
    ui.Image texture,
  ) async {
    final Mesh mesh =
        await generateSphereMeshPreloaded(radius: radius, texture: texture);
    parent
        .add(Object(name: name, mesh: mesh, backfaceCulling: backfaceCulling));
    _scene.updateTexture();
  }

  void _onSceneCreated(Scene scene) {
    _scene = scene;
    _scene.camera.position.z = widget.zoomIn;

    if (_texturesLoaded) {
      _initializeEarth();
      _initializeStars();
    }
  }

  void _initializeEarth() {
    if (!_texturesLoaded) return;
    if (_earth != null) {
      _scene.world.remove(_earth!); // Remove the old earth to avoid duplication
    }

    ui.Image selectedTexture = _currentTexture == 'assets/4096_earth.jpg'
        ? earthTexture
        : nightTexture;

    _earth = Object(name: 'earth', scale: Vector3(10.0, 10.0, 10.0));
    generateSphereObjectPreloaded(
        _earth!, 'surface', 0.485, true, selectedTexture);
    generateSphereObject(
        _earth!, 'clouds', 0.495, true, 'assets/4096_clouds.png');
    _scene.world.add(_earth!);
  }

  void _initializeStars() {
    if (!_texturesLoaded) return;

    _stars = Object(name: 'stars', scale: Vector3(2000.0, 2000.0, 2000.0));
    generateSphereObjectPreloaded(_stars, 'surface', 0.50, false, starsTexture);

    _scene.world.add(_stars);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Cube(
        onSceneCreated: _onSceneCreated,
      ),
    );
  }
}

Future<Mesh> generateSphereMesh(
    {num radius = 0.5,
    int latSegments = 32,
    int lonSegments = 64,
    required String texturePath}) async {
  int count = (latSegments + 1) * (lonSegments + 1);
  List<Vector3> vertices = List<Vector3>.filled(count, Vector3.zero());
  List<Offset> texcoords = List<Offset>.filled(count, Offset.zero);
  List<Polygon> indices =
      List<Polygon>.filled(latSegments * lonSegments * 2, Polygon(0, 0, 0));

  int i = 0;
  for (int y = 0; y <= latSegments; ++y) {
    final double v = y / latSegments;
    final double sv = math.sin(v * math.pi);
    final double cv = math.cos(v * math.pi);
    for (int x = 0; x <= lonSegments; ++x) {
      final double u = x / lonSegments;
      vertices[i] = Vector3(radius * math.cos(u * math.pi * 2.0) * sv,
          radius * cv, radius * math.sin(u * math.pi * 2.0) * sv);
      texcoords[i] = Offset(1.0 - u, 1.0 - v);
      i++;
    }
  }

  i = 0;
  for (int y = 0; y < latSegments; ++y) {
    final int base1 = (lonSegments + 1) * y;
    final int base2 = (lonSegments + 1) * (y + 1);
    for (int x = 0; x < lonSegments; ++x) {
      indices[i++] = Polygon(base1 + x, base1 + x + 1, base2 + x);
      indices[i++] = Polygon(base1 + x + 1, base2 + x + 1, base2 + x);
    }
  }

  ui.Image texture = await loadImageFromAsset(texturePath);
  final Mesh mesh = Mesh(
      vertices: vertices,
      texcoords: texcoords,
      indices: indices,
      texture: texture,
      texturePath: texturePath);
  return mesh;
}

Future<Mesh> generateSphereMeshPreloaded({
  num radius = 0.5,
  int latSegments = 32,
  int lonSegments = 64,
  required ui.Image texture,
}) async {
  int count = (latSegments + 1) * (lonSegments + 1);
  List<Vector3> vertices = List<Vector3>.filled(count, Vector3.zero());
  List<Offset> texcoords = List<Offset>.filled(count, Offset.zero);
  List<Polygon> indices =
      List<Polygon>.filled(latSegments * lonSegments * 2, Polygon(0, 0, 0));

  int i = 0;
  for (int y = 0; y <= latSegments; ++y) {
    final double v = y / latSegments;
    final double sv = math.sin(v * math.pi);
    final double cv = math.cos(v * math.pi);
    for (int x = 0; x <= lonSegments; ++x) {
      final double u = x / lonSegments;
      vertices[i] = Vector3(radius * math.cos(u * math.pi * 2.0) * sv,
          radius * cv, radius * math.sin(u * math.pi * 2.0) * sv);
      texcoords[i] = Offset(1.0 - u, 1.0 - v);
      i++;
    }
  }

  i = 0;
  for (int y = 0; y < latSegments; ++y) {
    final int base1 = (lonSegments + 1) * y;
    final int base2 = (lonSegments + 1) * (y + 1);
    for (int x = 0; x < lonSegments; ++x) {
      indices[i++] = Polygon(base1 + x, base1 + x + 1, base2 + x);
      indices[i++] = Polygon(base1 + x + 1, base2 + x + 1, base2 + x);
    }
  }

  final Mesh mesh = Mesh(
    vertices: vertices,
    texcoords: texcoords,
    indices: indices,
    texture: texture,
  );
  return mesh;
}
