//
//  BBConstants.h
//  BabyBrezza
//
//  Created by Jay on 2017/3/6.
//  Copyright © 2017年 BabyBrezza. All rights reserved.
//

#ifndef BBConstants_h
#define BBConstants_h

//语言
typedef NS_ENUM(NSInteger, JJLanguageType)
{
    JJLanguageTypeEN = 0,    //英语
    JJLanguageTypeFR,        //法语
};

typedef NS_ENUM(NSInteger, JJLanguageStrType) {
    JJLanguageStrTypeENFR = 0,
    /** kStartBottleWarmer_EN */
    JJLanguageStrTypeSBW,
    /** kScanForYourBottleWarmer_EN */
    JJLanguageStrTypeSFYBW,
    /** kBottleWarmerConnected_EN */
    JJLanguageStrTypeBWC,
    /** kSettingGuide_EN */
    JJLanguageStrTypeSetGuide,
    /** kSetting_EN */
    JJLanguageStrTypeSetting,
    /** kSpeed_EN */
    JJLanguageStrTypeSpeed,
    /** kStartTemp_EN */
    JJLanguageStrTypeStartTemp,
    /** kRoom_EN */
    JJLanguageStrTypeRoom,
    /** kCode_EN */
    JJLanguageStrTypeCode,
    /** kSteady_EN */
    JJLanguageStrTypeSteedy,
    /** kQuick_EN */
    JJLanguageStrTypeQuick,
    /** kStart_EN */
    JJLanguageStrTypeStart,
    /** kConnect_EN */
    JJLanguageStrTypeConnect,
    /** kDisconnect_EN */
    JJLanguageStrTypeDisconnect,
    /** kCancel_EN */
    JJLanguageStrTypeCancel,
    /** kBottleIsReady_EN */
    JJLanguageStrTypeBIR,
    /** kError_EN */
    JJLanguageStrTypeError,
    /** kPleaseSeeTrouble_EN */
    JJLanguageStrTypePST,
};


static NSString * const kEN = @"EN";
static NSString * const kFR = @"FR";

static NSString * const kStartBottleWarmer_EN = @"start bottle warmer";
static NSString * const kStartBottleWarmer_FR = @"Chauffe-biberon intelligent";

static NSString * const kScanForYourBottleWarmer_EN = @"scan for your bottle warmer";
static NSString * const kScanForYourBottleWarmer_FR = @"Chercher le chauffe-biberon";

static NSString * const kBottleWarmerConnected_EN = @"Bottle warmer \n connected!";
static NSString * const kBottleWarmerConnected_FR = @"Connexion établie avec le chauffe-biberon";

static NSString * const kSettingGuide_EN = @"setting guide";
static NSString * const kSettingGuide_FR = @"guide des réglages";

static NSString * const kSetting_EN = @"setting";
static NSString * const kSetting_FR = @"réglages";

static NSString * const kSpeed_EN = @"speed";
static NSString * const kSpeed_FR = @"vitesse";

static NSString * const kStartTemp_EN = @"start temp";
static NSString * const kStartTemp_FR = @"temp départ";

static NSString * const kRoom_EN = @"room";
static NSString * const kRoom_FR = @"ambiante";

static NSString * const kCode_EN = @"cold";
static NSString * const kCode_FR = @"froid";

static NSString * const kSteady_EN = @"steady";
static NSString * const kSteady_FR = @"constant";

static NSString * const kQuick_EN = @"quick";
static NSString * const kQuick_FR = @"rapide";

static NSString * const kStart_EN = @"start";
static NSString * const kStart_FR = @"démarrer";

static NSString * const kConnect_EN = @"connected";
static NSString * const kConnect_FR = @"connecté";

static NSString * const kDisconnect_EN = @"disconnect";
static NSString * const kDisconnect_FR = @"déconnecté";

static NSString * const kCancel_EN = @"cancel";
static NSString * const kCancel_FR = @"annuler";

static NSString * const kBottleIsReady_EN = @"Bottle is ready!";
static NSString * const kBottleIsReady_FR = @"Le biberon est prét!";

static NSString * const kError_EN = @"Error";
static NSString * const kError_FR = @"Erreur";

static NSString * const kPleaseSeeTrouble_EN = @"Please see troubleshooting section\n in the instruction manual";
static NSString * const kPleaseSeeTrouble_FR = @"Consulter la section\n Dépannage du mode d’emploi";


#endif /* BBConstants_h */
