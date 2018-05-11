//
//  SNTool.m
//  snlo
//
//  Created by snlo on 2017/9/25.
//  Copyright © 2017年 snlo. All rights reserved.
//

#import "SNTool.h"

#import <objc/runtime.h>

#import <MBProgressHUD.h>

@interface SNTool ()

@property (nonatomic, strong) MBProgressHUD * hud;

@property (nonatomic, strong) MBProgressHUD * hudSuccess;

@property (nonatomic, strong) MBProgressHUD * hudLoding;

@end

@implementation SNTool

static id instanse;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
	static dispatch_once_t onesToken;
	dispatch_once(&onesToken, ^{
		instanse = [super allocWithZone:zone];
	});
	return instanse;
}
+ (instancetype)sharedManager {
	static dispatch_once_t onestoken;
	dispatch_once(&onestoken, ^{
		instanse = [[self alloc] init];
	});
	return instanse;
}
- (id)copyWithZone:(NSZone *)zone {
	return instanse;
};

#pragma mark -- API

+ (UIViewController *)rootViewController {
	return [UIApplication sharedApplication].windows.lastObject.rootViewController;
}

+ (void)showAlertStyle:(UIAlertControllerStyle)style title:(NSString *)title msg:(NSString *)message chooseBlock:(void (^)(NSInteger actionIndx))block  actionsStatement:(NSString *)cancelString, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableArray * argsArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    if (cancelString) [argsArray addObject:cancelString];
    
    id arg;
    va_list argList;
    if(cancelString) {
        
        va_start(argList,cancelString);
        
        while ((arg = va_arg(argList,id))) {
            [argsArray addObject:arg];
        }
        va_end(argList);
    }
    
//    遍历私有属性
    BOOL isSettingColor = NO;
    unsigned int count;
    Ivar *ivars =  class_copyIvarList([UIAlertAction class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char * cName =  ivar_getName(ivar);
        NSString *ocName = [NSString stringWithUTF8String:cName];
        if ([ocName isEqualToString:@"_titleTextColor"]) {
            isSettingColor = YES;
            break;
        }
//        NSLog(@"%@",ocName);
    }
//    free(ivars);

    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    for (int i = 0; i < [argsArray count]; i++) {
        
        UIAlertActionStyle styleAction =  (0 == i)? UIAlertActionStyleCancel: UIAlertActionStyleDefault;
        // Create the actions.
        UIAlertAction * action = [UIAlertAction actionWithTitle:[argsArray objectAtIndex:i] style:styleAction handler:^(UIAlertAction *action) {
            
            if (block) block(i);
        }];
        if (argsArray.count > 1) {
            if (isSettingColor) {
                if (styleAction == UIAlertActionStyleCancel) {
                    [action setValue:COLOR_CONTENT forKey:@"titleTextColor"];
                } else {
                    [action setValue:COLOR_MAIN forKey:@"titleTextColor"];
                }
            }
        }
        [alertController addAction:action];
    }
    
    [[self topViewController] presentViewController:alertController animated:YES completion:nil];
    
    alertController.view.tintColor = COLOR_MAIN;
    
    //2秒钟之后自动dismiss掉
    if (!cancelString) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [alertController dismissViewControllerAnimated:YES completion:nil];
        });
    }
}

+ (void)showHUDalertMsg:(NSString *)msg completion:(void(^)(void))completion
{
	[SNTool sharedManager].hud.label.text = msg;
	[[SNTool sharedManager].hud hideAnimated:YES afterDelay:3.f];
	[SNTool sharedManager].hud.completionBlock = ^ () {
		[SNTool sharedManager].hud = nil;
		if (completion) completion();
	};
}

+ (void)showHUDsuccessMsg:(NSString *)msg completion:(void(^)(void))completion {
	[SNTool sharedManager].hudSuccess.label.text = SNString(@"\n%@",msg);
	[[SNTool sharedManager].hudSuccess hideAnimated:YES afterDelay:3.f];
	[SNTool sharedManager].hudSuccess.completionBlock = ^ () {
		[SNTool sharedManager].hudSuccess = nil;
		if (completion) completion();
	};
}

