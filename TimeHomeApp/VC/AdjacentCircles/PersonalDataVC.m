//
//  PersonalDataVC.m
//  TimeHomeApp
//
//  Created by UIOS on 16/2/25.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.


///vcs
#import "PersonalDataVC.h"
#import "CirclesHomePageVC.h"
#import "ModifyRemarkVC.h"
#import "SignatureVC.h"
#import "ActionSheetVC.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

///views
#import "PersonalView.h"
#import "PersonnalBarView.h"
#import "Masonry.h"
#import "PopViewVC.h"
///cells
#import "DetailInfoCell.h"
#import "DynamicImgCell.h"
#import "PersonnalTitleRCell.h"
#import "PersonnalContentRCell.h"
#import "ChatMessageMainVC.h"

///models
#import "THMyInfoPresenter.h"
#import "TopicDetailModel.h"
#import "UserInfoModel.h"
#import "ChatPresenter.h"
#import "PostPresenter.h"
#import "MessageAlert.h"
#import "ChatViewController.h"

#import "UserInfoMotifyPresenters.h"
#import "DataOperation.h"

@interface PersonalDataVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    PersonalView * pV;
    NSArray * titleArr;
    NSInteger sectionCount;
    BOOL isBuilding;
}
@property (strong, nonatomic)UICollectionView *collectionV;
@property (nonatomic,copy)NSString *userid;
@property (nonatomic,strong)UserInfoModel *UIML;
@property (nonatomic,strong)PersonnalBarView *barV;

@end

@implementation PersonalDataVC
@synthesize UIML,barV;

