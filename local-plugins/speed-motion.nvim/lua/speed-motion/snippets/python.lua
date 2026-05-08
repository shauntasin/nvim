-- Python code snippets for typing practice

return {
  {
    "def greet(name: str) -> str:",
    "  return f\"Hello, {name}\"",
  },

  {
    "class User:",
    "  def __init__(self, name: str, age: int) -> None:",
    "    self.name = name",
    "    self.age = age",
  },

  {
    "for index, item in enumerate(items):",
    "  print(index, item)",
  },

  {
    "if value is None:",
    "  raise ValueError(\"value is required\")",
  },

  {
    "try:",
    "  data = json.loads(payload)",
    "except json.JSONDecodeError as exc:",
    "  logger.error(\"invalid payload: %s\", exc)",
  },

  {
    "numbers = [n * 2 for n in range(10) if n % 2 == 0]",
    "total = sum(numbers)",
  },

  {
    "with open(path, \"r\", encoding=\"utf-8\") as file:",
    "  contents = file.read()",
  },

  {
    "async def fetch_data(client, url: str) -> dict:",
    "  response = await client.get(url)",
    "  return response.json()",
  },

  {
    "@dataclass",
    "class Point:",
    "  x: float",
    "  y: float",
  },

  {
    "match status:",
    "  case \"ready\":",
    "    return True",
    "  case _:",
    "    return False",
  },
}
