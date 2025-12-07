#include <filesystem>
#include <fstream>
#include <print>
#include <ranges>
#include <sstream>
#include <string>
#include <vector>

using namespace std;
namespace fs = std::filesystem;

const auto BASE_PATH = "../inputs/";

string read_input(string_view name, bool test = false) {
  string path =
      string(BASE_PATH) + name.data() + (test ? "_test" : "") + ".txt";

  if (!fs::exists(path)) {
    println("Failed to open the input at: {}", path);
    return "";
  }

  ifstream f(path);
  stringstream ss;
  ss << f.rdbuf();
  return ss.str();
}

int main(int argc, char *argv[]) {
  const auto input = read_input("day_4", false);
  std::println("{}\n", input);

  auto grid = input | std::views::split('\n') |
              std::views::filter([](const auto &s) { return !s.empty(); }) |
              std::ranges::to<std::vector<std::string>>();

  const size_t n = grid.size();
  const size_t m = grid[0].size();

  int count = 0;

  while (true) {
    bool removed = false;
    for (size_t i = 0; i < n; ++i) {
      for (size_t j = 0; j < m; ++j) {
        if (grid[i][j] != '@')
          continue;

        const auto count_neighbors = [&]() {
          size_t neighbors = 0;

          for (int dy = -1; dy <= 1; ++dy) {
            for (int dx = -1; dx <= 1; ++dx) {
              if (dx == 0 && dy == 0)
                continue;

              if (i + dy >= n || j + dx >= m || i + dy < 0 || j + dx < 0)
                continue;

              neighbors += grid[i + dy][j + dx] == '@';
            }
          }

          return neighbors;
        };
        const auto neighbors = count_neighbors();
        if (neighbors < 4) {
          removed = true;
          grid[i][j] = '.';
          count++;
        }
      }
    }

    if (!removed) {
      break;
    }
  }

  for (const auto &row : grid) {
    println("{}", row);
  }

  println("result: {}", count);
  return 0;
}
