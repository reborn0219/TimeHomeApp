//
//  MMPopupView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMPopupView.h"
#import "MMPopupWindow.h"
#import "MMPopupDefine.h"
#import "MMPopupCategory.h"
#import "Masonry.h"

@implementation MMPopupView

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if ( self )
    {
        [self setup];
    }
    
    return self;
}

- (void)setup
{
    self.type = MMPopupTypeAlert;
    self.animationDuration = 0.3f;
}

- (BOOL)visible
{
    if ( self.attachedView )
    {
        return !self.attachedView.mm_dimBackgroundView.hidden;
    }
    
    return NO;
}

- (void)setType:(MMPopupType)type
{
    _type = type;
    
    switch (type)
    {
        case MMPopupTypeAlert:
        {
            self.showAnimation = [self alertShowAnimation];
            self.hideAnimation = [self alertHideAnimation];
            break;
        }
        case MMPopupTypeSheet:
        {
            self.showAnimation = [self sheetShowAnimation];
            self.hideAnimation = [self sheetHideAnimation];
            break;
        }
        case MMPopupTypeCustom:
        {
            self.showAnimation = [self customShowAnimation];
            self.hideAnimation = [self customHideAnimation];
            break;
        }
        case MMPopupTypeCustomStyle1:
        {
            self.showAnimation = [self customStyle1ShowAnimation];
            self.hideAnimation = [self customStyle1HideAnimation];
            break;
        }
        case MMPopupTypeCustomStyle2:
        {
            self.showAnimation = [self customStyle2ShowAnimation];
            self.hideAnimation = [self customStyle2HideAnimation];
            break;
        }
        case MMPopupTypeFullScreen:
        {
            self.showAnimation = [self fullScreenShowAnimation];
            self.hideAnimation = [self fullScreenHideAnimation];
            break;
        }
            
        default:
            break;
    }
}
- (MMPopupBlock)fullScreenShowAnimation {
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [self.attachedView.mm_dimBackgroundView addSubview:self];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            //            make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.withKeyboard?-216/2:0));
//            make.width.mas_equalTo(SCREEN_WIDTH);
//            make.centerX.equalTo(self.attachedView.mas_centerX);
//            make.top.equalTo(self.attachedView).offset(20);
//            make.height.equalTo(@(SCREEN_HEIGHT-20));
            make.left.equalTo(self.attachedView).offset(WidthSpace(56));
            make.right.equalTo(self.attachedView).offset(-WidthSpace(56));
            make.top.equalTo(self.attachedView).offset(WidthSpace(102)+20);
            make.bottom.equalTo(self.attachedView).offset(-WidthSpace(194));
        }];
        [self layoutIfNeeded];
        
        self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.layer.transform = CATransform3DIdentity;
                             self.alpha = 1.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;

}
- (MMPopupBlock)fullScreenHideAnimation {
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;

}

- (MMPopupBlock)customStyle2ShowAnimation {
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [self.attachedView.mm_dimBackgroundView addSubview:self];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            //            make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.withKeyboard?-216/2:0));
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.centerX.equalTo(self.attachedView.mas_centerX);
            make.top.equalTo(self.attachedView).offset(20);
            make.height.equalTo(@(SCREEN_HEIGHT-20));
        }];
        [self layoutIfNeeded];
        
        self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.layer.transform = CATransform3DIdentity;
                             self.alpha = 1.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
    
}
- (MMPopupBlock)customStyle2HideAnimation {
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (MMPopupBlock)customStyle1ShowAnimation {
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [self.attachedView.mm_dimBackgroundView addSubview:self];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.withKeyboard?-216/2:0));
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width-WidthSpace(30));
            make.centerX.equalTo(self.attachedView.mas_centerX);
            make.top.equalTo(self.attachedView).offset(HeightSpace(234));
            make.height.equalTo(@(HeightSpace(442)));
        }];
        [self layoutIfNeeded];
        
        self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.layer.transform = CATransform3DIdentity;
                             self.alpha = 1.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;

}
- (MMPopupBlock)customStyle1HideAnimation {
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (void)setAnimationDuration:(NSTimeInterval)animationDuration
{
    _animationDuration = animationDuration;
    
    self.attachedView.mm_dimAnimationDuration = animationDuration;
}

- (void)show
{
    [self showWithBlock:nil];
}

- (void)showWithBlock:(MMPopupBlock)block
{
    if ( block )
    {
        self.showCompletionBlock = block;
    }
    
    if ( !self.attachedView )
    {
        self.attachedView = [MMPopupWindow sharedWindow];
    }
    [self.attachedView mm_showDimBackground];
    
    NSAssert(self.showAnimation, @"show animation must be there");
    
    self.showAnimation(self);
    
    if ( self.withKeyboard )
    {
        [self showKeyboard];
    }
}

- (void)hide
{
    [self hideWithBlock:nil];
}

- (void)hideWithBlock:(MMPopupBlock)block
{
    if ( block )
    {
        self.hideCompletionBlock = block;
    }
    
    if ( !self.attachedView )
    {
        self.attachedView = [MMPopupWindow sharedWindow];
    }
    [self.attachedView mm_hideDimBackground];
    
    if ( self.withKeyboard )
    {
        [self hideKeyboard];
    }
    
    NSAssert(self.showAnimation, @"hide animation must be there");
    
    self.hideAnimation(self);
}

- (MMPopupBlock)alertShowAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [self.attachedView.mm_dimBackgroundView addSubview:self];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.withKeyboard?-216/2:0));
        }];
        [self layoutIfNeeded];
        
        self.layer.transform = CATransform3DMakeScale(1.2f, 1.2f, 1.0f);
        self.alpha = 0.0f;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.layer.transform = CATransform3DIdentity;
                             self.alpha = 1.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (MMPopupBlock)alertHideAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             self.alpha = 0.0f;
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (MMPopupBlock)sheetShowAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [self.attachedView.mm_dimBackgroundView addSubview:self];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.attachedView);
            make.bottom.equalTo(self.attachedView.mas_bottom).offset(self.attachedView.frame.size.height);
        }];
        [self layoutIfNeeded];
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(self.attachedView.mas_bottom).offset(0);
                             }];
                             
                             [self layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (MMPopupBlock)sheetHideAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.bottom.equalTo(self.attachedView.mas_bottom).offset(self.attachedView.frame.size.height);
                             }];
                             
                             [self layoutIfNeeded];
                             
                         }
                         completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                             if ( self.hideCompletionBlock )
                             {
                                 self.hideCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (MMPopupBlock)customShowAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [self.attachedView.mm_dimBackgroundView addSubview:self];
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, -self.attachedView.bounds.size.height));
        }];
        [self layoutIfNeeded];
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
             usingSpringWithDamping:0.8
              initialSpringVelocity:1.5
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.withKeyboard?-216/2:0));
                             }];
                             
                             [self layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             
                             if ( self.showCompletionBlock )
                             {
                                 self.showCompletionBlock(self);
                             }
                             
                         }];
    };
    
    return block;
}

- (MMPopupBlock)customHideAnimation
{
    MMWeakify(self);
    MMPopupBlock block = ^(MMPopupView *popupView){
        MMStrongify(self);
        
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             
                             [self mas_updateConstraints:^(MASConstraintMaker *make) {
                                 make.center.equalTo(self.attachedView).centerOffset(CGPointMake(0, self.attachedView.bounds.size.height));
                             }];
                             
                             [self layoutIfNeeded];
                             
                         } completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             
                         }];
    };
    
    return block;
}

- (void)showKeyboard
{
    
}

- (void)hideKeyboard
{
    
}

@end
