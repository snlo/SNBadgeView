//
//  ViewController.m
//  SNBadgeView
//
//  Created by sunDong on 2018/5/7.
//  Copyright © 2018年 snloveydus. All rights reserved.
//

#import "ViewController.h"

#import "SNBadgeView.h"

#import "SNBadgeViewTool.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    pod trunk push SNBadgeView.podspec --verbose --allow-warnings --use-libraries
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"点我" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 200, 60, 60);
    [self.view addSubview:button];

    [SNBadgeView new].colorNumber = [UIColor redColor];
    [SNBadgeView new].colorHint = [UIColor yellowColor];
    
    NSLog(@"%@",button.sn_badgeView);
    NSLog(@"%@",button.sn_badgeView);
    
    [button.sn_badgeView setBadgeValue:23];
    
    
    UIButton * button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setTitle:@"点我2" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button2.frame = CGRectMake(0, 400, 60, 60);
    [self.view addSubview:button2];
    
    [SNBadgeView new].colorNumber = [UIColor redColor];
    [SNBadgeView new].colorHint = [UIColor blueColor];
    
    NSLog(@"%@",button2.sn_badgeView);
    NSLog(@"%@",button2.sn_badgeView);
    
    [button2.sn_badgeView setBadgeValue:23];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
