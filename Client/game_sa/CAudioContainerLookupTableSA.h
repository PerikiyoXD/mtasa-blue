/*****************************************************************************
 *
 *  PROJECT:     Multi Theft Auto v1.0
 *  LICENSE:     See LICENSE in the top level directory
 *  FILE:        game_sa/CAudioContainerLookupTableSA.h
 *  PURPOSE:     Audio container lookup table reader
 *
 *  Multi Theft Auto is available from https://www.multitheftauto.com/
 *
 *****************************************************************************/

#pragma once

#include "CAudioContainerSA.h"

struct SAudioLookupEntrySA;

class CAudioContainerLookupTableSA
{
public:
    CAudioContainerLookupTableSA(const SString& strPath);
    ~CAudioContainerLookupTableSA();

    int                  CountIndex(eAudioLookupIndex index);
    SAudioLookupEntrySA* GetEntry(eAudioLookupIndex lookupIndex, std::uint8_t bankIndex);

private:
    std::vector<SAudioLookupEntrySA*> m_Entries[9];
};

struct SAudioLookupEntrySA
{
    std::uint8_t  index;
    std::uint8_t  filter[3];
    std::uint32_t offset;
    std::uint32_t length;
};            // size = 12 = 0xC
static_assert(sizeof(SAudioLookupEntrySA) == 0xC, "Invalid size for SAudioLookupEntrySA");
