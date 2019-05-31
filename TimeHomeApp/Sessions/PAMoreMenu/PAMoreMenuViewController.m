//
//  PAMoreMenuViewController.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/2.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAMoreMenuViewController.h"
#import "NibCell.h"
#import "HomePropertyIconModel.h"
#import "IntelligentGarageVC.h"
#import "ShakePassageVC.h"
#import "MessageAlert.h"
#import "VisitorVC.h"
#import "NotificationVC.h"
#import "RaiN_NewServiceTempVC.h"
#import "SuggestionsVC.h"
#import "L_NewBikeListViewController.h"
#import "L_BikeGuardListVC.h"
#import "L_CertifyHoustListViewController.h"
#import "L_AddHouseForCertifyCommunityVC.h"
#import "PAMoreMenuHeaderView.h"
#import "L_CommunityAuthoryPresenters.h"
#import "L_NewMyHouseListViewController.h"
#import "PAWaterScanViewController.h"
#import "WebViewVC.h"

@interface PAMoreMenuViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@end

@implementation PAMoreMenuViewController
@synthesize isHaveHouse,isHaveParking;

#pragma mark - LifeCircle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
#pragma mark - 初始化UI
- (void)initializeUI{
    
    self.navigationItem.title = @"全部服务";
    
    CGFloat row_H = 0;
    for (int i = 0 ; i< _dataSource.count; i++) {
        
        NSArray * arr = [_dataSource objectAtIndex:i][@"list"];
        row_H += 80*(arr.count/4 +1);
    }

    UICollectionViewFlowLayout *viewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat height = (_dataSource.count *50 +row_H + 30)<(SCREEN_HEIGHT-64)?(_dataSource.count *50 +row_H + 30):(SCREEN_HEIGHT-64);
    self.mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,height) collectionViewLayout:viewFlowLayout];
    self.mainCollectionView.backgroundColor = [UIColor whiteColor];

    self.mainCollectionView.showsHorizontalScrollIndicator = FALSE; // 去掉滚动条
    self.mainCollectionView.delegate = self;
    self.mainCollectionView.dataSource = self;
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"NibCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    [self.mainCollectionView registerNib:[UINib nibWithNibName:@"PAMoreMenuHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PAMoreMenuHeaderView"];
    
 
    
    [self.view addSubview:self.mainCollectionView];
    
}

