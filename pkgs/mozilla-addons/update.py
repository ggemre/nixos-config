import base64
import json
import hashlib
import sys
import tempfile
import urllib.request
from pathlib import Path


API_BASE = "https://addons.mozilla.org/api/v5/addons/addon/"

SCRIPT_DIR = Path(__file__).resolve().parent
ADDONS_FILE = SCRIPT_DIR / "addons.json"


def fetch_json(url: str) -> dict:
    request = urllib.request.Request(
        url,
        headers={
            "User-Agent": "nixos-config-mozilla-addon-updater/1.0",
            "Accept": "application/json",
        },
    )

    with urllib.request.urlopen(request) as response:
        return json.load(response)


def download(url: str) -> bytes:
    request = urllib.request.Request(
        url,
        headers={
            "User-Agent": "nixos-config-mozilla-addon-updater/1.0",
        },
    )

    with urllib.request.urlopen(request) as response:
        return response.read()


def sha256_sri(data: bytes) -> str:
    digest = hashlib.sha256(data).digest()
    encoded = base64.b64encode(digest).decode("ascii")
    return f"sha256-{encoded}"


def get_latest(addon: dict) -> tuple[str, str, str]:
    slug = addon["slug"]

    data = fetch_json(f"{API_BASE}{slug}/")

    current_version = data["current_version"]
    version = current_version["version"]

    file_info = current_version["file"]
    url = file_info["url"]

    addon_id = data["guid"]

    return addon_id, version, url


def update_addon(name: str, addon: dict) -> bool:
    print(f"== Checking {name} ==")

    addon_id, version, url = get_latest(addon)

    if addon_id != addon["addonId"]:
        raise RuntimeError(
            f"{name}: addon ID mismatch!\n"
            f"  configured: {addon['addonId']}\n"
            f"  Mozilla:    {addon_id}"
        )

    old_version = addon["version"]

    print(f"Current version: {old_version}")
    print(f"Latest version:  {version}")

    if version == old_version:
        print("Already up to date.")
        return False

    print(f"Downloading {url}")

    data = download(url)
    hash_value = sha256_sri(data)

    print(f"New hash: {hash_value}")

    addon["version"] = version
    addon["url"] = url
    addon["hash"] = hash_value

    print(f"Updated {name}: {old_version} -> {version}")

    return True


def write_json(addons: dict) -> None:
    # atomic write
    with tempfile.NamedTemporaryFile(
        mode="w",
        encoding="utf-8",
        dir=ADDONS_FILE.parent,
        delete=False,
    ) as tmp:
        json.dump(addons, tmp, indent=2)
        tmp.write("\n")
        tmp_path = Path(tmp.name)

    tmp_path.replace(ADDONS_FILE)


def main() -> int:
    with ADDONS_FILE.open(encoding="utf-8") as f:
        addons = json.load(f)

    changed = False

    for name, addon in addons.items():
        try:
            if update_addon(name, addon):
                changed = True
        except Exception as e:
            print(f"ERROR: failed to update {name}: {e}", file=sys.stderr)
            return 1

        print()

    if changed:
        write_json(addons)
        print(f"Updated {ADDONS_FILE}")
    else:
        print("All addons are up to date.")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
