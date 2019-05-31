//
//  RaiN_NewOnlineServiceVC.m
//  TimeHomeApp
//
//  Created by 赵思雨 on 2017/9/5.
//  Copyright © 2017年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "RaiN_NewOnlineServiceVC.h"
#import "PopListVC.h"
#import "RepairDevTypeModel.h"
#import "ReleaseReservePresenter.h"
#import "CommunityManagerPresenters.h"
#import "AppSystemSetPresenters.h"
#import "RegularUtils.h"
#import "UpImageModel.h"
#import "ImgCollectionCell.h"
#import "LCActionSheet.h"
#import "ZZCameraController.h"
#import "ImageUitls.h"
#import "TZImagePickerController.h"
#import "ZZPhotoKit.h"
#import "UserReservePic.h"
#import "THMyRepairedListsViewController.h"
#import "NewServiceDatePickerView.h"
#import "DateUitls.h"
#import "THMyRequiredDetailsViewController.h"
#import "RaiN_NewServiceTempVC.h"
@interface RaiN_NewOnlineServiceVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextViewDelegate,TZImagePickerControllerDelegate,ZZBrowserPickerDelegate,SDPhotoBrowserDelegate>
{
    ///公共设备类型数据
    NSArray * publicDevArray;
    ///家用设备类型数据
    NSArray * homeDevArray;
    
    ///公共地址数据
    NSArray * publicAddresArray;
    ///家用地址数据
    NSArray * homeAddresArray;
    
    ////报修逻辑处理
    ReleaseReservePresenter * releasePresenter;
    
    ///选中的设备分类ID
    NSString * devTypeID;
    ///选中的公共地址ID
    NSString * pAddresID;
    ///选中的家用地址ID
    NSString * hAddresID;
    
    ///图片数组
    NSMutableArray *imgArray;
    ///点击放大图片的URL
    NSMutableArray *clickImageUrlArr;
    ///上传计数
    NSInteger Count;
    
    ///时间选择器最小的时间
    NSString *minDate;
    ///预约维修时间
    NSString *theReservedate;
}
@end

@implementation RaiN_NewOnlineServiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    [self getAppsystemTime];/** 获取系统时间 */
    
