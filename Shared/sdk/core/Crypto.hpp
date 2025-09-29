/*****************************************************************************
 *
 *  PROJECT:     Multi Theft Auto
 *  LICENSE:     See LICENSE in the top level directory
 *
 *  Multi Theft Auto is available from https://www.multitheftauto.com/
 *
 *****************************************************************************/

#pragma once

#define CRYPTOPP_ENABLE_NAMESPACE_WEAK 1
#include <cryptopp/filters.h>
#include <cryptopp/hex.h>
#include <cryptopp/hmac.h>
#include <cryptopp/md5.h>
#include <cryptopp/sha.h>
#include <cryptopp/sha3.h>
#include <cryptopp/stdcpp.h>

#include "SString.h"

#include <string>

namespace SharedUtil
{
    template <class HashType>
    SString Hash(const SString& value)
    {
        std::string result;
        HashType    hashType{};

        CryptoPP::StringSource ss(value, true, new CryptoPP::HashFilter(hashType, new CryptoPP::HexEncoder(new CryptoPP::StringSink(result))));

        SString sResult = result.c_str();
        return sResult;
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

}            // namespace SharedUtil
