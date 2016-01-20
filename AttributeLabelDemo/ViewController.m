//
//  ViewController.m
//  AttributeLabelDemo
//
//  Created by GMCC on 16/1/20.
//  Copyright © 2016年 N. All rights reserved.
//

//  1.因为用到RegexKitLite，所以要加一个系统库libicucore，还有一个就是这个RegexKitLite是mrc写的，所以要加 -fno-objc-arc
//  2.以下是用法

#import "ViewController.h"
#import "AttributeLabel.h"

@interface ViewController ()
@property (nonatomic,strong) AttributeLabel *label;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _label = [[AttributeLabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 32)];
    _label.attributeString = @"未读25条";
    _label.rulesText = @"[0-9]\\d*";
    [self.view addSubview:_label];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