//    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
//    for (UIViewController *vc in marr) {
//        if ([vc isKindOfClass:[THMyRequiredDetailsViewController class]]) {
//            [marr removeObject:vc];
//            break;
//        }
//        
//        if ([_isFormMy integerValue] == 1 && [vc isKindOfClass:[RaiN_NewServiceTempVC class]]) {
//            [marr removeObject:vc];
//            break;
//        }
//    }
//    self.navigationController.viewControllers = marr;
    
    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in marr) {
        if ([vc isKindOfClass:[THMyRequiredDetailsViewController class]]) {
            [marr removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = marr;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [TalkingData trackPageBegin:@"zaixianbaoxiu"];
    ///数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate markStatistics:ZaiXianBaoXiu];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [TalkingData trackPageEnd:@"zaixianbaoxiu"];
    //数据统计
    AppDelegate * appdelegate = GetAppDelegates;
    [appdelegate addStatistics:@{@"viewkey":ZaiXianBaoXiu}];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self getDevType];
    [self getPublicAddress];
    [self getHomeAddress];
}

#pragma mark --- 初始化
- (void)initViews {
    
    releasePresenter=[ReleaseReservePresenter new];
    theReservedate = _chooseTimeBtn.titleLabel.text;
    ///初始化展示设备和手机号
    AppDelegate *appDlgt = GetAppDelegates;
    self.textView.delegate=self;
    self.phoneNumber.text=appDlgt.userData.phone;
    if([_fromType isEqualToString:@"0"])
    {
        if (publicDevArray != nil || publicDevArray.count != 0) {
            [_chooseTheFacilitiesBtn setTitle:[NSString stringWithFormat:@"%@",publicDevArray[0]] forState:UIControlStateNormal];
        }
        
    }
    else{
        if (homeDevArray != nil || homeDevArray.count != 0) {
            [_chooseTheFacilitiesBtn setTitle:[NSString stringWithFormat:@"%@",homeDevArray[0]] forState:UIControlStateNormal];
        }
    }
    
    _priceLabel.hidden = YES;
    _priceUnitslabel.hidden = YES;
    
    ///照片相关
    imgArray=[NSMutableArray arrayWithObject:@""];
    clickImageUrlArr = [[NSMutableArray alloc] init];
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ImgCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"ImgCollectionCell"];
    
    ///view加边框
    _phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    _phoneBgView.layer.borderWidth = 1.0f;
    _phoneBgView.layer.borderColor = LINE_COLOR.CGColor;
    
    _addressBgView.layer.borderWidth = 1.0f;
    _addressBgView.layer.borderColor = LINE_COLOR.CGColor;
    
    _timeBgView.layer.borderWidth = 1.0f;
    _timeBgView.layer.borderColor = LINE_COLOR.CGColor;
    
    ///不同类型的UI展示区分
    if ([_fromType isEqualToString:@"0"]) {
        self.navigationItem.title = @"公共设施报修";
        _theViewHeight.constant = 130;
        _priceView.hidden = NO;
        _submitView.hidden = YES;
        _timeView.hidden = YES;
    }else {
        _theViewHeight.constant = 185;
        _priceView.hidden = YES;
        _submitView.hidden = NO;
        _timeView.hidden = NO;
        self.navigationItem.title = @"家用设施报修";
    }
    
    
    
    if(self.jmpCode==1)///修改赋值 驳回
    {
        if(![XYString isBlankString:self.userInfo.type])
        {
//            if([self.userInfo.type integerValue]==0)
//            {
//                isPublic=NO;
//            }
//            else
//            {
//                isPublic=YES;
//            }
        }
        if(![XYString isBlankString:self.userInfo.typeID])
        {
            devTypeID=self.userInfo.typeID;
        }
        if(![XYString isBlankString:self.userInfo.typeID])
        {
            [self.chooseTheFacilitiesBtn setTitle:self.userInfo.typeName forState:UIControlStateNormal];
        }
        if(![XYString isBlankString:self.userInfo.feedback])
        {
            self.textView.text=self.userInfo.feedback;
            self.textViewNumber.text=[NSString stringWithFormat:@"%ld/200",(unsigned long)self.userInfo.feedback.length];
        }
        if(self.userInfo.piclist.count > 0)
        {
            UpImageModel * upImg;
            for(int i=0;i<self.userInfo.piclist.count;i++)
            {
                UserReservePic * urp=[self.userInfo.piclist objectAtIndex:i];
                upImg=[UpImageModel new];
                upImg.picID=urp.theID;
                upImg.imgUrl=urp.fileurl;
                upImg.isUpLoad=1;
                [imgArray addObject:upImg];
                [clickImageUrlArr addObject:urp.fileurl];
                [self.collectionView reloadData];
            }
            
            for (int i = 0; i < imgArray.count; i++) {
                if ([imgArray[i] isKindOfClass:[NSString class]]) {
                    [imgArray removeObjectAtIndex:i];
                }
            }
            if (imgArray.count < 4) {
                [imgArray addObject:@""];
            }
        }
        if(![XYString isBlankString:self.userInfo.phone])
        {
            self.phoneNumber.text=self.userInfo.phone;
        }
        if (![XYString isBlankString:self.userInfo.reservedate]) {
            [_chooseTimeBtn setTitle:[self.userInfo.reservedate substringToIndex:16] forState:UIControlStateNormal];
        }
        
        if (![XYString isBlankString:self.userInfo.pricedesc]) {
            _priceLabel.text = self.userInfo.pricedesc;
            _priceLabel.hidden = NO;
            _priceView.hidden = NO;
        }
        if (![XYString isBlankString:self.userInfo.phone]) {
            _phoneNumber.text = self.userInfo.phone;
        }
        if([_fromType isEqualToString:@"0"])
        {
            if(![XYString isBlankString:self.userInfo.addressid])
            {
                pAddresID=self.userInfo.addressid;
            }
            
        }
        else
        {
            if(![XYString isBlankString:self.userInfo.residenceid])
            {
                hAddresID=self.userInfo.residenceid;
            }
            self.priceLabel.text=[NSString stringWithFormat:@"%@",self.userInfo.pricedesc];
        }
        if(![XYString isBlankString:self.userInfo.address])
        {
            self.chooseAddressLabel.text = self.userInfo.address;
//            [self.chooseAddressBtn setTitle:self.userInfo.address forState:UIControlStateNormal];
        }
        else
        {
            self.chooseAddressLabel.text = @"";
//            [self.chooseAddressBtn setTitle:@"" forState:UIControlStateNormal];
        }
        
        
    }
    
}

#pragma mark ---- 按钮点击事件
/**
 选择报修设施
 */