#pragma mark - UICollectionViewDataSource
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
        PAMoreMenuHeaderView * circleHeaderView  =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"PAMoreMenuHeaderView"forIndexPath:indexPath];
        
        NSString *classname = _dataSource[indexPath.section][@"classname"];
        NSString *color = _dataSource[indexPath.section][@"color"];
        [circleHeaderView assignmentWithTitle:classname color:color];
        return circleHeaderView;
        
    }else
    {
    
        return [UICollectionReusableView new];
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(SCREEN_WIDTH, 50);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    
    return 0;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    
    return 0;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/4.0f,80);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 10, 0);
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return _dataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    NSArray * arr = [_dataSource objectAtIndex:section][@"list"];
    return arr.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NibCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSArray *sectionArr = _dataSource[indexPath.section][@"list"];
    HomePropertyIconModel *homeIconModel =  [HomePropertyIconModel mj_objectWithKeyValues:[sectionArr objectAtIndex:indexPath.item]];
    cell.sourceId = homeIconModel.keynum;
    cell.backgroundColor = [UIColor whiteColor];
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:homeIconModel.picurl] placeholderImage:[UIImage imageNamed:@"homepage_button_none_n"]];
    cell.textLabel.text  = homeIconModel.title;
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *sectionArr = _dataSource[indexPath.section][@"list"];
    HomePropertyIconModel *homeIconModel =  [HomePropertyIconModel mj_objectWithKeyValues:[sectionArr objectAtIndex:indexPath.item]];
    if ([homeIconModel.key isEqualToString:@"car"]) {
        AppDelegate * appDlt=GetAppDelegates;
        if(appDlt.userData.openmap != nil)
        {
            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"procar"] integerValue];
            if(flag==0)
            {
                [self showToastMsg:@"您的社区暂未开通该服务" Duration:3];
                return;
            }
            
        }
        UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
        IntelligentGarageVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"IntelligentGarageVC"];
        [self.navigationController pushViewController:pmvc animated:YES];
        
    } else if ([homeIconModel.key isEqualToString:@"shake"]) {
        
        [self getUserauthory];
        /**
         * 摇摇通行
         **/
        NSString *resipower = [UserDefaultsStorage getDataforKey:@"resipower"];
        if ([resipower integerValue] == 1) {
            NSArray * blueTooths = (NSArray *)[UserDefaultsStorage getDataforKey:@"UserUnitKeyArray"];
            if (blueTooths.count==0||blueTooths==nil) {
                
                NSString * blueErrmessage = (NSString *)[UserDefaultsStorage getDataforKey:@"Blue_errmessage"];
                if ([XYString isBlankString:blueErrmessage]) {
                    
                    [self showToastMsg:@"请联系物业开通摇一摇通行服务" Duration:3.f];
                }else{
                    
                    [self showToastMsg:blueErrmessage Duration:3.f];
                }
                
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                ShakePassageVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"ShakePassageVC"];
                pmvc.isStart=YES;
                pmvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:pmvc animated:YES];
            }
            
        }else {
            
            [self certificationPopupType:resipower.integerValue];
        }
        
    } else if ([homeIconModel.key isEqualToString:@"traffic"]) {
        
        /**
         * 访客通行
         **/
        AppDelegate * appDlt=GetAppDelegates;
        if(appDlt.userData.openmap!=nil)
        {
            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"protraffic"] integerValue];
            if(flag==0)
            {
                [self showToastMsg:@"您的社区暂未开通该服务" Duration:3];
                return;
            }
        }
        
        if(!isHaveParking&&!isHaveHouse) {
            
            MessageAlert * msgAlert=[MessageAlert shareMessageAlert];
            msgAlert.isHiddLeftBtn = YES;
            [msgAlert showInVC:self withTitle:@"您所在小区没有房产和可使用的车位，没有权限邀请访客哦~" andCancelBtnTitle:@"" andOtherBtnTitle:@"确认"];
            return;
            
            
        }else {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
            VisitorVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"VisitorVC"];
            [self.navigationController pushViewController:pmvc animated:YES];
        }
        
        
    }else if ([homeIconModel.key isEqualToString:@"reserve"]) {
        
        /**
         * 在线报修
         **/
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
        [indicator startAnimating:self.tabBarController];
        [L_CommunityAuthoryPresenters checkUserPowerUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                
                if (resultCode == SucceedCode) {
                    
                    NSDictionary *dic = data[@"map"];
                    
                    NSString * resipower = [NSString stringWithFormat:@"%@",dic[@"isresipower"]];
                    [UserDefaultsStorage saveData:resipower forKey:@"resipower"];
                    
                    if ([resipower integerValue] == 0||[resipower integerValue] == 9) {
                       
                        [self certificationPopupType:resipower.integerValue];

                    }else {
                        ///认证
                        AppDelegate * appDlt=GetAppDelegates;
                        if(appDlt.userData.openmap!=nil)
                        {
                            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"proreserve"] integerValue];
                            if(flag==0)
                            {
                                [self showToastMsg:@"您的社区暂未开通该服务" Duration:3];
                                return;
                            }
                        }
                        
                        RaiN_NewServiceTempVC *newOnline = [[RaiN_NewServiceTempVC alloc] init];
                        newOnline.hidesBottomBarWhenPushed = YES;
                        newOnline.isFormMy = @"0";
                        [self.navigationController pushViewController:newOnline animated:YES];
                       
                    }
                    
                }else {
                    [self showToastMsg:data Duration:3.0f];
                }
            });
        }];
        
    }else if ([homeIconModel.key isEqualToString:@"complaint"]) {
        
        /*
         *建议投诉
         **/
        
        THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
        [indicator startAnimating:self.tabBarController];
        [L_CommunityAuthoryPresenters checkUserPowerUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            @WeakObj(self)
            dispatch_async(dispatch_get_main_queue(), ^{
                [indicator stopAnimating];
                
                if (resultCode == SucceedCode) {
                    
                    NSDictionary *dic = data[@"map"];
                    
                    NSString * resipower = [NSString stringWithFormat:@"%@",dic[@"isresipower"]];
                    [UserDefaultsStorage saveData:resipower forKey:@"resipower"];
                    if ([resipower integerValue] == 0 || [resipower integerValue] == 9 ) {
                        
                        [self certificationPopupType:resipower.integerValue];

                    }else {
                        ///认证
                        AppDelegate * appDlt=GetAppDelegates;
                        if(appDlt.userData.openmap!=nil)
                        {
                            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"procomplaint"] integerValue];
                            if(flag==0)
                            {
                                [self showToastMsg:@"所在小区暂未开通此功能" Duration:3];
                                return;
                            }
                            
                        }
                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
                        
                        SuggestionsVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"SuggestionsVC"];
                        [self.navigationController pushViewController:pmvc animated:YES];
                    }
                    
                }else {
                    [self showToastMsg:data Duration:3.0f];
                }
                
            });
        }];
        
    }else if ([homeIconModel.key isEqualToString:@"notice"]) {
        
        /**
         * 社区公告
         **/
        AppDelegate * appDlt=GetAppDelegates;
        if(appDlt.userData.openmap!=nil)
        {
            NSInteger flag=[[appDlt.userData.openmap objectForKey:@"pronotice"] integerValue];
            if(flag==0)
            {
                [self showToastMsg:@"所在小区暂未开通此功能" Duration:3];
                return;
            }
        }
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
        NotificationVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"NotificationVC"];
        [self.navigationController pushViewController:pmvc animated:YES];
        
    }else if([homeIconModel.key isEqualToString:@"bicycle"]) {
        
        if (kIsNewBikeList == 0) {
            
            /** 自行车管理 */
            UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
            L_NewBikeListViewController *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"L_NewBikeListViewController"];
            [self.navigationController pushViewController:pmvc animated:YES];
            
        }else {
            
            UIStoryboard * storyboard=[UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
            
            L_BikeGuardListVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"L_BikeGuardListVC"];
            pmvc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:pmvc animated:YES];
            
        }
        
    }else if([homeIconModel.key isEqualToString:@"water"]){
        
        PAWaterScanViewController * newHome = [[PAWaterScanViewController alloc]init];
        newHome.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newHome animated:YES];
        
    }else {
        
        [self jumpToWebViewWithURL:homeIconModel.gotourl andTitle:homeIconModel.title];

    }
    
    
}

