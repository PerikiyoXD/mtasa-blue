/*****************************************************************************
 *
 *  PROJECT:     Multi Theft Auto
 *  LICENSE:     See LICENSE in the top level directory
 *
 *  Multi Theft Auto is available from https://www.multitheftauto.com/
 *
 *****************************************************************************/

#pragma once

#include "core/IntTypes.h"
#include "core/Defines.h"
#include "core/AllocTracking.h"

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

#include "core/SString.h"
#include "core/WString.h"

#define _E(code) SString(" [%s]", code)

#include "core/Legacy.h"
#include "core/Map.h"
#if defined(SHARED_UTIL_WITH_HASH_MAP) || defined(SHARED_UTIL_WITH_FAST_HASH_MAP)
    #include "core/HashMap.h"
#endif
#if defined(SHARED_UTIL_WITH_FAST_HASH_MAP)
    #include "core/FastHashMap.h"
    #include "core/FastHashSet.h"
#endif
#include "core/Misc.h"
#include "core/File.h"
#include "core/SharedTime.h"
#include "core/Buffer.h"
#include "core/Game.h"
#include "core/SharedMath.h"
#include "core/ClassIdent.h"
#include "core/Hash.h"
#include "core/Crypto.h"
#if defined(SHARED_UTIL_WITH_SYS_INFO)
    #include "SysInfo.h"
#endif
#include "core/Profiling.h"
#include "core/Logging.h"
#include "core/AsyncTaskScheduler.h"
#include "core/ThreadPool.h"
#include "core/CMtaVersion.h"
#include "core/CFastList.h"
#include "core/CDuplicateLineFilter.h"

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
