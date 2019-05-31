//
//  THMyTagsViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/17.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THMyTagsViewController.h"
#import "MyTagsTitleTVC.h"
#import "MyTagsButtonsTVC.h"
#import "AddTagsTVC.h"

#import "UserInfoMotifyPresenters.h"

@interface THMyTagsViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *leftImages;
    NSArray *myTitles;
    /**
     *  供选择的标签
     */
    NSMutableArray *forSelectTags;
    /**
     *  已选中的标签
     */
    NSMutableArray *hasSelectedTags;
    /**
     *  是否在未保存是选中过标签
     */
    BOOL isSelected;

}
@property (nonatomic, strong) UITableView *tableView;
/**
 *  登录用户信息
 */
@property (nonatomic, strong) UserData *userData;

@end

@implementation THMyTagsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt markStatistics:GeRenSheZhi];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegt = GetAppDelegates;
    [appDelegt addStatistics:@{@"viewkey":GeRenSheZhi}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"标签";
    [self dealTags];
    isSelected = NO;
    [self createRightBarBtn];
    
    [self createTableView];
    
}
/**
 *  返回按钮
 */
- (void)backButtonClick {
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (isSelected) {
        /**
         *  返回，保存用户最开始的标签
         */
        [UserInfoMotifyPresenters saveUserSelfTagids:_tags UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            
        }];
    }
    
}

/**
 *  处理标签
 */
- (void)dealTags {
    
    @WeakObj(self);
    leftImages = [[NSArray alloc]initWithObjects:@"我的_个人设置_标签_已选定的标签",@"我的_个人设置_标签_点击选择标签", nil];
    myTitles = [[NSArray alloc]initWithObjects:@"已选定标签",@"点击选择标签", nil];
    
    hasSelectedTags = [[NSMutableArray alloc]initWithArray:_tags];

    forSelectTags = [[NSMutableArray alloc]init];
    
    if (hasSelectedTags.count == 0) {
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
                        [hasSelectedTags addObjectsFromArray:(NSArray *)data];
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
     *  获取系统标签列表
     */
    THIndicatorVC * indicator1 = [THIndicatorVC sharedTHIndicatorVC];
    [indicator1 startAnimating:self.tabBarController];
    [UserInfoMotifyPresenters getSystemSelfTagUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        [GCDQueue executeInGlobalQueue:^{
            [GCDQueue executeInMainQueue:^{
                [indicator1 stopAnimating];

                if(resultCode == SucceedCode)
                {
                    if (((NSArray *)data).count > 0) {
                        [forSelectTags addObjectsFromArray:(NSArray *)data];
                        [selfWeak.tableView reloadData];
                    }
                    
                }
                else
                {
//                    [selfWeak showToastMsg:(NSString *)data Duration:2.0];

                }
            }];
        }];

    }];
    
}

- (void)createRightBarBtn {
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(completionClick)];
    [rightBtn setTintColor:kNewRedColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
- (void)completionClick {

    AddTagsTVC *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    [cell.addtagTF resignFirstResponder];
    
//    if (hasSelectedTags.count == 0) {
//        [self showToastMsg:@"您还没有选择标签" Duration:3.0];
//        return;
//    }
    
    /**
     *  完成，保存用户最终选中的标签
     */
    THIndicatorVC * indicator = [THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self];
    
    @WeakObj(self);
    [UserInfoMotifyPresenters saveUserSelfTagids:hasSelectedTags UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            [indicator stopAnimating];
            
            if(resultCode == SucceedCode)
            {
                if (selfWeak.callBack) {
                    selfWeak.callBack();
                }
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                if (hasSelectedTags.count == 0) {
                    if (selfWeak.callBack) {
                        selfWeak.callBack();
                    }
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                }else {
                    [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                }
            }
            
        });

        
    }];
    
}

- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[MyTagsTitleTVC class] forCellReuseIdentifier:NSStringFromClass([MyTagsTitleTVC class])];
    [_tableView registerClass:[MyTagsButtonsTVC class] forCellReuseIdentifier:NSStringFromClass([MyTagsButtonsTVC class])];
    [_tableView registerClass:[AddTagsTVC class] forCellReuseIdentifier:NSStringFromClass([AddTagsTVC class])];

}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return WidthSpace(26.f);
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return WidthSpace(105);
    }
    if (indexPath.row == 1) {

        MyTagsButtonsTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyTagsButtonsTVC class])];
        if (indexPath.section == 0) {
           return [cell configureHeightForCellTagsArray:hasSelectedTags]+20;
        }
        if (indexPath.section == 1) {
            return [cell configureHeightForCellTagsArray:forSelectTags]+20;
        }

    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        return WidthSpace(180);
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @WeakObj(self);

    MyTagsTitleTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyTagsTitleTVC class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.leftImage = [UIImage imageNamed:leftImages[indexPath.section]];
    cell.titleString = myTitles[indexPath.section];
    
    if (indexPath.row == 1) {
        MyTagsButtonsTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyTagsButtonsTVC class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        if (indexPath.section == 0) {
            
            [cell configureCellTagsArray:hasSelectedTags atIndexPath:indexPath isCancelOrNot:YES];
            /**
             *  删除标签
             */
            cell.cancelCallBack = ^(NSInteger selectIndex) {

                AddTagsTVC *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
                [cell.addtagTF resignFirstResponder];
                
                isSelected = YES;

                [hasSelectedTags removeObjectAtIndex:selectIndex];

                [selfWeak.tableView reloadData];
                
            };
        }
        if (indexPath.section == 1) {
            [cell configureCellTagsArray:forSelectTags atIndexPath:indexPath isCancelOrNot:NO];
            /**
             *  选中标签
             */
            cell.selectedCallBack = ^(NSInteger selectIndex) {
                
                AddTagsTVC *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
                [cell.addtagTF resignFirstResponder];
                
                if (hasSelectedTags.count == 6) {
                    [selfWeak showToastMsg:@"最多设置6个标签" Duration:2.0];
                    return ;
                }
                
                /**
                 *  不允许重复选中
                 */
                THTags *tag = [forSelectTags objectAtIndex:selectIndex];
                for (THTags *oneTag in hasSelectedTags) {
                    if ([oneTag.name isEqualToString:tag.name]) {
                        [selfWeak showToastMsg:@"您已选中此标签" Duration:2.0];
                        return ;
                    }
                }
                isSelected = YES;
                [hasSelectedTags addObject:[forSelectTags objectAtIndex:selectIndex]];
                [selfWeak.tableView reloadData];
            };
            
        }
        
        return cell;
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        AddTagsTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AddTagsTVC class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        /**
         *  添加标签
         */
        @WeakObj(cell);
        cell.addTagsCallBack = ^(){
          
            [cellWeak.addtagTF resignFirstResponder];
            
            if (hasSelectedTags.count == 6) {
                [selfWeak showToastMsg:@"最多设置6个标签" Duration:2.0];
                return ;
            }
            
            if ([XYString isBlankString:cellWeak.addtagTF.text]) {
                return ;
            }
            /**
             *  判断是否重复，若重复则不处理
             */
            for (THTags *oneTag in hasSelectedTags) {
                if ([oneTag.name isEqualToString:cellWeak.addtagTF.text]) {
                    [selfWeak showToastMsg:@"您已添加此标签" Duration:2.0];
                    return;
                }
            }
            
            if (cellWeak.addtagTF.text.length > 6) {
                [selfWeak showToastMsg:@"标签要在6字以内哦" Duration:2.0];
                return;
            }
            
            /**
             *  添加用户自定义标签
             */
            THIndicatorVC * indicator = [THIndicatorVC sharedTHIndicatorVC];
            [indicator startAnimating:self.tabBarController];
            [UserInfoMotifyPresenters addSelfTagName:cellWeak.addtagTF.text UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                [GCDQueue executeInGlobalQueue:^{
                    [GCDQueue executeInMainQueue:^{
                        cellWeak.addtagTF.text = @"";

                        [indicator stopAnimating];
                        
                        if(resultCode == SucceedCode)
                        {
                            isSelected = YES;
                            [hasSelectedTags addObject:(THTags *)data];
                            [selfWeak.tableView reloadData];
                        }
                        else
                        {
                            [selfWeak showToastMsg:@"添加失败" Duration:2.0];
                        }
                        
                    }];
                }];
                
            }];
            
        };
        
        return cell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;
    if (indexPath.section == 1 && indexPath.row == 2) {
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
