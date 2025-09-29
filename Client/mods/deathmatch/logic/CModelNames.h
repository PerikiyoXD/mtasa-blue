/*****************************************************************************
 *
 *  PROJECT:     Multi Theft Auto v1.0
 *               (Shared logic for modifications)
 *  LICENSE:     See LICENSE in the top level directory
 *  FILE:        mods/shared_logic/CModelNames.h
 *  PURPOSE:     Model names class header
 *
 *****************************************************************************/

#pragma once

#define CLOTHES_MODEL_ID_FIRST  30000
#define CLOTHES_MODEL_ID_LAST   30151
#define CLOTHES_TEX_ID_FIRST    30152
#define CLOTHES_TEX_ID_LAST     30541
#define INVALID_MODEL_ID        32000

class CModelNames
{
public:
    static std::uint32_t      GetModelID(const SString& strName);
    static std::uint32_t      GetClothesTexID(const SString& strName);
    static const char* GetModelName(std::uint32_t usModelID);
    static std::uint32_t      ResolveModelID(const SString& strModelNameOrNumber);
    static std::uint32_t      ResolveClothesTexID(const SString& strTexNameOrNumber);

protected:
    static void InitializeMaps();

    static std::map<std::uint32_t, const char*> ms_ModelIDNameMap;
    static std::map<SString, std::uint32_t>     ms_NameModelIDMap;
    static std::map<std::uint32_t, const char*> ms_ClothesModelIDNameMap;
    static std::map<SString, std::uint32_t>     ms_NameClothesModelIDMap;
    static std::map<std::uint32_t, const char*> ms_ClothesTexIDNameMap;
    static std::map<SString, std::uint32_t>     ms_NameClothesTexIDMap;
};
