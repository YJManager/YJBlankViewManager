//
//  YJBlankView.m
//  YJBlankView
//
//  Created by YJHou on 14/1/10.
//  Copyright © 2014年 YJManager. All rights reserved.
//

#import "YJBlankView.h"

@interface YJBlankView ()

@end

@implementation YJBlankView
@synthesize contentView = _contentView, titleLabel = _titleLabel, detailLabel = _detailLabel, imageView = _imageView, button = _button, customView = _customView;

- (instancetype)init{
    self =  [super init];
    if (self) {
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self addSubview:self.contentView];
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
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _titleLabel = nil;
    _detailLabel = nil;
    _imageView = nil;
    _button = nil;
    _customView = nil;
    
    [self removeConstraints:self.constraints];
    [_contentView removeConstraints:_contentView.constraints];

}

- (void)installBlankViewConstraints{
    
    [self addConstraint:[self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterX toItem:self]];
    NSLayoutConstraint * centerYConstraint = [self equallyRelatedConstraintWithView:self.contentView attribute:NSLayoutAttributeCenterY toItem:self];
    if (self.verticalOffset != 0 && self.constraints.count > 0) {
        centerYConstraint.constant = self.verticalOffset;
    }
    [self addConstraint:centerYConstraint];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.contentView}]];
    
    if (_customView) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:@{@"contentView": self.contentView}]];
        
        if (_customView.superview == nil) {
            [self.contentView addSubview:_customView];
        }
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[customView]|" options:0 metrics:nil views:@{@"customView":_customView}]];
    }else {
        CGFloat width = CGRectGetWidth(self.frame)?:CGRectGetWidth([UIScreen mainScreen].bounds);
        CGFloat padding = roundf(width/16.0);
        CGFloat verticalAutoMargin = (self.verticalAutoMargin > 0)?:5.0f;
        NSMutableDictionary * viewsDic = [NSMutableDictionary dictionary];
        NSDictionary * metrics = @{@"padding": @(padding)};
        
        NSMutableString * verticalFormat = [[NSMutableString alloc] init];
        
        if ([self _canShowImage]) {
            NSString * viewString = @"imageView";
            [viewsDic setObject:_imageView forKey:viewString];
            [verticalFormat appendFormat:@"[%@]", viewString];
            [self.contentView addConstraint:[self equallyRelatedConstraintWithView:_imageView attribute:NSLayoutAttributeCenterX toItem:self.contentView]];
        }else{
            [_imageView removeFromSuperview];
            _imageView = nil;
        }
        
        if ([self _canShowTitle]) {
            
            NSString * viewString = @"titleLabel";
            [viewsDic setObject:_titleLabel forKey:viewString];

            NSString * titleVerticalFormat = nil;
            CGFloat titleY = self.titleLabel.frame.origin.y, titleWidth = self.titleLabel.frame.size.width, titleHeight = self.titleLabel.frame.size.height;
            if (titleWidth > 0 && titleHeight > 0) {
                NSDictionary * titleMetrics = @{@"titleWidth": @(titleWidth)};
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[titleLabel(titleWidth)]" options:0 metrics:titleMetrics views:viewsDic]];
               [self.contentView addConstraint:[self equallyRelatedConstraintWithView:self.titleLabel attribute:NSLayoutAttributeCenterX toItem:self.contentView]];
                
                titleVerticalFormat = [NSString stringWithFormat:@"-(%.f@750)-[%@(%.f)]", titleY, viewString, titleHeight];
                
            }else{
                titleVerticalFormat = [NSString stringWithFormat:@"-(%.f@750)-[%@]",verticalAutoMargin, viewString];
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[titleLabel(>=0)]-(padding@750)-|" options:0 metrics:metrics views:viewsDic]];
            }
            
            [verticalFormat appendString:titleVerticalFormat];
            _titleLabel.backgroundColor = [UIColor redColor];
        }else {
            [_titleLabel removeFromSuperview];
            _titleLabel = nil;
        }
        
        if ([self _canShowDetail]) {
            
            NSString * viewString = @"detailLabel";
            [viewsDic setObject:_detailLabel forKey:viewString];
            
            NSString * detailVerticalFormat = nil;
            CGFloat detailY = self.detailLabel.frame.origin.y, detailWidth = self.detailLabel.frame.size.width, detailHeight = self.detailLabel.frame.size.height;
            if (detailWidth > 0 && detailHeight > 0) {
                NSDictionary * detalMetrics = @{@"detailWidth":@(detailWidth)};
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[detailLabel(detailWidth)]" options:0 metrics:detalMetrics views:viewsDic]];
                [self.contentView addConstraint:[self equallyRelatedConstraintWithView:self.detailLabel attribute:NSLayoutAttributeCenterX toItem:self.contentView]];
                detailVerticalFormat = [NSString stringWithFormat:@"-(%.f@750)-[%@(%.f)]", detailY, viewString, detailHeight];
                
            }else{
                detailVerticalFormat = [NSString stringWithFormat:@"-(%.f@750)-[%@]",verticalAutoMargin, viewString];
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[detailLabel(>=0)]-(padding@750)-|" options:0 metrics:metrics views:viewsDic]];
            }
            
            
            [verticalFormat appendString:detailVerticalFormat];
            _detailLabel.backgroundColor = [UIColor greenColor];
        }else {
            [_detailLabel removeFromSuperview];
            _detailLabel = nil;
        }
        
        if ([self _canShowButton]) {
            
            NSString * viewString = @"button";
            [viewsDic setObject:_button forKey:viewString];
            
            NSString * buttonVerticalFormat = nil;
            CGFloat buttonY = self.button.frame.origin.y, buttonWidth = self.button.frame.size.width, buttonHeight = self.button.frame.size.height;
            if (buttonWidth > 0 && buttonHeight > 0) {
                NSDictionary * buttonMetrics = @{@"buttonWidth":@(buttonWidth)};
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[button(buttonWidth)]" options:0 metrics:buttonMetrics views:viewsDic]];
                [self.contentView addConstraint:[self equallyRelatedConstraintWithView:self.button attribute:NSLayoutAttributeCenterX toItem:self.contentView]];
                buttonVerticalFormat = [NSString stringWithFormat:@"-(%.f@750)-[%@(%.f)]", buttonY, viewString, buttonHeight];
                
            }else{
                buttonVerticalFormat = [NSString stringWithFormat:@"-(%.f@750)-[%@]", verticalAutoMargin, viewString];
                [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(padding@750)-[button(>=0)]-(padding@750)-|" options:0 metrics:metrics views:viewsDic]];
            }
            [verticalFormat appendString:buttonVerticalFormat];
            _button.backgroundColor = [UIColor cyanColor];
            
        }else {
            [_button removeFromSuperview];
            _button = nil;
        }

        if (verticalFormat.length > 0) {
            [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|%@|", verticalFormat] options:0 metrics:metrics views:viewsDic]];
        }
    }
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

- (NSLayoutConstraint *)equallyRelatedConstraintWithView:(UIView *)view1 attribute:(NSLayoutAttribute)attribute toItem:(nullable id)view2{
    return [NSLayoutConstraint constraintWithItem:view1 attribute:attribute relatedBy:NSLayoutRelationEqual toItem:view2 attribute:attribute multiplier:1.0 constant:0.0];
}

#pragma mark - Lazy
- (UIView *)contentView{
    if (_contentView == nil) {
        _contentView = [[UIView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
        _contentView.backgroundColor = [UIColor yellowColor];
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
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
        [self.delegate blankView:self didClickButton:sender];
    }
}

@end
