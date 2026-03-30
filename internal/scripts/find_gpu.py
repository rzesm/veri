from __future__ import annotations

from functools import lru_cache
from pathlib import Path
import re
import sys

# Vibe coded
# Prints one of: intel / amd / nvidia-modern / nvidia-legacy

SYSFS = Path("/sys")
PCI_DEVICES = SYSFS / "bus" / "pci" / "devices"
PCI_IDS_CANDIDATES = (
    Path("/usr/share/hwdata/pci.ids"),
    Path("/usr/share/misc/pci.ids"),
)

VENDOR_INTEL = 0x8086
VENDOR_AMD = 0x1002
VENDOR_NVIDIA = 0x10DE

DISPLAY_CLASS_PREFIXES = {"0300", "0302", "0380"}  # VGA, 3D, display controller


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore").strip()


def read_hex(path: Path) -> int:
    return int(read_text(path), 16)


def pci_devices_root(root: Path) -> Path:
    return root / "sys" / "bus" / "pci" / "devices"


def parse_hex_pair(vendor: Path, device: Path) -> tuple[int, int]:
    return read_hex(vendor), read_hex(device)


@lru_cache(maxsize=1)
def pci_ids_path() -> Path | None:
    for p in PCI_IDS_CANDIDATES:
        if p.exists():
            return p
    return None


@lru_cache(maxsize=None)
def pci_name_lookup(vendor_hex: int, device_hex: int) -> str | None:
    path = pci_ids_path()
    if path is None:
        return None

    vendor_target = f"{vendor_hex:04x}"
    device_target = f"{device_hex:04x}"

    in_vendor = False
    found_vendor = False

    with path.open("r", encoding="latin-1", errors="ignore") as f:
        for raw in f:
            line = raw.rstrip("\n")

            if not line or line.startswith("#"):
                continue

            # Top-level vendor line
            if not line.startswith("\t"):
                m = re.match(r"^([0-9a-fA-F]{4})\s+(.+)$", line)
                if not m:
                    continue
                vid = m.group(1).lower()
                if found_vendor and vid != vendor_target:
                    break
                in_vendor = (vid == vendor_target)
                found_vendor = found_vendor or in_vendor
                continue

            # Device line under current vendor
            if in_vendor:
                m = re.match(r"^\t([0-9a-fA-F]{4})\s+(.+)$", line)
                if m and m.group(1).lower() == device_target:
                    return m.group(2).strip()

    return None


def gpu_candidates(root: Path):
    devices_root = pci_devices_root(root)
    if not devices_root.exists():
        raise RuntimeError(f"{devices_root} not found")

    candidates = []

    for dev in sorted(devices_root.iterdir()):
        vendor_file = dev / "vendor"
        device_file = dev / "device"
        class_file = dev / "class"
        if not (vendor_file.exists() and device_file.exists() and class_file.exists()):
            continue

        try:
            vendor_id = read_hex(vendor_file)
            device_id = read_hex(device_file)
            class_raw = read_text(class_file).lower()
            class_hex = class_raw[2:] if class_raw.startswith("0x") else class_raw
            class_prefix = class_hex[:4]
            boot_vga = (dev / "boot_vga").exists() and read_text(dev / "boot_vga") == "1"
        except Exception:
            continue

        is_display = class_prefix in DISPLAY_CLASS_PREFIXES

        # Keep display adapters first, then everything else with a vendor we know.
        score = 0
        if is_display:
            score += 10
        if boot_vga:
            score += 100

        if vendor_id in {VENDOR_INTEL, VENDOR_AMD, VENDOR_NVIDIA}:
            candidates.append((score, vendor_id, device_id, dev))

    if not candidates:
        return []

    candidates.sort(key=lambda x: (-x[0], x[3].as_posix()))
    return candidates


def classify_nvidia(device_id: int) -> str:
    name = pci_name_lookup(VENDOR_NVIDIA, device_id)
    if name:
        u = name.upper()

        # Most NVIDIA PCI IDs on modern cards have an architecture prefix in pci.ids.
        # This catches Turing/Ampere/Ada/Hopper/Blackwell family names and RTX/GTX 16xx.
        if re.match(r"^(TU|GA|AD|GH|GB)\b", u): return "nvidia-modern"
        if " RTX " in f" {u} ": return "nvidia-modern"
        if re.search(r"\bGTX\s*16\d{2}\b", u): return "nvidia-modern"
        if re.search(r"\bRTX\s*A\b", u): return "nvidia-modern"

        return "nvidia-legacy"

    # Modern NVIDIA parts are typically >= 0x1e00.
    return "nvidia-modern" if device_id >= 0x1E00 else "nvidia-legacy"


def classify_gpu(vendor_id: int, device_id: int) -> str:
    if vendor_id == VENDOR_INTEL: return "intel"
    if vendor_id == VENDOR_AMD: return "amd"
    if vendor_id == VENDOR_NVIDIA: return classify_nvidia(device_id)
    else: return ""


def main() -> int:
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("/")
    candidates = gpu_candidates(root)

    _, vendor_id, device_id, _ = candidates[0]
    print(classify_gpu(vendor_id, device_id))
    return 0


if __name__ == "__main__":
    main()