DAY ?= 1
CXX := g++
CXX_FLAGS := -std=c++23 -Wall -Wextra -Wpedantic -O2

TARGET := day_$(DAY)
SOURCES := src/$(TARGET).cpp
OBJ := obj/$(TARGET).o
BIN := bin/$(TARGET)

$(BIN): $(OBJ)
	$(CXX) $(CXX_FLAGS) -o $@ $^

$(OBJ): $(SOURCES)
	$(CXX) $(CXX_FLAGS) -c $< -o $@

run: $(BIN)
	./$<
