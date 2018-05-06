//
//  SNBadgeView.h
//  snlo
//
//  Created by snlo on 2018/3/30.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNBadgeButton : UIButton

/**
 初始化
 */
+ (instancetype)badgeView;

/**
 设置标记值

 @param badgeValue integer类型
 */
- (void)setBadgeValue:(NSInteger)badgeValue;

@end
