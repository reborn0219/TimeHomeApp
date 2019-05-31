//
//  UIControl+ClickHook.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/29.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UIControl+ClickHook.h"

@implementation UIControl (ClickHook)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class selfClass = [self class];
        
        SEL oriSEL = @selector(sendAction:to:forEvent:);
        Method oriMethod = class_getInstanceMethod(selfClass, oriSEL);
        
        SEL cusSEL = @selector(mySendAction:to:forEvent:);
        Method cusMethod = class_getInstanceMethod(selfClass, cusSEL);
        
        BOOL addSucc = class_addMethod(selfClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
        if (addSucc) {
            class_replaceMethod(selfClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        }else {
            method_exchangeImplementations(oriMethod, cusMethod);
        }
        
    });
}

- (void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    UIControl *button = target;
    
    NSString *sourceId = self.sourceId;
   
    AppDelegate * delegate = GetAppDelegates;
    
    BOOL isContinue = [[PAAuthorityManager sharedPAAuthorityManager]verifyAuthorityWithCommunityId:delegate.userData.communityid sourceId:sourceId];
    
    if (NO == isContinue) {
        return;
    }
    
    [self mySendAction:action to:target forEvent:event];
}

@end
