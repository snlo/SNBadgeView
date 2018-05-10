//
//  UITabBarItem+SNBadge.m
//  snlo
//
//  Created by snlo on 2018/3/30.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import "UITabBarItem+SNBadgeView.h"

#import <objc/runtime.h>

#import "UIView+SNBadgeView.h"

@implementation UITabBarItem (SNBadgeView)

#pragma mark - badge
- (void)setSn_badgeView:(SNBadgeView *)sn_badgeView {
	[self bottomView].sn_badgeView = sn_badgeView;
}

- (SNBadgeView *)sn_badgeView {
	return [self bottomView].sn_badgeView;
}

#pragma mark - 获取Badge的父视图
- (UIView *)bottomView {
    UIView *tabBarButton = [self valueForKey:@"_view"];
    for (UIView *subView in tabBarButton.subviews) {
        if ([NSStringFromClass(subView.superclass) isEqualToString:@"UIImageView"]) {
            return subView;
        }
    }
    return tabBarButton;
}

@end
