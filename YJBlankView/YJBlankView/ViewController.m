//
//  ViewController.m
//  YJBlankView
//
//  Created by YJHou on 16/10/10.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import "ViewController.h"
#import "YJBlankView.h"

@interface ViewController () <YJBlankViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    YJBlankView * blankView = [[YJBlankView alloc] init];
    blankView.imageView.image = [UIImage imageNamed:@"noDataDefault"];
    blankView.titleLabel.text = @"没有网络";
    blankView.titleLabel.frame = CGRectMake(0, 0, 160, 44);
    blankView.titleLabel.font = [UIFont systemFontOfSize:24.0f];
    blankView.detailLabel.text = @"您可以尝试再次点击";
    [blankView.button setAttributedTitle:[[NSAttributedString alloc] initWithString:@"再来一次"] forState:UIControlStateNormal];
    blankView.button.frame = CGRectMake(0, 0, 100, 40);
    blankView.delegate = self;
    blankView.fadeInOnDisplay = YES;
    [self.view addSubview:blankView];
    
    [blankView installBlankViewConstraints];

    
    
}

- (void)blankView:(YJBlankView *)blankView didClickButton:(UIButton *)button{
    NSLog(@"%@", button);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
