//
//  YJBlankView.m
//  YJBlankView
//
//  Created by YJHou on 14/1/10.
//  Copyright © 2014年 YJManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YJBlankView;
@protocol YJBlankViewDelegate <NSObject>

@optional
- (void)blankView:(YJBlankView *)blankView didClickButton:(UIButton *)button;

@end

@interface YJBlankView : UIView

@property (nonatomic, weak) id<YJBlankViewDelegate> delegate;

@property (nonatomic, strong, readonly) UIView * contentView;
@property (nonatomic, readonly) UIImageView    * imageView;
@property (nonatomic, readonly) UILabel        * titleLabel;
@property (nonatomic, readonly) UILabel        * detailLabel;
@property (nonatomic, readonly) UIButton       * button;

@property (nonatomic, strong)   UIView         * customView;

@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, assign) CGFloat verticalAutoMargin; // 默认自动布局的间距

@property (nonatomic, assign) BOOL fadeInOnDisplay;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

/** 清除之前的所有约束 */
- (void)unInstallBlankViewConstraints;
/** 添加约束 */
- (void)installBlankViewConstraints;

@end
