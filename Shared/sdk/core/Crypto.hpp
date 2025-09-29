/*****************************************************************************
 *
 *  PROJECT:     Multi Theft Auto
 *  LICENSE:     See LICENSE in the top level directory
 *
 *  Multi Theft Auto is available from https://www.multitheftauto.com/
 *
 *****************************************************************************/

#pragma once

#include <cryptopp/filters.h>
#include <cryptopp/hex.h>
#include <cryptopp/hmac.h>
#include "SharedUtil.Crypto.h"

namespace SharedUtil
{
    template <class HashType>
    SString Hash(const SString& value)
    {
        SString  result;
        HashType hashType{};

        CryptoPP::StringSource ss(value, true, new CryptoPP::HashFilter(hashType, new CryptoPP::HexEncoder(new CryptoPP::StringSink(result))));

        return result;
    }

    template <class HmacType>
    SString Hmac(const SString& value, const SString& key)
    {
        SString mac;
        SString result;

        CryptoPP::HMAC<HmacType> hmac(reinterpret_cast<const CryptoPP::byte*>(key.c_str()), key.size());

        CryptoPP::StringSource ssMac(value, true, new CryptoPP::HashFilter(hmac, new CryptoPP::StringSink(mac)));
        CryptoPP::StringSource ssResult(mac, true, new CryptoPP::HexEncoder(new CryptoPP::StringSink(result)));

        return result;
    }

}  // namespace SharedUtil
