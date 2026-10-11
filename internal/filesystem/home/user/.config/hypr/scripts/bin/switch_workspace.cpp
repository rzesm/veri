#include <iostream>
#include <string>
#include <string_view>
#include <filesystem>
#include <cstdlib>
#include <vector>
#include <algorithm>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

namespace fs = std::filesystem;

std::string hyprland_request(std::string_view request) {
    const char* xdg_runtime = std::getenv("XDG_RUNTIME_DIR");
    const char* his = std::getenv("HYPRLAND_INSTANCE_SIGNATURE");
    if (!xdg_runtime || !his) return "";

    fs::path socket_path = fs::path(xdg_runtime) / "hypr" / his / ".socket.sock";
    
    int sock = socket(AF_UNIX, SOCK_STREAM, 0);
    if (sock < 0) return "";
    
    auto closer = [sock]() { close(sock); };

    sockaddr_un addr{};
    addr.sun_family = AF_UNIX;
    std::string path_str = socket_path.string();
    if (path_str.length() >= sizeof(addr.sun_path)) {
        closer();
        return "";
    }
    std::copy(path_str.begin(), path_str.end(), addr.sun_path);

    if (connect(sock, reinterpret_cast<sockaddr*>(&addr), sizeof(addr)) < 0) {
        closer();
        return "";
    }

    if (write(sock, request.data(), request.size()) < 0) {
        closer();
        return "";
    }

    std::string response;
    char buffer[4096];
    ssize_t bytes_read = 0;
    while ((bytes_read = read(sock, buffer, sizeof(buffer))) > 0) {
        response.append(buffer, bytes_read);
    }

    closer();
    return response;
}

int extract_json_int(std::string_view json, std::string_view key) {
    std::string search_key = "\"" + std::string(key) + "\"";
    size_t pos = json.find(search_key);
    if (pos == std::string_view::npos) return -1;

    pos = json.find(':', pos + search_key.length());
    if (pos == std::string_view::npos) return -1;

    pos++;
    while (pos < json.length() && (json[pos] == ' ' || json[pos] == '"' || json[pos] == '\t')) pos++;

    size_t end = pos;
    while (end < json.length() && (std::isdigit(json[end]) || json[end] == '-')) end++;

    try {
        return std::stoi(std::string(json.substr(pos, end - pos)));
    } catch (...) {
        return -1;
    }
}

std::vector<int> extract_all_workspace_ids(std::string_view json) {
    std::vector<int> ids;
    size_t pos = 0;
    std::string search_key = "\"id\"";
    
    while ((pos = json.find(search_key, pos)) != std::string_view::npos) {
        size_t colon = json.find(':', pos + search_key.length());
        if (colon == std::string_view::npos) break;

        size_t start = colon + 1;
        while (start < json.length() && (json[start] == ' ' || json[start] == '\t')) start++;

        size_t end = start;
        while (end < json.length() && (std::isdigit(json[end]) || json[end] == '-')) end++;

        try {
            ids.push_back(std::stoi(std::string(json.substr(start, end - start))));
        } catch (...) {}

        pos = end;
    }
    return ids;
}

void handle_right() {
    std::string active_res = hyprland_request("j/activeworkspace");
    if (active_res.empty()) return;

    int active_id = extract_json_int(active_res, "id");
    int window_count = extract_json_int(active_res, "windows");
    if (active_id == -1 || window_count == -1) return;

    std::string workspaces_res = hyprland_request("j/workspaces");
    if (workspaces_res.empty()) return;

    std::vector<int> ids = extract_all_workspace_ids(workspaces_res);
    int max_id = active_id;
    if (!ids.empty()) {
        max_id = *std::max_element(ids.begin(), ids.end());
    }

    std::string dispatch_cmd;
    if (active_id == max_id) {
        if (window_count != 0) {
            dispatch_cmd = "dispatch hl.dsp.focus({ workspace = '+1' })";
        }
    } else {
        dispatch_cmd = "dispatch hl.dsp.focus({ workspace = 'e+1' })";
    }

    if (!dispatch_cmd.empty()) {
        hyprland_request(dispatch_cmd);
    }
}

void handle_left() {
    std::string active_res = hyprland_request("j/activeworkspace");
    if (active_res.empty()) return;

    int active_id = extract_json_int(active_res, "id");
    if (active_id == -1) return;

    std::string workspaces_res = hyprland_request("j/workspaces");
    if (workspaces_res.empty()) return;

    std::vector<int> ids = extract_all_workspace_ids(workspaces_res);
    int min_id = active_id;
    if (!ids.empty()) {
        min_id = *std::min_element(ids.begin(), ids.end());
    }

    if (active_id != min_id) {
        hyprland_request("dispatch hl.dsp.focus({ workspace = 'e-1' })");
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: switch_workspace <left|right>\n";
        return 1;
    }

    std::string direction(argv[1]);
    if (direction == "right") {
        handle_right();
    } else if (direction == "left") {
        handle_left();
    } else {
        std::cerr << "Unknown direction: " << direction << ". Use 'left' or 'right'.\n";
        return 1;
    }

    return 0;
}
