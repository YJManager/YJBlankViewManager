//
//  UIView+YJBlankView.m
//  YJBlankView
//
//  Created by YJHou on 16/10/10.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import "UIView+YJBlankView.h"

@implementation UIView (YJBlankView)

- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view attribute:(NSLayoutAttribute)attribute{
    return [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:self attribute:attribute multiplier:1.0 constant:0.0];
}

@end
