//
//  UIButton+SNBadge.m
//  snlo
//
//  Created by snlo on 2018/3/30.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import "UIButton+SNBadgeView.h"

#import <objc/runtime.h>

#import "UIView+SNBadgeView.h"

@implementation UIButton (SNBadgeView)

#pragma mark - badge
- (void)setSn_badgeView:(SNBadgeButton *)sn_badgeView {
	[self bottomView].sn_badgeView = sn_badgeView;
}

- (SNBadgeButton *)sn_badgeView {
	return [self bottomView].sn_badgeView;
}

#pragma mark - 获取Badge的父视图

- (UIView *)bottomView
{
    self.imageView.layer.masksToBounds = NO;
    
    if (self.imageView.image) {
        return self.imageView;
    } else if (self.titleLabel.text.length > 0) {
        return self.titleLabel;
    } else {
        return self;
    }
}

@end
