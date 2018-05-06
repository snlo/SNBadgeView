//
//  SNBadgeViewTool.m
//  SNBadgeView
//
//  Created by sunDong on 2018/5/7.
//  Copyright © 2018年 snloveydus. All rights reserved.
//

#import "SNBadgeViewTool.h"

@implementation SNBadgeViewTool

static id instanse;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
	static dispatch_once_t onesToken;
	dispatch_once(&onesToken, ^{
		instanse = [super allocWithZone:zone];
	});
	return instanse;
}
+ (instancetype)sharedManager {
	static dispatch_once_t onestoken;
	dispatch_once(&onestoken, ^{
		instanse = [[self alloc] init];
	});
	return instanse;
}
- (id)copyWithZone:(NSZone *)zone {
	return instanse;
};

#pragma mark -- getter //setter

- (UIColor *)hinthColor {
	if (!_hinthColor) {
		_hinthColor = [UIColor redColor];
	} return _hinthColor;
}

@end
