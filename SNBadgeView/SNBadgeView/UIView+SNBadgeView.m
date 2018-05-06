//
//  UIView+SNBadge.m
//  snlo
//
//  Created by snlo on 2018/3/30.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import "UIView+SNBadgeView.h"

#import <objc/runtime.h>

@implementation UIView (SNBadgeView)

- (void)setSn_badgeView:(SNBadgeButton *)sn_badgeView {
    objc_setAssociatedObject(self, @selector(sn_badgeView), sn_badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SNBadgeButton *)sn_badgeView {
    SNBadgeButton * badgeView = objc_getAssociatedObject(self, _cmd);
    if (!badgeView) {
        badgeView = [SNBadgeButton badgeView];
        
        [self addSubview:badgeView];
        [self bringSubviewToFront:badgeView];
        badgeView.center = CGPointMake(self.frame.size.width, 0);
        
        objc_setAssociatedObject(self, _cmd, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return badgeView;
}

@end
