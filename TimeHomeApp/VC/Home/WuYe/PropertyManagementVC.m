//
//  PropertyManagementVC.m
//  TimeHomeApp
//
//  Created by us on 16/2/24.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PropertyManagementVC.h"
#import "PMPresenter.h"
#import "PMCollectionCell.h"
#import "IntelligentGarageVC.h"
#import "ShakePassageVC.h"
#import "VisitorVC.h"
#import "NotificationVC.h"
#import "OnlineServiceVC.h"
#import "SuggestionsVC.h"
#import "THMyInfoPresenter.h"
#import "MessageAlert.h"
#import "THOwnerAuthViewController.h"
#import "RaiN_NewServiceTempVC.h"
@interface PropertyManagementVC ()
{
    /**
     *  物业数据逻辑处理类
     */
    PMPresenter * pmPresenter;
}

@end

@implementation PropertyManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



#pragma mark - ---------初始化--------------
/**
 *  初始化视图
 */
-(void)initView
{
    self.navigationController.navigationBar.barTintColor=UIColorFromRGB(0xf7f7f7);
    pmPresenter=[[PMPresenter alloc]init];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"PMCollectionCell" bundle:nil]
        forCellWithReuseIdentifier:@"PMCollectionCell"];
    
    [pmPresenter getPMData:^(id  _Nullable data, ResultCode resultCode) {
        if (resultCode==SucceedCode) {
            [self.collectionView reloadData];
        }
    }];
    
}


