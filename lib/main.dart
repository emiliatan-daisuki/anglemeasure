import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TiltAngleScreen(),
    );
  }
}

class TiltAngleScreen extends StatefulWidget {
  @override
  _TiltAngleScreenState createState() => _TiltAngleScreenState();
}

class _TiltAngleScreenState extends State<TiltAngleScreen> {
  int _selectedIndex = 0;
  double _angleX = 0.0;
  double _angleY = 0.0;
  bool _isAngleXZero = false;
  bool _isAngleYZero = false;

  @override
  void initState() {
    super.initState();

    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        _angleX = _calculateAngle(event.x, event.y);
        _angleY = _calculateAngle(event.y, event.z);

        if (_angleX.toInt() == 0 && !_isAngleXZero) {
          _isAngleXZero = true;
          _delayBackgroundChangeX();
        } else if (_angleX.toInt() != 0) {
          _isAngleXZero = false;
        }

        if (_angleY.toInt() == 0 && !_isAngleYZero) {
          _isAngleYZero = true;
          _delayBackgroundChangeY();
        } else if (_angleY.toInt() != 0) {
          _isAngleYZero = false;
        }
      });
    });
  }

  double _calculateAngle(double axis1, double axis2) {
    return atan2(axis2, axis1) * 180 / pi;
  }

  void _delayBackgroundChangeX() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        if (_angleX.toInt() == 0) {
          _getBackgroundColor();
        }
      });
    });
  }

  void _delayBackgroundChangeY() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        if (_angleY.toInt() == 0) {
          _getBackgroundColor();
        }
      });
    });
  }

  // 배경 색상 계산 함수
  Color _getBackgroundColor() {
    if (_selectedIndex == 0) {
      if (_angleX.toInt() == 0) {
        return Colors.green;
      } else if (_angleX < 0) {
        return Colors.red;
      } else {
        return Colors.white;
      }
    } else {
      if (_angleY.toInt() == 0) {
        return Colors.green;
      } else if (_angleY < 0) {
        return Colors.red;
      } else {
        return Colors.white;
      }
    }
  }

  Widget _getCurrentPage() {
    switch (_selectedIndex) {
      case 0:
        return _buildAnglePage('X 축 기울기 각도: ${_angleX.toInt()}°');
      case 1:
        return _buildAnglePage('Y 축 기울기 각도: ${_angleY.toInt()}°');
      default:
        return _buildAnglePage('X 축 기울기 각도: ${_angleX.toInt()}°');
    }
  }

  Widget _buildAnglePage(String angleText) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(angleText, style: TextStyle(fontSize: 24)),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('기울기 각도 측정기'),
      ),
      body: _getCurrentPage(),
      backgroundColor: _getBackgroundColor(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_upward),
            label: 'X축',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: 'Y축',
          ),
        ],
      ),
    );
  }
}