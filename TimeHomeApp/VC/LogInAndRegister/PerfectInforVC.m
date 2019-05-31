//
//  PerfectInforVC.m
//  TimeHomeApp
//
//  Created by us on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PerfectInforVC.h"
#import "THBaseTableViewCell.h"
#import "MMDateView.h"
#import "MMPopupWindow.h"
#import "MMPickerView.h"
#import "ChangAreaVC.h"
#import "LCActionSheet.h"
#import "XYString.h"
//网络请求
#import "THMyInfoPresenter.h"
#import "AppSystemSetPresenters.h"
#import "L_NewPointPresenters.h"

//头像选择
#import "TZImagePickerController.h"
#import "UIView+Layout.h"
#import "GCD.h"
#import "ImageUitls.h"

#import "LoginVC.h"
#import "LogInPresenter.h"
#import "MainTabBars.h"
#import "CommunityManagerPresenters.h"
#import "MySettingAndOtherLogin.h"
#import "ZSY_PhoneNumberBinding.h"

#import "ChatPresenter.h"
#import "Gam_Chat.h"
#import "XMMessage.h"
#import "DateUitls.h"
#import "DataOperation.h"
#import "RaiN_PerfectinforBottomCell.h"//提示cell
//#import "CommunityCertificationVC.h"//认证页面
#import "CertificationPopupView.h"
#import "AppDelegate+JPush.h"
#import "PAOtherLogInRequest.h"
#import "PAH5UrlManager.h"

@interface PerfectInforVC ()<UITableViewDelegate,UITableViewDataSource,TZImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSArray *titles;//左标题
    NSMutableArray *detailTitles;//右内容
    /**
     *  头像
     */
    UIImage *headImage;
    /**
     *  判断完成资料数组
     */
    NSMutableArray *countArray;
    /**
     *  完成按钮
     */
    UIButton *completionButton;
    LogInPresenter * logInPresenter;
    /**
     *  昵称
     */
    NSString *nickName;
    /**
     *  性别
     */
    NSString *sexString;
    /**
     *  生日
     */
    NSString *birthdayString;
    /**
     *  小区id
     */
    NSString *communityid;
    /**
     *  小区名称
     */
    NSString *communityName;
    
    AppDelegate *appDelegate;
}
/**
 *  拍照
 */
@property (nonatomic, strong) UIImagePickerController* picker;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PerfectInforVC

- (void)backButtonClick {
    
    if (_fromVCType == 1) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }else {
        
        CommonAlertVC *alertVC = [CommonAlertVC getInstance];
        [alertVC ShowAlert:self Title:@"提示" Msg:@"确定返回并重新登录？" oneBtn:@"取消" otherBtn:@"确定"];
        [alertVC setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
            if (index == 1000) {
                //确定
                appDelegate.userData.nickname = @"";
                appDelegate.userData.sex = @"0";
                appDelegate.userData.birthday = @"";
                appDelegate.userData.communityid = @"0";
                appDelegate.userData.communityname = @"";
                appDelegate.userData.userpic = @"";
                [appDelegate saveContext];
                
                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"LogInRegister" bundle:nil];
                UINavigationController *loginVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"navLogIn"];
                AppDelegate *appdelegate = GetAppDelegates;
                appdelegate.window.rootViewController = loginVC;
                CATransition * animation =  [AnimtionUtils getAnimation:5 subtag:0];
                [loginVC.view.window.layer addAnimation:animation forKey:nil];
                
            }else {
                return ;
            }
            
        }];
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:ZhuCeYe];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":ZhuCeYe}];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super.navigationController setNavigationBarHidden:NO animated:TRUE];
    appDelegate = GetAppDelegates;
    self.navigationItem.title = @"完善资料";
    
    self.view.backgroundColor = BLACKGROUND_COLOR;
    self.navigationController.navigationBar.barTintColor = NABAR_COLOR;
    
    _picker = [[UIImagePickerController alloc] init];
    _picker.delegate = self;
    _picker.allowsEditing = YES;
    _picker.navigationBar.tintColor = TEXT_COLOR;
    
    [self setUpArrays];
    
    [self initView];
    //----------提示框的默认按钮设置---------------------
    [[MMPopupWindow sharedWindow] cacheWindow];
    [MMPopupWindow sharedWindow].touchWildToHide = YES;
    
}
/**
 *  设置数组
 */
