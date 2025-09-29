/*****************************************************************************
 *
 *  PROJECT:     Multi Theft Auto v1.0
 *  LICENSE:     See LICENSE in the top level directory
 *  FILE:        game_sa/CBikeSA.h
 *  PURPOSE:     Header file for bike vehicle entity class
 *
 *  Multi Theft Auto is available from https://www.multitheftauto.com/
 *
 *****************************************************************************/

#pragma once

#include <game/CBike.h>
#include "CVehicleSA.h"

enum class eBikeNodes
{
    NONE = 0,
    CHASSIS,
    FORKS_FRONT,
    FORKS_REAR,
    WHEEL_FRONT,
    WHEEL_REAR,
    MUDGUARD,
    HANDLEBARS,
    MISC_A,
    MISC_B,

    NUM_NODES
};

struct sRideAnimData
{
    std::int32_t iAnimGroup;
    float fSteerAngle;
    float fAnimLean;
    std::int32_t iUnknow;
    std::int32_t iUnknowToo;
    float fHandlebarsAngle;
    float fAnimPercentageState;
};
static_assert(sizeof(sRideAnimData) == 0x1C, "Invalid size for sRideAnimData");

class CBikeSAInterface : public CVehicleSAInterface
{
public:
    RwFrame*             m_apModelNodes[static_cast<std::size_t>(eBikeNodes::NUM_NODES)];
    std::int8_t                 m_bLeanMatrixCalculated;
    std::int8_t                 pad0[3];            // Maybe prev value is std::int32_t
    std::int8_t                 m_mLeanMatrix[72];
    std::int8_t                 m_cDamageFlags;
    std::int8_t                 pad1[27];
    CVector              m_vecUnknowVector;
    tBikeHandlingDataSA* m_pBikeHandlingData;
    sRideAnimData        m_sRideData;
    std::int8_t                 m_acWheelDamageState[2];
    std::int8_t                 field_65E;
    std::int8_t                 field_65F;
    std::int8_t                 m_anWheelColPoint[176];
    float                m_afWheelDistanceToGround[4];
    std::int32_t                field_720[4];
    std::int32_t                field_730[4];
    std::int32_t                field_740;
    std::int32_t                m_aiWheelSurfaceType[2];
    std::int8_t                 field_74C[2];
    std::int8_t                 field_74E[2];
    float                m_afWheelRotationX[2];
    std::int32_t                field_758[2];
    std::int32_t                field_760;
    std::int32_t                field_764;
    std::int32_t                field_768;
    std::int32_t                field_76C;
    std::int32_t                field_770[4];
    std::int32_t                field_780[4];
    float                m_fHeightAboveRoad;
    float                m_fCarTraction;
    std::int32_t                field_798;
    std::int32_t                field_79C;
    std::int32_t                field_7A0;
    std::int32_t                field_7A4;
    std::int16_t                field_7A8;
    std::int8_t                 field_7AA[2];
    std::int32_t                field_7AC;
    std::int32_t                field_7B0;
    std::int8_t                 m_bPedLeftHandFixed;
    std::int8_t                 m_bPedRightHandFixed;
    std::int8_t                 field_7B6[2];
    std::int32_t                field_7B8;
    std::int32_t                field_7BC;
    std::int32_t                m_apWheelCollisionEntity[4];
    CVector              m_avTouchPointsLocalSpace[4];
    std::int32_t                m_pDamagedEntity;
    std::int8_t                 m_cNumContactWheels;
    std::int8_t                 m_cNumWheelsOnGround;
    std::int8_t                 field_806;
    std::int8_t                 field_807;
    std::int32_t                field_808;
    std::int32_t                m_aiWheelState[2];
};
static_assert(sizeof(CBikeSAInterface) == 0x814, "Invalid size for CBikeSAInterface");

class CBikeSA : public virtual CBike, public virtual CVehicleSA
{
private:
    CBikeHandlingEntrySA* m_pBikeHandlingData = nullptr;

public:
    CBikeSA() = default;
    CBikeSA(CBikeSAInterface* pInterface);

    CBikeSAInterface* GetBikeInterface() { return reinterpret_cast<CBikeSAInterface*>(GetInterface()); }

    CBikeHandlingEntry* GetBikeHandlingData();
    void                SetBikeHandlingData(CBikeHandlingEntry* pHandling);

    void RecalculateBikeHandling();
};
