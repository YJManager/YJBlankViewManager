//
//  YJBlankView.m
//  YJBlankView
//
//  Created by YJHou on 16/10/10.
//  Copyright © 2016年 YJHou. All rights reserved.
//

#import "YJBlankView.h"
#import "UIView+YJBlankView.h"

@interface YJBlankView ()

@end

@implementation YJBlankView
@synthesize contentView = _contentView, titleLabel = _titleLabel, detailLabel = _detailLabel, imageView = _imageView, button = _button;

- (instancetype)init{
    self =  [super init];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    self.frame = self.superview.bounds;
    
    void(^fadeInBlock)(void) = ^{
        _contentView.alpha = 1.0f;
    };
    
    if (self.fadeInOnDisplay) {
        [UIView animateWithDuration:0.25 animations:fadeInBlock completion:nil];
    }else {
        fadeInBlock();
    }
}


#pragma mark - APIS
- (void)prepareForYJBlankViewReuse{
    
    for (NSInteger i = 0; i < self.contentView.subviews.count; i++) {
        __kindof UIView * subView = self.contentView.subviews[i];
        [subView removeFromSuperview];
        subView = nil;
    }
    
    [self removeConstraints:self.constraints];
    [_contentView removeConstraints:_contentView.constraints];
    _contentView = nil;
}

- (void)installBlankViewConstraints{
    
    NSLayoutConstraint * centerXConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterX];
    NSLayoutConstraint * centerYConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterY];
    
    [self addConstraint:centerXConstraint];
    [self addConstraint:centerYConstraint];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.contentView}]];
    
    if (self.verticalOffset != 0 && self.constraints.count > 0) {
        centerYConstraint.constant = self.verticalOffset;
    }
    
    if (_customView) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.contentView}]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
    }else {
        
        CGFloat width = CGRectGetWidth(self.frame)?:CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat padding = roundf(width / 16.0);
        CGFloat verticalSpace = self.verticalMargin?:11.0; // Default is 11 pts
        
        NSMutableArray * subviewStrings = [NSMutableArray array];
        NSMutableDictionary * viewsDic = [NSMutableDictionary dictionary];
        NSDictionary * metrics = @{@"padding": @(padding)};
        
        if ([self _canShowImage]) {
            [subviewStrings addObject:@"imageView"];
            viewsDic[[subviewStrings lastObject]] = _imageView;
            [self.contentView addConstraint:[self.contentView equallyRelatedConstraintWithView:_imageView attribute:NSLayoutAttributeCenterX]];
        }else{
            [_imageView removeFromSuperview];
            _imageView = nil;
        }
        
        if ([self _canShowTitle]) {
            [subviewStrings addObject:@"titleLabel"];
            viewsDic[[subviewStrings lastObject]] = _titleLabel;
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[titleLabel(>=0)]-(padding@750)-|" options:0 metrics:metrics views:viewsDic]];
        }else {
            [_titleLabel removeFromSuperview];
            _titleLabel = nil;
        }
        
        if ([self _canShowDetail]) {
            [subviewStrings addObject:@"detailLabel"];
            viewsDic[[subviewStrings lastObject]] = _detailLabel;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[detailLabel(>=0)]-(padding@750)-|" options:0 metrics:metrics views:viewsDic]];
        }else {
            [_detailLabel removeFromSuperview];
            _detailLabel = nil;
        }
        
        if ([self _canShowButton]) {
            
            [subviewStrings addObject:@"button"];
            viewsDic[[subviewStrings lastObject]] = _button;
            
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[button(>=0)]-(padding@750)-|" options:0 metrics:metrics views:viewsDic]];
        }else {
            [_button removeFromSuperview];
            _button = nil;
        }
        
        NSMutableString *verticalFormat = [[NSMutableString alloc] init];
        
        for (int i = 0; i < subviewStrings.count; i++) {
            NSString * string = subviewStrings[i];
            [verticalFormat appendFormat:@"[%@]", string];
            if (i < subviewStrings.count-1) {
                [verticalFormat appendFormat:@"-(%.f@750)-", verticalSpace];
            }
        }
        
        if (verticalFormat.length > 0) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalFormat] options:0 metrics:metrics views:viewsDic]];
        }
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentView.frame  = self.frame;

    CGFloat contentCenterX = self.contentView.bounds.size.width * 0.5;
    CGFloat contentCenterY = self.contentView.bounds.size.height * 0.5 + self.verticalOffset;
    CGFloat verticalMargin = self.verticalMargin;
    
    self.titleLabel.frame = CGRectMake(0, contentCenterY, <#CGFloat width#>, <#CGFloat height#>)
    
    CGFloat imageViewCenterY =
    self.imageView.center = CGPointMake(contentCenterX, <#CGFloat y#>)
    
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView *hitView = [super hitTest:point withEvent:event];
    
    if ([hitView isKindOfClass:[UIControl class]]) {
        return hitView;
    }
    
    if ([hitView isEqual:_contentView] || [hitView isEqual:_customView]) {
        return hitView;
    }
    return nil;
}

#pragma mark - Setting Support
- (BOOL)_canShowImage{
    return (_imageView.image && _imageView.superview);
}

- (BOOL)_canShowTitle{
    return (_titleLabel.attributedText.string.length > 0 && _titleLabel.superview);
}

- (BOOL)_canShowDetail{
    return (_detailLabel.attributedText.string.length > 0 && _detailLabel.superview);
}

- (BOOL)_canShowButton{
    if ([_button attributedTitleForState:UIControlStateNormal].string.length > 0 || [_button imageForState:UIControlStateNormal]) {
        return (_button.superview != nil);
    }
    return NO;
}

#pragma mark - Lazy
- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.accessibilityIdentifier = @"contentViewInit";
        _contentView.alpha = 0;
    }
    return _contentView;
}

- (void)setCustomView:(UIView *)customView{
    if (customView == nil) return;
    if (_customView) {
        [_customView removeFromSuperview];
        _customView = nil;
    }
    _customView = customView;
    _customView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_customView];
}

- (UIImageView *)imageView{
    if (!_imageView){
        _imageView = [[UIImageView alloc] init];
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.accessibilityIdentifier = @"imageViewInit";
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];
        _titleLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.accessibilityIdentifier = @"titleLabelInit";
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel{
    if (!_detailLabel){
        _detailLabel = [UILabel new];
        _detailLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:14.0];
        _detailLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1.0];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        _detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _detailLabel.numberOfLines = 0;
        _detailLabel.accessibilityIdentifier = @"detailLabelInit";
        [self.contentView addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIButton *)button{
    if (!_button){
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.translatesAutoresizingMaskIntoConstraints = NO;
        _button.backgroundColor = [UIColor clearColor];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _button.accessibilityIdentifier = @"buttonInit";
        [_button addTarget:self action:@selector(blankViewButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
    }
    return _button;
}

- (void)blankViewButtonClickAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(blankView:didClickButton:)]) {
        [self blankViewButtonClickAction:sender];
    }
}

@end