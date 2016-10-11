//
//  ViewController.m
//  YJBlankView
//
//  Created by YJHou on 16/10/10.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import "ViewController.h"
#import "YJBlankView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YJBlankView * blankView = [[YJBlankView alloc] init];
    blankView.titleLabel.text = @"12";
    blankView.detailLabel.text = @"detail";
    
    [self.view addSubview:blankView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
