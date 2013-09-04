//
//  UserDefaultsDef.h
//  Acquirer
//
//  Created by chinapnr on 13-9-3.
//  Copyright (c) 2013年 chinaPnr. All rights reserved.
//

#ifndef Acquirer_UserDefaultsDef_h
#define Acquirer_UserDefaultsDef_h
//==================================================
//设置默认值为#
//==================================================
#define ACQUIRER_DEFAULT_VALUE @"#"

#define NSSTRING_YES @"YES"
#define NSSTRING_NO @"NO"

//==================================================
//UserDefaults def
//==================================================

//定义code.csv的版本号
#define CODE_CSV_VERSION @"CODE_CSV_VERSION"

#define ACQUIRER_IGNORE_VERSION @"ACQUIRER_IGNORE_VERSION"

//==================================================
//MTP Server
//==================================================
#define MTP_POS_RESPONSE_CODE @"RespCode"
#define MTP_TTY_RESPONSE_CODE @"return_code"
#define POSTBE_UID @"uid"

#define POSMINI_MTP_SESSION @"CHINAPNRJSESSIONID"
#define POSMINI_LOCAL_SESSION @"POSMINI_LOCAL_SESSION"

//==================================================
//Notification Name
//==================================================
#define NOTIFICATION_MESSAGE @"NOTIFICATION_MESSAGE"
#define NOTIFICATION_TYPE @"NOTIFICATION_TYPE"

#define NOTIFICATION_TITANIUM_PROMPT @"NOTIFICATION_TITANIUM_PROMPT"
//Acquirer local error
#define NOTIFICATION_TYPE_ERROR @"NOTIFICATION_TYPE_ERROR"
//Acquirer server error
#define NOTIFICATION_TYPE_WARNING @"NOTIFICATION_TYPE_WARNING"
//Acquirer success
#define NOTIFICATION_TYPE_SUCCESS @"NOTIFICATION_TYPE_SUCCESS"

#define NOTIFICATION_UI_AUTO_PROMPT @"NOTIFICATION_UI_AUTO_PROMPT"
#define NOTIFICATION_HIDE_UI_PROMPT @"NOTIFICATION_HIDE_UI_PROMPT"

#define NOTIFICATION_SYS_AUTO_PROMPT @"NOTIFICATION_SYS_AUTO_PROMPT"

#define NOTIFICATION_REQUIRE_USER_LOGIN @"NOTIFICATION_REQUIRE_USER_LOGIN"

#define NOTIFICATION_REFRESH_ACCOUNT @"NOTIFICATION_REFRESH_ACCOUNT"

//=====================================================
//UIDimension
//=====================================================

//start from 60
typedef enum {
    MBPHUD_UI_PROMPT_TAG = 60,
    MBPHUD_SYS_PROMPT_TAG,
    
    CPTABBAR_UIVIEW_TAG,
    
    UITABLE_VIEW_CELL_TITLE,
    UITABLE_VIEW_CELL_CONTENT
} PosMiniUIViewTag;


#define DEFAULT_STATUS_BAR_HEIGHT 20
#define DEFAULT_NAVIGATION_BAR_HEIGHT 44

#define DEFAULT_TAB_BAR_HEIGHT 49
#define DEFAULT_TAB_WIDTH 80

#endif
