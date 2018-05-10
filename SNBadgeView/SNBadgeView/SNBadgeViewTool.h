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

+ (instancetype)sharedManager;

@property (nonatomic, strong) UIColor * hinthColor;

@property (nonatomic, strong) UIColor * numberColor;

@end