+ (void)showLoading:(NSString *)msg {
    [SNTool sharedManager].hudLoding.label.text = msg;
}
+ (void)dismisLoding {
    [[SNTool sharedManager].hudLoding hideAnimated:YES];
    [SNTool sharedManager].hudLoding.completionBlock = ^ () {
        [[SNTool sharedManager].hudLoding removeFromSuperview];
        [SNTool sharedManager].hudLoding = nil;
    };
}

+ (BOOL)isPresented:(UIViewController *)viewController {
	return viewController.parentViewController.presentingViewController;
}

+ (CGFloat)alphaColor:(UIColor *)color {
	CGFloat red = 0.0;
	CGFloat green = 0.0;
	CGFloat blue = 0.0;
	CGFloat alpha = 0.0;
	[color getRed:&red green:&green blue:&blue alpha:&alpha];
	return alpha;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
	
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context,color.CGColor);
	CGContextFillRect(context, rect);
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	return image;
}

// 颜色转换三：iOS中十六进制的颜色（以#开头）转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
	NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
	
	// String should be 6 or 8 characters
	if ([cString length] < 6) {
		return [UIColor clearColor];
	}
	
	// 判断前缀并剪切掉
	if ([cString hasPrefix:@"0X"])
	cString = [cString substringFromIndex:2];
	if ([cString hasPrefix:@"#"])
	cString = [cString substringFromIndex:1];
	if ([cString length] != 6)
	return [UIColor clearColor];
	
	// 从六位数值中找到RGB对应的位数并转换
	NSRange range;
	range.location = 0;
	range.length = 2;
	
	//R、G、B
	NSString *rString = [cString substringWithRange:range];
	
	range.location = 2;
	NSString *gString = [cString substringWithRange:range];
	
	range.location = 4;
	NSString *bString = [cString substringWithRange:range];
	
	// Scan values
	unsigned int r, g, b;
	[[NSScanner scannerWithString:rString] scanHexInt:&r];
	[[NSScanner scannerWithString:gString] scanHexInt:&g];
	[[NSScanner scannerWithString:bString] scanHexInt:&b];
	
	return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

//正则表达式检索手机号
+ (BOOL)isPhone:(NSString *)phone {
    if (phone.length != 11) return NO;
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
//    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
//    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
//    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
//    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    NSString *NEW = @"(^1([3-9])\\d{9}$)";
    
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestnew = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", NEW];
    if (([regextestnew evaluateWithObject:phone] == YES)) {
        
        return YES;
    } else {
        return NO;
    }
//    if (([regextestmobile evaluateWithObject:phone] == YES) || ([regextestcm evaluateWithObject:phone] == YES) || ([regextestct evaluateWithObject:phone] == YES) || ([regextestcu evaluateWithObject:phone] == YES)) {
//
//        return YES;
//    } else {
//        return NO;
//    }
}
+ (BOOL)isIDCardNumber:(NSString *)value {
    
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSInteger length =0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        //不满足15位和18位，即身份证错误
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray = @[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    // 检测省份身份行政区代码
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag =NO; //标识省份代码是否正确
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return NO;
    }
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    //分为15位、18位身份证进行校验
    switch (length) {
        case 15:
            //获取年份对应的数字
            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
            
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                //创建正则表达式 NSRegularExpressionCaseInsensitive：不区分字母大小写的模式
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                                                        options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            //使用正则表达式匹配字符串 NSMatchingReportProgress:找到最长的匹配字符串后调用block回调
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            if(numberofMatch >0) {
                return YES;
            }else {
                return NO;
            }
        case 18:
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$" options:NSRegularExpressionCaseInsensitive error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                               options:NSMatchingReportProgress
                                                                 range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                //1：校验码的计算方法 身份证号码17位数分别乘以不同的系数。从第一位到第十七位的系数分别为：7－9－10－5－8－4－2－1－6－3－7－9－10－5－8－4－2。将这17位数字和系数相乘的结果相加。
                
                int S = [value substringWithRange:NSMakeRange(0,1)].intValue*7 + [value substringWithRange:NSMakeRange(10,1)].intValue *7 + [value substringWithRange:NSMakeRange(1,1)].intValue*9 + [value substringWithRange:NSMakeRange(11,1)].intValue *9 + [value substringWithRange:NSMakeRange(2,1)].intValue*10 + [value substringWithRange:NSMakeRange(12,1)].intValue *10 + [value substringWithRange:NSMakeRange(3,1)].intValue*5 + [value substringWithRange:NSMakeRange(13,1)].intValue *5 + [value substringWithRange:NSMakeRange(4,1)].intValue*8 + [value substringWithRange:NSMakeRange(14,1)].intValue *8 + [value substringWithRange:NSMakeRange(5,1)].intValue*4 + [value substringWithRange:NSMakeRange(15,1)].intValue *4 + [value substringWithRange:NSMakeRange(6,1)].intValue*2 + [value substringWithRange:NSMakeRange(16,1)].intValue *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                
                //2：用加出来和除以11，看余数是多少？余数只可能有0－1－2－3－4－5－6－7－8－9－10这11个数字
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 3：获取校验位
                
                NSString *lastStr = [value substringWithRange:NSMakeRange(17,1)];
                
                //4：检测ID的校验位
                if ([lastStr isEqualToString:@"x"]) {
                    if ([M isEqualToString:@"X"]) {
                        return YES;
                    }else{
                        
                        return NO;
                    }
                }else{
                    
                    if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                        return YES;
                    }else {
                        return NO;
                    }
                    
                }
                
            }else {
                return NO;
            }
        default:
            return NO;
    }
}
+ (BOOL)isPassWord:(NSString *)pass {
	NSString * regex = @"^(?!^[0-9]+$)(?!^[A-z]+$)(?!^[^A-z0-9]+$)^.{6,12}$";
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
	return [pred evaluateWithObject:pass];
}
+ (BOOL)isPaymentNumber:(NSString *)number {
    BOOL result = false;
    if (number.length == 6) {
//        NSString *regex =@"[0-9]*";
        NSString *regex = @"[a-zA-Z0-9]*";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        result = [pred evaluateWithObject:number];
    }
    return result;
}
+ (NSString *)isImageUrl:(NSString *)string {
    
    NSString * regex = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];

    if ([pred evaluateWithObject:string]) {
        return string;
    } else {
        NSObject * temp = [NSClassFromString(@"snlo") sharedManager];
        NSString * tempString = @"";
        
        Ivar ivar = class_getInstanceVariable([temp class], "_basrUrl");
        if (ivar != NULL) {
            tempString = object_getIvar(temp, ivar);
        }
        return SNString(@"%@/%@",tempString, string);
    }
}
+ (NSString *)cutHTTPStringFromChatFilePath:(NSString *)filePath {
    NSRange range = [filePath rangeOfString:@"upload"];
    return [filePath substringFromIndex:range.location];
}


