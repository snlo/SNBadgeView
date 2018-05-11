//
//  NSString+SNTool.m
//  SNTool
//
//  Created by snlo on 2018/5/10.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import "NSString+SNTool.h"

@implementation NSString (SNTool)

+ (NSString *)sn_localizedStringForKey:(NSString *)key {
    return [self sn_localizedStringForKey:key table:@"SNModuleKitStrings" bundle:@"SNModuleKit"];
}

+ (NSString *)sn_localizedStringForKey:(NSString *)key table:(NSString *)table {
    return [self sn_localizedStringForKey:key table:table ? :@"SNToolStrings" bundle:@"SNTool"];
}

+ (NSString *)sn_localizedStringForKey:(NSString *)key table:(NSString *)table bundle:(NSString *)bundle {
    if (!table) {
        table = @"SNToolStrings";
    }
    if (!bundle) {
        bundle = @"SNTool";
    }
    
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        language = @"en";
    } else if ([language hasPrefix:@"zh"]) {
        if ([language rangeOfString:@"Hans"].location != NSNotFound) {
            language = @"zh-Hans";
        }
    } else {
        language = @"en";
    }
    
    NSBundle * bundleKit = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:bundle ofType:@"bundle"]];
    NSBundle * bundles = [NSBundle bundleWithPath:[bundleKit pathForResource:language ofType:@"lproj"]];
    
    NSString * value = [bundles localizedStringForKey:key value:nil table:table];
    
    return [[NSBundle mainBundle] localizedStringForKey:key value:value table:table];
}

@end
