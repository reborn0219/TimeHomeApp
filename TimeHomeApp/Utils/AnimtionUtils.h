//
//  HDAnimtionUtils.h

//
/**
 过场动画类
 **/

#import <Foundation/Foundation.h>
#import <QuartzCore/CAAnimation.h>

@interface AnimtionUtils : NSObject

+(CATransition * )getAnimation:(NSInteger) hdtag subtag:(NSInteger) subtag;

@end