- (IBAction)ChooseTheFacilities:(id)sender {
    
    NSArray * listData;
    if([_fromType isEqualToString:@"0"])
    {
        listData=publicDevArray;
    }
    else{
        listData=homeDevArray;
    }
    if(listData==nil||listData.count==0)
    {
        [self showToastMsg:@"未获取到设备分类,不能使用维修发布,请联系物业管理人员" Duration:5.0];
        return;
    }
    NSInteger heigth= listData.count>10?(SCREEN_HEIGHT/2):(listData.count*50.0);
    PopListVC * popList=[PopListVC getInstance];
    popList.nsLay_TableHeigth.constant=heigth;
    @WeakObj(popList);
    [popList showVC:self listData:listData cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        RepairDevTypeModel *devType =( RepairDevTypeModel *)data;
        devTypeID=devType.ID;
        [sender setTitle:devType.name forState:UIControlStateNormal];
        if (![XYString isBlankString:devType.pricedesc]) {
            _priceLabel.hidden = NO;
            _priceUnitslabel.hidden = NO;
            self.priceLabel.text=[NSString stringWithFormat:@"%@",devType.pricedesc];
        }else {
            _priceLabel.hidden = YES;
            _priceUnitslabel.hidden = YES;
            self.priceLabel.text=@"";
        }
        
        [popListWeak dismissVC];
        
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        UITableViewCell * cell=(UITableViewCell *)view;
        RepairDevTypeModel *devType =( RepairDevTypeModel *)data;
        cell.textLabel.text=devType.name;
        cell.textLabel.numberOfLines=0;
    }];
}

/**
 选择报修地址
 */
- (IBAction)chooseAddressClick:(id)sender {
    
    NSArray * listData;
    if([_fromType isEqualToString:@"0"])
    {
        listData=publicAddresArray;
    }
    else{
        listData=homeAddresArray;
    }
    if(listData==nil||listData.count==0)
    {
        [self showToastMsg:@"未获取到地址分类,不能使用维修发布,请联系物业管理人员" Duration:5.0];
        return;
    }
    NSInteger heigth= listData.count>10?(SCREEN_HEIGHT/2):(listData.count*50.0);
    PopListVC * popList=[PopListVC getInstance];
    popList.nsLay_TableHeigth.constant=heigth;
    @WeakObj(popList);
    [popList showVC:self listData:listData cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        NSDictionary *devAddr;
        if([_fromType isEqualToString:@"0"])
        {
            devAddr =(NSDictionary *)data;
            /**
             ,”list”:[{
             “id”: ”12122”
             ,”name”:”广场东”
             }]
             */
            pAddresID=[devAddr objectForKey:@"id"];
            self.chooseAddressLabel.text = [devAddr objectForKey:@"name"];
//            [sender setTitle:[devAddr objectForKey:@"name"] forState:UIControlStateNormal];
        }
        else{
            devAddr =(NSDictionary *)data;
            /**
             ,“list”:[{
             ”id”:”12“
             ,”communityname”:”金谈固家园”
             ,”propertyname”:”恒祥物业”
             ,”name”:”1号楼 3单元506”
             ,”builtuparea”:120.6
             ,”usearea”:100.6
             ,”expiretime”:”2016-06-30”
             ,”isinstall”:1
             }]
             */
            hAddresID=[devAddr objectForKey:@"id"];
            NSString * name=[NSString stringWithFormat:@"%@%@",[devAddr objectForKey:@"communityname"],[devAddr objectForKey:@"name"]];
            self.chooseAddressLabel.text = name;
//            [sender setTitle:name forState:UIControlStateNormal];
        }
        [popListWeak dismissVC];
        
    } cellViewBlock:^(id  _Nullable data, UIView * _Nullable view, NSIndexPath * _Nullable index) {
        UITableViewCell * cell=(UITableViewCell *)view;
        NSDictionary *devAddr=(NSDictionary *)data;;
        if([_fromType isEqualToString:@"0"])
        {
            
            /**
             ,”list”:[{
             “id”: ”12122”
             ,”name”:”广场东”
             }]
             */
            cell.textLabel.text=[devAddr objectForKey:@"name"];
        }
        else{
            /**
             ,“list”:[{
             ”id”:”12“
             ,”communityname”:”金谈固家园”
             ,”propertyname”:”恒祥物业”
             ,”name”:”1号楼 3单元506”
             ,”builtuparea”:120.6
             ,”usearea”:100.6
             ,”expiretime”:”2016-06-30”
             ,”isinstall”:1
             }]
             */
//            NSString * name=[NSString stringWithFormat:@"%@%@",[devAddr objectForKey:@"communityname"],[devAddr objectForKey:@"name"]];
            NSString * name=[NSString stringWithFormat:@"%@",[devAddr objectForKey:@"name"]];
            cell.textLabel.text=name;
        }
        
        cell.textLabel.numberOfLines=0;
    }];
    
}

/**
 选择报修时间
 */
- (IBAction)chooseTimeClick:(id)sender {

    NewServiceDatePickerView *newDatePicker = [NewServiceDatePickerView getInstance];
    newDatePicker.minDate = minDate;
    [newDatePicker showVC:self withTitle:@"预约维修时间" cellEvent:^(id  _Nullable data, UIView * _Nullable view, NSInteger index) {
       
        if (index == 2) {
            NSLog(@"%@",data);
            [_chooseTimeBtn setTitle:[XYString IsNotNull:data] forState:UIControlStateNormal];
            theReservedate = [NSString stringWithFormat:@"%@:00",[XYString IsNotNull:data]];
            
        }
    }];
}


