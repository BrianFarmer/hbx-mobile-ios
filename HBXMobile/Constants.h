/*
 * Copyright 2010-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License").
 * You may not use this file except in compliance with the License.
 * A copy of the License is located at
 *
 *  http://aws.amazon.com/apache2.0
 *
 * or in the "license" file accompanying this file. This file is distributed
 * on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
 * express or implied. See the License for the specific language governing
 * permissions and limitations under the License.
 */
/*
#import <Foundation/Foundation.h>
#import <AWSCore/AWSCore.h>

FOUNDATION_EXPORT AWSRegionType const CognitoRegionType;
FOUNDATION_EXPORT AWSRegionType const DefaultServiceRegionType;
FOUNDATION_EXPORT NSString *const CognitoIdentityPoolId;
FOUNDATION_EXPORT NSString *const S3BucketName;
*/

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 alpha:1.0]

#define UI_COLOR_BLUE                       [UIColor colorWithRed:(0/255.0) green:(123/255.0) blue:(196/255.0) alpha:1]
#define UI_COLOR_DARK_BLUE                  UIColorFromRGB(0x003260)
#define UI_COLOR_ANOTHER_BLUE               UIColorFromRGB(0x044972)
#define UI_COLOR_LIGHT_BLUE                 UIColorFromRGB(0x007BC4)

#define UI_COLOR_PASTEL_GREEN               UIColorFromRGB(0x00a99e)
#define UI_COLOR_PASTEL_BLUE                UIColorFromRGB(0x00a3e2)
#define UI_COLOR_PURPLE                     UIColorFromRGB(0x625ba8)
#define UI_COLOR_YELLOW                     UIColorFromRGB(0xEAAA00)
#define UI_COLOR_RED                        UIColorFromRGB(0xE72B2D)
#define UI_COLOR_GREEN                      UIColorFromRGB(0x69A30D)
#define UI_COLOR_SUPER_DARK_GRAY            UIColorFromRGB(0x555555)
#define UI_COLOR_LIGHT_GRAY                 UIColorFromRGB(0xebebeb)
#define UI_COLOR_WHITE                      UIColorFromRGB(0xffffff)
#define UI_COLOR_PINK                       UIColorFromRGB(0xf06eaa)
#define UI_COLOR_DARK_GRAY                  UIColorFromRGB(0x414141)
#define UI_COLOR_GRAY                       UIColorFromRGB(0x909090)
#define UI_COLOR_MEDIUM_GRAY                UIColorFromRGB(0x7B7B7B)
#define UI_COLOR_BLACK                      UIColorFromRGB(0x000000)

#define APPLICATION_DEFAULT_TEXT_COLOR      UI_COLOR_SUPER_DARK_GRAY

#define ENROLLMENT_STATUS_OE_MIN_NOTMET     UI_COLOR_RED
#define ENROLLMENT_STATUS_OE_MIN_MET        UI_COLOR_GREEN
#define ENROLLMENT_STATUS_RENEWAL_IN_PROG   UI_COLOR_YELLOW
#define ENROLLMENT_STATUS_ALL_CLIENTS       UI_COLOR_PURPLE

#define EMPLOYER_LIST_HEADER_DRAWERS_OE     UI_COLOR_LIGHT_BLUE
#define EMPLOYER_LIST_HEADER_DRAWERS_RIP    UI_COLOR_LIGHT_BLUE
#define EMPLOYER_LIST_HEADER_DRAWERS_AC     UI_COLOR_LIGHT_BLUE

#define EMPLOYER_DETAIL_HEADER_DRAWER_RENEWAL           UI_COLOR_LIGHT_BLUE
#define EMPLOYER_DETAIL_HEADER_DRAWER_PART              UI_COLOR_LIGHT_BLUE
#define EMPLOYER_DETAIL_HEADER_DRAWER_COSTS             UI_COLOR_LIGHT_BLUE
#define EMPLOYER_DETAIL_HEADER_DRAWER_TEXT              UI_COLOR_WHITE

#define EMPLOYER_DETAIL_PARTICIPATION_ENROLLED          UI_COLOR_GREEN
#define EMPLOYER_DETAIL_PARTICIPATION_WAIVED            UI_COLOR_YELLOW
#define EMPLOYER_DETAIL_PARTICIPATION_NOT_ENROLLED      UI_COLOR_RED
#define EMPLOYER_DETAIL_PARTICIPATION_TERMINATED        UI_COLOR_DARK_GRAY
#define EMPLOYER_DETAIL_PARTICIPATION_ALL               UI_COLOR_DARK_GRAY


#define EMPLOYER_PLAN_CONTRIBUTION_EMPLOYEE             UI_COLOR_ANOTHER_BLUE
#define EMPLOYER_PLAN_CONTRIBUTION_SPOUSE               UI_COLOR_ANOTHER_BLUE
#define EMPLOYER_PLAN_CONTRIBUTION_PARTNER              UI_COLOR_ANOTHER_BLUE
#define EMPLOYER_PLAN_CONTRIBUTION_CHILD                UI_COLOR_ANOTHER_BLUE


