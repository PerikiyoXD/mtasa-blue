import os
import shutil
from pathlib import Path
from typing import Optional
import requests
import hashlib
import tarfile
import bz2
from Common import Logger, print_header, print_footer


class CEFInstaller:
    CEF_PATH: str = "vendor/cef3/cef/"
    CEF_TEMP_PATH: str = "vendor/cef3/"
    CEF_URL_PREFIX: str = "https://cef-builds.spotifycdn.com/cef_binary_"
    CEF_URL_SUFFIX: str = "_windows32_minimal.tar.bz2"
    
    CEF_VERSION: str = "140.1.14+geb1c06e+chromium-140.0.7339.185"
    CEF_HASH: str = "154fb157f1222cf06c086133c2bfb8ba94370d465d50e014464dd384f7020825"

    def __init__(self) -> None:
        self.platform: str = self._detect_platform()

    @staticmethod
    def _detect_platform() -> str:
        if os.name == "nt":
            return "windows"
        elif os.uname().sysname == "Darwin":
            return "macos"
        return "linux"

    def _make_download_url(self) -> str:
        return f"{self.CEF_URL_PREFIX}{self.CEF_VERSION}{self.CEF_URL_SUFFIX}"

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

    def _extract_tar_bz2(self, archive_path: Path, extract_to: Path) -> bool:
        try:
            Logger.info(f"Extracting {archive_path.name}", archive_path.name)
            
            # Extract .tar.bz2 to .tar
            tar_path = extract_to / "temp.tar"
            with bz2.open(archive_path, 'rb') as bz2_file:
                with open(tar_path, 'wb') as tar_file:
                    shutil.copyfileobj(bz2_file, tar_file)
            
            Logger.success("Decompressed .bz2")
            
            # Extract .tar
            with tarfile.open(tar_path) as tar:
                tar.extractall(extract_to, filter='data')
            
            Logger.success(f"Extracted {archive_path.name}", archive_path.name)
            
            # Remove temporary .tar file
            tar_path.unlink()
            Logger.info("Cleaned up temporary files")
            
            return True
        except Exception as e:
            Logger.error("Extraction failed", str(e))
            return False

    def _expand_cef_directory(self, cef_path: Path) -> bool:
        try:
            cef_dirs = list(cef_path.glob("cef_binary*"))
            if not cef_dirs:
                Logger.error("No cef_binary directory found after extraction")
                return False
            
            cef_binary_dir = cef_dirs[0]
            Logger.info(f"Reorganizing from {cef_binary_dir.name}", cef_binary_dir.name)
            
            for item in cef_binary_dir.iterdir():
                dest = cef_path / item.name
                if dest.exists():
                    (shutil.rmtree if dest.is_dir() else dest.unlink)(dest)
                shutil.move(str(item), str(dest))
            
            cef_binary_dir.rmdir()
            Logger.success("Reorganized CEF directory structure")
            return True
        except Exception as e:
            Logger.error("Failed to reorganize directory", str(e))
            return False

    def install(self, upgrade: bool = False, version: Optional[str] = None) -> bool:
        Logger.info(f"Starting CEF installation for {self.platform}", self.platform)
        
        # Non-Windows platforms only proceed if upgrading
        if self.platform != "windows" and not upgrade:
            Logger.warning("CEF installation only runs on Windows unless upgrading")
            return True
        
        if upgrade and version:
            if version == self.CEF_VERSION:
                Logger.info(f"CEF version is already {version}", version)
                return True
            Logger.info(f"Upgrading to version {version}", version)
            self.CEF_VERSION = version
            self.CEF_HASH = ""
        
        cef_path = Path(self.CEF_PATH)
        has_cef_dir = cef_path.exists()
        archive_path = Path(self.CEF_TEMP_PATH) / "temp.tar.bz2"
        
        # Check existing archive
        if archive_path.exists():
            Logger.info("Checking existing archive integrity")
            downloaded_hash = self._calculate_sha256(archive_path)
            
            if downloaded_hash == self.CEF_HASH:
                Logger.success("CEF consistency checks succeeded")
                if has_cef_dir:
                    Logger.info("CEF already installed and validated")
                    return True
        
        # Download if needed
        Logger.info(f"Downloading CEF {self.CEF_VERSION}", self.CEF_VERSION)
        if not self._download_file(self._make_download_url(), archive_path):
            return False
        
        # Verify downloaded file
        downloaded_hash = self._calculate_sha256(archive_path)
        
        if upgrade:
            Logger.info(f"New CEF hash: {downloaded_hash}", downloaded_hash)
            self.CEF_HASH = downloaded_hash
            Logger.warning("Update install_cef.lua manually with new hash")
        
        if downloaded_hash != self.CEF_HASH:
            Logger.error("CEF consistency check failed", 
                        f"Expected: {self.CEF_HASH}\nGot: {downloaded_hash}")
            return False
        
        Logger.success("CEF consistency checks succeeded")
        
        # Windows-only from here
        if self.platform != "windows":
            Logger.info("Skipping extraction on non-Windows platform")
            return True
        
        # Delete old CEF files
        if has_cef_dir:
            Logger.info("Removing old CEF installation")
            shutil.rmtree(cef_path)
            Logger.success("Removed old installation")
        
        # Create CEF directory
        cef_path.mkdir(parents=True, exist_ok=True)
        
        # Extract and reorganize
        if not self._extract_tar_bz2(archive_path, cef_path):
            return False
        
        if not self._expand_cef_directory(cef_path):
            return False
        
        Logger.success("CEF installation completed successfully!")
        return True


if __name__ == "__main__":
    print_header("CEF (Chromium Embedded Framework) Installer")
    installer = CEFInstaller()
    success = installer.install()
    print_footer()
    exit(0 if success else 1)