#include <cmath>
#include <csignal>
#include <cstdio>
#include <cstdlib>
#include <chrono>
#include <thread>
#include <string>

namespace {
    constexpr double interval = 0.005d;
    constexpr double threshold = 1.d;
    constexpr double pi = 3.14159265358979323846d;

    volatile std::sig_atomic_t running = 1;

    void handleSignal(int) {
        running = 0;
    }

    bool getCenter(double& x, double& y) {
        FILE* pipe = popen(
            "hyprctl -j monitors | jq -r "
            "'.[] | select(.focused == true) | "
            "[.x + .width / (2 * .scale), "
            ".y + .height / (2 * .scale)] | @tsv'",
            "r"
        );

        if (!pipe) return false;

        char output[128]{};
        bool success = false;

        if (fgets(output, sizeof(output), pipe)) {
            success = std::sscanf(output, "%lf %lf", &x, &y) == 2;
        }

        pclose(pipe);
        return success;
    }

    // Get cursor coordinates from hyprctl
    bool getPos(double& x, double& y) {
        FILE* pipe = popen("hyprctl cursorpos 2>/dev/null", "r");
        if (!pipe)
            return false;

        char output[128]{};
        bool success = false;

        if (fgets(output, sizeof(output), pipe)) {
            success = std::sscanf(output, " %lf , %lf", &x, &y) == 2;
        }

        pclose(pipe);
        return success;
    }

    void run(const std::string& command) {
        std::system((command + " >/dev/null 2>&1").c_str());
    }

    void cleanUp(double original_x, double original_y, bool original_pos_stored) {
        run("hyprctl eval 'hl.config({ cursor = { invisible = false } })'");

        if (original_pos_stored) {
            run(
                "hyprctl dispatch \"hl.dsp.cursor.move({ x = " +
                std::to_string(original_x) +
                ", y = " +
                std::to_string(original_y) +
                " })\""
            );
        }
    }
}

int main() {
    std::signal(SIGINT, handleSignal);
    std::signal(SIGTERM, handleSignal);
    std::signal(SIGQUIT, handleSignal);

    run("hyprctl eval 'hl.config({ cursor = { invisible = true } })'");

    double original_x = 0;
    double original_y = 0;

    bool original_pos_stored = getPos(original_x, original_y);

    if (!original_pos_stored) {
        cleanUp(0, 0, false);
        return 1;
    }

    double center_x = 0;
    double center_y = 0;

    bool center_pos_stored = getCenter(center_x, center_y);

    if (!center_pos_stored) {
        cleanUp(original_x, original_y, true);
        return 1;
    }

    while (running) {
        // Lock the cursor at a safe margin from the screen
        run(
            "hyprctl dispatch \"hl.dsp.cursor.move({ x = " +
            std::to_string(center_x) +
            ", y = " +
            std::to_string(center_y) +
            " })\""
        );

        double x1, y1, x2, y2;

        if (!getPos(x1, y1)) {
            std::this_thread::sleep_for(std::chrono::milliseconds(5));
            continue;
        }

        std::this_thread::sleep_for( std::chrono::duration<double>(interval));

        if (!getPos(x2, y2)) continue;

        double dx = x2 - x1;
        double dy = y2 - y1;

        long distance = std::hypot(dx, dy) / 2.0;
        double angle_rad = std::atan2(dx, -dy);
        long angle = std::lround(angle_rad * 180.0 / pi);

        if (angle < 0) angle += 360;
        if (distance < threshold) continue;

        // Up - increase brightness
        if (angle > 340 || angle < 20) {
            run("swayosd-client --brightness +" + std::to_string(distance));
        }
        // Right - increase volume
        else if (angle > 70 && angle < 110) {
            run("swayosd-client --output-volume +" + std::to_string(distance));
        }
        // Down - decrease brightness
        else if (angle > 160 && angle < 200) {
            run(
                "swayosd-client --brightness -" +
                std::to_string(distance) +
                " --min-brightness 0"
            );
        }
        // Left -  decrease volume
        else if (angle > 250 && angle < 290) {
            run("swayosd-client --output-volume -" + std::to_string(distance));
        }
    }

    cleanUp(original_x, original_y, original_pos_stored);
    return 0;
}
