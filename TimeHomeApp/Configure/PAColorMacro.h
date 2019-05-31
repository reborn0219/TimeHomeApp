//
//  PAColorMacro.h
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/24.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#ifndef PAColorMacro_h
#define PAColorMacro_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBAFrom0X(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//清除背景色
#define CLEARCOLOR [UIColor clearColor]

//placeHolder颜色
#define PlaceHolder_COLOR (UIColorFromRGB(0xC5C5CA))

//红包黄色字体
#define kNewYellowColor (UIColorFromRGB(0xfcd440))

//2.2版本新的红色主题色
#define kNewRedColor (UIColorFromRGB(0xd21e1d))
/**
 *  新红色（同上）
 */
#define NEW_RED_COLOR (UIColorFromRGB(0xd21e1d))
/**
 *  新蓝色
 */
#define NEW_BLUE_COLOR (UIColorFromRGB(0x159bd1))
/**
 *  新灰色
 */
#define NEW_GRAY_COLOR (UIColorFromRGB(0x8e8f90))

//2.2版本 粉包颜色
#define kNewPinkColor (UIColorFromRGB(0xEB3E7D))

///紫色按钮
#define PURPLE_COLOR (UIColorFromRGB(0xab2121))

///背景色
#define BLACKGROUND_COLOR (UIColorFromRGB(0xf1f1f1))

//字体颜色(浅)
#define TEXT_COLOR (UIColorFromRGB(0x8e8e8e))

//导航栏
#define NABAR_COLOR (UIColorFromRGB(0xf7f7f7))

//Tabbar
#define TABBAR_COLOR (UIColorFromRGB(0XAB131F))

//分割线
#define LINE_COLOR (UIColorFromRGB(0xdadada))

/**
 *  标题文字颜色(深)
 */
#define TITLE_TEXT_COLOR (UIColorFromRGB(0x595353))

/**
 *  蓝色链接文字颜色
 */
#define BLUE_TEXT_COLOR (UIColorFromRGB(0x5b9ef9))

/**
 *  女性性别底色
 */
#define WOMEN_COLOR (UIColorFromRGB(0xee6161))

/**
 *  男性性别颜色
 */
#define MAN_COLOR   (UIColorFromRGB(0X5b9ef9))

/**
 *  绿色
 */
#define GREEN_COLOR (UIColorFromRGB(0x94da47))

/**
 *  橙色
 */
#define ORANGE_COLOR (UIColorFromRGB(0xf0a82f))

/**
 * 业主认证相关
 */
#define DARK_ORANGE_COLOR (UIColorFromRGB(0xc37304))///深黄色
#define LIGHT_ORANGE_COLOR (UIColorFromRGB(0xfac344))///浅黄色

/**
 *截图反馈
 */
#define Screenshots_COLOR (UIColorFromRGB(0x151759))///警徽蓝


///---------------------准迁移版本颜色宏定义------------------------


//主色调---蓝色
#define PREPARE_MAIN_BLUE_COLOR (UIColorFromRGB(0x007AFF))


#endif /* PAColorMacro_h */