#pragma mark - ---------UICollection协议实现--------------
/**
 *  返回集合个数
 *
 *  @param view    <#view description#>
 *  @param section section description
 *
 *  @return return value 返回集合个数
 */
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [pmPresenter.PMDataArray count];
}
/**
 *  处理每项视图数据
 *
 *  @param collectionView collectionView description
 *  @param indexPath      indexPath description
 *
 *  @return return value cell
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PMCollectionCell" forIndexPath:indexPath];
    PMDataModel * pmData=[pmPresenter.PMDataArray objectAtIndex:indexPath.row];
//    [cell.img_English setImage:[UIImage imageNamed:pmData.strEngLishImgName]];
    [cell.img_Icon setImage:[UIImage imageNamed:pmData.strIcon]];
    [cell.lab_Title setText:pmData.strTitle];
    
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREEN_WIDTH-50)/3, (SCREEN_WIDTH-50)/3);
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMCollectionCell *cell=(PMCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.view_BackBg setBackgroundColor:UIColorFromRGB(0xffffff)];
    
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    PMCollectionCell *cell=(PMCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.view_BackBg setBackgroundColor:UIColorFromRGB(0x818181)];
}

//事件处理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 0://智能车库
        {
            AppDelegate * appDlt=GetAppDelegates;
            if(appDlt.userData.openmap!=nil)
            {
                NSInteger flag=[[appDlt.userData.openmap objectForKey:@"procar"] integerValue];
                if(flag==0)
                {
                    [self showToastMsg:@"所在小区暂未开通此功能" Duration:5];
                    return;
                }
                
            }
            IntelligentGarageVC *pmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"IntelligentGarageVC"];
            [self.navigationController pushViewController:pmvc animated:YES];
            
        }
            break;
        case 1://摇摇通行
        {

            ShakePassageVC *pmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShakePassageVC"];
            [self.navigationController pushViewController:pmvc animated:YES];
        }
            break;
        case 2://访客通行
        {
            AppDelegate * appDlt=GetAppDelegates;
            if(appDlt.userData.openmap!=nil)
            {
                NSInteger flag=[[appDlt.userData.openmap objectForKey:@"protraffic"] integerValue];
                if(flag==0)
                {
                    [self showToastMsg:@"所在小区暂未开通此功能" Duration:5];
                    return;
                }
                
            }
            VisitorVC *pmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"VisitorVC"];
            [self.navigationController pushViewController:pmvc animated:YES];
        }
            break;
        case 3://建议投诉
        {
            AppDelegate * appDlt=GetAppDelegates;
            if(appDlt.userData.openmap!=nil)
            {
                NSInteger flag=[[appDlt.userData.openmap objectForKey:@"procomplaint"] integerValue];
                if(flag==0)
                {
                    [self showToastMsg:@"所在小区暂未开通此功能" Duration:5];
                    return;
                }
                
            }
            
            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
            [indicator startAnimating:self.tabBarController];
            
            [THMyInfoPresenter validationIsTheOwnerUpDataViewblock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [indicator stopAnimating];
                    
                    if (resultCode == SucceedCode) {
                        
                    SuggestionsVC *pmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SuggestionsVC"];
                    [self.navigationController pushViewController:pmvc animated:YES];
                        
                    }else {
                        
                        MessageAlert * msgAlert=[MessageAlert getInstance];
                        msgAlert.isHiddLeftBtn=YES;
                        msgAlert.closeBtnIsShow = YES;
                        
                        [msgAlert showInVC:self withTitle:@"请先认证为本小区的业主" andCancelBtnTitle:@"" andOtherBtnTitle:@"去认证"];
                        msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                        {
                            if (index==Ok_Type) {
                                NSLog(@"---跳转认证");
                                
                                THOwnerAuthViewController *ownerVC = [[THOwnerAuthViewController alloc]init];
                                UserCommunity *user = [[UserCommunity alloc]init];
                                AppDelegate *appDelegate = GetAppDelegates;
                                user.name = appDelegate.userData.communityname;
                                ownerVC.user = user;
                                [self.navigationController pushViewController:ownerVC animated:YES];
                                
                                
                            }
                            
                        };
                        
                        
                    }
                    
                    
                });
                
            }];

            
            
            
        }
            break;
        case 4://通知公告 pronotice
        {
            AppDelegate * appDlt=GetAppDelegates;
            if(appDlt.userData.openmap!=nil)
            {
                NSInteger flag=[[appDlt.userData.openmap objectForKey:@"pronotice"] integerValue];
                if(flag==0)
                {
                    [self showToastMsg:@"所在小区暂未开通此功能" Duration:5];
                    return;
                }
                
            }
            NotificationVC *pmvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationVC"];
            [self.navigationController pushViewController:pmvc animated:YES];
        }
            break;
        case 5://在线报修
        {
            AppDelegate * appDlt=GetAppDelegates;
            if(appDlt.userData.openmap!=nil)
            {
                NSInteger flag=[[appDlt.userData.openmap objectForKey:@"proreserve"] integerValue];
                if(flag==0)
                {
                    [self showToastMsg:@"所在小区暂未开通此功能" Duration:5];
                    return;
                }
                
            }
            
            
            THIndicatorVC * indicator=[THIndicatorVC sharedTHIndicatorVC];//加载动画
            [indicator startAnimating:self.tabBarController];
            
            [THMyInfoPresenter validationIsTheOwnerUpDataViewblock:^(id  _Nullable data, ResultCode resultCode) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [indicator stopAnimating];
                    
                    if (resultCode == SucceedCode) {
                        
//                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"PropertyManagement" bundle:nil];
//                        OnlineServiceVC *pmvc = [storyboard instantiateViewControllerWithIdentifier:@"OnlineServiceVC"];
//                        [self.navigationController pushViewController:pmvc animated:YES];

                        
                        RaiN_NewServiceTempVC *newOnline = [[RaiN_NewServiceTempVC alloc] init];
                        newOnline.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:newOnline animated:YES];
                        
                    }else {
                        
                        MessageAlert * msgAlert=[MessageAlert getInstance];
                        msgAlert.isHiddLeftBtn=YES;
                        msgAlert.closeBtnIsShow = YES;
                        
                        [msgAlert showInVC:self withTitle:@"请先进行业主认证，然后再用报修功能吧！" andCancelBtnTitle:@"" andOtherBtnTitle:@"去认证"];
                        msgAlert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                        {
                            if (index==Ok_Type) {
                                NSLog(@"---跳转认证");
                                
                                THOwnerAuthViewController *ownerVC = [[THOwnerAuthViewController alloc]init];
                                UserCommunity *user = [[UserCommunity alloc]init];
                                AppDelegate *appDelegate = GetAppDelegates;
                                user.name = appDelegate.userData.communityname;
                                ownerVC.user = user;
                                [self.navigationController pushViewController:ownerVC animated:YES];
                                
                                
                            }
                            
                        };
                        
                        
                    }
                    
                    
                });
                
            }];

            
            
            
            
        }
            break;
            
        default:
            break;
    }
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
