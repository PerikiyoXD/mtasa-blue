import os
import shutil
import zipfile
from pathlib import Path
from typing import Optional
import requests
import hashlib
import re
from urllib.parse import quote
from Common import Logger, print_header, print_footer


class DiscordSDKInstaller:
    DISCORD_PATH: str = "vendor/discord-rpc/discord/"
    DISCORD_TEMP: str = "vendor/discord-rpc/discord-rpc.zip"
    DISCORD_UPDATE: str = "https://api.github.com/repos/multitheftauto/discord-rpc/releases/latest"
    DISCORD_URL: str = "https://github.com/multitheftauto/discord-rpc/archive/refs/tags/"
    DISCORD_EXT: str = ".zip"
    
    RAPID_PATH: str = "vendor/discord-rpc/discord/thirdparty/rapidjson/"
    RAPID_TEMP: str = "vendor/discord-rpc/rapidjson.zip"
    RAPID_UPDATE: str = "https://api.github.com/repos/multitheftauto/rapidjson/releases/latest"
    RAPID_URL: str = "https://github.com/multitheftauto/rapidjson/archive/refs/tags/"
    RAPID_EXT: str = ".zip"
    
    DISCORD_VERSION: str = "v3.4.3"
    DISCORD_HASH: str = "dacfcf9ac6f005923eef55b4e41f0e46dc64f7a25da88e00faeef86e8553f32f"
    RAPID_VERSION: str = "v1.1.1"
    RAPID_HASH: str = "3d638ad2549645a4831e8e98cf7b919f191de0d60816e63e1d5aa08cd56e6db8"

    def __init__(self) -> None:
        self.platform: str = self._detect_platform()

    @staticmethod
    def _detect_platform() -> str:
        if os.name == "nt":
            return "windows"
        elif os.uname().sysname == "Darwin":
            return "macos"
        return "linux"

    def _make_download_url(self, url: str, version: str, ext: str) -> str:
        return f"{url}{quote(version)}{ext}"

    def _update_version_hash(self, variable: str, version: str, hash_value: str) -> None:
        """Update version and hash in this file"""
        filename = "003-DiscordSDKInstaller.py"
        try:
            with open(filename, 'r', encoding='utf-8') as f:
                content = f.read()
            
            version_pattern = f'{variable}_VERSION: str = "[^"]*"'
            hash_pattern = f'{variable}_HASH: str = "[^"]*"'
            new_version = f'{variable}_VERSION: str = "{version}"'
            new_hash = f'{variable}_HASH: str = "{hash_value}"'
            
            content = re.sub(version_pattern, new_version, content, count=1)
            content = re.sub(hash_pattern, new_hash, content, count=1)
            
            with open(filename, 'w', encoding='utf-8') as f:
                f.write(content)
            
            Logger.success(f"Updated {variable} version to {version}", version)
        except Exception as e:
            Logger.error("Failed to update file", str(e))

    def _check_github_update(self, name: str, url: str, current_version: str) -> Optional[str]:
        Logger.info(f"Checking GitHub for {name} update...", name)
        try:
            response = requests.get(url)
            response.raise_for_status()
            
            meta = response.json()
            latest_version = meta.get("tag_name")
            
            if latest_version == current_version:
                Logger.info(f"{name} is up to date ({latest_version})", latest_version)
                return None
            
            Logger.success(f"Found {name} update: {latest_version}", latest_version)
            return latest_version
        except Exception as e:
            Logger.error(f"Could not check {name} updates", str(e))
            return None

    def _calculate_sha256(self, filepath: Path) -> str:
        Logger.info(f"Calculating SHA256 for {filepath.name}", filepath.name)
        sha256_hash = hashlib.sha256()
        
        with open(filepath, "rb") as f:
            for byte_block in iter(lambda: f.read(8192), b""):
                sha256_hash.update(byte_block)
        
        hash_value = sha256_hash.hexdigest()
        Logger.success(f"Hash: {hash_value[:16]}...", hash_value[:16])
        return hash_value

    def _download_file(self, url: str, dest: Path) -> bool:
        try:
            dest.parent.mkdir(parents=True, exist_ok=True)
            Logger.download(dest)
            
            response = requests.get(url, stream=True)
            response.raise_for_status()
            
            total_size = int(response.headers.get('content-length', 0))
            downloaded = 0
            
            with open(dest, "wb") as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
                    downloaded += len(chunk)
                    if total_size > 0 and downloaded % (1024 * 1024) == 0:
                        progress = (downloaded / total_size) * 100
                        Logger.info(f"Progress: {progress:.1f}%")
            
            Logger.success(f"Downloaded {dest.name}", dest.name)
            return True
        except Exception as e:
            Logger.error(f"Download failed: {dest.name}", str(e))
            return False

    def _extract_zip(self, archive_path: Path, extract_to: Path) -> bool:
        try:
            Logger.info(f"Extracting {archive_path.name}", archive_path.name)
            
            with zipfile.ZipFile(archive_path, 'r') as zip_ref:
                zip_ref.extractall(extract_to)
            
            Logger.success(f"Extracted {archive_path.name}", archive_path.name)
            return True
        except Exception as e:
            Logger.error("Extraction failed", str(e))
            return False

    def _expand_directory(self, base_path: Path, wildcard: str, target: Path) -> bool:
        try:
            matching = list(base_path.glob(wildcard))
            if not matching:
                Logger.error(f"No directory matching {wildcard}")
                return False
            
            source = matching[0]
            Logger.info(f"Reorganizing from {source.name}", source.name)
            
            for item in source.iterdir():
                dest = target / item.name
                if dest.exists():
                    (shutil.rmtree if dest.is_dir() else dest.unlink)(dest)
                shutil.move(str(item), str(dest))
            
            shutil.rmtree(source)
            Logger.success("Directory reorganized")
            return True
        except Exception as e:
            Logger.error("Directory reorganization failed", str(e))
            return False

    def _install_component(self, name: str, version: str, expected_hash: str,
                          url: str, ext: str, temp_path: str, install_path: str,
                          wildcard: str, should_upgrade: bool = False) -> bool:
        """Generic component installation logic"""
        has_dir = Path(install_path).exists()
        archive = Path(temp_path)
        
        # Check existing archive
        if archive.exists():
            current_hash = self._calculate_sha256(archive)
            if current_hash == expected_hash:
                Logger.success(f"{name} consistency checks succeeded")
                if has_dir:
                    return True
        
        # Download if needed
        Logger.info(f"Downloading {name} {version}", version)
        download_url = self._make_download_url(url, version, ext)
        if not self._download_file(download_url, archive):
            return False
        
        # Verify hash
        downloaded_hash = self._calculate_sha256(archive)
        if should_upgrade:
            Logger.info(f"New {name} hash: {downloaded_hash}")
            var_prefix = "DISCORD" if "discord" in name.lower() else "RAPID"
            self._update_version_hash(var_prefix, version, downloaded_hash)
        
        if downloaded_hash != expected_hash:
            Logger.error(f"{name} consistency check failed",
                        f"Expected {expected_hash}\nGot {downloaded_hash}")
            return False
        
        Logger.success(f"{name} consistency checks succeeded")
        
        # Windows-only installation
        if self.platform != "windows":
            return True
        
        # Clean old installation
        install_dir = Path(install_path)
        if has_dir:
            shutil.rmtree(install_dir)
            Logger.info(f"Removed old {name} installation")
        
        install_dir.mkdir(parents=True, exist_ok=True)
        
        # Extract and reorganize
        return (self._extract_zip(archive, install_dir) and
                self._expand_directory(install_dir, wildcard, install_dir))

    def install(self, upgrade: bool = False) -> bool:
        Logger.info(f"Starting Discord SDK installation for {self.platform}", self.platform)
        
        discord_version = self.DISCORD_VERSION
        discord_hash = self.DISCORD_HASH
        rapid_version = self.RAPID_VERSION
        rapid_hash = self.RAPID_HASH
        
        if upgrade:
            new_discord = self._check_github_update("discord-rpc", self.DISCORD_UPDATE, self.DISCORD_VERSION)
            if new_discord:
                discord_version = new_discord
                discord_hash = ""
            
            new_rapid = self._check_github_update("rapidjson", self.RAPID_UPDATE, self.RAPID_VERSION)
            if new_rapid:
                rapid_version = new_rapid
                rapid_hash = ""
        
        # Skip on non-Windows unless upgrading
        if self.platform != "windows" and not upgrade:
            Logger.warning("Discord SDK installation skipped (Windows only)")
            return True
        
        # Install components
        discord_ok = self._install_component(
            "discord-rpc", discord_version, discord_hash,
            self.DISCORD_URL, self.DISCORD_EXT, self.DISCORD_TEMP,
            self.DISCORD_PATH, "discord-rpc*", upgrade
        )
        
        rapid_ok = self._install_component(
            "rapidjson", rapid_version, rapid_hash,
            self.RAPID_URL, self.RAPID_EXT, self.RAPID_TEMP,
            self.RAPID_PATH, "rapidjson*", upgrade
        )
        
        success = discord_ok and rapid_ok
        
        if success:
            Logger.success("Discord SDK installation completed!")
        else:
            Logger.error("Discord SDK installation failed")
        
        return success


if __name__ == "__main__":
    import sys
    
    print_header("Discord SDK Installer")
    installer = DiscordSDKInstaller()
    upgrade = len(sys.argv) > 1 and sys.argv[1] == "upgrade"
    success = installer.install(upgrade)
    print_footer()
    exit(0 if success else 1)