/**
 跳转认证页
 */
#pragma mark  -  跳转认证页
- (void)goToCertification {
    
    AppDelegate * appDlgt = GetAppDelegates;
    THIndicatorVCStart
    [L_CommunityAuthoryPresenters getWaitCertInfoWithCommunityid:nil UpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            THIndicatorVCStopAnimating
            
            if (resultCode == SucceedCode) {
                
                //                NSString *isownercert = [NSString stringWithFormat:@"%@",data[@"map"][@"isownercert"]];
                //
                //                if (isownercert.intValue == 1) {
                //
                //                    [self showToastMsg:@"当前社区已认证" Duration:3.0];
                //                    return ;
                //
                //                }else {
                
                NSArray *houseArr = [L_ResiListModel mj_objectArrayWithKeyValuesArray:data[@"resilist"]];
                NSArray *carArr = [L_ResiCarListModel mj_objectArrayWithKeyValuesArray:data[@"parklist"]];
                
                if (houseArr.count > 0) {
                    
                    //---有房产----
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                    L_CertifyHoustListViewController *houseListVC = [story instantiateViewControllerWithIdentifier:@"L_CertifyHoustListViewController"];
                    houseListVC.fromType = 5;
                    houseListVC.houseArr = houseArr;
                    houseListVC.carArr = carArr;
                    houseListVC.communityID = appDlgt.userData.communityid;
                    houseListVC.communityName = appDlgt.userData.communityname;
                    [houseListVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:houseListVC animated:YES];
                    
                }else {
                    
                    //---无房产----
                    UIStoryboard *story = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                    L_AddHouseForCertifyCommunityVC *addVC = [story instantiateViewControllerWithIdentifier:@"L_AddHouseForCertifyCommunityVC"];
                    addVC.fromType = 5;
                    addVC.communityID = appDlgt.userData.communityid;
                    addVC.communityName = appDlgt.userData.communityname;
                    [addVC setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:addVC animated:YES];
                    
                }
                
                //                }
                
            }else {
                [self showToastMsg:data Duration:3.0];
            }
            
        });
        
    }];
}

