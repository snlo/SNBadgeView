//
//  SNBadgeViewTool.h
//  SNBadgeView
//
//  Created by sunDong on 2018/5/7.
//  Copyright © 2018年 snloveydus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface SNBadgeViewTool : NSObject

/**
 初始化

 @return 单例
 */
+ (instancetype)sharedManager;

/**
 暗示颜色
 */
@property (nonatomic, strong) UIColor * colorHint;

/**
 数值颜色
 */
@property (nonatomic, strong) UIColor * colorNumber;

@end
