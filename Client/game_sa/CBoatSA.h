/*****************************************************************************
 *
 *  PROJECT:     Multi Theft Auto v1.0
 *  LICENSE:     See LICENSE in the top level directory
 *  FILE:        game_sa/CBoatSA.h
 *  PURPOSE:     Header file for boat vehicle entity class
 *
 *  Multi Theft Auto is available from https://www.multitheftauto.com/
 *
 *****************************************************************************/

#pragma once

#include <game/CBoat.h>
#include "CVehicleSA.h"

enum class eBoatNodes
{
    NONE = 0,
    MOVING,
    WINDSCREEN,
    RUDDER,
    FLAP_LEFT,
    FLAP_RIGHT,
    REARFLAP_LEFT,
    REARFLAP_RIGHT,
    STATIC_PROP,
    MOVING_PROP,
    STATIC_PROP2,
    MOVING_PROP2,

    NUM_NODES
};

class CBoatSAInterface : public CVehicleSAInterface
{
public:
    std::uint32_t               pad1[3];                                 // 1440
    std::uint32_t               BoatFlags;                               // 1452
    RwFrame*             pBoatParts[static_cast<std::size_t>(eBoatNodes::NUM_NODES)];       // 1456
    std::uint32_t               pad2[3];                                 // 1500
    std::uint16_t               pad3;                                    // 1512
    std::uint8_t                pad4[2];                                 // 1514
    std::uint32_t               pad5[3];                                 // 1516
    tBoatHandlingDataSA* pBoatHandlingData;                       // 1528
    std::uint32_t               pad6[5];                                 // 1532
    CVector              vecUnk1;                                 // 1552
    CVector              vecUnk2;                                 // 1564
    class CParticleFx*   pBoatPropellerSplashParticle;            // 1576
    std::uint32_t               pad7[4];                                 // 1580
    std::uint8_t                pad8;                                    // 1596
    std::uint8_t                ucPadUsingBoat;                          // 1597  [[ see class CPad
    std::uint8_t                pad9[2];                                 // 1598
    std::uint32_t               pad10[106];                              // 1600
};

class CBoatSA final : public virtual CBoat, public virtual CVehicleSA
{
private:
    CBoatHandlingEntrySA* m_pBoatHandlingData = nullptr;

public:
    CBoatSA(CBoatSAInterface* pInterface);

    CBoatSAInterface* GetBoatInterface() { return reinterpret_cast<CBoatSAInterface*>(GetInterface()); }

    CBoatHandlingEntry* GetBoatHandlingData();
    void                SetBoatHandlingData(CBoatHandlingEntry* pHandling);
};