+ (BOOL)isiOS11{
    return [UIDevice currentDevice].systemVersion.floatValue >= 11.0;
}

+ (UIViewController *)topViewController {
    __block UIWindow * window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        [[UIApplication sharedApplication].windows enumerateObjectsUsingBlock:^(__kindof UIWindow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            window = obj;
        }];
    }
    NSLog(@"%@",window.rootViewController);
    
    UIViewController * resultVC = [self fetchTopViewControllerWith:[window rootViewController]];
    if (!resultVC) {
        
    }
    while (resultVC.presentedViewController) {
        resultVC = [self fetchTopViewControllerWith:resultVC.presentedViewController];
    }
    while (resultVC.childViewControllers.count > 0) {
        resultVC = [self fetchTopViewControllerWithChilds:resultVC.childViewControllers.lastObject];
    }
    return resultVC;
}
+ (UIViewController *)fetchTopViewControllerWithChilds:(UIViewController *)VC  {
    if (VC.childViewControllers.lastObject) {
        return VC.childViewControllers.lastObject;
    } else {
        return VC;
    }
}
+ (UIViewController *)fetchTopViewControllerWith:(UIViewController *)VC {
    if ([VC isKindOfClass:[UINavigationController class]]) {
        return [self fetchTopViewControllerWith:[(UINavigationController *)VC topViewController]];
    } else if ([VC isKindOfClass:[UITabBarController class]]) {
        return [self fetchTopViewControllerWith:[(UITabBarController *)VC selectedViewController]];
    } else {
        return VC;
    }
}


+ (void)callWithTelephone:(NSString *)number {

    NSMutableString * phoneNmuberString = [[NSMutableString alloc] initWithFormat:@"telprompt:%@",number];
    
    NSURL * url =[NSURL URLWithString:phoneNmuberString];
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [[UIApplication sharedApplication] openURL:url options:@{}
                                 completionHandler:^(BOOL success) {
                                     
                                 }];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] openURL:url];
