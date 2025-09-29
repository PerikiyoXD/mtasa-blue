/*****************************************************************************
 *
 *  PROJECT:     Multi Theft Auto
 *  LICENSE:     See LICENSE in the top level directory
 *
 *  Multi Theft Auto is available from https://www.multitheftauto.com/
 *
 *****************************************************************************/

#pragma once

#include <SString.h>
#include <cryptopp/aes.h>
#include <cryptopp/modes.h>
#include <cryptopp/osrng.h>

namespace SharedUtil
{
    using CryptoPP::byte;

    std::pair<SString, SString> Aes128Encode(const SString& sData, const SString& sKey);
    SString                     Aes128Decode(const SString& sData, const SString& sKey, const SString& sIv);

}            // namespace SharedUtil
