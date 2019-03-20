//
//  Singletion.h
//  SNNetworking
//
//  Created by snlo on 16/6/30.
//  Copyright © 2016年 snlo. All rights reserved.
//


#define singletonInterface(classname) \
__attribute__((objc_subclassing_restricted)) \
@interface classname : NSObject \
+(instancetype)sharedManager;

#if __has_feature(objc_arc)
#define singletonImplemention(classname) \
@implementation classname \
static id instanse;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onesToken;\
dispatch_once(&onesToken, ^{\
instanse = [super allocWithZone:zone];\
});\
return instanse;\
}\
+ (instancetype)sharedManager\
{\
static dispatch_once_t onestoken;\
dispatch_once(&onestoken, ^{\
instanse = [[self alloc] init];\
});\
return instanse;\
}\
- (id)copyWithZone:(NSZone *)zone\
{\
return instanse;\
};
#else
#define singletonImplemention(class)  \
static id instanse;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onesToken;\
dispatch_once(&onesToken, ^{\
instanse = [super allocWithZone:zone];\
});\
return instanse;\
}\
+ (instancetype)sharedManager\
{\
static dispatch_once_t onestoken;\
dispatch_once(&onestoken, ^{\
instanse = [[self alloc] init];\
});\
return instanse;\
}\
- (id)copyWithZone:(NSZone *)zone\
{\
return instanse;\
}\
- (oneway void)release {} \
- (instancetype)retain {return instance;} \
- (instancetype)autorelease {return instance;} \
- (NSUInteger)retainCount {return ULONG_MAX;}

#endif /* Singletion_h */
