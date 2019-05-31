//
//  THOwnerAuthViewController.m
//  TimeHomeApp
//
//  Created by 世博 on 16/3/21.
//  Copyright © 2016年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "THOwnerAuthViewController.h"
#import "THBaseTableViewCell.h"
#import "THInPutTVC.h"
/**
 *  网络请求
 */
#import "CommunityManagerPresenters.h"

@interface THOwnerAuthViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *titles;
    NSArray *detailTitles;
    UserData *userData;
}
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation THOwnerAuthViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"业主认证";
    
    titles = @[@[@"小    区",@"手机号"],@[@"",@"姓    名",@"楼    栋",@"房    号",@""]];

//    titles = @[@[@"小    区",@"手机号"],@[@"",@"姓    名",@"楼    区",@"楼    栋",@"单    元",@"房    号",@""]];

    AppDelegate *appDelegate = GetAppDelegates;
    
    NSString *string = _user.name;
    if (![XYString isBlankString:_user.certbuiding]) {
        string = [string stringByAppendingFormat:@" %@",_user.certbuiding];
    }
    if (![XYString isBlankString:_user.certnumber]) {
        string = [string stringByAppendingFormat:@" %@",_user.certnumber];
    }
    detailTitles = @[@[[XYString IsNotNull:string],appDelegate.userData.phone],@[@"",@"请输入您在物业登记的姓名",@"例：A区3号楼2单元",@"例：1802室",@""]];

//    detailTitles = @[@[[XYString IsNotNull:string],appDelegate.userData.phone],@[@"",@"请输入您在物业登记的姓名",@"例：A区3号楼2单元",@"例：A区3号楼2单元",@"例：A区3号楼2单元",@"例：1802室",@""]];
    [self createTableView];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    //如果从发帖页面推出，则销毁这个页面
    if ([_IDStr isEqualToString:@"postPush"]) {
        NSMutableArray *navigationArray = [[NSMutableArray alloc] initWithArray: self.navigationController.viewControllers];
        
        [navigationArray removeObjectAtIndex: 1];  // 移除指定的controller
        self.navigationController.viewControllers = navigationArray;
        
    }
    
}

- (void)createTableView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-(44+statuBar_Height)) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = BLACKGROUND_COLOR;
    [_tableView registerClass:[THBaseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([THBaseTableViewCell class])];
    [_tableView registerClass:[THInPutTVC class] forCellReuseIdentifier:NSStringFromClass([THInPutTVC class])];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];

}
#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return titles.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [titles[0] count];
    }
    return [titles[1] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.000001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }
    return 60;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = BLACKGROUND_COLOR;
    view.userInteractionEnabled = YES;
    if (section == 1) {
        UIButton *tjshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [tjshButton setBackgroundColor:kNewRedColor];
        [tjshButton setTitle:@"提 交 审 核" forState:UIControlStateNormal];
        tjshButton.titleLabel.font = DEFAULT_BOLDFONT(16);
        [tjshButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [view addSubview:tjshButton];
        [tjshButton addTarget:self action:@selector(tjshButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [tjshButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view).offset(20);
            make.width.equalTo(@(WidthSpace(584)));
            make.height.equalTo(@(WidthSpace(64)));
            make.centerX.equalTo(view.mas_centerX);
        }];
    }
    
    return view;
}
- (void)tjshButtonClick {
    @WeakObj(self);
    
    THInPutTVC *cell1 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    THInPutTVC *cell2 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    THInPutTVC *cell3 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
//    THInPutTVC *cell4 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
//    THInPutTVC *cell5 = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:1]];

    
    [cell1.phoneTF resignFirstResponder];
    [cell2.phoneTF resignFirstResponder];
    [cell3.phoneTF resignFirstResponder];
//    [cell4.phoneTF resignFirstResponder];
//    [cell5.phoneTF resignFirstResponder];
    
    NSString *name = cell1.phoneTF.text;
    NSString *buiding = cell2.phoneTF.text;
    NSString *number = cell3.phoneTF.text;

    THIndicatorVC *indicator = [THIndicatorVC sharedTHIndicatorVC];
    [indicator startAnimating:self.tabBarController];
    [CommunityManagerPresenters addCommcertificationName:name buiding:buiding number:number UpDataViewBlock:^(id  _Nullable data, ResultCode resultCode) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            if(resultCode == SucceedCode)
            {
                [selfWeak showToastMsg:@"信息提交成功，审核期限1-3天" Duration:3.0];
                [selfWeak.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [selfWeak showToastMsg:data Duration:3.0];
            }
        });

        
    }];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 ) {
        if (indexPath.row == 0 || indexPath.row == [titles[1] count]-1) {
            return 20;
        }
    }
    return 48;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        THBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THBaseTableViewCell class])];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.baseTableViewCellStyle = BaseTableViewCellStyleValue1;
        cell.leftLabel.textColor = TEXT_COLOR;
        cell.rightLabel.font = DEFAULT_FONT(16);
        cell.leftLabel.text = titles[indexPath.section][indexPath.row];
        cell.rightLabel.text = detailTitles[indexPath.section][indexPath.row];
        
        
        return cell;
    }else {
        
        
        
        if (indexPath.row == 0) {
            
            THBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THBaseTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.baseTableViewCellStyle = BaseTableViewCellStyleValue1;
            
            return cell;
            
        }else if (indexPath.row < [titles[1] count] - 1) {
            
            THInPutTVC *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THInPutTVC class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.rightViewLength = RightViewLengthLongToCellBorder;
            cell.leftTitleLabel.text = titles[indexPath.section][indexPath.row];
            cell.phoneTF.placeholder = detailTitles[indexPath.section][indexPath.row];
            [cell.phoneTF addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
            return cell;
        }else {
            
            THBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([THBaseTableViewCell class])];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.baseTableViewCellStyle = BaseTableViewCellStyleValue1;
            
            return cell;
        }

        
    }

}
- (void)textFieldDidChanged:(UITextField *)sender {
    
    THInPutTVC *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];

    if (sender == cell.phoneTF) {
        UITextRange * selectedRange = sender.markedTextRange;
        if(selectedRange == nil || selectedRange.empty){
            if(sender.text.length >= 4)
            {
                sender.text=[sender.text substringToIndex:4];
            }
        }
    }
    

}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = 13;
    if (indexPath.section == 1) {
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