- (void) setUpArrays{
    
    sexString = @"1";
    birthdayString = @"";
    nickName = @"";
    
    logInPresenter=[LogInPresenter new];

    NSArray *array1 = [[NSArray alloc]initWithObjects:@"1",@"1",@"0",@"1",@"0", nil];
    countArray = [[NSMutableArray alloc]init];
    [countArray addObjectsFromArray:array1];
    
    titles = [[NSArray alloc]initWithObjects:@"头        像",@"昵        称",@"性        别",@"生        日",@"小        区", nil];

    NSString *sex = @"请选择性别";

    NSString *birthString = @"请选择生日";

    NSString *nickname = @"请输入昵称";

    NSString *communityname;
    if (![XYString isBlankString:_theCommunityName]) {
        communityname= _theCommunityName;
        communityid = _theCommunityID;
        communityName = _theCommunityName;
        [detailTitles replaceObjectAtIndex:4 withObject:communityName];
        [self.tableView reloadData];
        [countArray replaceObjectAtIndex:4 withObject:@"1"];
        [self buttonState];
        [_tableView reloadData];
    }else {
        communityname = @"请选择小区";
    }
//    NSString *communityname = @"请选择小区";
    
    if (_fromVCType == 1) {
        
        if (appDelegate.userData.sex.integerValue == 1) {
            sex = @"男";
            sexString = @"1";

        }
        if (appDelegate.userData.sex.integerValue == 2) {
            sex = @"女";
            sexString = @"2";

        }
        
        if (![XYString isBlankString:appDelegate.userData.birthday]) {
            
            NSDate *date = [XYString NSStringToDate:appDelegate.userData.birthday withFormat:@"yyyy/MM/dd"];
            
            birthString = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
            birthdayString = birthString;

        }
        
        if (![XYString isBlankString:appDelegate.userData.nickname]) {
            nickname = appDelegate.userData.nickname;
            nickName = appDelegate.userData.nickname;

        }
        
        if (![XYString isBlankString:appDelegate.userData.communityname]) {
            communityName = appDelegate.userData.communityname;
            communityid = appDelegate.userData.communityid;
            
        }
        
    }

    NSArray *array = [[NSArray alloc]initWithObjects:@"",nickname,sex,birthString,communityname,nil];
    detailTitles = [[NSMutableArray alloc]init];
    [detailTitles addObjectsFromArray:array];
    
    if (_fromVCType == 1) {
        headImage = nil;
        
        titles = [[NSArray alloc]initWithObjects:@"头        像",@"昵        称",@"生        日", nil];

        [detailTitles removeAllObjects];
        NSArray *array = [[NSArray alloc]initWithObjects:@"",nickname,birthString,nil];
        [detailTitles addObjectsFromArray:array];
        
    }else {
        headImage = kHeaderPlaceHolder;
    }

}
///初始化
- (void)initView {

    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[THBaseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([THBaseTableViewCell class])];
    [_tableView registerNib:[UINib nibWithNibName:@"RaiN_PerfectinforBottomCell" bundle:nil] forCellReuseIdentifier:@"RaiN_PerfectinforBottomCell"];
}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_fromVCType == 1) {
        return 1;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc]init];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 1) {
        return 1;
    }
    return titles.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 35;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (_fromVCType == 1) {
        return 60;
    }else {
        if (section == 0) {
            return 0.0001;
        }
        return 60;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    if (_fromVCType == 1) {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = BLACKGROUND_COLOR;
        
        completionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [completionButton setBackgroundColor:kNewRedColor];
        completionButton.selected = YES;
        [completionButton setTitle:@"完  成" forState:UIControlStateNormal];
        completionButton.titleLabel.font = DEFAULT_BOLDFONT(16);
        [completionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:completionButton];
        [completionButton addTarget:self action:@selector(completionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [completionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view).offset(8);
            make.width.equalTo(@(WidthSpace(584)));
            make.height.equalTo(@(35));
            make.centerX.equalTo(view.mas_centerX);
        }];
        
        if (_fromVCType == 1) {
            [completionButton setBackgroundColor:kNewRedColor];
            completionButton.selected = YES;
        }else {
            
            if ([countArray[2] isEqualToString:@"0"] || [countArray[4] isEqualToString:@"0"]) {
                
                [completionButton setBackgroundColor:TEXT_COLOR];
                completionButton.selected = NO;
                completionButton.userInteractionEnabled = NO;
            }else {
                
                [completionButton setBackgroundColor:kNewRedColor];
                completionButton.selected = YES;
                completionButton.userInteractionEnabled = YES;
            }
            
        }
        
        return view;
    }else {
        if (section == 0) {
            return nil;
        }
        UIView *view = [[UIView alloc]init];
        view.backgroundColor = BLACKGROUND_COLOR;
        
        completionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [completionButton setBackgroundColor:kNewRedColor];
        completionButton.selected = YES;
        [completionButton setTitle:@"完  成" forState:UIControlStateNormal];
        completionButton.titleLabel.font = DEFAULT_BOLDFONT(16);
        [completionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:completionButton];
        [completionButton addTarget:self action:@selector(completionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [completionButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(view).offset(8);
            make.width.equalTo(@(WidthSpace(584)));
            make.height.equalTo(@(35));
            make.centerX.equalTo(view.mas_centerX);
        }];
        
        if (_fromVCType == 1) {
            [completionButton setBackgroundColor:kNewRedColor];
            completionButton.selected = YES;
        }else {
            
            if ([countArray[2] isEqualToString:@"0"] || [countArray[4] isEqualToString:@"0"]) {
                
                [completionButton setBackgroundColor:TEXT_COLOR];
                completionButton.selected = NO;
                completionButton.userInteractionEnabled = NO;
            }else {
                
                [completionButton setBackgroundColor:kNewRedColor];
                completionButton.selected = YES;
                completionButton.userInteractionEnabled = YES;
            }
            
        }
        
        return view;
    }
    
}
/**
 *  判断完成按钮状态
 */
- (void)buttonState {
    
    if (_fromVCType == 1) {
        
        [completionButton setBackgroundColor:kNewRedColor];
        completionButton.selected = YES;
        
    }else {
        
        if ([countArray[2] isEqualToString:@"0"] || [countArray[4] isEqualToString:@"0"]) {
            
            [completionButton setBackgroundColor:TEXT_COLOR];
            completionButton.selected = NO;
            
        }else {
            
            [completionButton setBackgroundColor:kNewRedColor];
            completionButton.selected = YES;
            
        }

    }
    
}

// MARK: - 完成按钮点击
/**
 完成按钮点击

 @param button
 */
- (void)completionButtonClick:(UIButton *)button {
    
    UITableViewCell *TF_cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *nickName_TF =[TF_cell viewWithTag:101];
    [nickName_TF resignFirstResponder];
    
    if (button.selected == YES) {
        @WeakObj(self);

        if (_fromVCType == 1) {/** 从任务版完善资料进来 */
            
            if (headImage == nil) {
                
                THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
                [indicator startAnimating:self.tabBarController];
                
                NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
                
                if (![XYString isBlankString:birthdayString]) {
                    [mutableDict setObject:birthdayString forKey:@"birthday"];
                }
                
                if (![XYString isBlankString:nickName]) {
                    [mutableDict setObject:nickName forKey:@"nickname"];
                }
                [self.navigationController popViewControllerAnimated:YES];

               
                
            }else {
                
                THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
                [indicator startAnimating:self.tabBarController];
                
                /**
                 *  头像上传
                 */
                UIImage *newImage = [ImageUitls imageCompressForWidth:headImage targetWidth:PIC_HEAD_WH];
                
                newImage = [ImageUitls reduceImage:newImage percent:PIC_SCALING];
                
                [AppSystemSetPresenters upLoadPicFile:newImage UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if(resultCode == SucceedCode)
                        {
                            NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                            
                            NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
                            [mutableDict setObject:picID forKey:@"userpic"];
                            
                            if (![XYString isBlankString:birthdayString]) {
                                [mutableDict setObject:birthdayString forKey:@"birthday"];
                            }
                            
                            if (![XYString isBlankString:nickName]) {
                                [mutableDict setObject:nickName forKey:@"nickname"];
                            }
                            
                            [THMyInfoPresenter perfectMyUserInfoDict:[mutableDict copy] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {

                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    if (resultCode == SucceedCode) {

                                        [indicator stopAnimating];
                                        [self.navigationController popViewControllerAnimated:YES];
                                        
                                    }else {
                                        
                                        [indicator stopAnimating];
                                        [self showToastMsg:(NSString *)data Duration:3.0];
                                    }
                                    
                                });
                                
                            }];
                            
                        }else {
                            [indicator stopAnimating];
                            
                            [self showToastMsg:(NSString *)data Duration:3.0];
                        }

                    });
                    
                }];
                
            }
            
        }else {/** 从注册或第三方登录进来 */
            
            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
            [indicator startAnimating:self];
            /**
             *  头像上传
             */
            UIImage *newImage = [ImageUitls imageCompressForWidth:headImage targetWidth:PIC_HEAD_WH];
            
            newImage = [ImageUitls reduceImage:newImage percent:PIC_SCALING];
            
            [AppSystemSetPresenters upLoadPicFile:newImage UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if(resultCode == SucceedCode)
                    {
                        NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                        
                        NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] init];
                        [mutableDict setObject:picID forKey:@"userpic"];
                        [mutableDict setObject:sexString forKey:@"sex"];

                        if (![XYString isBlankString:birthdayString]) {
                            [mutableDict setObject:birthdayString forKey:@"birthday"];
                        }
                        
                        if (![XYString isBlankString:nickName]) {
                            [mutableDict setObject:nickName forKey:@"nickname"];
                        }
                        
                        [THMyInfoPresenter perfectMyUserInfoDict:[mutableDict copy] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {

                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if (resultCode == SucceedCode) {
                                    
                                    if ([XYString isBlankString:communityid] || [communityid isEqualToString:@"0"]) {
                                        communityid = @"11";/** 默认时代小区 */
                                    }
                                    
                                    /** 切换小区数据提交 */
                                    [CommunityManagerPresenters changeCommunityCommunityid:communityid UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            
                                        if(resultCode==SucceedCode)
                                            {
                                                if (_isFromThirdBinding) {
                                                    
                                                    /**
                                                     第三方登录
                                                     @param type 第三方类型
                                                     @param token 第三方token
                                                     @param ThirdID 第三方id
                                                     @param Account 第三方昵称
                                                     */
                                                    [selfWeak oterLogin:indicator];
                                                    
                                                }else {
                                                    
                                                    [logInPresenter logInForAcc:appDelegate.userData.accPhone Pw:appDelegate.userData.passWord upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                                                        
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [indicator stopAnimating];
                                                            
                                                            if(resultCode==SucceedCode)
                                                            {
                                                                 NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
                                                                [shared setObject:appDelegate.userData.token forKey:@"widget"];
                                                                [shared synchronize];
                                                                [THMyInfoPresenter getMyUserInfoUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                                                                    
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        
                                                                        if(resultCode == SucceedCode)
                                                                        {
                                                                            ///绑定标签
                                                                            [AppSystemSetPresenters getBindingTag];
                                                                            
                                                                            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
                                                                            MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
                                                                            appDelegate.window.rootViewController=MainTabBar;

                                                                            
                                                                            
                                                                            CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
                                                                            [MainTabBar.view.window.layer addAnimation:animation forKey:nil];
                                                                            CertificationPopupView *community = [[CertificationPopupView alloc] init];
                                                                            
                                                                            community.type = 0;
                                                                            
                                                                            [community showVC:selfWeak event:nil];
                                                                            
                                                                            [self getChatRecord];
                                                                            
                                                                        }else {
                                                                            
                                                                            [selfWeak showToastMsg:@"登录失败！" Duration:5.0];
                                                                            
                                                                            AppDelegate * appdelegate = GetAppDelegates;
                                                                            [appdelegate setTags:nil error:nil];
                                                                            appdelegate.userData.token = @"";
                                                                            [appdelegate saveContext];
                                                                            
                                                                        }
                                                                        
                                                                    });
                                                                    
                                                                }];
                                                                
                                                            }
                                                            else
                                                            {
                                                                AppDelegate * appdelegate = GetAppDelegates;
                                                                [appdelegate setTags:nil error:nil];
                                                                appdelegate.userData.token = @"";
                                                                [appdelegate saveContext];
                                                                
                                                                [selfWeak showToastMsg:(NSString *)data Duration:5.0];
                                                            }
                                                            
                                                            
                                                        });
                                                        
                                                    }];
                                                    
                                                }
                                                
                                            }else {
                                                [indicator stopAnimating];
                                                
                                                [selfWeak showToastMsg:(NSString *)data Duration:5.0];
                                            }
                                            
                                        });
                                        
                                    }];
                                    
                                }else {
                                    [indicator stopAnimating];
                                    
                                    [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                                }
                                
                            });
                            
                        }];
                        
                    }else {
                        [indicator stopAnimating];
                        
                        [selfWeak showToastMsg:(NSString *)data Duration:3.0];
                    }
                    
                });
                
            }];
            
        }

    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 1) {
        RaiN_PerfectinforBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RaiN_PerfectinforBottomCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.backgroundColor=BLACKGROUND_COLOR;
        cell.backgroundColor = BLACKGROUND_COLOR;
        return cell;

    }
    if (indexPath.row==1)//输入昵称
    {
        UITextField * tf_NickName;
        UILabel *leftLabel;
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor=[UIColor clearColor];
            cell.contentView.backgroundColor=UIColorFromRGB(0xffffff);
            [cell.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell).offset(-7);
                make.left.equalTo(cell).offset(7);
                make.top.equalTo(cell);
                make.bottom.equalTo(cell);
            }];
            
            leftLabel = [[UILabel alloc]init];
            leftLabel.textColor = TITLE_TEXT_COLOR;
            leftLabel.font = DEFAULT_FONT(16);
            leftLabel.tag=100;
            [cell.contentView addSubview:leftLabel];
            
            tf_NickName=[[UITextField alloc]init];
            tf_NickName.textColor = TITLE_TEXT_COLOR;
            tf_NickName.font = DEFAULT_FONT(14);
            tf_NickName.borderStyle=UITextBorderStyleNone;
            tf_NickName.tag=101;
            tf_NickName.textAlignment=NSTextAlignmentRight;
            [cell.contentView addSubview:tf_NickName];
            
            [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).offset(26);
                make.top.equalTo(cell.contentView);
                make.bottom.equalTo(cell.contentView);
                make.width.equalTo(@80);
            }];
            [tf_NickName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(cell.contentView).offset(-20);
                make.left.equalTo(leftLabel.mas_right).offset(10);
                make.top.equalTo(cell.contentView);
                make.bottom.equalTo(cell.contentView);
            }];
            
        }

        leftLabel=[cell viewWithTag:100];
        tf_NickName=[cell viewWithTag:101];
        [tf_NickName  addTarget:self action:@selector(tf_NickNameChangeEvent:) forControlEvents:UIControlEventEditingChanged];

        leftLabel.text=titles[indexPath.row];
        tf_NickName.placeholder = detailTitles[indexPath.row];
         return cell;
    }
    else
    {
        THBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THBaseTableViewCell class])];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.baseTableViewCellStyle = BaseTableViewCellStyleValue4;
        
        [cell configureIndexpath:indexPath headImageUrl:appDelegate.userData.userpic headImage:headImage];
        
        if (_fromVCType == 1) {
            
            
        }else {
            if (indexPath.row == 2 || indexPath.row == 4) {
                cell.leftImageView.image = [UIImage imageNamed:@"修改二轮--必填图标"];
            }else {
                cell.leftImageView.image = [UIImage imageNamed:@""];
            }
        }
        
        cell.leftLabel.text = titles[indexPath.row];
        cell.rightLabel.text = detailTitles[indexPath.row];
        
         return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    

    UITableViewCell *TF_cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    UITextField *nickName_TF =[TF_cell viewWithTag:101];
    [nickName_TF resignFirstResponder];
    
     @WeakObj(self);
    switch (indexPath.row) {
        case 0://头像
        {
            if (indexPath.section==0) {
                
            
                // 类方法
                LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
                    
                    if (buttonIndex == 0) {
                        
                        /** 相机授权判断 */
                        if (![self canOpenCamera]) {
                            return ;
                        };
                        
                        //拍照
                        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                        {
                            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                            _picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                            _picker.allowsEditing = YES;
                            [selfWeak presentViewController:_picker animated:YES completion:nil];
                        }

                    }
                    if (buttonIndex == 1) {
                        //从相册选择
                        [selfWeak pickPhotoButtonClick:nil];
                    }
                }];
                [sheet setTextColor:UIColorFromRGB(0xffffff)];
                [sheet show];
            }
        }
            break;
        case 1://昵称
        {
           
        }
            break;
        case 2://性别
        {
            if (_fromVCType == 1) {
                /** 生日 */
                MMDateView *dateView = [[MMDateView alloc]init];
                dateView.titleLabel.text = @"生日";
                NSDate *currentDate = nil;
                if ([XYString isBlankString:birthdayString]) {
                    currentDate = [XYString NSStringToDate:@"1990-01-01" withFormat:@"yyyy-MM-dd"];
                }else {
                    currentDate = [XYString NSStringToDate:birthdayString withFormat:@"yyyy-MM-dd"];
                }
                dateView.datePicker.date = currentDate;
                NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
                NSDate *theDate = [[NSDate date] initWithTimeIntervalSinceNow: -oneDay*100*365];
                
                dateView.datePicker.minimumDate = theDate;
                dateView.datePicker.maximumDate = [NSDate date];
                [dateView show];
                
                dateView.confirm = ^(NSString *dataString) {
                    
                    NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",dataString] withFormat:@"yyyy/MM/dd"];
                    birthdayString = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
                    //                [countArray replaceObjectAtIndex:3 withObject:@"1"];
                    [detailTitles replaceObjectAtIndex:2 withObject:birthdayString];
                    [selfWeak.tableView reloadData];
                    [selfWeak buttonState];
                    
                };
                
            }else {
                
                MMPickerView *pickerView = [[MMPickerView alloc]init];
                [pickerView show];
                pickerView.titleString = @"性别";
                
                if ([XYString isBlankString:sexString]) {
                    pickerView.selectStr = @"男";
                }else {
                    
                    if (sexString.intValue == 2) {
                        pickerView.selectStr = @"女";
                    }else {
                        pickerView.selectStr = @"男";
                    }
                    
                }
                
                pickerView.dataArray = @[@"男",@"女"];
                pickerView.confirm = ^(NSString *sexString1) {
                    
                    //确定
                    NSString *sex = @"";
                    if ([sexString1 isEqualToString:@"男"]) {
                        sex = @"1";
                    }
                    if ([sexString1 isEqualToString:@"女"]) {
                        sex = @"2";
                    }
                    sexString = sex;
                    [countArray replaceObjectAtIndex:2 withObject:@"1"];
                    [detailTitles replaceObjectAtIndex:2 withObject:sexString1];
                    [self.tableView reloadData];
                    [self buttonState];
//                    CommonAlertVC *alertVC = [CommonAlertVC getInstance];
//                    [alertVC ShowAlert:selfWeak Title:@"提示" Msg:@"注册成功后不允许修改性别，请慎重选择" oneBtn:@"取消" otherBtn:@"确定"];
//                    [alertVC setEventCallBack:^(id _Nullable data,UIView *_Nullable view,NSInteger index) {
//                        if (index == 1000) {
//
//
//                        }
//                    }];
                };
                
            }

        }
            break;
        case 3://生日
        {
            MMDateView *dateView = [[MMDateView alloc]init];
            dateView.titleLabel.text = @"生日";
            NSDate *currentDate = nil;
            if ([XYString isBlankString:birthdayString]) {
                currentDate = [XYString NSStringToDate:@"1990-01-01" withFormat:@"yyyy-MM-dd"];
            }else {
                currentDate = [XYString NSStringToDate:birthdayString withFormat:@"yyyy-MM-dd"];
            }
            dateView.datePicker.date = currentDate;
            NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
            NSDate *theDate = [[NSDate date] initWithTimeIntervalSinceNow: -oneDay*100*365];

            dateView.datePicker.minimumDate = theDate;
            dateView.datePicker.maximumDate = [NSDate date];
            [dateView show];
            
            dateView.confirm = ^(NSString *dataString) {
                
                NSDate *date = [XYString NSStringToDate:[NSString stringWithFormat:@"%@",dataString] withFormat:@"yyyy/MM/dd"];
                birthdayString = [XYString NSDateToString:date withFormat:@"yyyy-MM-dd"];
//                [countArray replaceObjectAtIndex:3 withObject:@"1"];
                [detailTitles replaceObjectAtIndex:3 withObject:birthdayString];
                [selfWeak.tableView reloadData];
                [selfWeak buttonState];
                
            };

        }
            break;
        case 4://小区
        {
            
            if (_fromVCType == 1) {
                return;
            }
            
            UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
            ChangAreaVC * areaVC=[storyboard instantiateViewControllerWithIdentifier:@"ChangAreaVC"];
            areaVC.pageSourceType = PAGE_SOURCE_TYPE_MYINFO;
            areaVC.myCallBack = ^(NSString *selectID, NSString *selectName){
              
                communityid = selectID;
                communityName = selectName;
                [countArray replaceObjectAtIndex:4 withObject:@"1"];
                [detailTitles replaceObjectAtIndex:4 withObject:selectName];
                [selfWeak.tableView reloadData];
                [selfWeak buttonState];
                
            };
            [self.navigationController pushViewController:areaVC animated:YES];
        }
            break;
        default:
            break;
    }
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    CGFloat width = 13;
    if (indexPath.row == 1) {
        width = 20;
    }
    if (indexPath.section == 1) {
        width = 13;
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

#pragma mark Click Event
/**
 *  进入相册方法
 *
 *  @param sender
 */
- (void) pickPhotoButtonClick:(UIButton *)sender {
    _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _picker.allowsEditing = YES;
    [self presentViewController:_picker animated:YES completion:nil];
}
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //模态消失
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        if (picker.allowsEditing) {
            
            image = [info objectForKey:UIImagePickerControllerEditedImage];
            
        }else {
            
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
        }
        
    }else {
        
        if (picker.allowsEditing) {
            
            image = [info objectForKey:UIImagePickerControllerEditedImage];
            
        }else {
            
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
            
        }
        
    }

    headImage = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
