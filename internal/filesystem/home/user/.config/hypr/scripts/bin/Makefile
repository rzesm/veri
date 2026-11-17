CXX = g++
CXXFLAGS = -O3 -std=c++20

TARGETS = switch_workspace cursor_control

all: $(TARGETS)

%: %.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

clean:
	rm -f $(TARGETS)
