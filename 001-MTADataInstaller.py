import os
import shutil
from pathlib import Path
from typing import Dict, List, Tuple
import requests
from Common import Logger, print_header, print_footer


class MTADataInstaller:
    BIN_DIR: str = "Bin"
    DATA_DIR: str = "Shared/data/MTA San Andreas"
    BASE_URL: str = "https://mirror-cdn.multitheftauto.com/bdata/"
    
    NET_PATHS: Dict[str, Dict[str, str]] = {
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

    def __init__(self) -> None:
        self.platform: str = self._detect_platform()

    @staticmethod
    def _detect_platform() -> str:
        if os.name == "nt":
            return "windows"
        elif os.uname().sysname == "Darwin":
            return "macos"
        return "linux"

    def _download_file(self, url: str, dest: Path) -> bool:
        try:
            dest.parent.mkdir(parents=True, exist_ok=True)
            Logger.download(dest)
            
            response = requests.get(url, stream=True)
            response.raise_for_status()
            
            with open(dest, "wb") as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            
            Logger.success(f"Downloaded {dest.name}", dest.name)
            return True
        except Exception as e:
            Logger.error(f"Download failed: {dest.name}", str(e))
            return False

    def _copy_file(self, src: Path, dest: Path) -> bool:
        try:
            dest.parent.mkdir(parents=True, exist_ok=True)
            shutil.copy2(src, dest)
            Logger.success(f"Copied {src.name} → {dest.name}", dest.name)
            return True
        except Exception as e:
            Logger.error(f"Copy failed: {src.name}", str(e))
            return False

    def _copy_configs(self, pattern: str, skip_existing: bool = True) -> bool:
        src_dir = Path("Server/mods/deathmatch")
        dest_dir = Path(self.BIN_DIR) / "server/mods/deathmatch"
        
        try:
            dest_dir.mkdir(parents=True, exist_ok=True)
            count = 0
            
            for file in src_dir.glob(pattern):
                dest_file = dest_dir / file.name
                if skip_existing and dest_file.exists():
                    continue
                shutil.copy2(file, dest_file)
                count += 1
            
            Logger.success(f"Copied {count} config files ({pattern})")
            return True
        except Exception as e:
            Logger.error(f"Config copy failed ({pattern})", str(e))
            return False

    def _install_platform_binaries(self, downloads: List[Tuple[str, Path]], 
                                   copies: List[Tuple[Path, Path]]) -> bool:
        for url, dest in downloads:
            if not self._download_file(url, dest):
                return False
        
        return all(self._copy_file(src, dest) for src, dest in copies)

    def _install_windows(self) -> bool:
        bin_path = Path(self.BIN_DIR)
        paths = self.NET_PATHS["windows"]
        
        downloads = [
            (paths["x86"], bin_path / "server/net.dll"),
            (paths["x64"], bin_path / "server/x64/net.dll"),
            (paths["arm64"], bin_path / "server/arm64/net.dll"),
            (paths["netc"], bin_path / "MTA/netc.dll")
        ]
        
        copies = [
            (bin_path / "MTA/netc.dll", bin_path / "MTA/netc_d.dll"),
            (bin_path / "server/net.dll", bin_path / "server/net_d.dll"),
            (bin_path / "server/x64/net.dll", bin_path / "server/x64/net_d.dll"),
            (bin_path / "server/arm64/net.dll", bin_path / "server/arm64/net_d.dll")
        ]
        
        return self._install_platform_binaries(downloads, copies)

    def _install_linux(self) -> bool:
        bin_path = Path(self.BIN_DIR)
        paths = self.NET_PATHS["linux"]
        
        downloads = [
            (paths["x86"], bin_path / "server/net.so"),
            (paths["x64"], bin_path / "server/x64/net.so"),
            (paths["arm"], bin_path / "server/arm/net.so"),
            (paths["arm64"], bin_path / "server/arm64/net.so")
        ]
        
        copies = [
            (bin_path / "server/net.so", bin_path / "server/net_d.so"),
            (bin_path / "server/x64/net.so", bin_path / "server/x64/net_d.so"),
            (bin_path / "server/arm/net.so", bin_path / "server/arm/net_d.so"),
            (bin_path / "server/arm64/net.so", bin_path / "server/arm64/net_d.so")
        ]
        
        return self._install_platform_binaries(downloads, copies)

    def _install_macos(self) -> bool:
        bin_path = Path(self.BIN_DIR)
        url = self.NET_PATHS["macos"]["x64"]
        dest = bin_path / "server/arm64/net.dylib"
        
        if not self._download_file(url, dest):
            return False
        
        return self._copy_file(dest, bin_path / "server/arm64/net_d.dylib")

    def install(self) -> bool:
        Logger.info(f"Starting MTA installation for {self.platform}", self.platform)
        bin_path = Path(self.BIN_DIR)
        
        # Create Bin directory
        Logger.info("Creating binary directory")
        bin_path.mkdir(parents=True, exist_ok=True)
        
        # Copy data files (Windows only)
        if self.platform == "windows":
            Logger.info("Copying data files")
            try:
                shutil.copytree(self.DATA_DIR, self.BIN_DIR, dirs_exist_ok=True)
                Logger.success("Data files copied")
            except Exception as e:
                Logger.error("Data copy failed", str(e))
                return False
        
        # Copy configs
        Logger.info("Installing configuration files")
        if not self._copy_configs("*.conf"):
            return False
        
        # Create config template
        conf_path = bin_path / "server/mods/deathmatch/mtaserver.conf"
        template_path = bin_path / "server/mods/deathmatch/mtaserver.conf.template"
        if conf_path.exists():
            if not self._copy_file(conf_path, template_path):
                return False
        
        if not self._copy_configs("*.xml"):
            return False
        
        # Platform-specific installation
        Logger.info(f"Installing {self.platform} binaries", self.platform)
        
        if self.platform == "windows":
            result = self._install_windows()
        elif self.platform == "macos":
            result = self._install_macos()
        else:
            result = self._install_linux()
        
        if result:
            Logger.success("MTA installation completed successfully!")
        else:
            Logger.error("MTA installation failed")
        
        return result


if __name__ == "__main__":
    print_header("MTA San Andreas Data Installer")
    installer = MTADataInstaller()
    success = installer.install()
    print_footer()
    exit(0 if success else 1)