/**
 提交按钮
 */
- (IBAction)submitClick:(id)sender {
    
    if(self.jmpCode==1)
    {
        [self sumbitChangeData];
        
    }else {
     [self sumbitData];
    }
}

- (IBAction)phoneNumberEditing:(id)sender {
    UITextField *tf = sender;
    UITextRange * selectedRange = tf.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        if(tf.text.length>11)
        {
            tf.text=[tf.text substringToIndex:11];
        }
    }
}


#pragma mark ---- 网络请求事件

///提交报修
-(void)sumbitData
{
    if(![RegularUtils isPhoneNum:self.phoneNumber.text])//验证手机号正确
    {
        [self showToastMsg:@"手机号不正确,请重新输入" Duration:5.0];
        return;
    }
    if([self.textView.text isEqualToString:@"请详细说明已损坏设施的具体情况（必填）"])
    {
        [self showToastMsg:@"您还没有填写详细描述" Duration:5.0];
        return;
    }
    if(self.textView.text.length<5)
    {
        [self showToastMsg:@"填写详细描述不能少于5个字" Duration:5.0];
        return;
    }
    if(devTypeID==nil||devTypeID.length==0)
    {
        [self showToastMsg:@"请选择报修设施" Duration:5.0];
        return;
    }
    if([_fromType isEqualToString:@"0"])
    {
        if(pAddresID==nil||pAddresID.length==0)
        {
            [self showToastMsg:@"请选择报修地址" Duration:5.0];
            return;
        }
        hAddresID=@"0";
    }
    else{
        if(hAddresID==nil||hAddresID.length==0)
        {
            [self showToastMsg:@"请选择报修地址" Duration:5.0];
            return;
        }
        pAddresID=@"0";
    }
    NSMutableString * picIDs=[NSMutableString new];
    [picIDs appendString:@""];
    UpImageModel * upImg;
    if ([imgArray[imgArray.count - 1] isKindOfClass:[NSString class]]) {
        [imgArray removeObjectAtIndex:imgArray.count - 1];
    }
    for(int i=0;i<imgArray.count;i++)
    {
        upImg=[imgArray objectAtIndex:i];
        [picIDs appendString:upImg.picID];
        if(i<imgArray.count-1)
        {
            [picIDs appendString:@","];
        }
    }

    if ([theReservedate isEqualToString:@"请选择时间"] || theReservedate.length < 19) {
        theReservedate = @"";
    }
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    @WeakObj(self);
    [releasePresenter addReserveForTypeId:devTypeID phone:self.phoneNumber.text feedback:self.textView.text picids:picIDs residenceid:hAddresID addressed:pAddresID andReservedate:theReservedate upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                [selfWeak showToastMsg:@"报修成功" Duration:5.0];
                //                [selfWeak.navigationController popViewControllerAnimated:YES];
                //                if(selfWeak.jmpCode==1)
                //                {
                //                    [selfWeak.navigationController popViewControllerAnimated:YES];
                //                }
                //                else
                //                {
                //            }
                //我的维修
                if ([_isFormMy integerValue] == 0) {
                    ///不是从我的页面进入  跳转到报修记录页
                    THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
                    subVC.isFromRelease=YES;
                    [selfWeak.navigationController pushViewController:subVC animated:YES];
                    
                }else {
                    NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:selfWeak.navigationController.viewControllers];
                    for (UIViewController *vc in marr) {
                        
                        if ([_isFormMy integerValue] == 1 && [vc isKindOfClass:[RaiN_NewServiceTempVC class]]) {
                            [marr removeObject:vc];
                            break;
                        }
                    }
                    selfWeak.navigationController.viewControllers = marr;
                    [selfWeak.navigationController popViewControllerAnimated:YES];
                }
//                THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
//                subVC.isFromRelease=YES;
//                [selfWeak.navigationController pushViewController:subVC animated:YES];
                
            }
            else
            {
                [selfWeak showToastMsg:data Duration:5.0];
            }
            
        });
    }];
    
}

