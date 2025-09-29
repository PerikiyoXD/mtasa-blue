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
#include <zlib/zlib.h>

namespace SharedUtil
{
    bool StringToZLibFormat(const std::string& format, int& outResult);

    int ZlibCompress(const std::string& input, std::string& output, int compressionLevel = Z_DEFAULT_COMPRESSION);
    int ZlibDecompress(const std::string& input, std::string& output);

}            // namespace SharedUtil