-(void)rightAction:(id)sender
{
   
    NSString * str;
    BOOL isB = UIML.isblack.boolValue;
    
    if (UIML.isblack.boolValue) {
        [PopViewVC sharePopView].data = @[@"移除黑名单",@"举报"];
        str = @"确定将用户从黑名单中移除";

    }else
    {
        [PopViewVC sharePopView].data = @[@"拉黑",@"举报"];
        str = @"加入黑名单将不会收到邻友聊天消息";

    }
    
    [PopViewVC sharePopView].picData = @[@"邻圈_详细资料_拉黑",@"邻圈_详细资料_举报"];
    @WeakObj(self)
    [[PopViewVC sharePopView] showInVC:self];
    [PopViewVC sharePopView].block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
    {
        [[PopViewVC sharePopView]dismiss];
        NSLog(@"%ld",(long)index.row);
        
        if (index.row==0) {
            
            NSLog(@"%@",str);
            [[MessageAlert shareMessageAlert] showInVC:selfWeak withTitle:str andCancelBtnTitle:@"取消" andOtherBtnTitle:@"确定"];
            
                    if (isB) {
                        
                        [MessageAlert shareMessageAlert].block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
                        {
                            if (index==Ok_Type) {
                                [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];

                                [ChatPresenter removeUserBlackList:^(id  _Nullable data, ResultCode resultCode){

                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];

                                        if (resultCode == SucceedCode) {
                                            [selfWeak showToastMsg:data Duration:2.5f];
                                            selfWeak.UIML.isfllow = @"0";
                                            
                                            [selfWeak.barV.focusBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_注"] forState:UIControlStateNormal];
                                            selfWeak.barV.leftLb.text = @"关注";
                                            selfWeak.UIML.isblack = @"0";

                                        }
                                        
                                    });
                                    
                                } withUserID:selfWeak.UIML.userID andType:@""];
                            }
                        };
                        
                    }else
                    {
                        [MessageAlert shareMessageAlert].block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index){
                            if (index==Ok_Type) {
                                
                                [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];

                                [ChatPresenter addUserBlackList:^(id  _Nullable data, ResultCode resultCode) {
                                    
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [[THIndicatorVC sharedTHIndicatorVC]stopAnimating];
                                        if (resultCode == SucceedCode) {
                                            
                                           // [[DataOperation sharedDataOperation]deleteDataWithChatID:UIML.userID];

                                            [selfWeak showToastMsg:data Duration:2.5f];
                                            [barV.focusBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_移除"] forState:UIControlStateNormal];
                                            barV.leftLb.text = @"移除黑名单";
                                            selfWeak.UIML.isblack = @"1";

                                        }
                                        
                                    });
                                    
                                    
                                } withUserID:selfWeak.UIML.userID andType:@""];
                            }
                            
                        };
                    }
            
            
        }else
        {

            [ActionSheetVC shareActionSheet].data = @[@"骚扰信息",@"虚假身份",@"广告欺诈",@"不当发言",@"取消"];
            [ActionSheetVC shareActionSheet].tableViewH.constant = 5 * 45;
            [[ActionSheetVC shareActionSheet] showInVC:selfWeak];
            [ActionSheetVC shareActionSheet].block = ^(id  data,UIView * view,NSIndexPath * index)
            {
                [[ActionSheetVC shareActionSheet]dismiss];
                if (index.row < 4) {
                    if (![XYString isBlankString:selfWeak.UIML.userID]) {
                        [UserInfoMotifyPresenters addUserReportUserID:selfWeak.UIML.userID type:[NSString stringWithFormat:@"%ld",(long)index.row] UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                if(resultCode == SucceedCode)
                                {
                                    [selfWeak showToastMsg:@"举报成功" Duration:2.0];
                                }
                                else
                                {
                                    [selfWeak showToastMsg:(NSString *)data Duration:2.0];
                                }
                                
                            });
                            
                        }];
                    }

                }
                
                
            };
            
        }
        
    };
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
  
    
    sectionCount = 0;
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"邻圈_群_群设置_举报-退出"] style:UIBarButtonItemStyleDone target:self action:@selector(rightAction:)];
    self.navigationItem.rightBarButtonItem = rightBar;
   
    UICollectionViewFlowLayout * flowlayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionV = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40-55) collectionViewLayout:flowlayout];
    [self.collectionV setBackgroundColor:[UIColor clearColor]];
    self.collectionV.alwaysBounceVertical = NO;
    self.collectionV.delegate = self;
    self.collectionV.dataSource =self;
    self.collectionV.alwaysBounceVertical = NO;
    self.collectionV.bounces = NO;
    
    
    [self.collectionV registerNib:[UINib nibWithNibName:@"ColorLabelCell" bundle:nil] forCellWithReuseIdentifier:@"labelCell"];

    [self.collectionV registerNib:[UINib nibWithNibName:@"DynamicImgCell" bundle:nil] forCellWithReuseIdentifier:@"imgCell"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"PersonnalTitleRCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"titleCell"];
    [self.collectionV registerNib:[UINib nibWithNibName:@"PersonnalContentRCell" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"contentCell"];
    UICollectionReusableView * headerV = [[UICollectionReusableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,10)];
    headerV.backgroundColor = BLACKGROUND_COLOR;
    
    [self.collectionV registerClass:[headerV class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
    
    
    [self.view addSubview:self.collectionV];
    barV = [[[NSBundle mainBundle]loadNibNamed:@"PersonnalBarView" owner:self options:nil] lastObject];
//    barV.frame = CGRectMake(0, SCREEN_HEIGHT-155,SCREEN_WIDTH,55);
    
    
    [self.view addSubview:barV];
    
    
    [barV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@55.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        
    }];
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.view.mas_bottom).offset(-55);
        make.top.equalTo(self.view.mas_top).offset(0);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.left.equalTo(self.view.mas_left).offset(15);
        
        
    }];
    pV = [[[NSBundle mainBundle]loadNibNamed:@"PersonalView" owner:self options:nil]lastObject];
    self.navigationItem.title = @"详细资料";

    
    @WeakObj(self);
    barV.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        if (index==1000) {
            if (selfWeak.UIML.isblack.boolValue) {
                [ChatPresenter removeUserBlackList:^(id  _Nullable data, ResultCode resultCode){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (resultCode == SucceedCode) {
                            [selfWeak showToastMsg:data Duration:2.5f];
                            selfWeak.UIML.isfllow = @"0";
                            
                            [selfWeak.barV.focusBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_注"] forState:UIControlStateNormal];
                            selfWeak.barV.leftLb.text = @"关注";
                            selfWeak.UIML.isblack = @"0";
                        }
                        
                    });
                    
                } withUserID:selfWeak.UIML.userID andType:@""];

            }else{
                if (selfWeak.UIML.isfllow.boolValue) {
                    ///取消关注
//                    [ChatPresenter removeUserFollow:selfWeak.userid withBlock:^(id  _Nullable data, ResultCode resultCode) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            
//                            [selfWeak showToastMsg:data Duration:2.5];
//                            selfWeak.UIML.isfllow = @"0";
//
//                            [selfWeak.barV.focusBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_注"] forState:UIControlStateNormal];
//                            selfWeak.barV.leftLb.text = @"关注";
//                        });
//                    }];
                    
                    

                }else
                {
                    ///关注
//                    [ChatPresenter addUserFollow:selfWeak.userid withBlock:^(id  _Nullable data, ResultCode resultCode) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//     
//                            [selfWeak showToastMsg:data Duration:2.5];
//                            selfWeak.UIML.isfllow = @"1";
//                            [selfWeak.barV.focusBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_已注"] forState:UIControlStateNormal];
//                            selfWeak.barV.leftLb.text = @"已关注";
//                        });
//                    }];
//
                }
            }
        }else
        {
            ///聊天
            if (selfWeak.UIML.isblack.boolValue) {
              
                
                [selfWeak showToastMsg:@"请先将该用户移除黑名单！" Duration:3.5f];

            }else{
                AppDelegate * tempApp = GetAppDelegates;
                if([selfWeak.UIML.userID isEqualToString:tempApp.userData.userID]){
                    [selfWeak showToastMsg:@"不能和自己聊天！" Duration:2.5f];
                }else
                {
                    ChatViewController *chatC =[[ChatViewController alloc] initWithChatType:XMMessageChatSingle];
                    chatC.ReceiveID = selfWeak.UIML.userID;
                    [selfWeak.navigationController pushViewController:chatC animated:YES];
                }
            }
        }
        
    };
    
    [barV setHidden:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   
    self.navigationController.navigationBarHidden = NO;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    @WeakObj(self)
    sectionCount = 6;
    isBuilding =YES;

    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    
    [THMyInfoPresenter getOneUserInfoUserID:_userID UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
         
            
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode == SucceedCode)
            {
                [barV setHidden:NO];

                UIML = data;
                selfWeak.userid = UIML.userID;
                
                
                NSString * url = [[UIML.piclist firstObject] objectForKey:@"fileurl"];;
                NSString * sendname;
                if ([XYString isBlankString:UIML.remarkname]) {
                    sendname =  UIML.nickname;
                }else
                {
                    sendname =  UIML.remarkname;
                    
                }
                
                NSDictionary * remarkDic = @{UIML.userID:sendname};
                
                [[NSUserDefaults standardUserDefaults]setObject:remarkDic forKey:@"remarkName"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                NSDictionary * picUrl = @{UIML.userID:url};
                
                [[NSUserDefaults standardUserDefaults]setObject:picUrl forKey:@"headPicUrl"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"remarkName" object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"headPicUrl" object:nil];
                
                [[DataOperation sharedDataOperation] queryData:@"Gam_Chat" withHeadPicUrl:url andChatID:UIML.userID andnikeName:sendname];

                if(UIML.isblack.boolValue)
                {
                    [barV.focusBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_移除"] forState:UIControlStateNormal];
                    barV.leftLb.text = @"移除黑名单";
                
                }else
                {
                    if (UIML.isfllow.boolValue) {
                        [barV.focusBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_已注"] forState:UIControlStateNormal];
                        barV.leftLb.text = @"已关注";
                    }else
                    {
                        [barV.focusBtn setImage:[UIImage imageNamed:@"邻圈_详细资料_注"] forState:UIControlStateNormal];
                        barV.leftLb.text = @"关注";

                    }
                }
                
                if ([XYString isBlankString:UIML.building]||UIML.building == nil||[UIML.building isKindOfClass:[NSNull class]]) {
                    sectionCount --;
                    isBuilding = NO;
                }
                if ([XYString isBlankString:UIML.name]||UIML.name == nil||[UIML.name isKindOfClass:[NSNull class]]) {
                    sectionCount --;

                }
                AppDelegate * appdelegate = GetAppDelegates;
                if ([selfWeak.UIML.userID isEqualToString:appdelegate.userData.userID]) {
                    selfWeak.navigationItem.rightBarButtonItem = nil;
                }

                [self.collectionV reloadData];
            }else if(resultCode ==FailureCode)
            {
                NSNumber * code = data;
                if (code.integerValue == 90002) {
                    [selfWeak showToastMsg:@"您已被拉黑！" Duration:5.0f];
                    [selfWeak.navigationController popViewControllerAnimated:NO];
                }
            }
        });
        
    }];

   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDelagate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DynamicImgCell * cell = (DynamicImgCell * )[collectionView cellForItemAtIndexPath:indexPath];
    [self tapPicture:indexPath tapView:cell.imgV];

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        DynamicImgCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    
        cell.backgroundColor = [UIColor clearColor];
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:[[UIML.piclist objectAtIndex:indexPath.row] objectForKey:@"fileurl"]] placeholderImage:PLACEHOLDER_IMAGE];
    
        return cell;


 }
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return CGSizeMake(SCREEN_WIDTH,10);
    }
    if (section==sectionCount-1) {
        return CGSizeMake(SCREEN_WIDTH,10);
    }
    return CGSizeMake(0, 0);

}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    
    if (section==0) {
        
        NSLog(@"----刘帅%f",UIML.tagV_H);
        if (UIML.tags==nil||UIML.tags.count==0) {
            return CGSizeMake(SCREEN_WIDTH, 54+20);

        }else
        {
            return CGSizeMake(SCREEN_WIDTH, UIML.tagV_H);
        }

    }
    return CGSizeMake(SCREEN_WIDTH, 45);
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
       return CGSizeMake((SCREEN_WIDTH-30-50)/4.0,(SCREEN_WIDTH-30-50)/4.0);
}
//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    if(section == 0)
    {
        return 10;
    }
    return 0;
}
//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
{
    return 0;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    if (section == 0) {
    
        return UIML.piclist.count;
    }
    return 0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section==0) {
        
        return UIEdgeInsetsMake(10,10,10,10);
    }
    return UIEdgeInsetsMake(0,0,0,0);
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return sectionCount;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    if([kind isEqual:UICollectionElementKindSectionHeader])
    {
         UICollectionReusableView * sectionCell  =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"forIndexPath:indexPath];
        sectionCell.backgroundColor = BLACKGROUND_COLOR;
        
        return sectionCell;
        
        
    }else if([kind isEqual:UICollectionElementKindSectionFooter]){
        
        
        PersonnalContentRCell * contentCell  =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"contentCell"forIndexPath:indexPath];
        

        if (indexPath.section == 0) {
            PersonnalTitleRCell * titleCell  =  [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"titleCell"forIndexPath:indexPath];

            titleCell.levelLb.text = UIML.level;
            NSLog(@"%@",UIML.taglist);
            if (UIML.taglist==nil||UIML.taglist.count==0) {
                [titleCell.lineImg setHidden:YES];
            }else
            {
                [titleCell.lineImg setHidden:NO];
                
            }
            @WeakObj(self)
            titleCell.block = ^(id  _Nullable data,ResultCode resultCode)
            {
                ModifyRemarkVC * mrVC =  [[UIStoryboard storyboardWithName:@"AdjacentCirclesTab" bundle:nil] instantiateViewControllerWithIdentifier:@"ModifyRemarkVC"];
                mrVC.userID = selfWeak.UIML.userID;
                mrVC.nikeName = selfWeak.UIML.nickname;
                if (![XYString isBlankString:selfWeak.UIML.remarkname ]) {
                    
                    mrVC.remarkname = selfWeak.UIML.remarkname;
                }
                [self.navigationController pushViewController:mrVC animated:YES];
                
            };
            if ([XYString isBlankString:UIML.remarkname]) {
                titleCell.nameLb.text = UIML.nickname;
            }else
            {
                titleCell.nameLb.text = UIML.remarkname;
                
            }
            titleCell.ageLb.text = UIML.age;
            if(UIML.sex.integerValue == 1)
            {
                [titleCell.sexImg setImage:[UIImage imageNamed:@"邻圈_男"]];
                [titleCell.ageView setBackgroundColor:BLUE_TEXT_COLOR];
                
            }else if(UIML.sex.integerValue == 2)
            {
                [titleCell.sexImg setImage:[UIImage imageNamed:@"邻圈_女"]];
                [titleCell.ageView setBackgroundColor:WOMEN_COLOR];
                
            }
            titleCell.colorLabelV.tags = UIML.tags;
            [titleCell.colorLabelV commonInit];
            titleCell.colorLabelV.textColor = UIColorFromRGB(0x319afb);
            titleCell.colorLabelV.font = [UIFont systemFontOfSize:13.0];
            
            titleCell.colorLabelV.multiLine = YES;
            titleCell.colorLabelV.multiSelect = YES;
            titleCell.colorLabelV.allowNoSelection = YES;
            titleCell.colorLabelV.vertSpacing = 1;
            titleCell.colorLabelV.horiSpacing = 5;
            titleCell.colorLabelV.selectedTextColor = [UIColor clearColor];
            titleCell.colorLabelV.tagBackgroundColor = [UIColor clearColor];
            titleCell.colorLabelV.selectedTagBackgroundColor = [UIColor redColor];
            titleCell.colorLabelV.tagCornerRadius = 3;
            titleCell.colorLabelV.tagEdge = UIEdgeInsetsMake(5,3,0,0);
            return titleCell;
            

        }else if(indexPath.section ==1)
        {
            @WeakObj(self)

            [contentCell.imgV setImage:[UIImage imageNamed:@"个性签名"]];
            contentCell.indexPath = indexPath;
            contentCell.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
                
                SignatureVC * sVC = [[SignatureVC alloc]init];
                sVC.navigationItem.title = @"个性签名" ;
                sVC.signatureStr = selfWeak.UIML.signature;
                
                [selfWeak.navigationController pushViewController:sVC animated:YES];
                
            };
            [contentCell.lineImgV setHidden:NO];
            contentCell.contentLb.text = UIML.signature;
            [contentCell.contentLb setHidden:NO];
            contentCell.titleLb.text = @"个性签名";
            [contentCell.rightArrowBtn setHidden:NO];
            
            return contentCell;

        }else if(indexPath.section ==sectionCount-2)
        {
            [contentCell.imgV setImage:[UIImage imageNamed:@"邻圈_详细资料_星座"]];
            contentCell.indexPath = indexPath;
            contentCell.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
                
                
            };
            [contentCell.rightArrowBtn setHidden:YES];
            
            [contentCell.lineImgV setHidden:YES];
            contentCell.titleLb.text = @"星       座";
            contentCell.contentLb.text = UIML.constellation;
            
            return contentCell;

        }else if(indexPath.section ==sectionCount-1)
        {
            [contentCell.imgV setImage:[UIImage imageNamed:@"邻圈_详细资料_我的动态"]];
            contentCell.indexPath = indexPath;
            contentCell.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
                
                CirclesHomePageVC * chpVC = [[CirclesHomePageVC alloc]init];
                chpVC.UIML = UIML;
                chpVC.userID = UIML.userID;
                chpVC.navigationItem.title = UIML.remarkname ? UIML.remarkname: UIML.nickname;
                [self.navigationController pushViewController:chpVC animated:YES];
                
            };
            [contentCell.lineImgV setHidden:YES];
            [contentCell.rightArrowBtn setHidden:NO];
            contentCell.titleLb.text = @"圈子";
            [contentCell.contentLb setHidden:NO];
            contentCell.contentLb.text = UIML.lastpostscontent;
            
            return contentCell;
            
        }else if(indexPath.section ==2)
        {
            if (isBuilding) {
                [contentCell.imgV setImage:[UIImage imageNamed:@"邻圈_详细资料_住址"]];
                contentCell.indexPath = indexPath;
                contentCell.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
                    
                    
                };
                [contentCell.rightArrowBtn setHidden:YES];
                contentCell.contentLb.text = UIML.building;
                contentCell.titleLb.text = @"地       址";
                
            }else{
                
                [contentCell.imgV setImage:[UIImage imageNamed:@"邻圈_详细资料_真实姓名"]];
                contentCell.titleLb.text = @"真实姓名";
                contentCell.indexPath = indexPath;
                contentCell.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
                    
                    
                };
                contentCell.contentLb.text = UIML.name;
                [contentCell.rightArrowBtn setHidden:YES];

            }
            return contentCell;

        }else if(indexPath.section ==3)
        {
            [contentCell.imgV setImage:[UIImage imageNamed:@"邻圈_详细资料_真实姓名"]];
            contentCell.titleLb.text = @"真实姓名";
            contentCell.indexPath = indexPath;
            contentCell.block = ^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index){
                
                
            };
            contentCell.contentLb.text = UIML.name;
            [contentCell.rightArrowBtn setHidden:YES];
            return contentCell;
        }
        
    }
    return [UICollectionReusableView new];
}


-(void)tapPicture :(NSIndexPath *)index
          tapView :(UIImageView *)tapView
{
    
    NSInteger count = UIML.piclist.count;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        
        NSString *url;
        MJPhoto *photo = [[MJPhoto alloc] init];
        url = [[UIML.piclist objectAtIndex:i] objectForKey:@"fileurl"];;
        photo.url = [NSURL URLWithString:url];
        photo.srcImageView = tapView; // 来源于哪个UIImageView
        [photos addObject:photo];
        
    }
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = index.row; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

@end
