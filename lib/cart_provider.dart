import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  Map<String, dynamic> farmers = {};
  Map<String, int> tools = {};
  Map<String, int> machines = {};
  Map<String, int> seeds = {};

  void setFarmers(int count, String area) {
    farmers = {'count': count, 'area': area};
    notifyListeners();
  }

  void setTools(Map<String, int> newTools) {
    tools = Map.from(newTools);
    notifyListeners();
  }

  void setMachines(Map<String, int> newMachines) {
    machines = Map.from(newMachines);
    notifyListeners();
  }

  void setSeeds(Map<String, int> newSeeds) {
    seeds = Map.from(newSeeds);
    notifyListeners();
  }

  void clearCart() {
    farmers = {};
    tools = {};
    machines = {};
    seeds = {};
    notifyListeners();
  }

  void incrementSeed(String name) {
    seeds[name] = (seeds[name] ?? 0) + 1;
    notifyListeners();
  }

  void decrementSeed(String name) {
    if (seeds[name] != null && seeds[name]! > 0) {
      seeds[name] = seeds[name]! - 1;
      if (seeds[name] == 0) seeds.remove(name);
      notifyListeners();
    }
  }

  void incrementMachine(String name) {
    machines[name] = (machines[name] ?? 0) + 1;
    notifyListeners();
  }

  void decrementMachine(String name) {
    if (machines[name] != null && machines[name]! > 0) {
      machines[name] = machines[name]! - 1;
      if (machines[name] == 0) machines.remove(name);
      notifyListeners();
    }
  }

  void incrementTool(String name) {
    tools[name] = (tools[name] ?? 0) + 1;
    notifyListeners();
  }

  void decrementTool(String name) {
    if (tools[name] != null && tools[name]! > 0) {
      tools[name] = tools[name]! - 1;
      if (tools[name] == 0) tools.remove(name);
      notifyListeners();
    }
  }

  void incrementFarmers() {
    farmers['count'] = (farmers['count'] ?? 0) + 1;
    notifyListeners();
  }

  void decrementFarmers() {
    if ((farmers['count'] ?? 0) > 0) {
      farmers['count'] = farmers['count'] - 1;
      notifyListeners();
    }
  }

  Map<String, dynamic> get cartData => {
        'farmers': farmers,
        'tools': tools,
        'machines': machines,
        'seeds': seeds,
      };
}
