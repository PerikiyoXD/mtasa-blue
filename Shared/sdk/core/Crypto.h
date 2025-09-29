/*****************************************************************************
 *
 *  PROJECT:     Multi Theft Auto
 *  LICENSE:     See LICENSE in the top level directory
 *
 *  Multi Theft Auto is available from https://www.multitheftauto.com/
 *
 *****************************************************************************/

#pragma once

#include "SString.h"

namespace SharedUtil
{
    struct KeyPair
    {
        SString publicKey, privateKey;
    };

    SString Base64encode(const SString& data, const SString& variant = SString());
    SString Base64decode(const SString& data, const SString& variant = SString());
    
    SString Base32encode(const SString& data, const SString& variant = SString());
    SString Base32decode(const SString& data, const SString& variant = SString());

    KeyPair GenerateRsaKeyPair(const unsigned int size);
    SString RsaEncode(const SString& data, const SString& publicKey);
    SString RsaDecode(const SString& data, const SString& privateKey);

    std::pair<SString, SString> Aes128encode(const SString& sData, const SString& sKey);
    SString                     Aes128decode(const SString& sData, const SString& sKey, SString sIv);

    bool StringToZLibFormat(const std::string& format, int& outResult);
    int  ZLibCompress(const std::string& input, std::string& output, const int windowBits = (int)ZLibFormat::GZIP, const int compression = 9,
                      const ZLibStrategy strategy = ZLibStrategy::DEFAULT);
    int  ZLibUncompress(const std::string& input, std::string& output, int windowBits = 0);

}            // namespace SharedUtil
