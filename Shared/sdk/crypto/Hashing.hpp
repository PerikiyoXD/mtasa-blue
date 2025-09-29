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
#include <cryptopp/hex.h>

namespace SharedUtil
{
    template <class HashType>
    inline SString Hash(const SString& value)
    {
        SString  result;
        HashType hashType{};

        CryptoPP::StringSource ss(value, true, new CryptoPP::HashFilter(hashType, new CryptoPP::HexEncoder(new CryptoPP::StringSink(result))));

        return result;
    }

}            // namespace SharedUtil