#pragma clang diagnostic pop
    }
}

+ (CGFloat)widthFromString:(NSString *)aString withRangeWidth:(CGFloat)aWidth font:(UIFont *)font
{
    CGRect rectToFit = [aString boundingRectWithSize:CGSizeMake(aWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil];
    
    return rectToFit.size.width;
}
+ (CGFloat)heightFromString:(NSString *)aString withRangeWidth:(CGFloat)aWidth font:(UIFont *)font
{
    CGRect rectToFit = [aString boundingRectWithSize:CGSizeMake(aWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil] context:nil];
    
    return rectToFit.size.height;
}

+ (NSMutableAttributedString *)attributedChangeFont:(UIFont *)font color:(UIColor *)color totalString:(NSString *)totalString subStringArray:(NSArray *)subArray {
    
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalString];
    
    for (NSString *rangeStr in subArray) {
        
        NSRange range = [totalString rangeOfString:rangeStr options:NSBackwardsSearch];
        
        [attributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    }
    
    return attributedStr;
}


+ (BOOL)stringContainsEmoji:(NSString *)string {
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

+ (void)addVisualEffectViewAtView:(UIView *)view withColor:(UIColor *)color alpha:(CGFloat)alpha {
    if (color && alpha) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        visualEffectView.frame = view.bounds;
        visualEffectView.backgroundColor = color;
        visualEffectView.alpha = alpha;
        visualEffectView.userInteractionEnabled = YES;
        [view insertSubview:visualEffectView atIndex:0];
    } else {
        UIToolbar * toolbar = [[UIToolbar alloc] init];
        toolbar.frame = view.bounds;
        toolbar.barStyle = UIBarStyleDefault;
        [view insertSubview:toolbar atIndex:0];
    }
}

+ (NSString *)fetchCurrentTimeFormat:(NSString *)format fromDate:(NSDate *)date
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    
    if (format) {
        [formatter setDateFormat:format];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    if (!date) {
        date = [NSDate date];
    }
    return [formatter stringFromDate:date];
}
+ (NSString *)fetchTimeFromCurrentSecs:(NSTimeInterval)secs format:(NSString *)format
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    if (format) {
        [formatter setDateFormat:format];
    } else {
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate *nextDate = [NSDate dateWithTimeInterval:secs sinceDate:[NSDate date]];
    
    return [formatter stringFromDate:nextDate];
}
+ (NSString *)fetchCurrentWeekFromDate:(NSDate *)date {
    NSCalendar  * calendar = [NSCalendar  currentCalendar];
    NSUInteger  unitFlags = NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
    if (!date) {
        date = [NSDate date];
    }
    NSDateComponents * conponent = [calendar components:unitFlags fromDate:date];
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"0", @"1", @"2", @"3", @"4", @"5", @"6", nil];
    
//    completeBlock(conponent.year,
//                  conponent.month,
//                  conponent.day,
//                  [weekdays[conponent.weekday] integerValue],
//                  conponent.hour,
//                  conponent.minute,
//                  conponent.second);
    return SNString(@"%@",weekdays[conponent.weekday]);
}
+ (NSString *)fetchAppVersionNo {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

//根据正则，过滤特殊字符
+ (NSString *)filterCharacters:(NSString *)string withRegex:(NSString *)regexStr {
    NSString *searchText = string;
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:searchText options:NSMatchingReportCompletion range:NSMakeRange(0, searchText.length) withTemplate:@""];
    return result;
}