#pragma mark - 获取用户权限
- (void)getUserauthory {
    [L_CommunityAuthoryPresenters checkUserPowerUpdataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (resultCode == SucceedCode) {
                
                NSDictionary *dic = data[@"map"];
                NSString * resipower = [NSString stringWithFormat:@"%@",dic[@"isresipower"]];
                [UserDefaultsStorage saveData:resipower forKey:@"resipower"];
            }else {
                NSLog(@"");
            }
            
        });
    }];
}
#pragma mark - 权限提示框 审核中 9 未认证 0

-(void)certificationPopupType:(NSInteger)type
{
    @WeakObj(self);
    if (type == 0) {
        
        ///未认证
        MessageAlert * msgAlert=[MessageAlert getInstance];
        msgAlert.isHiddLeftBtn=YES;
        msgAlert.closeBtnIsShow = YES;
        
        [msgAlert showInVC:self withTitle:@"请先认证为本小区的业主，您才可以使用此功能" andCancelBtnTitle:@"" andOtherBtnTitle:@"去认证"];
        msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
        {
            if (index==Ok_Type) {
                NSLog(@"---跳转认证");
                [selfWeak goToCertification];
            }
        };
        
    }else if (type == 9) {
        
        ///审核中
        MessageAlert * msgAlert=[MessageAlert getInstance];
        msgAlert.isHiddLeftBtn=YES;
        msgAlert.closeBtnIsShow = YES;
        [msgAlert showInVC:self withTitle:@"当前社区已提交过认证，请耐心等待物业为您审核通过后即可正常使用" andCancelBtnTitle:@"" andOtherBtnTitle:@"去我的房产"];
        msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
        {
            if (index==Ok_Type) {
                NSLog(@"---跳转我的房产");
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CommunityCertify" bundle:nil];
                L_NewMyHouseListViewController *houseListVC = [storyboard instantiateViewControllerWithIdentifier:@"L_NewMyHouseListViewController"];
                houseListVC.iscurrentVC = @"1";
                [selfWeak.navigationController pushViewController:houseListVC animated:YES];
                
                
            }
        };
    }
    
}
///跳转H5
-(void)jumpToWebViewWithURL:(NSString *)urlStr andTitle:(NSString *)title;
{
    AppDelegate * appDlgt = GetAppDelegates;
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"HomeTab" bundle:nil];
    WebViewVC * webVc = [secondStoryBoard instantiateViewControllerWithIdentifier:@"WebViewVC"];
    webVc.isNoRefresh = YES;
    
    NSLog(@"kCurrentVersion====%@",kCurrentVersion);
    
    if([urlStr hasSuffix:@".html"])
    {
        webVc.url=[NSString stringWithFormat:@"%@?token=%@&version=%@",urlStr,appDlgt.userData.token,kCurrentVersion];
    }else{
        webVc.url=[NSString stringWithFormat:@"%@&token=%@&version=%@",urlStr,appDlgt.userData.token,kCurrentVersion];
    }
    
    webVc.url = [webVc.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"webVc.url===%@",webVc.url);
    webVc.type = 5;
    webVc.shareTypes = 5;
    
    if (![XYString isBlankString:title]) {
        webVc.title = title;
        
    }else {
        webVc.title = @"活动详情";
    }
    
    webVc.isGetCurrentTitle = YES;
    webVc.talkingName = @"shequhuodong";
    [self.navigationController pushViewController:webVc animated:YES];
}
@end
