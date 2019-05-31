//
//  RaiN_NewServiceTempVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/9/6.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_NewServiceTempVC.h"
#import "RaiN_NewOnlineServiceVC.h"
#import "THMyRepairedListsViewController.h"
#import "ContactServiceVC.h"
#import "OnlineServiceVC.h"
@interface RaiN_NewServiceTempVC ()

@end

@implementation RaiN_NewServiceTempVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"在线报修";
    self.view.backgroundColor = BLACKGROUND_COLOR;
//    _isFormMy = @"0";
}
- (void)viewWillAppear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = NO;
    
}
- (IBAction)buttonClick:(UIButton *)sender {
    
    if (sender.tag == 11) {
        //公共设施
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
//       OnlineServiceVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"OnlineServiceVC"];
//       [self.navigationController pushViewController:pmvc animated:YES];
        RaiN_NewOnlineServiceVC *newOnline = [[RaiN_NewOnlineServiceVC alloc] init];
        newOnline.hidesBottomBarWhenPushed = YES;
        newOnline.fromType = @"0";
        newOnline.isFormMy = _isFormMy;
        [self.navigationController pushViewController:newOnline animated:YES];
    }else if (sender.tag == 12) {
        ///家用设施
        RaiN_NewOnlineServiceVC *newOnline = [[RaiN_NewOnlineServiceVC alloc] init];
        newOnline.hidesBottomBarWhenPushed = YES;
        newOnline.fromType = @"1";
        newOnline.isFormMy = _isFormMy;
        [self.navigationController pushViewController:newOnline animated:YES];
        
    }else if (sender.tag == 13) {
        //报修记录
        
        NSArray*arrController =self.navigationController.viewControllers;
        UIViewController *lastVC = arrController[arrController.count - 2];
        // 返回到倒数第二个控制器
        if ([lastVC isKindOfClass:[THMyRepairedListsViewController class]]) {
            [self.navigationController popToViewController:lastVC animated:YES];
        }else {
            THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
            subVC.isFromRelease = NO;
            subVC.isFromMy = _isFormMy;
            //        if (![XYString isBlankString:_showRepairMsg]) {
            //            NSArray *array = [_showRepairMsg componentsSeparatedByString:@","];
            //            subVC.IdArray = array;
            //        }
            [self.navigationController pushViewController:subVC animated:YES];
        }
        
    }else if (sender.tag == 14) {
        //联系物业
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
        ContactServiceVC * contactsVC = [storyboard instantiateViewControllerWithIdentifier:@"ContactServiceVC"];
        contactsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:contactsVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
