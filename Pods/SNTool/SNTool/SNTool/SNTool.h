//
//  SNTool.h
//  snlo
//
//  Created by snlo on 2017/9/25.
//  Copyright © 2017年 snlo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SNTololMacro.h"
#import "Singletion.h"

#import "NSString+SNTool.h"

__attribute__((objc_subclassing_restricted))

@interface SNTool : NSObject

+ (instancetype)sharedManager;

/**
 获取根视图控制器，最后一个window的rootViewController
 */
+ (UIViewController *)rootViewController;

/**
 统一定制alertViewController,兼容到iOS 8。

 @param style 见 UIAlertControllerStyle
 @param title 标题
 @param message 内容
 @param block action回调，‘0’为UIAlertActionStyleCancel的action。
 @param cancelString action数组，与回到中的actionIndex一一对应。当为nil时，alertViewController在2s后自动销毁
 */
+ (void)showAlertStyle:(UIAlertControllerStyle)style title:(NSString *)title msg:(NSString *)message chooseBlock:(void (^)(NSInteger actionIndx))block  actionsStatement:(NSString *)cancelString, ... NS_REQUIRES_NIL_TERMINATION;

/**
 HUD 提示框，默认显示3秒
 */
+ (void)showHUDalertMsg:(NSString *)msg completion:(void(^)(void))completion;

/**
 HUD 成功的提示，默认3秒显示
 */
+ (void)showHUDsuccessMsg:(NSString *)msg completion:(void(^)(void))completion;

/**
 HUD 全局菊花
 @param msg 等待提示
 */
+ (void)showLoading:(NSString *)msg;

/**
 销毁 全局菊花
 */
+ (void)dismisLoding;

/**
 判断一个视图控制器是否是模态推送出来的
 */
+ (BOOL)isPresented:(UIViewController *)viewController;

/**
 任意对象的上一个响应者ViewContrllor实咧，前提是它已经被加载
 */
+ (UIViewController *)topViewController;

/**
 读取颜色的透明度
 */
+ (CGFloat)alphaColor:(UIColor *)color;

/**
 颜色转图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 颜色转换
 
 @param color iOS中十六进制的颜色（以#开头）
 @return UIColor
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

/**
 正则表达式检索手机号:(^1([3-9])\\d{9}$)
 */
+ (BOOL)isPhone:(NSString *)phone;

/**
 正则身份证有效性
 */
+ (BOOL)isIDCardNumber:(NSString *)value;

/**
 正则密码是否6-12位包含数字和字母
 */
+ (BOOL)isPassWord:(NSString *)pass;

/**
 正则是否为6位数的交易密码
 */
+ (BOOL)isPaymentNumber:(NSString *)number;

/**
 正则匹配image的url，若不是则加上SNNetworking中的url
 */
+ (NSString *)isImageUrl:(NSString *)string;

/**
 切除聊天文件域名地址
 */
+ (NSString *)cutHTTPStringFromChatFilePath:(NSString *)filePath;

/**
 判断iOS 11以便UI适配
 */
+ (BOOL)isiOS11;

/**
 拨打电话
 @param number 电话号码
 */
+ (void)callWithTelephone:(NSString *)number;

/**
 string 的长度，在不同的显示范围类
 */
+ (CGFloat)widthFromString:(NSString *)aString withRangeWidth:(CGFloat)aWidth font:(UIFont *)font;

/**
 string 的高度，在不同的显示范围类
 */
+ (CGFloat)heightFromString:(NSString *)aString withRangeWidth:(CGFloat)aWidth font:(UIFont *)font;

/**
 实现模糊效果（兼容到iOS_7，在iOS8以前用的是UIToolbar，在iOS8以后用的是UIVisualEffectView。当然这两者的效果也是有所不同） 不建议让其参加CaorAnimation动画
 @param view 被模糊对象
 @param color 模糊颜色,设置它的alpha值从0~1模糊度由低变高
 @param alpha 模糊透明度，值为0时，不存在模糊度。
 */
+ (void)addVisualEffectViewAtView:(UIView *)view withColor:(UIColor *)color alpha:(CGFloat)alpha;

/**
 改变某些文字的颜色 并单独设置其字体
 @param font 设置的字体
 @param color 颜色
 @param totalString 总的字符串
 @param subArray 想要变色的字符数组
 @return 生成的富文本
 */
+ (NSMutableAttributedString *)attributedChangeFont:(UIFont *)font color:(UIColor *)color totalString:(NSString *)totalString subStringArray:(NSArray *)subArray;

/**
 限制表情符号
 */
+ (BOOL)stringContainsEmoji:(NSString *)string;

/**
 根据正则，过滤特殊字符
 @param string 要过滤的字符串
 @param regexStr 正则
 @return 过滤后的字符串
 */
+ (NSString *)filterCharacters:(NSString *)string withRegex:(NSString *)regexStr;

/**
 获取当前时间，
 @param format 默认格式：@"yyyy-MM-dd HH:mm:ss" 当为nil，时间的格式为默认
 @param date 自定义时间
 @return 当前时间
 */
+ (NSString *)fetchCurrentTimeFormat:(NSString *)format fromDate:(NSDate *)date;

/**
 获取距离当前时间
 @param secs  时间间隔，秒，after就传正数，before就传负数 eg:在此之前3天 -24 * 60 * 60 * 3
 @param format 默认格式：@"yyyy-MM-dd HH:mm:ss" 当为nil，时间的格式为默认
 @return 距离当前时间secs秒
 */
+ (NSString *)fetchTimeFromCurrentSecs:(NSTimeInterval)secs format:(NSString *)format;

/**
 获取当前星期几
 @param date 自定义时间
 */
+ (NSString *)fetchCurrentWeekFromDate:(NSDate *)date;

/**
 获取本地版本号
 */
+ (NSString *)fetchAppVersionNo;

/**
 是否全为空格
 */
+ (BOOL)isAllEmpty:(NSString *)string;

/**
 'homeBar' 高度
 */
+ (CGFloat)homeBarHeight;
/**
 标签栏高度
 */
+ (CGFloat)tabbarHeight;

/**
 导航栏高度
 */
+ (CGFloat)navigationBarHeight;

/**
 状态栏高度
 */
+ (CGFloat)statusBarHeight;

/**
 导航栏 + 状态栏高度
 */
+ (CGFloat)naviBarAndStatusBarHeight;

@end
