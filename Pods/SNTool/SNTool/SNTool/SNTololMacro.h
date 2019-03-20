//
//  SNTololMacro.h
//  SNTool
//
//  Created by snlo on 2018/5/8.
//  Copyright © 2018年 snlo. All rights reserved.
//

#ifndef SNTololMacro_h
#define SNTololMacro_h

/**
 屏幕宽高
 */
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define kIs_iPhoneX (SCREEN_HEIGHT / SCREEN_WIDTH > 2.1 ? YES : NO)

#define kStatusBarAndNavigationBarHeight (kIs_iPhoneX ? 88.f : 64.f)
#define kTabbarHeight (kIs_iPhoneX ? 83.f : 49.f)

/**
 image about
 */
#define IMAGE_NAMED(name) [UIImage imageNamed:name]
#define IMAGE_PNG(name) UIImageMakeWithFileAndSuffix(name, @"png")
#define IMAGE_JPG(name) UIImageMakeWithFileAndSuffix(name, @"jpg")
#define UIImageMakeWithFileAndSuffix(name, suffix) [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@.%@", [[NSBundle mainBundle] resourcePath], name, suffix]]

/**
 color about
 */
#define COLOR_MAIN [SNTool colorWithHexString:@"#222222"] //雅黑
#define COLOR_BACK [SNTool colorWithHexString:@"#F6F6F6"] //背景色
#define COLOR_SEPARATOR [SNTool colorWithHexString:@"#E9EDEE"] //分割线颜色
#define COLOR_TITLE [SNTool colorWithHexString:@"#666666"] //标题色
#define COLOR_CONTENT [SNTool colorWithHexString:@"#999999"] //内容色

/**
 设置取消动态部署 scrollview及其子类
 */
#define  adjustsScrollViewInsets_NO(scrollView,vc)\
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
if ([UIScrollView instancesRespondToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
[scrollView   performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
} else {\
vc.automaticallyAdjustsScrollViewInsets = NO;\
}\
_Pragma("clang diagnostic pop") \
} while (0)

/**
 关于log
 */
#if TARGET_IPHONE_SIMULATOR
#define SNLog( s, ... ) NSLog( @"[%s:%d] %s", [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[[NSString alloc] initWithData:[[NSString stringWithFormat:s, ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSASCIIStringEncoding] UTF8String])
#else
#define SNLog( s, ... )
#endif

#if TARGET_IPHONE_SIMULATOR
#define NSLog( s, ...) NSLog(@"--------------->\n[%s:%d] %s\n  <---------\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__, [[NSString stringWithFormat:s, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog( s, ...)
#endif

#define SN_ASCII_String( s, ... ) [NSString stringWithCString:[[NSString stringWithFormat:(s), ##__VA_ARGS__] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding]

#define CODE_LOCATION_LABLE [NSString stringWithFormat:@"%s%d",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],__LINE__]

/**
 string about
 */
#define SNString( s, ... ) [NSString stringWithFormat:(s), ##__VA_ARGS__]
#define SNString_localized( s ) [NSString sn_localizedStringForKey:(s) table:nil bundle:nil]


#endif /* SNTololMacro_h */
