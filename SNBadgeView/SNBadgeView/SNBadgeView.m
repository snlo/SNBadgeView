//
//  SNBadge.m
//  snlo
//
//  Created by snlo on 2018/3/30.
//  Copyright © 2018年 snlo. All rights reserved.
//

#import "SNBadgeView.h"

#import "SNBadgeViewTool.h"

@implementation SNBadgeView

+ (instancetype)badgeView {
    return [[SNBadgeView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
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
    if (self.hinthColor) {
        self.backgroundColor = self.hinthColor;
    } else {
        self.backgroundColor = [SNBadgeViewTool sharedManager].hinthColor;
    }
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    if (self.numberColor) {
        self.tintColor = self.numberColor;
        [self setTitleColor:self.numberColor forState:UIControlStateNormal];
    } else {
        self.tintColor = [SNBadgeViewTool sharedManager].numberColor;
        [self setTitleColor:[SNBadgeViewTool sharedManager].numberColor forState:UIControlStateNormal];
    }
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

#pragma mark -- setter

- (void)setHinthColor:(UIColor *)hinthColor {
    _hinthColor = hinthColor;
    [SNBadgeViewTool sharedManager].hinthColor = _hinthColor;
}
- (void)setNumberColor:(UIColor *)numberColor {
    _numberColor = numberColor;
    [SNBadgeViewTool sharedManager].numberColor = _numberColor;
}

@end