///提交报修
-(void)sumbitChangeData
{
    if(![RegularUtils isPhoneNum:self.phoneNumber.text])//验证手机号正确
    {
        [self showToastMsg:@"手机号不正确,请重新输入" Duration:5.0];
        return;
    }
    if([self.textView.text isEqualToString:@"请详细说明已损坏设施的具体情况（必填）"])
    {
        [self showToastMsg:@"您还没有填写详细描述" Duration:5.0];
        return;
    }
    if(self.textView.text.length<5)
    {
        [self showToastMsg:@"填写详细描述不能少于5个字" Duration:5.0];
        return;
    }
    if(devTypeID==nil||devTypeID.length==0)
    {
        [self showToastMsg:@"请选择报修设施" Duration:5.0];
        return;
    }
    if([_fromType isEqualToString:@"0"])
    {
        if(pAddresID==nil||pAddresID.length==0)
        {
            [self showToastMsg:@"请选择报修地址" Duration:5.0];
            return;
        }
        hAddresID=@"0";
    }
    else{
        if(hAddresID==nil||hAddresID.length==0)
        {
            [self showToastMsg:@"请选择报修地址" Duration:5.0];
            return;
        }
        pAddresID=@"0";
    }
    NSMutableString * picIDs=[NSMutableString new];
    [picIDs appendString:@""];
    UpImageModel * upImg;
    if ([imgArray[imgArray.count - 1] isKindOfClass:[NSString class]]) {
        [imgArray removeObjectAtIndex:imgArray.count - 1];
    }
    for(int i=0;i<imgArray.count;i++)
    {
        upImg=[imgArray objectAtIndex:i];
        [picIDs appendString:upImg.picID];
        if(i<imgArray.count-1)
        {
            [picIDs appendString:@","];
        }
    }
    
    if ([theReservedate isEqualToString:@"请选择时间"] || theReservedate.length < 19) {
        theReservedate = @"";
    }
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    @WeakObj(self);
    [releasePresenter changeToReserveForTypeId:devTypeID phone:self.phoneNumber.text feedback:self.textView.text picids:picIDs residenceid:hAddresID addressed:pAddresID reserveid:self.userInfo.theID andReservedate:theReservedate upDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                [selfWeak showToastMsg:@"提交成功" Duration:5.0];
                
                if(selfWeak.jmpCode==1)
                {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    //我的维修
//                    THMyRepairedListsViewController *subVC = [[THMyRepairedListsViewController alloc]init];
//                    subVC.isFromRelease=YES;
//                    
//                    [selfWeak.navigationController pushViewController:subVC animated:YES];
                }
                
            }
            else
            {
                [selfWeak showToastMsg:data Duration:5.0];
            }
            
        });
        
    }];
    
}

////获取设备
-(void)getDevType
{
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    
    [releasePresenter getReserveTypeForupDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                NSArray * devList=(NSArray *)data;
                NSLog(@"dev===%@",devList);
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type BEGINSWITH[c] %@", @"1"];
                publicDevArray = [devList filteredArrayUsingPredicate:predicate];
                
                predicate = [NSPredicate predicateWithFormat:@"type BEGINSWITH[c] %@", @"0"];
                homeDevArray = [devList filteredArrayUsingPredicate:predicate];
            }
            else
            {
                //                [selfWeak showToastMsg:data Duration:5.0];
                //                [selfWeak showToastMsg:@"获取维修设备类型失败!" Duration:5.0];
            }
            
        });
    }];
    
}


///获取公共设备地址
-(void)getPublicAddress
{
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    [releasePresenter getReserveAddressForupDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                publicAddresArray=(NSArray *)data;
                if ([_fromType isEqualToString:@"0"]) {
                    pAddresID = publicAddresArray[0][@"id"];
                    self.chooseAddressLabel.text = publicAddresArray[0][@"name"];
//                    [_chooseAddressBtn setTitle:publicAddresArray[0][@"name"] forState:UIControlStateNormal];
                }
            }
            else
            {
                //                [selfWeak showToastMsg:@"获取公共维修地址失败!" Duration:5.0];
            }
            
        });
    }];
}
///个人地址
-(void)getHomeAddress
{
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    [CommunityManagerPresenters getUserResidenceUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                homeAddresArray=(NSArray *)data;
                if ([_fromType isEqualToString:@"1"]) {
                    hAddresID = homeAddresArray[0][@"id"];
                    self.chooseAddressLabel.text = homeAddresArray[0][@"name"];
                    
//                    [_chooseAddressBtn setTitle:homeAddresArray[0][@"name"] forState:UIControlStateNormal];
                }
            }
            else
            {
                //                [selfWeak showToastMsg:@"获取家用维修地址失败!" Duration:5.0];
            }
            
        });
        
    }];
}

