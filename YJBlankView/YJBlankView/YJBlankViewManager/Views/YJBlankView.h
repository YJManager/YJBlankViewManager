//
//  YJBlankView.h
//  YJBlankView
//
//  Created by YJHou on 16/10/10.
//  Copyright © 2016年 YJHou. All rights reserved.
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
@property (nonatomic, assign) CGFloat verticalMargin;

@property (nonatomic, assign) BOOL fadeInOnDisplay;
@property (nonatomic, strong) UITapGestureRecognizer * tapGesture;

- (void)prepareForYJBlankViewReuse;

@end
