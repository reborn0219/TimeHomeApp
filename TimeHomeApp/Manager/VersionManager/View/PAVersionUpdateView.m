//
//  PAVersionUpdateView.m
//  TimeHomeApp
//
//  Created by Evagrius on 2018/5/11.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAVersionUpdateView.h"

@interface PAVersionUpdateView ()

@property (nonatomic, strong)UIAlertController * alertController;
@property (nonatomic, strong)PAVersionModel *versionModel;
@end

@implementation PAVersionUpdateView

/**
 强制更新

 @param versionModel 传入的versionModel
 @param shouldUpdate 是否更新Block
 */
- (void)showForcedUpdate:(PAVersionModel *)versionModel shouldUpdate:(UpDateViewsBlock)shouldUpdate{
    
    self.versionModel = versionModel;
    UIAlertAction * update = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        shouldUpdate(nil,SucceedCode);
    }];
    [self.alertController addAction:update];
    [self showInWindow];
}

/**
 普通更新
 
 @param versionModel 传入的versionModel
 @param shouldUpdate 是否更新Block
 */
- (void)showGeneralUpdate:(PAVersionModel *)versionModel shouldUpdate:(UpDateViewsBlock)shouldUpdate{
    self.versionModel = versionModel;
    UIAlertAction * update = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        shouldUpdate(nil,SucceedCode);
    }];
    
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [self.alertController addAction:update];
    [self.alertController addAction:cancel];
    [self showInWindow];
}

- (void)showInWindow{
    AppDelegate * delegate = GetAppDelegates;
    UIViewController * controller =  [delegate getCurrentViewController];
    [controller presentViewController:self.alertController animated:YES completion:^{
    }];
}

#pragma mark init
- (UIAlertController *)alertController{
    if (!_alertController) {
        _alertController = [UIAlertController alertControllerWithTitle:@"Update Notes" message:self.versionModel.information[0] preferredStyle:UIAlertControllerStyleAlert];
    }
    return _alertController;
}
@end