///上传图片
-(void)upLoadImgForImg
{
    UpImageModel *upImg;
    for(NSInteger i=Count;i<imgArray.count;i++)
    {
        if (![imgArray[i] isKindOfClass:[NSString class]]) {
            upImg=[imgArray objectAtIndex:i];
        }
        
        if(upImg.isUpLoad==1||upImg.img==nil || [imgArray[i] isKindOfClass:[NSString class]])
        {
            continue;
        }
        [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
        [AppSystemSetPresenters upLoadPicFile:upImg.img UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
                if(resultCode==SucceedCode)
                {
                    [clickImageUrlArr addObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"fileurl"]]];
                    NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                    
                    upImg.picID=(NSString *)picID;
                    upImg.isUpLoad=1;
                    [_collectionView reloadData];
                }
                else
                {
                    [clickImageUrlArr addObject:@""];
                    upImg.isUpLoad=2;
                    [self showToastMsg:[NSString stringWithFormat:@"第%ld张图片上传失败了",(long)i] Duration:5.0];
                    [self.collectionView reloadData];
                    
                }
                
            });
        }];
        
    }
}
///上传单张图片
-(void)upLoadImgForInde:(NSInteger) index
{
    UpImageModel *upImg;
    upImg=[imgArray objectAtIndex:index];
    [[THIndicatorVC sharedTHIndicatorVC] startAnimating:self];
    [AppSystemSetPresenters upLoadPicFile:upImg.img UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[THIndicatorVC sharedTHIndicatorVC] stopAnimating];
            if(resultCode==SucceedCode)
            {
                NSString *picID = [NSString stringWithFormat:@"%@",[data objectForKey:@"id"]];
                
                upImg.picID=(NSString *)picID;
                upImg.isUpLoad=1;
                
                for (int i = 0; i < clickImageUrlArr.count - 1; i++) {
                    if ([clickImageUrlArr[i] isEqualToString:@""]) {
                        [clickImageUrlArr replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@",[data objectForKey:@"fileurl"]]];
                    }
                }
                
            }
            else
            {
                upImg.isUpLoad=2;
                [self showToastMsg:@"上传失败" Duration:5.0];
                [self.collectionView reloadData];
            }
            
        });
        
    }];
}
- (void)getAppsystemTime {
    
    THIndicatorVCStart
    [AppSystemSetPresenters getSystemTimeUpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            THIndicatorVCStopAnimating
            
            if(resultCode == SucceedCode) {
                 minDate = [(NSString *)data substringToIndex:16];
            }else {
                NSString *beginTimeStr = [DateUitls getTodayDateFormatter:@"yyyy-MM-dd HH:mm"];
                minDate = beginTimeStr;
            }
            
        });
        
    }];
    
}
#pragma mark ------ 代理相关

// MARK: - TextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
-(void)textViewDidBeginEditing:(nonnull UITextView *)textView
{
    CGRect line = [textView caretRectForPosition:
                   textView.selectedTextRange.start];
    CGFloat overflow = line.origin.y + line.size.height- ( textView.contentOffset.y + textView.bounds.size.height- textView.contentInset.bottom - textView.contentInset.top );
    if ( overflow > 0 ) {
        // We are at the bottom of the visible text and introduced a line feed, scroll down (iOS 7 does not do it)
        // Scroll caret to visible area
        CGPoint offset = textView.contentOffset;
        offset.y += overflow + 7; // leave 7 pixels margin
        // Cannot animate with setContentOffset:animated: or caret will not appear
        [UIView animateWithDuration:.2 animations:^{
            [textView setContentOffset:offset];
        }];
    }
    if ([self.textView.text isEqualToString:@"请详细说明已损坏设施的具体情况（必填）"]) {
        self.textView.text=@"";
    }
    self.textView.textColor=UIColorFromRGB(0x8e8e8e);
}
-(void)textViewDidChange:(UITextView *)textView
{
    UITextRange * selectedRange = textView.markedTextRange;
    if(selectedRange == nil || selectedRange.empty){
        self.textViewNumber.text=[NSString stringWithFormat:@"%ld/200",(unsigned long)self.textView.text.length];
        
        if (self.textView.text.length>200) {
            
            NSString *tempStr = [self.textView.text substringWithRange:NSMakeRange(self.textView.text.length-2, 2)];
            self.textViewNumber.text=[NSString stringWithFormat:@"%d/200",200];
            if ([self stringContainsEmoji:tempStr]) {
                
                [self showToastMsg:@"输入内容超过200字了" Duration:5.0];
                if (self.textView.text.length%2 ==0) {
                    self.textView.text=[textView.text substringToIndex:200];
                }else {
                    NSString *s = [self.textView.text substringToIndex:200 - 1];
                    [textView setText:s];
                }
                
            }else {
                [self showToastMsg:@"输入内容超过200字了" Duration:5.0];
                NSString *s = [self.textView.text substringToIndex:200];
                [textView setText:s];
            }
            
            
//            self.textView.text=[textView.text substringToIndex:200];
//            [self showToastMsg:@"输入内容超过200字了" Duration:5.0];
//
            return;
        }
        
    }
    
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
    return [imgArray count];
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
    ImgCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImgCollectionCell" forIndexPath:indexPath];
    UpImageModel * upImg=[imgArray objectAtIndex:indexPath.row];
    
    if (imgArray.count == 1 && [imgArray[0] isKindOfClass:[NSString class]]) {
        cell.img_Pic.image=[UIImage imageNamed:@"default照片"];
        cell.btn_Del.hidden = YES;
        cell.lab_TiShi.hidden = YES;
    }else {
        if ([imgArray[indexPath.row] isKindOfClass:[NSString class]]) {
            cell.img_Pic.image=[UIImage imageNamed:@"default照片"];
            cell.btn_Del.hidden = YES;
            cell.lab_TiShi.hidden = YES;
        }else {
            cell.btn_Del.hidden = NO;
            if(![XYString isBlankString:upImg.imgUrl])
            {
                [cell.img_Pic sd_setImageWithURL:[NSURL URLWithString:upImg.imgUrl] placeholderImage:[UIImage imageNamed:@"图片加载失败"]];
            }
            else
            {
                
//                CGFloat top = 100; // 顶端盖高度
//                CGFloat bottom = 125 ; // 底端盖高度
//                CGFloat left = 110; // 左端盖宽度
//                CGFloat right = 110; // 右端盖宽度
//                UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
//                // 指定为拉伸模式，伸缩后重新赋值
//                upImg.img = [upImg.img resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
                cell.img_Pic.image=upImg.img;
            }
            cell.indexPath=indexPath;
            cell.lab_TiShi.hidden=YES;
            if(upImg.isUpLoad==2)
            {
                cell.lab_TiShi.hidden=NO;
            }
        }
        
    }
    

    
    
    cell.eventBlock=^(id _Nullable data,UIView *_Nullable view,NSIndexPath *_Nullable index)
    {
        
        if(![XYString isBlankString:upImg.imgUrl])
        {
            
            
        }else {
            ///本地图片
            
        }
        
        
        [imgArray removeObjectAtIndex:index.row];
        [clickImageUrlArr removeObjectAtIndex:index.row];
//        if([XYString isBlankString:upImg.imgUrl])
//        {
//            clickImageUrlArr removeObjectAtIndex:<#(NSUInteger)#>
//            
//        }

        if (imgArray.count >= 3 && ![imgArray[imgArray.count-1] isKindOfClass:[NSString class]]) {
            [imgArray addObject:@""];
        }

        [self.collectionView reloadData];
    };
    return cell;
}

