//
//  THMySettingsVC.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMySettingsVC.h"
#import "THBaseTableViewCell.h"
#import "THNickNameVC.h"
#import "THMySignsViewController.h"
#import "THDoorNumberViewController.h"
#import "THMyRealNameViewController.h"
#import "THMyTagsViewController.h"
#import "THPicUploadViewController.h"

#import "ZGPicWallViewController.h"

#import "MMDateView.h"
#import "MMPopupWindow.h"

#import "MMPickerView.h"

#import "THMyInfoPresenter.h"
#import "UserInfoMotifyPresenters.h"

#import "ZSY_AddressSuperviseVC.h"
#import "ZSY_CertificationVC.h"
#import "ZSY_BindingVC.h"
#import "NewTHBaseTableViewCell.h"
@interface THMySettingsVC () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titles;
    NSMutableArray *detailTitles;
    /**
     *  我的数据
     */
    PAUserData *userData;
    /**
     *  标签数组
     */
    NSMutableArray *tagsArray;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THMySettingsVC

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"gerenshezhi"];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":GeRenSheZhi}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    self.tabBarController.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    
    [self setUpArrays];
//    [TalkingData trackPageBegin:@"gerenshezhi"];
    [_tableView reloadData];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:GeRenSheZhi];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isChangeAge = 0;
    self.navigationItem.title = @"个人设置";
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationController.navigationBar.barTintColor = NABAR_COLOR;
    
    [self createTableView];
    [self tagHttpRequest];
    
    //----------提示框的默认按钮设置---------------------
     [[MMPopupWindow sharedWindow] cacheWindow];
     [MMPopupWindow sharedWindow].touchWildToHide = YES;
}
/**
 *  用户标签数组请求
 */
- (void)tagHttpRequest {
    @WeakObj(self);
    tagsArray = [[NSMutableArray alloc]init];
    /**
     *  获取用户标签列表
     */
    THIndicatorVC * indicator = [THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [UserInfoMotifyPresenters getUserSelfTagUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                if (((NSArray *)data).count > 0) {
                    [tagsArray removeAllObjects];
                    [tagsArray addObjectsFromArray:(NSArray *)data];
                    [selfWeak.tableView reloadData];
                }
            }
            else
            {
                AppDelegate *appDelegate = GetAppDelegates;
                appDelegate.userData.selftag = @"";
                [appDelegate saveContext];
                [selfWeak.tableView reloadData];
            }
        });

    }];
    
}

/**
 *  设置数组
 */
- (void)setUpArrays {
    
    AppDelegate *appDelegate = GetAppDelegates;
    userData = appDelegate.userData;
    
    titles = [[NSArray alloc]initWithObjects:@"头        像",@"昵        称",@"个性签名",@"门  牌  号",@"真实姓名",@"性        别",@"生        日",@"标        签",@"绑        定", nil];//@"我的地址" ,@"实名认证"
    NSString *name = @"";
    name = [XYString IsNotNull:userData.name];

    NSString *sexString = @"";
    if ([userData.sex intValue] == 1) {
        sexString = @"男";
    }else if ([userData.sex intValue] == 2) {
        sexString = @"女";
    }
    NSString *signature = @"我在平安社区，你在哪？";
    if (![XYString isBlankString:userData.signature]) {
        signature = userData.signature;
    }
    
    NSString *buidling = @"";
    buidling = [XYString IsNotNull:userData.building];
    
    NSArray *array = [[NSArray alloc]initWithObjects:@"",userData.nickname,signature,buidling,name,sexString,userData.birthday,@"",@"",nil];//@"",@""
    detailTitles = [[NSMutableArray alloc]init];
    [detailTitles addObjectsFromArray:array];

}

- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height) - 8) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
   
    
    [_tableView registerClass:[THBaseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([THBaseTableViewCell class])];
    [_tableView registerClass:[THBaseTableViewCell class] forCellReuseIdentifier:@"RaiN_cellID"];
    
//    [_tableView registerNib:[UINib nibWithNibName:@"NewTHBaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"newCell"];
    
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.0001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
   return titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    THBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THBaseTableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.baseTableViewCellStyle = BaseTableViewCellStyleDefault;
    
    [cell configureIndexpath:indexPath headImageUrl:userData.userpic headImage:nil];
    cell.leftLabel.text = titles[indexPath.row];
    cell.rightLabel.text = detailTitles[indexPath.row];
    
    if (indexPath.row == 5) {
        cell.arrowImage.hidden = YES;
    }
    
    if (indexPath.row == 7) {
        
        if ([XYString isBlankString:userData.selftag]) {
            cell.rightLabel.text = @"设置自己的专属标签会更加引人注目哦";
            
        }else {
            cell.rightLabel.text = userData.selftag;
        }
    }
    
    if(indexPath.row == 8){
        
        THBaseTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"RaiN_cellID"];
        cell2.leftLabel.text = titles[indexPath.row];
        cell2.rightLabel.text = detailTitles[indexPath.row];
        cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        cell2.baseTableViewCellStyle = BaseTableViewCellStyleDefault;
        return cell2;
        
    }

    //        else if (indexPath.row == 8) {
    //            NewTHBaseTableViewCell *newCell = [tableView dequeueReusableCellWithIdentifier:@"newCell"];
    //            newCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //            newCell.leftLabel.text = [NSString stringWithFormat:@"%@",titles[indexPath.row]];
    //
    //            if ([userData.isvaverified isEqualToString:@"1"]) {
    //                newCell.showImage.image = [UIImage imageNamed:@"个人设置-个人设置-已实名认证"];
    //                newCell.rightLabel.textColor = kNewRedColor;
    //            }else if ([userData.isvaverified isEqualToString:@"0"]) {
    //                newCell.showImage.image = [UIImage imageNamed:@"个人设置-个人设置-未实名认证"];
    //                newCell.rightLabel.textColor = TEXT_COLOR;
    //            }
    //            return newCell;
    //        }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        @WeakObj(self);
        switch (indexPath.row) {
            case 0:
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ZGPicWallViewController *picUploadVC = [[ZGPicWallViewController alloc]init];
                    picUploadVC.callBack = ^(){
                        
                        /**
                         获得登陆用户的个人信息
                         */
                        
                        AppDelegate *appDelegate = GetAppDelegates;
                        userData = appDelegate.userData;
                        [_tableView reloadData];
                        
                        
                        ////edit by ls  2016-4-27 修改个人头像昵称后发送通知给邻圈界面
                        NSLog(@"%@",userData.nickname);
                        NSLog(@"%@",userData.userpic);
                        
                        NSDictionary * picUrl = @{userData.userID:userData.userpic};
                        
                        [[NSUserDefaults standardUserDefaults]setObject:picUrl forKey:@"headPicUrl"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"headPicUrl" object:@"123"];
                        
                       
                        
                    };
                    [selfWeak.navigationController pushViewController:picUploadVC animated:YES];
                    
                });
                
            }
                break;
            case 1:
            {
                THNickNameVC *nickVC = [[THNickNameVC alloc]init];
                [self.navigationController pushViewController:nickVC animated:YES];
            }
                break;
            case 2:
            {
                THMySignsViewController *signVC = [[THMySignsViewController alloc]init];
                [self.navigationController pushViewController:signVC animated:YES];
            }
                break;
            case 3:
            {
                THDoorNumberViewController *doorNumberVC = [[THDoorNumberViewController alloc]init];
                [self.navigationController pushViewController:doorNumberVC animated:YES];
            }
                break;
            case 4:
            {
                THMyRealNameViewController *myRealNameVC = [[THMyRealNameViewController alloc]init];
                [self.navigationController pushViewController:myRealNameVC animated:YES];
            }
                break;
            case 6:
            {
                MMDateView *dateView = [MMDateView shareDateAlert];
                dateView.titleLabel.text=@"生日";
                if (![XYString isBlankString:userData.birthday]) {
                    dateView.datePicker.date = [XYString NSStringToDate:userData.birthday withFormat:@"yyyy-MM-dd"];
                }
                dateView.datePicker.maximumDate = [NSDate date];
                [dateView show];
                
                dateView.confirm = ^(NSString *dataString) {
                    
                    NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",dataString] withFormat:@"yyyy/MM/dd"];
                    NSString *birth = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
                    
                    THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
                    [indicator startAnimating:selfWeak];
                    @WeakObj(indicator);
                    /**
                     *  保存生日
                     */
                    [THMyInfoPresenter perfectMyUserInfoDict:@{@"birthday":birth} UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [indicatorWeak stopAnimating];
                            if(resultCode == SucceedCode)
                            {
                                selfWeak.isChangeAge = 1;

                                [detailTitles replaceObjectAtIndex:6 withObject:dataString];
                                [selfWeak.tableView reloadData];
                            }
                            else
                            {
                                [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                            }
                            
                        });
                        
                    }];
                    
                };
            }
                break;
            case 7:
            {
                THMyTagsViewController *myTagsVC = [[THMyTagsViewController alloc]init];
                myTagsVC.tags = tagsArray;
                myTagsVC.callBack = ^(){
                    [selfWeak tagHttpRequest];
                };
                [self.navigationController pushViewController:myTagsVC animated:YES];
            }
                break;
//            case 8:
//            {
//                //地址
//                ZSY_AddressSuperviseVC *address = [[ZSY_AddressSuperviseVC alloc] init];
//                [self.navigationController pushViewController:address animated:YES];
//            }
//                break;
//            case 8:
//            {//实名认证
//                
//                ZSY_CertificationVC *certification = [[ZSY_CertificationVC alloc] init];
//                [self.navigationController pushViewController:certification animated:YES];
//                
//            }
//                break;
            case 8:
            {
                ///绑定
                ZSY_BindingVC *bingd = [[ZSY_BindingVC alloc] init];
                [self.navigationController pushViewController:bingd animated:YES];
//                ZSY_CertificationVC *certification = [[ZSY_CertificationVC alloc] init];
//                [self.navigationController pushViewController:certification animated:YES];
                
            }
                break;
            default:
                break;
        }

    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;
    if (indexPath.row == 10) {
        width = SCREEN_WIDTH/2-7;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, width, 0, width)];
    }
    
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, width, 0, width)];
    }
}



@end
