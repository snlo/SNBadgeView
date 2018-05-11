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
    self.backgroundColor = self.hinthColor;
    self.titleLabel.font = [UIFont systemFontOfSize:11];
	self.tintColor = self.numberColor;
	[self setTitleColor:self.numberColor forState:UIControlStateNormal];
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

#pragma mark -- setter / getter

@synthesize hinthColor = _hinthColor;
- (void)setHinthColor:(UIColor *)hinthColor {
    _hinthColor = hinthColor;
	self.backgroundColor = _hinthColor;
}
@synthesize numberColor = _numberColor;
- (void)setNumberColor:(UIColor *)numberColor {
    _numberColor = numberColor;
	self.tintColor = _numberColor;
	[self setTitleColor:_numberColor forState:UIControlStateNormal];
}
- (UIColor *)hinthColor {
	if (!_hinthColor) {
		_hinthColor = [UIColor redColor];
	} return _hinthColor;
}
- (UIColor *)numberColor {
	if (!_numberColor) {
		_numberColor = [UIColor whiteColor];
	} return _numberColor;
}

@end
