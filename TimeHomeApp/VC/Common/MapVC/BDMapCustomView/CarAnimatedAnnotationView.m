//
//  MyAnimatedAnnotationView.m
//  YouLifeApp
//
//  Created by us on 15/10/24.
//  Copyright © 2015年 us. All rights reserved.
//

#import "CarAnimatedAnnotationView.h"
#import "AnimatedAnnotation.h"

#define kWidth          40.f
#define kHeight         40.f
#define kTimeInterval   1.0f

#define kCalloutWidth       200.0


@implementation CarAnimatedAnnotationView
@synthesize imageView = _imageView;

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        [self setBounds:CGRectMake(0.f, 0.f, kWidth, kHeight)];
        [self setBackgroundColor:[UIColor clearColor]];
        
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.imageView];
    }
    
    return self;
}

#pragma mark - Utility

- (void)updateImageView
{
    AnimatedAnnotation *animatedAnnotation = (AnimatedAnnotation *)self.annotation;
    
    if ([self.imageView isAnimating])
    {
        [self.imageView stopAnimating];
    }
    
    self.imageView.animationImages      = animatedAnnotation.animatedImages;
    self.imageView.animationDuration    = kTimeInterval * [animatedAnnotation.animatedImages count];
    self.imageView.animationRepeatCount = 0;
    [self.imageView startAnimating];
}

#pragma mark - Override

- (void)setAnnotation:(id<BMKAnnotation>)annotation
{
    [super setAnnotation:annotation];
    
    [self updateImageView];
}

//-(void) setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    if (self.selected == selected)
//    {
//        return;
//    }
//    
//    if (selected)
//    {
//        if (self.calloutView == nil)
//        {
//            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, self.calloutView.height)];
//            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
//                                                  -self.calloutView.height -50+self.calloutOffset.y);
//        }
//        
//        self.calloutView.title = self.annotation.title;
//        [self.calloutView setIntroductionText:self.annotation.title];
//        
//        [self addSubview:self.calloutView];
//    }
//    else
//    {
//        [self.calloutView removeFromSuperview];
//    }
//    
//    [super setSelected:selected animated:animated];
//}

@end
