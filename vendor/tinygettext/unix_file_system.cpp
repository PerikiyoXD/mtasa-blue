//  tinygettext - A gettext replacement that works directly on .po files
//  Copyright (C) 2009 Ingo Ruhnke <grumbel@gmx.de>
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

#include "unix_file_system.hpp"
#include <fstream>
#include <filesystem>
#include <system_error>

namespace tinygettext {

UnixFileSystem::UnixFileSystem()
{
}

bool
UnixFileSystem::open_directory(const std::string& pathname, std::vector<std::string>& files, std::vector<std::string>& dirs)
{
  std::error_code ec;
  std::filesystem::path dir_path(std::filesystem::u8path(pathname));
  
  if (!std::filesystem::exists(dir_path, ec) || !std::filesystem::is_directory(dir_path, ec))
  {
    return false;
  }

  for (const auto& entry : std::filesystem::directory_iterator(dir_path, ec))
  {
    if (ec)
    {
      return false;
    }

    auto u8filename = entry.path().filename().u8string();
    std::string filename(u8filename.begin(), u8filename.end());
    
    if (entry.is_regular_file(ec))
    {
      files.push_back(filename);
    }
    else if (entry.is_directory(ec))
    {
      if (filename != "." && filename != "..")
      {
        dirs.push_back(filename);
      }
    }
  }

  return true;
}

std::unique_ptr<std::istream>
UnixFileSystem::open_file(const std::string& filename)
{
  std::filesystem::path file_path(std::filesystem::u8path(filename));
  return std::unique_ptr<std::istream>(new std::ifstream(file_path));
}

bool
UnixFileSystem::file_exists(const std::string& filename)
{
  std::error_code ec;
  std::filesystem::path file_path(std::filesystem::u8path(filename));
  return std::filesystem::exists(file_path, ec) && !ec;
}

} // namespace tinygettext

/* EOF */