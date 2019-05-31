//
//  UICollectionView+DelegateHook.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/29.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UICollectionView+DelegateHook.h"
#import "PAAuthorityManager.h"

@implementation UICollectionView (DelegateHook)

+ (void)load {
    //交换实现
    method_exchangeImplementations(class_getInstanceMethod(self, @selector(setDelegate:)), class_getInstanceMethod(self, @selector(tracking_setDelegate:)));
}

- (void)tracking_setDelegate:(id<UICollectionViewDelegate>)delegate {
    
    [self tracking_setDelegate:delegate];
    
    Class class = [delegate class];
    if (class_addMethod([delegate class], NSSelectorFromString(@"tracking_didSelectItemAtIndexPath"), (IMP)tracking_didSelectItemAtIndexPath, "v@:@@")) {
        
        Method dis_originalMethod = class_getInstanceMethod(class, NSSelectorFromString(@"tracking_didSelectItemAtIndexPath"));
        Method dis_swizzledMethod = class_getInstanceMethod(class, @selector(collectionView:didSelectItemAtIndexPath:));
        //交换实现
        method_exchangeImplementations(dis_originalMethod, dis_swizzledMethod);
    }
}

void tracking_didSelectItemAtIndexPath(id self, SEL _cmd, id collectionView, id indexpath) {
    
    NSLog(@"权限控制####CollectionView%@ select:第%ld栏第%ld行 ",NSStringFromClass([self class]),((NSIndexPath *)indexpath).section,((NSIndexPath *)indexpath).row);
    
    if ([collectionView isKindOfClass:[UICollectionView class]]) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexpath];
        
        AppDelegate * delegate = GetAppDelegates;
        
        BOOL isContinue = [[PAAuthorityManager sharedPAAuthorityManager]verifyAuthorityWithCommunityId:delegate.userData.communityid sourceId:cell.sourceId];
        
        if (NO == isContinue) {
            return;
        }
    }
    
    SEL selector = NSSelectorFromString(@"tracking_didSelectItemAtIndexPath");
    ((void(*)(id, SEL,id, id))objc_msgSend)(self, selector, collectionView, indexpath);
    
}
@end
