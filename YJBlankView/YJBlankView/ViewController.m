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
    blankView.titleLabel.text = @"12";
    blankView.detailLabel.text = @"detail";
    [blankView.button setAttributedTitle:[[NSAttributedString alloc] initWithString:@"再来一次"] forState:UIControlStateNormal];
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
