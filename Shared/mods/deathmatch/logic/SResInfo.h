#pragma once

// SResInfo - Item in list of potential resources - Used in Refresh()
struct SResInfo
{
    SString strAbsPath;
    SString strName;
    bool    bIsDir;
    bool    bPathIssue;
    SString strAbsPathDup;
};

// IMPROVED REFACTOR FOR LATER:

// struct SResourceInformation
// {
//     std::string absolutePathDuplicate; // Handle this elsewhere
//     std::string absolutePath;
//     std::string name;
//     bool        isDirectory;
//     bool        pathIssue;
// };
