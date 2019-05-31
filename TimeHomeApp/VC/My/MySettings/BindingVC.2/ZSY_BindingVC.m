//
//  ZSY_BindingVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2016/10/19.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "ZSY_BindingVC.h"
#import "ZSY_BindingCell.h"
#import <ShareSDK/ShareSDK.h>
/**
 模型
 */
#import "GetMyBinding.h"
/**
 接口
 */
#import "MySettingAndOtherLogin.h"

@interface ZSY_BindingVC ()<UITableViewDelegate,UITableViewDataSource>
{
    BOOL getNetisFailure; //判断网络获取成功
    
}
/**
 列表
 */
@property (nonatomic,strong)UITableView *tableView;
/**
 列表数据源
 */
@property (nonatomic,strong)NSMutableArray *dataSource;
/**
 请求失败时的假数据
 */
@property (nonatomic,strong)NSMutableArray *data;
/**
 开关状态
 */
@property (nonatomic,assign)BOOL isON;
/**
 记录row
 */
@property (nonatomic,assign)NSInteger indexPath;
/**
 警示弹框
 */
@property (nonatomic,strong)UIAlertController *alertController;
@property (nonatomic, copy) NSMutableArray *arr_one;

@end

@implementation ZSY_BindingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationItem.title = @"绑定";
    _arr_one = [[NSMutableArray alloc]initWithCapacity:3];
    
    [self createDataSource];
    [self createTableView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
#pragma mark -- createTableView And dataSource
- (void)createTableView {
    if (SCREEN_HEIGHT >= 812) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, (SCREEN_HEIGHT - 8)) style:UITableViewStylePlain];
    }else {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, (SCREEN_HEIGHT-8)) style:UITableViewStylePlain];
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = YES;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerNib:[UINib nibWithNibName:@"ZSY_BindingCell" bundle:nil] forCellReuseIdentifier:@"ZSY_BindingCell"];
}

