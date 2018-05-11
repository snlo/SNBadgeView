//
//  NSString+SNTool.h
//  SNTool
//
//  Created by snlo on 2018/5/10.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SNTool)

/**
 加载<SNModuleKit>中的本地国际化
 */
+ (NSString *)sn_localizedStringForKey:(NSString *)key;

/**
 加载<SNTool>中的本地国际化
 */
+ (NSString *)sn_localizedStringForKey:(NSString *)key table:(NSString *)table;

/**
 加载本地国际化

 @param key 字段值，当没找到时显示key值
 @param table 表值，当没找到时在<SNTool>中取
 @param bundle 资源库名称，当没找到时在<SNTool>中取
 @return 国际化字段值
 */
+ (NSString *)sn_localizedStringForKey:(NSString *)key table:(NSString *)table bundle:(NSString *)bundle;

@end
