from pathlib import Path
from colorama import Fore, Style, init
from datetime import datetime

init(autoreset=True)


class Logger:
    """Colorful console logger with level-based formatting"""
    
    @staticmethod
    def _timestamp() -> str:
        return f"{Fore.CYAN}{datetime.now().strftime('%H:%M:%S')}{Style.RESET_ALL}"
    
    @staticmethod
    def info(msg: str, emphasis: str = "") -> None:
        if emphasis:
            msg = msg.replace(emphasis, f"{Fore.WHITE}{Style.BRIGHT}{emphasis}{Style.RESET_ALL}")
        print(f"{Logger._timestamp()} {Fore.BLUE}INFO    {Style.RESET_ALL} {msg}")
    
    @staticmethod
    def success(msg: str, emphasis: str = "") -> None:
        if emphasis:
            msg = msg.replace(emphasis, f"{Fore.WHITE}{Style.BRIGHT}{emphasis}{Style.RESET_ALL}")
        print(f"{Logger._timestamp()} {Fore.GREEN}SUCCESS {Style.RESET_ALL} ✓ {msg}")
    
    @staticmethod
    def warning(msg: str, detail: str = "") -> None:
        output = f"{Logger._timestamp()} {Fore.YELLOW}WARNING {Style.RESET_ALL} ⚠ {msg}"
        if detail:
            output += f"\n         {Fore.YELLOW}↳{Style.RESET_ALL} {detail}"
        print(output)
    
    @staticmethod
    def error(msg: str, detail: str = "") -> None:
        output = f"{Logger._timestamp()} {Fore.RED}ERROR   {Style.RESET_ALL} ✗ {msg}"
        if detail:
            output += f"\n         {Fore.YELLOW}↳{Style.RESET_ALL} {detail}"
        print(output)
    
    @staticmethod
    def download(dest: Path) -> None:
        filename = f"{Fore.MAGENTA}{dest.name}{Style.RESET_ALL}"
        print(f"{Logger._timestamp()} {Fore.CYAN}DOWNLOAD{Style.RESET_ALL} ⬇ {filename}")


def print_header(title: str) -> None:
    """Print formatted header banner"""
    print(f"\n{Fore.MAGENTA}{'='*60}{Style.RESET_ALL}")
    print(f"{Fore.MAGENTA}{Style.BRIGHT}    {title}{Style.RESET_ALL}")
    print(f"{Fore.MAGENTA}{'='*60}{Style.RESET_ALL}\n")


def print_footer() -> None:
    """Print formatted footer banner"""
    print(f"\n{Fore.MAGENTA}{'='*60}{Style.RESET_ALL}\n")