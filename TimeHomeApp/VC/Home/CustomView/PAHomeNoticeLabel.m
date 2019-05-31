//
//  PAHomeNoticeLabel.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/4/9.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAHomeNoticeLabel.h"

@interface PAHomeNoticeLabel(){
    NSInteger currentIndex;
    NSTimer * _autoScrollTimer;
}

@end

@implementation PAHomeNoticeLabel

-(instancetype)init{
    self = [super init];
    if (self) {
        currentIndex = 0;
    }
    return self;
}

-(void)setNotificArray:(NSArray *)notificArray{
    
    _notificArray = notificArray;
    
    if (notificArray.count > 0) {
        [self setText:[[self.notificArray objectAtIndex:currentIndex] objectForKey:@"title"]];
        
        if(_autoScrollTimer!=nil)
        {
            [_autoScrollTimer invalidate];
            _autoScrollTimer = nil;
        }
        _autoScrollTimer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(noticeAnimation) userInfo:nil repeats:YES];
    }    
}

-(void)noticeAnimation {
    
    currentIndex++;
    if (currentIndex >= [self.notificArray count]){
        currentIndex=0;
    }
    
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.3f ;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = YES;
    animation.type = @"cube";
    
    [self.layer addAnimation:animation forKey:@"animationID"];
    [self setText:[[self.notificArray objectAtIndex:currentIndex] objectForKey:@"title"]];
}

-(void)dealloc{
    [_autoScrollTimer invalidate];
    _autoScrollTimer = nil;
}

@end
