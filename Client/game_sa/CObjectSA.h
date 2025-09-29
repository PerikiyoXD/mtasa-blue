/*****************************************************************************
 *
 *  PROJECT:     Multi Theft Auto v1.0
 *  LICENSE:     See LICENSE in the top level directory
 *  FILE:        game_sa/CObjectSA.h
 *  PURPOSE:     Header file for object entity class
 *
 *  Multi Theft Auto is available from https://www.multitheftauto.com/
 *
 *****************************************************************************/

#pragma once

#include <game/CObject.h>
#include "CPhysicalSA.h"

class CFireSAInterface;

#define FUNC_CObject_Create             0x5A1F60
#define FUNC_CObject_Explode            0x5A1340
#define FUNC_CGlass_WindowRespondsToCollision 0x71BC40

class CObjectInfo
{
public:
    float   fMass;                               // 0
    float   fTurnMass;                           // 4
    float   fAirResistance;                      // 8
    float   fElasticity;                         // 12
    float   fBuoyancy;                           // 16
    float   fUprootLimit;                        // 20
    float   fColDamageMultiplier;                // 24
    std::uint8_t   ucColDamageEffect;                   // 28
    std::uint8_t   ucSpecialColResponseCase;            // 29
    std::uint8_t   ucCameraAvoidObject;                 // 30
    std::uint8_t   ucCausesExplosion;                   // 31
    std::uint8_t   ucFxType;                            // 32
    std::uint8_t   pad1[3];                             // 33
    CVector vecFxOffset;                         // 36
    void*   pFxSystem;                           // ret from CParticleData::GetDataFromName // 48
    float   fSmashMultiplier;                    // 52
    CVector vecBreakVelocity;                    // 56
    float   fBreakVelocityRand;                  // 68
    std::uint32_t  uiGunBreakMode;                      // 72
    std::uint32_t  uiSparksOnImpact;                    // 76
};
// TODO: Find out correct size
// static_assert(sizeof(CObjectInfo) == 0x50, "Invalid size for CObjectInfo");

class CObjectSAInterface : public CPhysicalSAInterface
{
public:
    void*  pObjectList;            // 312
    std::uint8_t  pad1;                   // 316
    std::uint8_t  pad2;                   // 317
    std::uint16_t pad3;                   // 318

    // flags
    std::uint32_t b0x01 : 1;            // 320
    std::uint32_t b0x02 : 1;
    std::uint32_t b0x04 : 1;
    std::uint32_t b0x08 : 1;
    std::uint32_t b0x10 : 1;
    std::uint32_t b0x20 : 1;
    std::uint32_t bExploded : 1;
    std::uint32_t b0x80 : 1;

    std::uint32_t b0x100 : 1;            // 321
    std::uint32_t b0x200 : 1;
    std::uint32_t b0x400 : 1;
    std::uint32_t bIsTrainNearCrossing : 1;            // Train crossing will be opened if flag is set (distance < 120.0f)
    std::uint32_t b0x1000 : 1;
    std::uint32_t b0x2000 : 1;
    std::uint32_t bIsDoorMoving : 1;
    std::uint32_t bIsDoorOpen : 1;

    std::uint32_t b0x10000 : 1;            // 322
    std::uint32_t bUpdateScale : 1;
    std::uint32_t b0x40000 : 1;
    std::uint32_t b0x80000 : 1;
    std::uint32_t b0x100000 : 1;
    std::uint32_t b0x200000 : 1;
    std::uint32_t b0x400000 : 1;
    std::uint32_t b0x800000 : 1;

    std::uint32_t b0x1000000 : 1;            // 323
    std::uint32_t b0x2000000 : 1;
    std::uint32_t b0x4000000 : 1;
    std::uint32_t b0x8000000 : 1;
    std::uint32_t b0x10000000 : 1;
    std::uint32_t b0x20000000 : 1;
    std::uint32_t b0x40000000 : 1;
    std::uint32_t b0x80000000 : 1;

    std::uint8_t               ucColDamageEffect;              // 324
    std::uint8_t               pad4;                           // 325
    std::uint8_t               pad5;                           // 326
    std::uint8_t               pad6;                           // 327
    std::uint8_t               pad7;                           // 328
    std::uint8_t               pad8;                           // 329
    std::uint16_t              pad9;                           // 330
    std::uint8_t               pad10;                          // 332
    std::uint8_t               pad11;                          // 333
    std::uint8_t               pad12;                          // 334
    std::uint8_t               pad13;                          // 335
    std::uint32_t              uiObjectRemovalTime;            // 336
    float               fHealth;                        // 340
    std::uint32_t              pad15;                          // 344
    float               fScale;                         // 348
    CObjectInfo*        pObjectInfo;                    // 352
    CFireSAInterface*   pFire;                          // 356
    std::uint16_t              pad17;                          // 360
    std::uint16_t              pad18;                          // 362
    std::uint32_t              pad19;                          // 364
    CEntitySAInterface* pLinkedObjectDummy;             // 368  CDummyObject - Is used for dynamic objects like garage doors, train crossings etc.
    std::uint32_t              pad21;                          // 372
    std::uint32_t              pad22;                          // 376
};
static_assert(sizeof(CObjectSAInterface) == 0x17C, "Invalid size for CObjectSAInterface");

class CObjectSA : public virtual CObject, public virtual CPhysicalSA
{
private:
    unsigned char m_ucAlpha;
    bool          m_bIsAGangTag;
    CVector       m_vecScale;
    bool          m_preRenderRequired = false;

public:
    static void StaticSetHooks();

    CObjectSA(CObjectSAInterface* objectInterface);
    CObjectSA(DWORD dwModel, bool bBreakingDisabled);
    ~CObjectSA();

    CObjectSAInterface* GetObjectInterface() { return (CObjectSAInterface*)GetInterface(); }

    void  Explode();
    void  Break();
    void  SetHealth(float fHealth);
    float GetHealth();
    void  SetModelIndex(unsigned long ulModel);

    void          SetPreRenderRequired(bool required) { m_preRenderRequired = required; }
    bool          GetPreRenderRequired() { return m_preRenderRequired; }
    void          SetAlpha(unsigned char ucAlpha) { m_ucAlpha = ucAlpha; }
    unsigned char GetAlpha() { return m_ucAlpha; }

    bool IsAGangTag() const { return m_bIsAGangTag; }
    bool IsGlass();

    void     SetScale(float fX, float fY, float fZ);
    CVector* GetScale();
    void     ResetScale();

    bool IsOnFire() override { return GetObjectInterface()->pFire != nullptr; }
    bool SetOnFire(bool onFire) override;

private:
    void CheckForGangTag();
};
