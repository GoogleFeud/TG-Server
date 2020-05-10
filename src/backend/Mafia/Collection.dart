

import 'dart:math';

 class Collection<K, V> {
    Map<K, V> _map;
    Random _rng;

    Collection([Iterable<MapEntry<K, V>> entries]) {
      this._map = new Map<K, V>();
      if (entries != null) this._map.addEntries(entries);
      this._rng = new Random();
    }

    V get(K key) {
      return this._map[key];
    }

    V set(K key, V val) {
       this._map[key] = val;
       return val;
    }

    void delete(K key) {
      this._map.remove(key);
    }

    bool has(K key) {
      return this._map.containsKey(key);
    }

    void forEach(Function(V) cb) {
            for (MapEntry<K, V> entry in this._map.entries) {
            cb(entry.value);
      }
    }

    bool some(Function(V) cb) {
      for (MapEntry<K, V> entry in this._map.entries) {
            if (cb(entry.value) == true) return true;
      }
      return false;
    }

    bool every(Function(V) cb) {
        for (MapEntry<K, V> entry in this._map.entries) {
            if (cb(entry.value) == false) return false;
      }
      return true;
    }

    V find(Function(V) cb) {
        for (MapEntry<K, V> entry in this._map.entries) {
            if (cb(entry.value) == true) return entry.value;
      }
      return null;
    }

    Collection<K, V> filter(Function(V) cb) {
         Collection<K, V> res = new Collection<K, V>();
          for (MapEntry<K, V> entry in this._map.entries) {
            if (cb(entry.value) == true) res.set(entry.key, entry.value);
          }
        return res;
    }

    List<V> filterList(Function(V) cb) {
          List<V> res = [];
          for (MapEntry<K, V> entry in this._map.entries) {
            if (cb(entry.value) == true) res.add(entry.value);
          }
        return res;
    }

    List<R> map<R>(Function(V) cb) {
        List<R> res = [];
          for (MapEntry<K, V> entry in this._map.entries) {
              res.add(cb(entry.value));
          }
        return res;
    }

    List<Collection<K, V>> partition(Function(V) cb) {
        List<Collection<K, V>> res = [new Collection(), new Collection()];
          for (MapEntry<K, V> entry in this._map.entries) {
              if (cb(entry.value) == true) res[0].set(entry.key, entry.value);
              else res[1].set(entry.key, entry.value);
          }
        return res;
    }

    Collection<K, V> sweep(Function(V) cb) {
        Collection<K, V> res = new Collection();
        List entries = this._map.entries.toList();
          for (MapEntry<K, V> entry in entries) {
              if (cb(entry.value) == true) {
                res.set(entry.key, entry.value);
                this.delete(entry.key);
              }
        }
        return res;
    }

    Collection<K, V> clone() {
        return new Collection(this._map.entries);
    }

    List<V> random({amount: 1, Function filter}) {
        List<V> vals;
        if (filter != null) vals = this.filterList(filter);
        else vals = this._map.values.toList();
        if (vals.length == 0) return [];
        return new List<V>(amount).map((val) => vals.removeAt(this._rng.nextInt(vals.length))).toList();
    }

    V first() {
      return this._map.values.elementAt(0);
    }

    V last() {
      return this._map.values.elementAt(this._map.length - 1);
    }

    Map<K, V> toMap() {
      return this._map;
    }

    Iterable<V> values() {
      return this._map.values.toList();
    }

    String toString() {
      return this._map.toString();
    }

    void clear() {
      return this._map.clear();
    }

    int get size {
       return this._map.length;
     }

}

class Bitfield {
    int bits;

    Bitfield([int bits]) {
      this.bits = bits ?? 0;
    }

     bool get(int position) {
       return (this.bits & (1 << position)) == 0 ? false : true;
    }

    void set(int bits) {
      this.bits |= bits;
    }

    void update(int position, int bitValue) {
       this.bits ^= (1 << position);
    }


}