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
#include <cryptopp/base64.h>

namespace SharedUtil
{
    SString Base64encode(const SString& data, const SString& variant = "");
    SString Base64decode(const SString& data, const SString& variant = "");

}            // namespace SharedUtil