#pragma  mark ---- 网络获取数据
- (void)createDataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    [_data addObjectsFromArray:@[@"绑定QQ",@"绑定微信",@"绑定微博"]];//@"绑定QQ",@"绑定微信",@"绑定微博"
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
    [MySettingAndOtherLogin getMyOtherBindingWithUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        @WeakObj(self)
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            
            if (resultCode == SucceedCode) {
                NSDictionary *dict = (NSDictionary *)data;
                [_dataSource removeAllObjects];
                
                
                NSArray * arr= [dict objectForKey:@"list"];
                
                
                //微信微博QQ 2 3 1
                [_arr_one removeAllObjects];
                [_arr_one addObjectsFromArray:arr];
                
                ///排序type==3放到最前面
                for (int i= 0; i<_arr_one.count; i++) {

                    NSDictionary * dic_index = [_arr_one objectAtIndex:i];
                    NSString * type_ls = [dic_index objectForKey:@"type"];
                    if (type_ls.integerValue==3) {
                        
                        NSDictionary * first_dic = [_arr_one firstObject];
                        [_arr_one replaceObjectAtIndex:0 withObject:dic_index];
                        [_arr_one replaceObjectAtIndex:i withObject:first_dic];
                        
                    }
                }
                ///排序取出type==2插入到数组第一个
                for (int i= 0; i<_arr_one.count; i++) {
                    
                    NSDictionary * dic_index = [_arr_one objectAtIndex:i];
                    NSString * type_ls = [dic_index objectForKey:@"type"];
                    if (type_ls.integerValue==2) {
                        
                        NSDictionary * type_two_dic = [_arr_one objectAtIndex:i];
                        
                        [_arr_one removeObjectAtIndex:i];
                        
                        [_arr_one insertObject:type_two_dic atIndex:0];
                    }
                }

                NSArray *array = [GetMyBinding mj_objectArrayWithKeyValuesArray:_arr_one];
                
                
                [_dataSource addObjectsFromArray:array];
                
//                /**
//                 取出微信的model
//                 */
//                for (int i = 0; i < array.count; i++) {
//                    GetMyBinding *model = array[i];
//                    if ([model.type isEqualToString:@"2"]) {
//                        NSLog(@"%@,%@,%@",model.type,model.account,model.isbinding);
//                        [_dataSource addObject:model];
//                    }
//                }
                NSLog(@"%@",_dataSource);
                [selfWeak.tableView reloadData];
            }else {
                
                [selfWeak showToastMsg:@"获得绑定列表失败" Duration:3.0];
                getNetisFailure = YES;
            }
            
        });
    }];
}
#pragma mark -- UITableViewDelegate,UITableViewDataSource   列表代理
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.00001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.000001;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZSY_BindingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZSY_BindingCell"];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.bindingSwitch.onTintColor = kNewRedColor;
    cell.centerLabel.hidden = YES;
    [cell.bindingSwitch addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    cell.bindingSwitch.tag = indexPath.row + 1;

    cell.leftLabel.text = _data[indexPath.row];
    if (indexPath.row == _data.count - 1) {
        cell.lineView.hidden = YES;
    }else {
        cell.lineView.hidden = NO;
    }
    if (_dataSource.count > 2) {
        GetMyBinding *model = _dataSource[indexPath.row];
        if ([model.type isEqualToString:@"1"]) {
            cell.leftLabel.text = @"绑定QQ";
        }else if ([model.type isEqualToString:@"2"]) {
            cell.leftLabel.text = @"绑定微信";
        }else if ([model.type isEqualToString:@"3"]) {
            cell.leftLabel.text = @"绑定微博";
        }
        /**
         1是绑定
         0是未绑定
         */
        cell.centerLabel.hidden = NO;
        if ([model.isbinding isEqualToString:@"1"]) {
            cell.bindingSwitch.on = YES;
            
            cell.centerLabel.text = [NSString stringWithFormat:@"(%@)",model.account];
        }else if ([model.isbinding isEqualToString:@"0"]) {
            cell.bindingSwitch.on = NO;
            cell.centerLabel.text = @"";
        }

    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark -- switchValueChange
- (void)switchValueChange:(UISwitch *)cellSwitch {
    if (getNetisFailure == YES) {
        [self showToastMsg:@"网络请求失败,请重试" Duration:3.0f];
        cellSwitch.on = NO;
        return;
    }
    AppDelegate *appledelegate = GetAppDelegates;
    GetMyBinding *model = _dataSource[cellSwitch.tag - 1];
    switch ([model.type integerValue]) {
        case 1:
        {
            /**
             绑定QQ
             */
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:cellSwitch.tag - 1 inSection:0];
//            ZSY_BindingCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            if (cellSwitch.on == YES) {
                
                @WeakObj(self)
                [ShareSDK cancelAuthorize:SSDKPlatformTypeQQ];
                [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                [ShareSDK getUserInfo : SSDKPlatformTypeQQ onStateChanged :^( SSDKResponseState state, SSDKUser *user, NSError *error) {
                    
                    [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                    if (state == SSDKResponseStateSuccess ) {
                        /**
                         授权成功请求绑定接口
                         */
                        NSString *TokenStr = [XYString IsNotNull:user.credential.token];
                        NSString *IDStr = [XYString IsNotNull:user.uid];
                        NSString *nameStr = [XYString IsNotNull:user.nickname];
                        
                        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                        [MySettingAndOtherLogin addOtherBindingWithType:@"1" AndThifdToken:TokenStr AndPhone:appledelegate.userData.phone AndPassword:@"" andThirdid:IDStr andAccount:nameStr  AndVerificode:@"" AndUnionID:@"" AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                            /**
                             请求成功
                             */
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                                if (resultCode == SucceedCode) {
                                    
                                    [selfWeak showToastMsg:@"QQ绑定成功" Duration:3.0];
//
                                    model.account = user.nickname;
                                    model.isbinding = @"1";
                                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                    
                                }else {
                                    /**
                                     请求失败
                                     */
                                    model.account = @"";
                                    model.isbinding = @"0";
                                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                    [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                                }
                            });
                        }];
                        
                        NSLog ( @"uid=%@" ,user. uid );
                        NSLog ( @"%@" ,user. credential );
                        NSLog ( @"token=%@" ,user. credential . token );
                        NSLog ( @"nickname=%@" ,user. nickname );
                        
                    }else {
                        /**
                         授权失败
                         */
                        model.account = @"";
                        model.isbinding = @"0";
                        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                        
                        if(state == SSDKResponseStateCancel){
                            [selfWeak showToastMsg:@"取消授权" Duration:3.0];
                        } else if (state == SSDKResponseStateFail) {
                            [selfWeak showToastMsg:@"授权失败" Duration:3.0];
                        }

                    }
                }];
            }else {
                //解绑
                    _alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您确定要解除QQ(第三方)的账号绑定吗?" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        cellSwitch.on = YES;
                        [_alertController dismissViewControllerAnimated:YES completion:nil];
                    }];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        
                        /**
                         删除第三方登录
                         */
                        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                        [MySettingAndOtherLogin deleteThirdLoginWithThirdToken:model.thirdtoken AndType:@"1" andThirdid:model.thirdid andAccount:model.account AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                            @WeakObj(self)
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                                if (resultCode == SucceedCode) {
                                    /**
                                     解绑成功
                                     */
                                    model.account = @"";
                                    model.isbinding = @"0";
                                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                    [selfWeak showToastMsg:@"解绑成功" Duration:3.0];
                                    
                                }else {
                                    
                                    model.isbinding = @"1";
                                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                    [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                                }
                            });
                        }];
                    }];
                    [_alertController addAction:cancelAction];
                    [_alertController addAction:okAction];
                    [self presentViewController:_alertController animated:YES completion:nil];
            }
        }
            break;
        case 2:
        {
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:cellSwitch.tag - 1 inSection:0];
            @WeakObj(self)
            APPWXPAYMANAGER.callBack = ^(enum WXErrCode errCode){
                NSLog(@"%d",errCode);
                if (errCode == -2) {
                    [selfWeak showToastMsg:@"取消授权" Duration:3.0f];
                    /**
                     取消授权
                     */
                    model.account = @"";
                    model.isbinding = @"0";
                    
                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

                    
                }
                if (errCode == -4) {
                    [selfWeak showToastMsg:@"授权失败" Duration:3.0f];
                    /**
                     授权失败
                     */
                    model.account = @"";
                    model.isbinding = @"0";
            
                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                }
                //
            };
            NSLog(@"微信-------%@",cellSwitch.on?@"YES":@"NO");
            
            if (cellSwitch.on == YES) {
                ///开关为关,拉取授权进行绑定
                
                [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
                [ShareSDK getUserInfo : SSDKPlatformTypeWechat onStateChanged :^( SSDKResponseState state, SSDKUser *user, NSError *error) {
                    
                    if (state == SSDKResponseStateSuccess ) {
                        /**
                         授权成功
                         */
                        NSString *TokenStr = [XYString IsNotNull:user.credential.token];
                        NSString *IDStr = [XYString IsNotNull:user.uid];
                        NSString *nameStr = [XYString IsNotNull:user.nickname];
                        NSLog ( @"uid=%@" ,user. uid );
                        NSLog ( @"%@" ,user. credential );
                        NSLog ( @"token=%@" ,user. credential.token );
                        NSLog ( @"nickname=%@" ,user. nickname );
                        NSLog ( @"unionid=%@" , [user.rawData objectForKey:@"unionid"]);
                        NSString * unionid = [user.rawData objectForKey:@"unionid"];
                        
                        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                        [MySettingAndOtherLogin addOtherBindingWithType:@"2" AndThifdToken:TokenStr AndPhone:appledelegate.userData.phone AndPassword:@"" andThirdid:IDStr andAccount:nameStr AndVerificode:@"" AndUnionID:unionid AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                            @WeakObj(self)
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                                if (resultCode == SucceedCode) {
                                    /**
                                     请求成功
                                     */
                                    [selfWeak showToastMsg:@"绑定成功" Duration:3.0];
                                    model.account = user.nickname;
                                    model.isbinding = @"1";
                                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                    
                                }else {
                                    
                                    /**
                                     请求失败
                                     */
                                    model.account = @"";
                                    model.isbinding = @"0";
                                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                    [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                                }
                            });
                        }];

                    }else {
                        /**
                         授权失败
                         */
                        model.account = @"";
                        model.isbinding = @"0";
                        [_tableView reloadData];
//                        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                        
                        if(state == SSDKResponseStateCancel){
                            [selfWeak showToastMsg:@"取消授权" Duration:3.0];
                        } else if (state == SSDKResponseStateFail) {
                            [selfWeak showToastMsg:@"授权失败" Duration:3.0];
                        }

                    }
                }];
            }else {
                //解绑
                _alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您确定要解除微信(第三方)的账号绑定吗?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    cellSwitch.on = YES;
                    [_alertController dismissViewControllerAnimated:YES completion:nil];
                }];
                
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    /**
                     删除绑定
                     */
                    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                    @WeakObj(self)
                    [MySettingAndOtherLogin deleteThirdLoginWithThirdToken:model.thirdtoken AndType:@"2" andThirdid:model.thirdid andAccount:model.account AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                            
                            if (resultCode == SucceedCode) {
                                /**
                                 解绑成功
                                 */
                                model.account = @"";
                                model.isbinding = @"0";
                                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                [selfWeak showToastMsg:@"解绑成功" Duration:3.0];
                                
                            }else {
                                
                                model.isbinding = @"1";
                                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                            }
                        });
                    }];
                }];
                
                [_alertController addAction:cancelAction];
                [_alertController addAction:okAction];
                [self presentViewController:_alertController animated:YES completion:nil];
                
            }
        }
            break;
        case 3:
        {
            NSLog(@"微博-------%@",cellSwitch.on?@"YES":@"NO");
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:cellSwitch.tag - 1 inSection:0];
//            ZSY_BindingCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
            
            if (cellSwitch.on == YES) {
                ///开关为关,拉取授权进行绑定
                @WeakObj(self)
                [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];
                [ShareSDK getUserInfo : SSDKPlatformTypeSinaWeibo onStateChanged :^( SSDKResponseState state, SSDKUser *user, NSError *error) {
                    
                    [ShareSDK cancelAuthorize:SSDKPlatformTypeSinaWeibo];


                    if (state == SSDKResponseStateSuccess ) {
                        /**
                         授权成功
                         */
                        NSString *TokenStr = [XYString IsNotNull:user.credential.token];
                        NSString *IDStr = [XYString IsNotNull:user.uid];
                        NSString *nameStr = [XYString IsNotNull:user.nickname];
                        
                        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                        [MySettingAndOtherLogin addOtherBindingWithType:@"3" AndThifdToken:TokenStr AndPhone:appledelegate.userData.phone AndPassword:@"" andThirdid:IDStr andAccount:nameStr AndVerificode:@"" AndUnionID:@"" AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                            @WeakObj(self)
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                                
                                if  (resultCode == SucceedCode) {
                                    /**
                                     请求成功
                                     */
                                    [selfWeak showToastMsg:@"绑定成功" Duration:3.0];
                                    model.account = user.nickname;
                                    model.isbinding = @"1";
                                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                }else {
                                    /**
                                     请求失败
                                     */
                                    model.account = @"";
                                    model.isbinding = @"0";
                                    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                    [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                                }
                            });
                        }];
                        NSLog ( @"uid=%@" ,user. uid );
                        NSLog ( @"%@" ,user. credential );
                        NSLog ( @"token=%@" ,user. credential . token );
                        NSLog ( @"nickname=%@" ,user. nickname );
                    }else {
                        /**
                         授权失败
                         */
                        model.account = @"";
                        model.isbinding = @"0";
                        [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                        
                        if(state == SSDKResponseStateCancel){
                            
                            [selfWeak showToastMsg:@"取消授权" Duration:3.0];
                        } else if (state == SSDKResponseStateFail)
                        {
                            [selfWeak showToastMsg:@"授权失败" Duration:3.0];
                        }

                    }
                }];
            }else {
                //解绑
                _alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您确定要解除微博(第三方)的账号绑定吗?" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    cellSwitch.on = YES;
                    [_alertController dismissViewControllerAnimated:YES completion:nil];
                    cellSwitch.on = YES;
                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    
                    /**
                     删除第三方登录
                     */
                    @WeakObj(self)
                    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self.tabBarController];
                    [MySettingAndOtherLogin deleteThirdLoginWithThirdToken:model.thirdtoken AndType:@"3" andThirdid:model.thirdid andAccount:model.account AndUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                            
                            if (resultCode == SucceedCode) {
                                
                                /**
                                 解绑成功
                                 */
                                model.account = @"";
                                model.isbinding = @"0";
                                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                [selfWeak showToastMsg:@"解绑成功" Duration:3.0];
                                
                            }else {
                                
                                model.isbinding = @"1";
                                [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                                [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                            }
                        });
                    }];
                }];
                
                [_alertController addAction:cancelAction];
                [_alertController addAction:okAction];
                [self presentViewController:_alertController animated:YES completion:nil];
            }
        }
            break;
        default:
            break;
    }
}
@end
