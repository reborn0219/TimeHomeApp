//
//  UITableView+DelegateHook.m
//  TimeHomeApp
//
//  Created by WangKeke on 2018/3/29.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "UITableView+DelegateHook.h"

@implementation UITableView (DelegateHook)
+(void)load{
    // hook UIWebView
    Method originalMethod = class_getInstanceMethod([UITableView class], @selector(setDelegate:));
    Method swizzledMethod = class_getInstanceMethod([UITableView class], @selector(hook_setDelegate:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}
- (void)hook_setDelegate:(id<UITableViewDelegate>)delegate{
    [self hook_setDelegate:delegate];
    
    // 拿到 delegate 对象，在这里做替换 delegate 方法的操作
    
    // 获得 delegate 的实际调用类
    // 传递给 UIWebView 来交换方法
    [self exchangeUITableViewDelegateMethod:delegate];
    
}

-(void)exchangeUITableViewDelegateMethod:(id)delegeta{
    exchangeMethod([delegeta class], @selector(tableView:didSelectRowAtIndexPath:), [self class], @selector(my_tableView:didSelectRowAtIndexPath:), @selector(oriReplacetableView:didSelectRowAtIndexPath:));
}

static void exchangeMethod(Class originalClass, SEL originalSel, Class replacedClass, SEL replacedSel, SEL orginReplaceSel){
    // 原方法
    Method originalMethod = class_getInstanceMethod(originalClass, originalSel);
    // 替换方法
    Method replacedMethod = class_getInstanceMethod(replacedClass, replacedSel);
    // 如果没有实现 delegate 方法，则手动动态添加
    if (!originalMethod) {
        Method orginReplaceMethod = class_getInstanceMethod(replacedClass, orginReplaceSel);
        BOOL didAddOriginMethod = class_addMethod(originalClass, originalSel, method_getImplementation(orginReplaceMethod), method_getTypeEncoding(orginReplaceMethod));
        if (didAddOriginMethod) {
            NSLog(@"did Add Origin Replace Method");
        }
        return;
    }
    // 向实现 delegate 的类中添加新的方法
    // 这里是向 originalClass 的 replaceSel（@selector(replace_webViewDidFinishLoad:)） 添加 replaceMethod
    BOOL didAddMethod = class_addMethod(originalClass, replacedSel, method_getImplementation(replacedMethod), method_getTypeEncoding(replacedMethod));
    if (didAddMethod) {
        // 添加成功
        NSLog(@"class_addMethod_success --> (%@)", NSStringFromSelector(replacedSel));
        // 重新拿到添加被添加的 method,这里是关键(注意这里 originalClass, 不 replacedClass), 因为替换的方法已经添加到原类中了, 应该交换原类中的两个方法
        Method newMethod = class_getInstanceMethod(originalClass, replacedSel);
        // 实现交换
        method_exchangeImplementations(originalMethod, newMethod);
    }else{
        // 添加失败，则说明已经 hook 过该类的 delegate 方法，防止多次交换。
        NSLog(@"Already hook class --> (%@)",NSStringFromClass(originalClass));
    }
}

#pragma mark - hook tableView delegate methods

//替换原delegate的实现方法
- (void)my_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];    
    
    AppDelegate * delegate = GetAppDelegates;
    
    BOOL isContinue = [[PAAuthorityManager sharedPAAuthorityManager]verifyAuthorityWithCommunityId:delegate.userData.communityid sourceId:cell.sourceId];
    
    if (NO == isContinue) {
        return;
    }

    //这里做权限处理
    NSLog(@"权限控制####TableView%@ select:第%ld栏第%ld行 ",NSStringFromClass([self class]),((NSIndexPath *)indexPath).section,((NSIndexPath *)indexPath).row);
    [self my_tableView:tableView didSelectRowAtIndexPath:indexPath];
}

//如果代理未实现，为其增加处理方法
- (void)oriReplacetableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