//定义每个UICollectionViewCell 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH_SCALE(1/5), WIDTH_SCALE(1/5));
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImgCollectionCell *cell=(ImgCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.backgroundView setBackgroundColor:UIColorFromRGB(0xffffff)];
    
}
-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImgCollectionCell *cell=(ImgCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell.backgroundView setBackgroundColor:UIColorFromRGB(0x818181)];
}

//事件处理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == imgArray.count - 1 && [imgArray[imgArray.count - 1] isKindOfClass:[NSString class]]) {
        
        if(imgArray.count>=4 && ![imgArray[imgArray.count - 1] isKindOfClass:[NSString class]])
        {
            [self showToastMsg:@"最多能选四张图片" Duration:5.0];
            return;
        }
        // 类方法
        LCActionSheet *sheet = [LCActionSheet sheetWithTitle:@"" buttonTitles:@[@"拍照", @"从相册选择"] redButtonIndex:-1 clicked:^(NSInteger buttonIndex) {
            if(buttonIndex==0)//拍照
            {
                /** 相机授权判断 */
                if (![self canOpenCamera]) {
                    return ;
                };
                
                [THIndicatorVC sharedTHIndicatorVC].isStarting=NO;
                ZZCameraController *cameraController = [[ZZCameraController alloc]init];
                if (![imgArray[imgArray.count - 1] isKindOfClass:[NSString class]]) {
                    cameraController.takePhotoOfMax = 0;
                }else {
                    cameraController.takePhotoOfMax = 4-imgArray.count + 1;
                }
                
                cameraController.isSaveLocal = NO;
                [cameraController showIn:self result:^(id responseObject){
                    
                    NSArray *array = (NSArray *)responseObject;
                    if(array!=nil&&array.count>0)
                    {
                        
                        UpImageModel * upImage;
                        Count=imgArray.count-1;//上传计数初值
                        Count=Count<0?0:Count;
                        UIImage * img;
                        for(int i=0;i<array.count;i++)
                        {
                            upImage=[UpImageModel new];
                            img=[array objectAtIndex:i];
                            img=[ImageUitls imageCompressForWidth:img targetWidth:PIC_PIXEL_W];
                            img=[ImageUitls reduceImage:img percent:PIC_SCALING];
                            upImage.img=img;
                            upImage.isUpLoad=0;
                            [imgArray addObject:upImage];
//                            if (imgArray.count > 4) {
//                                [imgArray removeObjectAtIndex:imgArray.count - 1];
//                            }
                        }
                        for (int i = 0; i < imgArray.count; i++) {
                            if (imgArray.count == 1) {
                                return;
                            }else if (imgArray.count > 1 && imgArray.count <= 4) {
                                
                                if (i == imgArray.count - 1) {
                                    
                                }else {
                                    if ([imgArray[i] isKindOfClass:[NSString class]]) {
                                        [imgArray removeObjectAtIndex:i];
                                    }
                                }
                                
                            }else {
                                if ([imgArray[i] isKindOfClass:[NSString class]]) {
                                    [imgArray removeObjectAtIndex:i];
                                }
                            }
                        }
                        
                        if (imgArray.count < 4) {
                            [imgArray addObject:@""];
                        }
                        //        if (imgArray.count > 4) {
                        //            [imgArray removeObjectAtIndex:imgArray.count - 1];
                        //        }
                        [self upLoadImgForImg];
                        [self.collectionView reloadData];
                        
                    }
                    
                }];
                
            }
            else if (buttonIndex==1)//相册
            {
                NSUInteger maxPic;
                if (![imgArray[imgArray.count - 1] isKindOfClass:[NSString class]]) {
                    maxPic = 0;
                }else {
                    maxPic = 4-imgArray.count + 1;
                }
                TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:maxPic delegate:self];
                
                [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
                    
                }];
                
                [self presentViewController:imagePickerVc animated:YES completion:nil];
                
            }
        }];
        [sheet setTextColor:UIColorFromRGB(0xffffff)];
        [sheet show];
        
    }else {
        UpImageModel * upImg=[imgArray objectAtIndex:indexPath.row];
        if(upImg.isUpLoad==2)
        {
            [self upLoadImgForInde:indexPath.row];
        }else {
            /**
             点击放大图片
             */
            SDPhotoBrowser *browser = [SDPhotoBrowser sharedInstanceSDPhotoBrower];
            browser.sourceImagesContainerView = self.view;
            browser.imageCount = clickImageUrlArr.count;
            browser.currentImageIndex = indexPath.row;
            browser.delegate = self;
            [browser show]; // 展示图片浏览器
        }
    }
    
    
}

