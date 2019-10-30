//
//  AppMacro.h
//  RingCharts
//
//  Created by xiaoxh on 2019/6/7.
//  Copyright © 2019 肖祥宏. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h


//16进制GRB转UIColor
#define kCorlorFromHexcode(hexcode) [UIColor colorWithRed:((float)((hexcode & 0xFF0000) >> 16)) / 255.0 green:((float)((hexcode & 0xFF00) >> 8)) / 255.0 blue:((float)(hexcode & 0xFF)) / 255.0 alpha:1.0]

#define kScreenBounds [[UIScreen mainScreen] bounds]
#define kScreenWidth kScreenBounds.size.width
#define kScreenHeight kScreenBounds.size.height
#define kIS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define kSCREEN_MAX_LENGTH (MAX(kScreenWidth, kScreenHeight))
#define kIS_IPHONE_X (kIS_IPHONE && kSCREEN_MAX_LENGTH == 812.0)
#define kTopBarHeight (kIS_IPHONE_X ? 88 : 64)

#endif /* AppMacro_h */
