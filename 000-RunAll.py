#!/usr/bin/env python3
"""
MTA Blue Development Environment Setup Script

This script runs all MTA dependency installers in sequence:
1. MTA Data Installer (001-MTADataInstaller.py)
2. CEF Installer (002-CEFInstaller.py)
3. Discord SDK Installer (003-DiscordSDKInstaller.py)

Usage:
    python 000-RunAll.py              # Normal installation
    python 000-RunAll.py upgrade       # Upgrade to latest versions
    python 000-RunAll.py -v            # Verbose mode (show installer output)
    python 000-RunAll.py --mta-data    # Run only MTA Data installer
    python 000-RunAll.py --cef         # Run only CEF installer
    python 000-RunAll.py --discord     # Run only Discord SDK installer
"""

import sys
import subprocess
import argparse
from typing import List, Tuple, Optional
from colorama import Fore, Style
from Common import Logger, print_header, print_footer

class RunAllInstaller:
    """Master installer that runs all MTA dependency installers"""

    ALL_INSTALLERS: List[Tuple[str, str, str]] = [
        ("mta-data", "001-MTADataInstaller.py", "MTA Data Installer"),
        ("cef", "002-CEFInstaller.py", "CEF (Chromium Embedded Framework) Installer"),
        ("discord", "003-DiscordSDKInstaller.py", "Discord SDK Installer")
    ]

    def __init__(self, verbose: bool = False, upgrade: bool = False, selected_installers: Optional[List[str]] = None) -> None:
        self.verbose = verbose
        self.upgrade = upgrade
        self.selected_installers = selected_installers or [installer[0] for installer in self.ALL_INSTALLERS]
        self.results: List[Tuple[str, bool]] = []

    def _get_installers_to_run(self) -> List[Tuple[str, str, str]]:
        """Get the list of installers to run based on selection"""
        return [(key, script, name) for key, script, name in self.ALL_INSTALLERS if key in self.selected_installers]

    def _run_installer(self, script_path: str, name: str, extra_args: List[str]) -> bool:
        """Run a single installer script and return success status"""
        try:
            Logger.info(f"Starting {name}", name)

            # Build command
            cmd = [sys.executable, script_path] + extra_args

            # Run the installer
            if self.verbose:
                # In verbose mode, don't capture output so users see detailed progress
                Logger.info(f"Running {script_path} (verbose mode)...")
                result = subprocess.run(cmd, capture_output=False, text=True)
            else:
                # In normal mode, capture output for clean display
                Logger.info(f"Running {script_path}...")
                result = subprocess.run(cmd, capture_output=True, text=True)

            success = result.returncode == 0

            if success:
                Logger.success(f"{name} completed successfully")
            else:
                Logger.error(f"{name} failed with exit code {result.returncode}")
                # Show stderr if there was an error
                if result.stderr.strip():
                    print(f"Error output: {result.stderr.strip()}")

            self.results.append((name, success))
            return success

        except FileNotFoundError:
            Logger.error(f"Installer script not found: {script_path}")
            self.results.append((name, False))
            return False
        except Exception as e:
            Logger.error(f"Failed to run {name}", str(e))
            self.results.append((name, False))
            return False

    def _print_summary(self) -> None:
        """Print installation summary"""
        total = len(self.results)
        successful = sum(1 for _, success in self.results if success)
        failed = total - successful

        print(f"\n{Fore.MAGENTA}{'='*60}{Style.RESET_ALL}")
        print(f"{Fore.MAGENTA}{Style.BRIGHT}    INSTALLATION SUMMARY{Style.RESET_ALL}")
        print(f"{Fore.MAGENTA}{'='*60}{Style.RESET_ALL}")

        for name, success in self.results:
            status = f"{Fore.GREEN}✓ SUCCESS{Style.RESET_ALL}" if success else f"{Fore.RED}✗ FAILED{Style.RESET_ALL}"
            print(f"  {status} {name}")

        print(f"\n{Fore.CYAN}Total: {total} | Successful: {successful} | Failed: {failed}{Style.RESET_ALL}")

        if failed == 0:
            print(f"\n{Fore.GREEN}{Style.BRIGHT}🎉 All installations completed successfully!{Style.RESET_ALL}")
        else:
            print(f"\n{Fore.YELLOW}⚠ Some installations failed. Check the output above for details.{Style.RESET_ALL}")

    def run_all(self) -> bool:
        """Run all installers in sequence"""
        installers_to_run = self._get_installers_to_run()

        if not installers_to_run:
            Logger.error("No installers selected to run")
            return False

        Logger.info("Starting MTA Blue Development Environment Setup")
        if self.upgrade:
            Logger.info("Running in upgrade mode - checking for latest versions")
        if self.verbose:
            Logger.info("Running in verbose mode - showing detailed installer output")

        overall_success = True

        for key, script_path, name in installers_to_run:
            # Build extra args based on installer and mode
            extra_args: List[str] = []
            if self.upgrade and key == "discord":
                extra_args.append("upgrade")

            if not self._run_installer(script_path, name, extra_args):
                overall_success = False
                # Continue with other installers even if one fails

        self._print_summary()
        return overall_success


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="MTA Blue Development Environment Setup",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python 000-RunAll.py                    # Run all installers
  python 000-RunAll.py -v                 # Run all with verbose output
  python 000-RunAll.py upgrade            # Upgrade to latest versions
  python 000-RunAll.py --mta-data         # Run only MTA Data installer
  python 000-RunAll.py --cef --discord    # Run only CEF and Discord installers
        """
    )

    parser.add_argument(
        '-v', '--verbose',
        action='store_true',
        help='Show detailed output from individual installers'
    )

    parser.add_argument(
        'command',
        nargs='?',
        choices=['upgrade'],
        help='Special commands (upgrade: check for latest versions)'
    )

    # Individual installer flags
    parser.add_argument('--mta-data', action='store_true', help='Run MTA Data installer')
    parser.add_argument('--cef', action='store_true', help='Run CEF installer')
    parser.add_argument('--discord', action='store_true', help='Run Discord SDK installer')

    args = parser.parse_args()

    # Determine which installers to run
    selected_installers: List[str] = []
    if args.mta_data or args.cef or args.discord:
        # If any specific installer is selected, only run those
        if args.mta_data:
            selected_installers.append('mta-data')
        if args.cef:
            selected_installers.append('cef')
        if args.discord:
            selected_installers.append('discord')
    else:
        # Default: run all installers
        selected_installers = ['mta-data', 'cef', 'discord']

    # Check for upgrade command
    upgrade = args.command == 'upgrade'

    print_header("MTA Blue Development Environment Setup")

    installer = RunAllInstaller(
        verbose=args.verbose,
        upgrade=upgrade,
        selected_installers=selected_installers
    )

    success = installer.run_all()

    print_footer()

    # Exit with appropriate code
    exit(0 if success else 1)