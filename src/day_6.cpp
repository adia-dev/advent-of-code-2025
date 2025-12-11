#include <vector>

int foo(int x) {
  int y = x + 1; // should be suggested as const
  return y;
}

int main() { return 0; }
