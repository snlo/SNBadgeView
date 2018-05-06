//
//  SNBadge.m
//  snlo
//
//  Created by snlo on 2018/3/30.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import "SNBadgeButton.h"

#import "SNBadgeViewTool.h"

@implementation SNBadgeButton

+ (instancetype)badgeView {
    return [[SNBadgeButton alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
    self.backgroundColor = [SNBadgeViewTool sharedManager].hinthColor;
    self.tintColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.contentVerticalAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = nil;
    self.hidden = YES;
}

#pragma mark -- api

- (void)setBadgeValue:(NSInteger)badgeValue {
    if (badgeValue > 99) {
        self.hidden = NO;
        [self setTitle:@"99+" forState:UIControlStateNormal];
        self.bounds = CGRectMake(0, 0, 26, 14);
    } else if (badgeValue > 9) {
        self.hidden = NO;
        [self setTitle:[NSString stringWithFormat:@"%ld",(long)badgeValue] forState:UIControlStateNormal];
        self.bounds = CGRectMake(0, 0, 20, 14);
    } else if (badgeValue > 0) {
        self.hidden = NO;
        [self setTitle:[NSString stringWithFormat:@"%ld",(long)badgeValue] forState:UIControlStateNormal];
        self.bounds = CGRectMake(0, 0, 14, 14);
    } else if (badgeValue < 0) {
        self.hidden = NO;
        [self setTitle:@"" forState:UIControlStateNormal];
        self.bounds = CGRectMake(0, 0, 8, 8);
    } else {
        [self setTitle:@"" forState:UIControlStateNormal];
        self.hidden = YES;
    }
    self.layer.cornerRadius = self.bounds.size.height / 2;
}

@end
