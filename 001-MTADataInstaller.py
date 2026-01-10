import os
import shutil
from pathlib import Path
from typing import Optional
import requests
from colorama import Fore, Style, init
from datetime import datetime

# Initialize colorama
init(autoreset=True)

class Logger:
    @staticmethod
    def _timestamp():
        return f"{Fore.CYAN}{datetime.now().strftime('%H:%M:%S')}{Style.RESET_ALL}"
    
    @staticmethod
    def info(msg, emphasis=""):
        if emphasis:
            msg = msg.replace(emphasis, f"{Fore.WHITE}{Style.BRIGHT}{emphasis}{Style.RESET_ALL}")
        print(f"{Logger._timestamp()} {Fore.BLUE}INFO    {Style.RESET_ALL} {msg}")
    
    @staticmethod
    def success(msg, emphasis=""):
        if emphasis:
            msg = msg.replace(emphasis, f"{Fore.WHITE}{Style.BRIGHT}{emphasis}{Style.RESET_ALL}")
        print(f"{Logger._timestamp()} {Fore.GREEN}SUCCESS {Style.RESET_ALL} ✓ {msg}")
    
    @staticmethod
    def error(msg, detail=""):
        output = f"{Logger._timestamp()} {Fore.RED}ERROR   {Style.RESET_ALL} ✗ {msg}"
        if detail:
            output += f"\n         {Fore.YELLOW}↳{Style.RESET_ALL} {detail}"
        print(output)
    
    @staticmethod
    def download(dest):
        filename = f"{Fore.MAGENTA}{Path(dest).name}{Style.RESET_ALL}"
        print(f"{Logger._timestamp()} {Fore.CYAN}DOWNLOAD{Style.RESET_ALL} ⬇ {filename}")
        
class MTADataInstaller:
    BIN_DIR = "Bin"
    DATA_DIR = "Shared/data/MTA San Andreas"
    BASE_URL = "https://mirror-cdn.multitheftauto.com/bdata/"
    
    # Network library paths
    NET_PATHS = {
        "windows": {
            "x86": f"{BASE_URL}net.dll",
            "x64": f"{BASE_URL}net_64.dll",
            "arm64": f"{BASE_URL}net_arm64.dll",
            "netc": f"{BASE_URL}netc.dll"
        },
        "linux": {
            "x86": f"{BASE_URL}net.so",
            "x64": f"{BASE_URL}net_64.so",
            "arm": f"{BASE_URL}net_arm.so",
            "arm64": f"{BASE_URL}net_arm64.so"
        },
        "macos": {
            "x64": f"{BASE_URL}net.dylib"
        }
    }

    def __init__(self):
        self.platform = self._detect_platform()

    @staticmethod
    def _detect_platform() -> str:
        if os.name == "nt":
            return "windows"
        elif os.uname().sysname == "Darwin":
            return "macos"
        else:
            return "linux"

    def _download_file(self, url: str, dest: Path) -> bool:
        try:
            dest.parent.mkdir(parents=True, exist_ok=True)
            response = requests.get(url, stream=True)
            response.raise_for_status()
            
            with open(dest, "wb") as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            return True
        except Exception as e:
            print(f"ERROR: Download failed for {url}\n{e}")
            return False

    def _copy_file(self, src: Path, dest: Path) -> bool:
        try:
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dest)
            return True
        except Exception as e:
            print(f"ERROR: Could not copy {src}\n{e}")
            return False

    def _copy_configs(self, pattern: str, skip_existing: bool = True) -> bool:
        src_dir = Path("Server/mods/deathmatch")
        dest_dir = Path(self.BIN_DIR) / "server/mods/deathmatch"
        
        try:
            dest_dir.mkdir(parents=True, exist_ok=True)
            for file in src_dir.glob(pattern):
                dest_file = dest_dir / file.name
                if skip_existing and dest_file.exists():
                    continue
                shutil.copy2(file, dest_file)
            return True
        except Exception as e:
            print(f"ERROR: Couldn't copy config files\n{e}")
            return False

    def _install_windows(self) -> bool:
        bin_path = Path(self.BIN_DIR)
        paths = self.NET_PATHS["windows"]
        
        downloads = [
            (paths["x86"], bin_path / "server/net.dll"),
            (paths["x64"], bin_path / "server/x64/net.dll"),
            (paths["arm64"], bin_path / "server/arm64/net.dll"),
            (paths["netc"], bin_path / "MTA/netc.dll")
        ]
        
        for url, dest in downloads:
            if not self._download_file(url, dest):
                return False
        
        copies = [
            (bin_path / "MTA/netc.dll", bin_path / "MTA/netc_d.dll"),
            (bin_path / "server/net.dll", bin_path / "server/net_d.dll"),
            (bin_path / "server/x64/net.dll", bin_path / "server/x64/net_d.dll"),
            (bin_path / "server/arm64/net.dll", bin_path / "server/arm64/net_d.dll")
        ]
        
        return all(self._copy_file(src, dest) for src, dest in copies)

    def _install_linux(self) -> bool:
        bin_path = Path(self.BIN_DIR)
        paths = self.NET_PATHS["linux"]
        
        downloads = [
            (paths["x86"], bin_path / "server/net.so"),
            (paths["x64"], bin_path / "server/x64/net.so"),
            (paths["arm"], bin_path / "server/arm/net.so"),
            (paths["arm64"], bin_path / "server/arm64/net.so")
        ]
        
        for url, dest in downloads:
            if not self._download_file(url, dest):
                return False
        
        copies = [
            (bin_path / "server/net.so", bin_path / "server/net_d.so"),
            (bin_path / "server/x64/net.so", bin_path / "server/x64/net_d.so"),
            (bin_path / "server/arm/net.so", bin_path / "server/arm/net_d.so"),
            (bin_path / "server/arm64/net.so", bin_path / "server/arm64/net_d.so")
        ]
        
        return all(self._copy_file(src, dest) for src, dest in copies)

    def _install_macos(self) -> bool:
        bin_path = Path(self.BIN_DIR)
        url = self.NET_PATHS["macos"]["x64"]
        dest = bin_path / "server/arm64/net.dylib"
        
        if not self._download_file(url, dest):
            return False
        
        return self._copy_file(dest, bin_path / "server/arm64/net_d.dylib")

    def install(self) -> bool:
        bin_path = Path(self.BIN_DIR)
        
        # Create Bin directory
        bin_path.mkdir(parents=True, exist_ok=True)
        
        # Copy data files (Windows only)
        if self.platform == "windows":
            try:
                shutil.copytree(self.DATA_DIR, self.BIN_DIR, dirs_exist_ok=True)
            except Exception as e:
                print(f"ERROR: Couldn't copy data directory\n{e}")
                return False
        
        # Copy configs
        if not self._copy_configs("*.conf"):
            return False
        
        # Create config template
        conf_path = bin_path / "server/mods/deathmatch/mtaserver.conf"
        template_path = bin_path / "server/mods/deathmatch/mtaserver.conf.template"
        if conf_path.exists() and not self._copy_file(conf_path, template_path):
            return False
        
        if not self._copy_configs("*.xml"):
            return False
        
        # Platform-specific installation
        if self.platform == "windows":
            return self._install_windows()
        elif self.platform == "macos":
            return self._install_macos()
        else:
            return self._install_linux()


if __name__ == "__main__":
    installer = MTADataInstaller()
    success = installer.install()
    exit(0 if success else 1)