#pragma  mark - 放大图片功能  返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    
    return [UIImage imageNamed:@"图片加载失败"];
}
///返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    if (![XYString isBlankString:clickImageUrlArr[index]]) {
        return [NSURL URLWithString:clickImageUrlArr[index]];
    }
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"图片加载失败"withExtension:nil];
    return url;

//    UpImageModel * upImg=[imgArray objectAtIndex:index];
//    if(![XYString isBlankString:upImg.imgUrl] && upImg.imgUrl != nil)
//    {
//        return [NSURL URLWithString:upImg.imgUrl];
//        
//    }else if (upImg.img == nil || upImg.imgUrl == nil) {
//        ///加载失败
//        NSURL *url = [[NSBundle mainBundle] URLForResource:@"图片加载失败" withExtension:nil];
//        return url;
//    }else {
//        ///本地图片
//        return [NSURL URLWithString:clickImageUrlArr[index]];
//    }
}

#pragma mark -----------TZImagePickerControllerDelegate-------

/// 用户点击了取消
- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    
    
}
/**
 *  用户选择好了图片，如果assets非空，则用户选择了原图
 *
 *  @param picker 相册
 *  @param photos 选中的图片
 *  @param assets
 */
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets{
    
    if(photos!=nil&&photos.count>0)
    {
        
        UpImageModel * upImage;
        Count=imgArray.count-1;//上传计数初值
        Count=Count<0?0:Count;
        UIImage *img;
        for(int i=0;i<photos.count;i++)
        {
            upImage=[UpImageModel new];
            img=[photos objectAtIndex:i];
            img=[ImageUitls imageCompressForWidth:img targetWidth:PIC_PIXEL_W];
            img=[ImageUitls reduceImage:img percent:PIC_SCALING];
            upImage.img=img;
            upImage.isUpLoad=0;

            [imgArray addObject:upImage];
        }
        
        
        for (int i = 0; i < imgArray.count; i++) {
            if (imgArray.count == 1) {
                return;
            }else if (imgArray.count > 1 && imgArray.count <= 4) {
                
                if (i == imgArray.count - 1) {
                    
                }else {
                    if ([imgArray[i] isKindOfClass:[NSString class]]) {
                        [imgArray removeObjectAtIndex:i];
                    }
                }
                
            }else {
                if ([imgArray[i] isKindOfClass:[NSString class]]) {
                    [imgArray removeObjectAtIndex:i];
                }
            }
        }
        
        if (imgArray.count < 4) {
            [imgArray addObject:@""];
        }
//        if (imgArray.count > 4) {
//            [imgArray removeObjectAtIndex:imgArray.count - 1];
//        }
        [self upLoadImgForImg];
        [self.collectionView reloadData];
        
    }
    
    [self.collectionView reloadData];
    
}

@end
