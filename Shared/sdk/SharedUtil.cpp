/* This file serves as a temporary replacement for StdInc.cpp
    for projects which previously used PCHs to provide sdk/*.hpp
    implementations
*/

#include "SString.hpp"
#include "WString.hpp"
#include "AllocTracking.hpp"
#include "Misc.hpp"
#include "File.hpp"
#include "Time.hpp"
#include "Game.hpp"
#include "Hash.hpp"
#include "Profiling.hpp"
#include "Logging.hpp"
#include "AsyncTaskScheduler.hpp"
#if defined(SHARED_UTIL_WITH_SYS_INFO)
    #include "SharedUtil.SysInfo.hpp"
#endif
#include "SharedUtil.Memory.hpp"
#include "UTF8.hpp"
