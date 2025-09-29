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
#include "Misc.h"
#include "Thread.h"

namespace SharedUtil
{
    //
    // Increments supplied pointer contents using threads and stuff
    //
    class CIntervalCounter : public CRefCountable
    {
    public:
        ZERO_ON_NEW
        typedef uchar T; // Type of counter. Must be atomicly incrementable.
        CIntervalCounter(uint uiMinIntervalMs, T* pCounter);

    private:
        virtual ~CIntervalCounter();

    public:
        void         StopThread();
        static void* StaticThreadProc(void* pContext);
        void*        ThreadProc();

    protected:
        // Main thread variables
        CThreadHandle* m_pServiceThreadHandle;
        uint           m_uiMinIntervalMs;

        // Sync thread variables
        T m_InternalCounter;

        // Shared variables
        struct
        {
            T*          m_pCounter;
            bool        m_bTerminateThread;
            bool        m_bThreadTerminated;
            CComboMutex m_Mutex;
        } shared;
    };

}            // namespace SharedUtil
