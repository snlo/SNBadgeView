//
//  SNBadgeViewTool.h
//  SNBadgeView
//
//  Created by sunDong on 2018/5/7.
//  Copyright © 2018年 snloveydus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

//#import "UIView+SNBadgeView.h"
//#import "UIBarButtonItem+SNBadgeView.h"
//#import "UIButton+SNBadgeView.h"
//#import "UITabBarItem+SNBadgeView.h"


@interface SNBadgeViewTool : NSObject

+ (instancetype)sharedManager;

@property (nonatomic, strong) UIColor * hinthColor;

@end