//    [countArray replaceObjectAtIndex:0 withObject:@"1"];
    [self.tableView reloadData];
    [self buttonState];

}

#pragma mark ------------事件处理--------------
/**
 输入框事件
 */
-(void)tf_NickNameChangeEvent:(UITextField *)sender
{
    UITextRange * selectedRange = sender.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        nickName = sender.text;

        if(sender.text.length >= 10)
        {
            sender.text=[sender.text substringToIndex:10];
            nickName = sender.text;

        }else if ([XYString isBlankString:sender.text]) {
            
//            [countArray replaceObjectAtIndex:1 withObject:@"0"];
            [self buttonState];
            
        }else {
            
//            [countArray replaceObjectAtIndex:1 withObject:@"1"];
            [self buttonState];
            
        }

    }
    
}

- (void)getChatRecord {
    
    AppDelegate * appDelegateTemp = GetAppDelegates;
    NSNumber * maxid = [[NSUserDefaults standardUserDefaults]objectForKey:appDelegateTemp.userData.userID];
    
    [ChatPresenter getUserGamSync:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(resultCode == SucceedCode)
            {
                NSArray * list = data;
                NSLog(@"---------%@",data);
                
                for (int i = 0;i<list.count ;i++) {
                    
                    NSDictionary * map  = [list objectAtIndex:i];
                    NSString * content = [map objectForKey:@"content"];
                    NSString * fileurl = [map objectForKey:@"fileurl"];
                    NSString * msgtype = [map objectForKey:@"msgtype"];
                    NSString * senduserid = [map objectForKey:@"senduserid"];
                    NSString * sendusername = [map objectForKey:@"sendusername"];
                    NSString * senduserpic = [map objectForKey:@"senduserpic"];
                    NSString * systime = [map objectForKey:@"systime"];
                    //                                NSString * type = [map objectForKey:@"type"];
                    NSDate * systime_date = [DateUitls DateFromString:systime DateFormatter:@"YYYY-MM-dd HH:mm:ss"];
                    
                    
                    Gam_Chat * GC = (Gam_Chat *)[[DataOperation sharedDataOperation]creatManagedObj:@"Gam_Chat"];
                    GC.chatID = senduserid;
                    GC.sendID = senduserid;
                    
                    GC.isFirstMsg = @(YES);
                    GC.systime = systime_date;
                    GC.headPicUrl = senduserpic;
                    
                    //
                    //                            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                    //
                    //
                    //                            });
                    [[DataOperation sharedDataOperation] queryData:@"Gam_Chat" withHeadPicUrl:senduserpic andChatID:senduserid andnikeName:sendusername];
                    
                    
                    GC.isRead = @(NO);
                    GC.ownerType = @(XMMessageOwnerTypeOther);
                    GC.sendName = sendusername;
                    if(appDelegateTemp.userData!=nil&&appDelegateTemp.userData.userID!=nil)
                    {
                        GC.userID=appDelegateTemp.userData.userID;
                        GC.receiveID = appDelegateTemp.userData.userID;
                        
                    }
                    GC.msgType = @(msgtype.integerValue);
                    ///0 文字 1 照片 2 语音
                    if (msgtype.integerValue==0) {
                        GC.cellIdentifier = @"XMTextMessageCell";
                        GC.content = content;
                        
                    }
                    else if(msgtype.integerValue==1)
                    {
                        GC.cellIdentifier = @"XMImageMessageCell";
                        GC.contentPicUrl = fileurl;
                        GC.content = @"[图片]";
                        
                    }else if(msgtype.integerValue==2)
                    {
                        GC.cellIdentifier = @"XMVoiceMessageCell";
                        GC.voiceUrl = fileurl;
                        NSLog(@"录音文件－－－%@",fileurl);
                        GC.seconds = @(content.intValue);
                        GC.content = @"[语音]";
                        GC.voiceUnRead = @(YES);
                    }else if(msgtype.integerValue == 3)
                    {
                        
                        GC.cellIdentifier = @"XMMImageTextMessageCell";
                        GC.contentPicUrl = fileurl;
                        GC.content = content;
                    }else
                    {
                        GC.cellIdentifier = @"XMTextMessageCell";
                        GC.content = content;
                    }
                    
                    [[DataOperation sharedDataOperation]save];
                }
            }
        });
        
    } withMaxID:[NSString stringWithFormat:@"%@",maxid]];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Notification_Msg" object:nil];
    
}
-(void)oterLogin:(THIndicatorVC *) indicator{
    
    @WeakObj(self);
    
    PAOtherLogInRequest * req = [[PAOtherLogInRequest alloc]initWithToken:self.thirdToken  thirdID:self.thirdID Account:self.thirdName  Type:self.type];
    [req requestStartBlockWithSuccess:^(PABaseResponseModel * _Nullable responseModel, PABaseRequest * _Nullable request) {
        
        [indicator stopAnimating];
        NSLog(@"返回数据：%@",responseModel.data);
        
        //保存用户信息
        if (responseModel.data) {
            
            
            PAUser *user = [PAUser yy_modelWithJSON:responseModel.data];
            [[PAH5UrlManager sharedPAH5UrlManager]saveUrls:user.urllink];
            
            if (user) {
                
                [[PAUserManager sharedPAUserManager]integrationUserData:user];
                
                NSUserDefaults * userDefault = [NSUserDefaults standardUserDefaults];
                [userDefault setObject:user.userinfo.opid?:@"" forKey:@"PAUserOpId"];
                [userDefault synchronize];
                appDelegate.userData.isLogIn = [[NSNumber alloc]initWithBool:YES];
                appDelegate.userData.taglist = user.taglist;
                appDelegate.isupgrade = user.userinfo.isupgrade;
                [appDelegate saveContext];
                [appDelegate setMsgSaveName];
                //今天插件的Token
                NSUserDefaults *shared = [[NSUserDefaults alloc] initWithSuiteName:WIDGET_GROUP_ID];
                [shared setObject:appDelegate.userData.token forKey:@"widget"];
                [shared synchronize];
                
                //更新该社区的权限,调试期间先固定社区 "平安社区石家庄"
                //[[PAAuthorityManager sharedPAAuthorityManager]fetchAuthorityWithCommunityId:appDelegate.userData.communityid];
                ///绑定标签
                [AppSystemSetPresenters getBindingTag];
                UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainTabBar" bundle:nil];
                MainTabBars * MainTabBar = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MainTabBars"];
                appDelegate.window.rootViewController=MainTabBar;
                CATransition * animation =  [AnimtionUtils getAnimation:2 subtag:2];
                [MainTabBar.view.window.layer addAnimation:animation forKey:nil];
                CertificationPopupView *community = [[CertificationPopupView alloc] init];
                community.type = 0;
                [community showVC:selfWeak event:nil];
                [self getChatRecord];
                
            }
        }
        
        
    } failure:^(NSError * _Nullable error, PABaseRequest * _Nullable request) {
        
        [indicator stopAnimating];
        
        NSLog(@"权限获取失败");
        //       [selfWeak ]
    }];
    
}
@end
