//
//  HDAnimtionUtils.m

#import <UIKit/UIKit.h>
#import "AnimtionUtils.h"


@implementation AnimtionUtils 

+(CATransition * )getAnimation:(NSInteger) hdtag subtag:(NSInteger) subtag{
    
    CATransition * animation=[CATransition animation];
    
    animation.delegate=self;
    animation.duration=0.5;//持续时长
    animation.timingFunction=UIViewAnimationCurveEaseInOut;//计时函数，从头到尾的流畅度
    switch (hdtag) {
        case 1:
            animation.type=kCATransitionFade;
            break;
        case 2:
            animation.type=kCATransitionPush;
            break;
        case 3:
            animation.type=kCATransitionReveal;
            break;
        case 4:
            animation.type=kCATransitionMoveIn;
            break;
        case 5:
            animation.type=@"cube";
            break;
        case 6:
            animation.type=@"suckEffect";
            break;
        case 7:
            animation.type=@"oglFlip";
            break;
        case 8:
            animation.type=@"rippleEffect";
            break;
        case 9:
            animation.type=@"pageCurl";
            break;
        case 10:
            animation.type=@"pageUnCurl";
            break;
        case 11:
            animation.type=@"cameraIrisHollowOpen";
            break;
        case 12:
            animation.type=@"cameraIrisHollowClose";
            break;
            
        default:
            animation.type=kCATransitionPush;
            break;
    }
    switch (subtag) {
        case 0:
            animation.subtype = kCATransitionFromLeft;//左
            break;
        case 1:
            animation.subtype = kCATransitionFromBottom;//下
            break;
        case 2:
            animation.subtype = kCATransitionFromRight;//右
            break;
        case 3:
            animation.subtype = kCATransitionFromTop;//上
            break;
            
        default:
            animation.subtype = kCATransitionFromBottom;//下
            break;
    }
    
    return animation;
}

@end
