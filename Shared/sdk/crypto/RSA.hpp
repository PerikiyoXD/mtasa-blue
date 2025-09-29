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
#include <cryptopp/rsa.h>
#include <cryptopp/osrng.h>

namespace SharedUtil
{
    struct KeyPair
    {
        SString publicKey;
        SString privateKey;
    };

    KeyPair GenerateRsaKeyPair(const unsigned int size);

    SString RsaEncode(const SString& data, const SString& publicKey);
    SString RsaDecode(const SString& data, const SString& privateKey);

}            // namespace SharedUtil