+ (BOOL)isAllEmpty:(NSString *)string {
    if (!string) {
        return true;
    } else {
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        NSString *trimedString = [string stringByTrimmingCharactersInSet:set];
        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}

+ (CGFloat)homeBarHeight {
    if ([SNTool topViewController].tabBarController.tabBar) {
        return [SNTool topViewController].tabBarController.tabBar.frame.size.height - 49.f;
    } else {
        return kTabbarHeight - 49.f;
    }
}

+ (CGFloat)tabbarHeight {
    if ([SNTool topViewController].tabBarController.tabBar) {
        return [SNTool topViewController].tabBarController.tabBar.frame.size.height;
    } else {
        return kTabbarHeight;
    }
    
}

+ (CGFloat)navigationBarHeight {
    if ([SNTool fetchNavigationController].navigationBar) {
        return [SNTool fetchNavigationController].navigationBar.frame.size.height;
    } else {
        return kStatusBarAndNavigationBarHeight - [UIApplication sharedApplication].statusBarFrame.size.height;
    }
}

+ (UINavigationController *)fetchNavigationController {
    UIViewController * temp = [SNTool topViewController];
    if (temp.navigationController) {
        return temp.navigationController;
    } else if (temp.tabBarController) {
        return temp.tabBarController.navigationController;
    } else if ([temp isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)temp;
    } else {
        return nil;
    }
}

+ (CGFloat)statusBarHeight {
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

+ (CGFloat)naviBarAndStatusBarHeight {
    if ([SNTool fetchNavigationController].navigationBar) {
        CGFloat height = [SNTool fetchNavigationController].navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
        return height;
    } else {
        return kStatusBarAndNavigationBarHeight;
    }
}

#pragma mark -- getter

- (MBProgressHUD *)hud {
	if (!_hud) {
		_hud = [MBProgressHUD showHUDAddedTo:[SNTool topViewController].view animated:YES];
		_hud.mode = MBProgressHUDModeText;
        _hud.contentColor = [UIColor whiteColor];
		_hud.bezelView.color = [UIColor colorWithWhite:0.00 alpha:0.7];
		_hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
		_hud.animationType = MBProgressHUDAnimationZoomIn;
        _hud.label.numberOfLines = 0;
	} return  _hud;
}
- (MBProgressHUD *)hudSuccess {
	if (!_hudSuccess) {
		_hudSuccess = [MBProgressHUD showHUDAddedTo:[SNTool topViewController].view animated:YES];
		_hudSuccess.mode = MBProgressHUDModeCustomView;
		
		UIImage *image = [[UIImage imageNamed:@"public_checkbox_circle_checked_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		_hudSuccess.customView = [[UIImageView alloc] initWithImage:image];
        _hudSuccess.minSize = CGSizeMake(200, 110);
        _hudSuccess.label.numberOfLines = 2;
        _hudSuccess.label.font = [UIFont systemFontOfSize:16];
		_hudSuccess.contentColor = [UIColor whiteColor];
		_hudSuccess.bezelView.color = [UIColor colorWithWhite:0.00 alpha:0.5];
		_hudSuccess.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
		_hudSuccess.animationType = MBProgressHUDAnimationZoomIn;
	} return _hudSuccess;
}
- (MBProgressHUD *)hudLoding {
    if (!_hudLoding) {
        if (![SNTool topViewController]) {
            return _hudLoding;
        }
        _hudLoding = [MBProgressHUD showHUDAddedTo:[SNTool topViewController].view animated:YES];
        _hudLoding.mode = MBProgressHUDModeIndeterminate;
        _hudLoding.bezelView.color = [UIColor colorWithWhite:0.00 alpha:0.7];
        _hudLoding.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        _hudLoding.animationType = MBProgressHUDAnimationZoomIn;
        _hudLoding.contentColor = [UIColor whiteColor];
        _hudLoding.minShowTime = 0.1;
    } return _hudLoding;
}


#pragma mark -- Repealed
//+ (UIViewController *)topViewController
//{
//	UIViewController *result = nil;
//	UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//
//	if (window.windowLevel != UIWindowLevelNormal) {
//		NSArray *windows = [[UIApplication sharedApplication] windows];
//
//		for(UIWindow * tmpWin in windows) {
//
//			if (tmpWin.windowLevel == UIWindowLevelNormal) {
//				window = tmpWin;
//				break;
//			}
//		}
//	}
//
//	UIView * frontView = [[UIView alloc]init];
//
//	if (window.subviews.count < 1) {
//		frontView = window.rootViewController.view;
//	} else {
//		frontView = [[window subviews] objectAtIndex:0];
//	}
//
//	id nextResponder = [frontView nextResponder];
//
//	if ([nextResponder isKindOfClass:[UIViewController class]]) {
//		result = nextResponder;
//	} else {
//		result = window.rootViewController;
//	}
//
//	if (result.presentedViewController) {
//		result = result.presentedViewController;
//
//		for (int i = 0; i < 20; ++i) {
//			if (result.presentedViewController) {
//				result = result.presentedViewController;
//			} else {
//				break;
//			}
//		}
//	}
//	NSLog(@"topViewController -- %@",NSStringFromClass([result class]));
//	return result;
//}


@end
