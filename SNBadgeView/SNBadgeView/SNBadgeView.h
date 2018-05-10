//
//  SNBadgeView.h
//  snlo
//
//  Created by snlo on 2018/3/30.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNBadgeView : UIButton

/**
 初始化
 */
+ (instancetype)badgeView;

/**
 暗示颜色设置，默认红色
 */
@property (nonatomic, strong) UIColor * hinthColor;


/**
 数字色，默认白色
 */
@property (nonatomic, strong) UIColor * numberColor;

/**
 设置标记值

 @param badgeValue integer类型
 */
- (void)setBadgeValue:(NSInteger)badgeValue;

@end

#import "UIView+SNBadgeView.h"
#import "UIBarButtonItem+SNBadgeView.h"
#import "UIButton+SNBadgeView.h"
#import "UITabBarItem+SNBadgeView.h"


