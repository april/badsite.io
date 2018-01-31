class MixedObjectLoader {
  static function main() {
    var req = new haxe.Http('http://http.badsite.test/');
    req.request(true);
  }
}
