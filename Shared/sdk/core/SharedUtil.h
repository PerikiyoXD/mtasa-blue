/*****************************************************************************
 *
 *  PROJECT:     Multi Theft Auto
 *  LICENSE:     See LICENSE in the top level directory
 *
 *  Multi Theft Auto is available from https://www.multitheftauto.com/
 *
 *****************************************************************************/

#pragma once

#include "IntTypes.h"
#include "Defines.h"
#include "AllocTracking.h"

#include <cassert>
#include <list>
#include <vector>
#include <map>
#include <set>
#include <deque>
#include <algorithm>
#include <limits.h>
#include <stdio.h>
#include <string.h>
#include <string>
#include <stdarg.h>
#include <chrono>

// Vendor
#ifndef _
    #define _            // Use a dummy localisation define for modules that don't need it
#endif

#include "SString.h"
#include "WString.h"

#define _E(code) SString(" [%s]", code)

#include "Legacy.h"
#include "Map.h"
#if defined(SHARED_UTIL_WITH_HASH_MAP) || defined(SHARED_UTIL_WITH_FAST_HASH_MAP)
    #include "HashMap.h"
#endif
#if defined(SHARED_UTIL_WITH_FAST_HASH_MAP)
    #include "FastHashMap.h"
    #include "FastHashSet.h"
#endif
#include "Misc.h"
#include "File.h"
#include "SharedTime.h"
#include "Buffer.h"
#include "Game.h"
#include "SharedMath.h"
#include "ClassIdent.h"
#include "Hash.h"
#include "Crypto.h"
#if defined(SHARED_UTIL_WITH_SYS_INFO)
    #include "SysInfo.h"
#endif
#include "Profiling.h"
#include "Logging.h"
#include "AsyncTaskScheduler.hpp"
#include "ThreadPool.h"
#include "CMtaVersion.h"
#include "CFastList.h"
#include "CDuplicateLineFilter.h"

#ifdef _MSC_VER
    #define snprintf _snprintf
#endif

#ifndef stricmp
    #ifdef _MSC_VER
        #define stricmp _stricmp
    #else
        #define stricmp strcasecmp
    #endif
#endif

#ifndef strnicmp
    #ifdef _MSC_VER
        #define strnicmp _strnicmp
    #else
        #define strnicmp strncasecmp
    #endif
#endif
