-- C# code snippets for typing practice

return {
  {
    "public static void Main(string[] args)",
    "{",
    "  Console.WriteLine(\"Hello, World!\");",
    "}",
  },

  {
    "public class User",
    "{",
    "  public string Name { get; set; }",
    "  public int Age { get; set; }",
    "}",
  },

  {
    "foreach (var item in items)",
    "{",
    "  Console.WriteLine(item);",
    "}",
  },

  {
    "if (string.IsNullOrWhiteSpace(name))",
    "{",
    "  throw new ArgumentException(\"name is required\");",
    "}",
  },

  {
    "try",
    "{",
    "  await service.RunAsync();",
    "}",
    "catch (Exception ex)",
    "{",
    "  logger.LogError(ex, \"Run failed\");",
    "}",
  },

  {
    "var numbers = Enumerable.Range(1, 10)",
    "  .Where(n => n % 2 == 0)",
    "  .Select(n => n * 2)",
    "  .ToList();",
  },

  {
    "public record Point(int X, int Y);",
  },

  {
    "using var stream = File.OpenRead(path);",
    "using var reader = new StreamReader(stream);",
    "var content = reader.ReadToEnd();",
  },

  {
    "public interface IRepository<T>",
    "{",
    "  Task<T?> GetByIdAsync(Guid id);",
    "  Task SaveAsync(T entity);",
    "}",
  },

  {
    "return status switch",
    "{",
    "  Status.Ready => true,",
    "  _ => false,",
    "};",
  },
}
