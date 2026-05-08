-- C++ code snippets for typing practice

return {
  {
    "int main() {",
    "  std::cout << \"Hello, world!\" << std::endl;",
    "  return 0;",
    "}",
  },

  {
    "class User {",
    "public:",
    "  User(std::string name, int age) : name_(std::move(name)), age_(age) {}",
    "",
    "private:",
    "  std::string name_;",
    "  int age_;",
    "};",
  },

  {
    "std::vector<int> values = {1, 2, 3, 4};",
    "for (const auto& value : values) {",
    "  std::cout << value << std::endl;",
    "}",
  },

  {
    "if (result.has_value()) {",
    "  return result.value();",
    "}",
  },

  {
    "try {",
    "  process_data();",
    "} catch (const std::exception& ex) {",
    "  std::cerr << ex.what() << std::endl;",
    "}",
  },

  {
    "auto add = [](int a, int b) {",
    "  return a + b;",
    "};",
  },

  {
    "std::unordered_map<std::string, int> counts;",
    "counts[\"apples\"] = 3;",
  },

  {
    "template <typename T>",
    "T max_value(const T& left, const T& right) {",
    "  return left > right ? left : right;",
    "}",
  },

  {
    "std::unique_ptr<User> user = std::make_unique<User>(\"Ada\", 32);",
    "user->print();",
  },

  {
    "switch (state) {",
    "case State::Ready:",
    "  start();",
    "  break;",
    "default:",
    "  stop();",
    "  break;",
    "}",
  },
}
