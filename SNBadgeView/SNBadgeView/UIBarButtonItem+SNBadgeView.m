//
//  UIBarButtonItem+SNBadge.m
//  snlo
//
//  Created by snlo on 2018/3/30.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import "UIBarButtonItem+SNBadgeView.h"

#import <objc/runtime.h>

#import "UIView+SNBadgeView.h"

@implementation UIBarButtonItem (SNBadge)

#pragma mark - badge
- (void)setSn_badgeView:(SNBadgeView *)sn_badgeView {
	[self bottomView].sn_badgeView = sn_badgeView;
}

- (SNBadgeView *)sn_badgeView {
	return [self bottomView].sn_badgeView;
}

#pragma mark - 获取Badge的父视图
- (UIView *)bottomView {
    UIView *navigationButton = [self valueForKey:@"_view"];
    NSString *controlName = ([UIDevice currentDevice].systemVersion.doubleValue < 11 ? @"UIImageView" : @"UIButton" );
    
    for (UIView *subView in navigationButton.subviews) {
        if ([subView isKindOfClass:NSClassFromString(controlName)]) {
            subView.layer.masksToBounds = NO;
            return subView;
        }
    }
    return navigationButton;
}

@end
