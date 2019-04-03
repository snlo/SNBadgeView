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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configureView];
    }
    return self;
}

- (void)configureView {
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
    
    if (self.colorHint) {
        self.backgroundColor = self.colorHint;
    } else {
        self.backgroundColor = [SNBadgeViewTool sharedManager].colorHint;
    }
    self.titleLabel.font = [UIFont systemFontOfSize:11];
    if (self.colorNumber) {
        self.tintColor = self.colorNumber;
        [self setTitleColor:self.colorNumber forState:UIControlStateNormal];
    } else {
        self.tintColor = [SNBadgeViewTool sharedManager].colorNumber;
        [self setTitleColor:[SNBadgeViewTool sharedManager].colorNumber forState:UIControlStateNormal];
    }
}

#pragma mark -- setter / getter

- (void)setcolorHint:(UIColor *)colorHint {
    _colorHint = colorHint;
    self.backgroundColor = _colorHint;
}
- (void)setcolorNumber:(UIColor *)colorNumber {
    _colorNumber = colorNumber;
    self.tintColor = _colorNumber;
    [self setTitleColor:_colorNumber forState:UIControlStateNormal];
}

@end
