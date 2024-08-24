import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

class Logger {
  static final StreamController<String> _logStreamController =
      StreamController.broadcast();

  static Stream<String> get logStream => _logStreamController.stream;

  static final AVLTree _tree = AVLTree();

  static void info(String message) {
    _log("INFO", message);
  }

  static void warning(String message) {
    _log("WARNING", message);
  }

  static void error(String message) {
    _log("ERROR", message);
  }

  static void log(String message) {
    _log("LOG", message);
  }

  static void clear() {
    _logStreamController.add('');
    _tree.clear();
    _logStreamController.add(''); // Clear the stream output
  }

  static void close() {
    _logStreamController.close();
  }

  static void _log(String level, String message) {
    final String logMessage = "[$level]: $message";
    final DateTime timestamp = DateTime.now();
    _tree.insert(logMessage, timestamp);
    _printCurrentLogs();
  }

  static void _printCurrentLogs() {
    final StringBuffer buffer = StringBuffer();
    _tree.inOrderTraversal((msg, count) {
      buffer.writeln("[$count] $msg");
    });

    if (buffer.isNotEmpty) {
      // Clear the previous logs before adding new ones
      _logStreamController.add('');
      _logStreamController.add(buffer.toString());

      // Print to debug terminal
      assert(() {
        if (kDebugMode) {
          // Clear the terminal output before printing new logs
          print('\x1B[H\x1B[2J'); // ANSI escape code to clear the terminal
          print(buffer.toString());
        }
        return true;
      }());
    }
  }
}

class AVLTree {
  Node? _root;

  void insert(String message, DateTime timestamp) {
    if (_root == null) {
      _root = Node(message, timestamp);
    } else {
      _root = _root!.insert(message, timestamp);
    }
  }

  void inOrderTraversal(void Function(String, int) visit) {
    _root?.inOrderTraversal(visit);
  }

  void removeWhere(bool Function(DateTime) test) {
    _root = _root?.removeWhere(test);
  }

  void clear() {
    _root = null;
  }
}

class Node {
  String key;
  DateTime timestamp;
  int count;
  Node? left;
  Node? right;
  int height;

  Node(this.key, this.timestamp)
      : count = 1,
        height = 1;

  int _getHeight(Node? node) {
    return node?.height ?? 0;
  }

  int _getBalanceFactor() {
    return _getHeight(left) - _getHeight(right);
  }

  Node _updateHeight() {
    height = 1 + max(_getHeight(left), _getHeight(right));
    return this;
  }

  Node _rotateLeft() {
    final Node newRoot = right!;
    right = newRoot.left;
    newRoot.left = this;
    _updateHeight();
    newRoot._updateHeight();
    return newRoot;
  }

  Node _rotateRight() {
    final Node newRoot = left!;
    left = newRoot.right;
    newRoot.right = this;
    _updateHeight();
    newRoot._updateHeight();
    return newRoot;
  }

  Node insert(String message, DateTime timestamp) {
    if (message == key) {
      count++;
      return this;
    }

    if (message.compareTo(key) < 0) {
      left = left?.insert(message, timestamp) ?? Node(message, timestamp);
    } else {
      right = right?.insert(message, timestamp) ?? Node(message, timestamp);
    }

    return _balance();
  }

  Node _balance() {
    _updateHeight();
    final int balanceFactor = _getBalanceFactor();

    if (balanceFactor > 1) {
      if (left!._getBalanceFactor() < 0) {
        left = left!._rotateLeft();
      }
      return _rotateRight();
    }

    if (balanceFactor < -1) {
      if (right!._getBalanceFactor() > 0) {
        right = right!._rotateRight();
      }
      return _rotateLeft();
    }

    return this;
  }

  Node? removeWhere(bool Function(DateTime) test) {
    if (test(timestamp)) {
      // Node is old, remove this node
      if (right != null) {
        final Node? minNode = right!._findMin();
        key = minNode!.key;
        timestamp = minNode.timestamp;
        count = minNode.count;
        right = right!._removeMin();
      } else {
        return left;
      }
    } else {
      left = left?.removeWhere(test);
      right = right?.removeWhere(test);
    }

    return _balance();
  }

  Node? _findMin() {
    return left?.left == null ? this : left!._findMin();
  }

  Node? _removeMin() {
    if (left == null) {
      return right;
    }

    left = left!._removeMin();
    return _balance();
  }

  void inOrderTraversal(void Function(String, int) visit) {
    left?.inOrderTraversal(visit);
    visit(key, count);
    right?.inOrderTraversal(visit);
  }
}
