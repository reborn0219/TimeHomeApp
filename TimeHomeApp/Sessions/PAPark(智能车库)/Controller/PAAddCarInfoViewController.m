//
//  PAddVehicleInformationViewController.m
//  TimeHomeApp
//
//  Created by 优思科技 on 2018/4/8.
//  Copyright © 2018年 石家庄优思交通智能科技有限公司. All rights reserved.
//

#import "PAAddCarInfoViewController.h"
#import "PAChooseLicensePlateNumberView.h"
#import "PAHaveBindingVehiclesTableViewCell.h"
#import "PAPopupTool.h"
#import "RegularUtils.h"
#import "PAUpdateRelationCarNoRequest.h"
#import "PAUpdateRelationService.h"
#import "MessageAlert.h"

@interface PAAddCarInfoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,PAUpdateCompleteDelegate>

@property (weak, nonatomic) IBOutlet UILabel *unboundedLabel;
@property (weak, nonatomic) IBOutlet UILabel *bindingLabel;
@property (weak, nonatomic) IBOutlet UITextField *carOwnerNameTextField;
@property (weak, nonatomic) IBOutlet UITableView *carTable;
@property (weak, nonatomic) IBOutlet UITextField *carNumberTextField;
@property (weak, nonatomic) IBOutlet UILabel *provinceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBbindingButton;
@property (nonatomic, strong) PAUpdateRelationService *paService;

@end

@implementation PAAddCarInfoViewController

#pragma mark - LifeCircle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initializeUI:self.type];
    
    if (_type == AddCarInfoControllerJumpTypeRelation) {
    
        NSString *sapceID = self.spaceModel.spaceId?:@"";
        [self.paService loadData:sapceID];
        
    }
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
#pragma mark - 初始化UI
-(void)initializeUI:(NSInteger)type
{
    AppDelegate * appdelegate = GetAppDelegates;
    self.navigationItem.title = appdelegate.userData.communityname;
  
    if (type == AddCarInfoControllerJumpTypeUpdate){
        
        [self.bindingLabel setHidden:YES];
        [self.unboundedLabel setHidden:YES];
        [self.carTable setHidden:YES];
        self.navigationItem.title = @"修改车牌";
        [self.addBbindingButton setTitle:@"确定" forState:UIControlStateNormal];
        _carNumberTextField.text = [self.vehicleModel.carNo substringFromIndex:1];
        _provinceLabel.text = [self.vehicleModel.carNo substringToIndex:1];
        
    }else if(type== AddCarInfoControllerJumpTypeRelation){
        
        [self.bindingLabel setHidden:NO];
        [self.unboundedLabel setHidden:NO];
        [self.carTable setHidden:NO];
        [self.addBbindingButton setTitle:@"添加到列表" forState:UIControlStateNormal];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightButton.frame = CGRectMake(0, 0, 35, 30);
        [rightButton setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
        rightButton.tag = 2;
        rightButton.titleLabel.font = DEFAULT_FONT(15);
        [rightButton setTitle:@"保存" forState:UIControlStateNormal];
        [rightButton addTarget:self action:@selector(addCarNoActon) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightBarButton;
        
    }else if(type == AddCarInfoControllerJumpTypeBatchUpdate){
        
        [self.bindingLabel setHidden:YES];
        [self.unboundedLabel setHidden:YES];
        [self.carTable setHidden:YES];
        self.navigationItem.title = @"修改车牌";
        [self.addBbindingButton setTitle:@"确定" forState:UIControlStateNormal];
        _carNumberTextField.text = [self.vehicleModel.carNo substringFromIndex:1];
        _provinceLabel.text = [self.vehicleModel.carNo substringToIndex:1];
    }
    
    [self.carTable registerNib:[UINib nibWithNibName:@"PAHaveBindingVehiclesTableViewCell" bundle:nil] forCellReuseIdentifier:@"PAHaveBindingVehiclesTableViewCell"];
    self.carTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.carTable setBackgroundColor:[UIColor clearColor]];
    
    [[PAPopupTool sharePAPopupTool]showProvincesKeyBoard:^(id  _Nullable data, ResultCode resultCode) {
        self.provinceLabel.text = data;
    }];
    
}
-(PAUpdateRelationService *)paService{
    
    if (!_paService) {
        _paService = [[PAUpdateRelationService alloc]init];
        _paService.delegagte = self;
    }
    
    return _paService;
}

#pragma mark - IBActions
- (IBAction)selectProvincesAction:(id)sender {

    [self.carNumberTextField resignFirstResponder];
    [self.carOwnerNameTextField resignFirstResponder];

    [[PAPopupTool sharePAPopupTool] popupKeyBoard:YES];
    
}

- (IBAction)addBbindingAction:(id)sender {
    
    if (_type == AddCarInfoControllerJumpTypeRelation) {
        
        //添加到列表
        NSString * carNo = [NSString stringWithFormat:@"%@%@",_provinceLabel.text,_carNumberTextField.text];
        
        NSMutableString *convertedString = [carNo mutableCopy];
        CFStringTransform((CFMutableStringRef)convertedString, NULL, kCFStringTransformFullwidthHalfwidth, false);
        carNo = convertedString;
        
        if(![RegularUtils isCarNum:carNo])//车牌号验证
        {
            [self showToastMsg:@"请输入5/6位车牌号" Duration:5.0];
            return;
        }
        PACarManagementModel * model = [[PACarManagementModel alloc]init];
        model.carNo =carNo;
        model.isSelected = YES;
        model.ownerName = self.carOwnerNameTextField.text?self.carOwnerNameTextField.text:@"";
        for (int i = 0; i<self.paService.carDataArray.count; i++) {
            PACarManagementModel * tempModel= [self.paService.carDataArray objectAtIndex:i];
            if ([model.carNo isEqualToString:tempModel.carNo]) {
                [self.paService.carDataArray removeObject:tempModel];
            }
            
        }
        if (self.paService.carDataArray == nil) {
            self.paService.carDataArray = [[NSMutableArray alloc]initWithCapacity:0];
        }
        [self.paService.carDataArray insertObject:model atIndex:0];
        [self requestUnRelationCompleted];
        [self.carTable reloadData];
        [self crateAlertWith:carNo];
        
        
    }else{
        
        //修改 返回
        NSString * carNo = [NSString stringWithFormat:@"%@%@",_provinceLabel.text,_carNumberTextField.text];
        if(![RegularUtils isCarNum:carNo])//车牌号验证
        {
            [self showToastMsg:@"请输入5/6位车牌号" Duration:5.0];
            return;
        }
        if(_type == AddCarInfoControllerJumpTypeBatchUpdate){
            
            AppDelegate * appdelegate = GetAppDelegates;
            [self.paService batchChangeRelationCarNO:self.vehicleModel.carNo updateCarNo:carNo communityID:appdelegate.userData.communityid?appdelegate.userData.communityid:@""];
            
        }else if(_type == AddCarInfoControllerJumpTypeUpdate){
            
            [self.paService changeCarNo:carNo ownerName:self.carOwnerNameTextField.text?self.carOwnerNameTextField.text:@"" spaceID:self.spaceModel.spaceId carID:self.vehicleModel.vehicleID];
        }
        
        
    }
    
    
    
}

- (IBAction)carNumberChanged:(UITextField *)sender {
    
    UITextRange * selectedRange = sender.markedTextRange;
    sender.text = [sender.text uppercaseString];
    
    if(selectedRange == nil || selectedRange.empty){
        
        if(sender.text.length>7)
        {
            sender.text=[sender.text substringToIndex:7];
        }else{
            
            NSString *infoText = sender.text;
            if (infoText.length > 0) {
                infoText = [infoText substringFromIndex:infoText.length - 1];
            }
            if ([infoText isEqualToString:@"o"] || [infoText isEqualToString:@"i"] || [infoText isEqualToString:@"O"] || [infoText isEqualToString:@"I"]) {
                
                sender.text = [sender.text substringToIndex:sender.text.length - 1];
                
                [self showToastMsg:@"根据国家法律法规，车牌号不允许添加O 或者 I" Duration:3.0];
            }
        }
    }
}
#pragma mark - 添加绑定事件
-(void)addCarNoActon{
    
    [self.paService relationCar:[self changeModelToArray] spaceID:self.spaceModel.spaceId];
    
}
///添加提示
- (void)crateAlertWith:(NSString *)string {
    
    MessageAlert *alert = [MessageAlert getInstance];
    NSString *str = [NSString stringWithFormat:@"车辆 %@ 已添加到下方列表",string];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc]initWithString:str attributes:@{NSFontAttributeName:DEFAULT_FONT(16)}];
    [attributeString addAttribute:NSForegroundColorAttributeName value:TITLE_TEXT_COLOR range:NSMakeRange(2,string.length + 2)];
    [attributeString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(2,string.length + 2)];
    alert.isNull = YES;
    [alert newShowInVC:self withTitle:attributeString andCancelBtnTitle:@"继续添加" andOtherBtnTitle:@"完成"];
    alert.okBtn.backgroundColor = [UIColor whiteColor];
    alert.okBtn.layer.borderColor = TEXT_COLOR.CGColor;
    alert.okBtn.layer.borderWidth = 1.f;
    [alert.okBtn setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    alert.cancelBtn.layer.borderColor = TEXT_COLOR.CGColor;
    alert.cancelBtn.layer.borderWidth = 1.f;
    [alert.cancelBtn setTitleColor:TITLE_TEXT_COLOR forState:UIControlStateNormal];
    alert.block = ^(id _Nullable data,UIView *_Nullable view,NSInteger index)
    {
        if (index==Ok_Type) {

            [self addCarNoActon];
            
        }else if (index == Cancel_Type) {
            //继续添加
       
            self.carNumberTextField.text = @"";
            self.carOwnerNameTextField.text = @"";
            
        }
        
    };
    
}

#pragma mark - Helper
-(NSArray *)changeModelToArray{
    
    NSMutableArray * carArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (PACarManagementModel *model in self.paService.carDataArray) {
        
        NSDictionary * dic = @{
                               @"carNo": model.carNo,
                               @"ownerName": model.ownerName?model.ownerName:@"",
                               @"spaceId": self.spaceModel.spaceId,
                               };
        
        if (model.isSelected) {
            [carArr addObject:dic];
        }
        
    }
    return carArr;
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[PAPopupTool sharePAPopupTool] popupKeyBoard:NO];

}

#pragma mark - TableViewDelegate/DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PAHaveBindingVehiclesTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PAHaveBindingVehiclesTableViewCell"];
    PACarManagementModel * model = [self.paService.carDataArray objectAtIndex:indexPath.row];
    [cell assignmentWithModel:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.paService.carDataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [[PAPopupTool sharePAPopupTool] popupKeyBoard:NO];
    PACarManagementModel * model = [self.paService.carDataArray objectAtIndex:indexPath.row];
    model.isSelected = !model.isSelected;
    [tableView reloadData];

}

#pragma mark - Request
-(void)requestRelationCarCompleted:(NSInteger)type{
    
    if (type == 1) {
        
        [self.navigationController popViewControllerAnimated:YES];
        if (self.block) {
            self.block(nil, SucceedCode);
        }
        [self showToastMsg:@"保存成功！" Duration:2.5f];

    }else{
        
        [self showToastMsg:@"保存失败！" Duration:2.5f];
        
    }
}

-(void)requestUnRelationCompleted{
    
    if (self.paService.carDataArray==nil||self.paService.carDataArray.count==0) {
        
        [self.unboundedLabel setHidden:NO];
        [self.bindingLabel setHidden:YES];
        [self.carTable setHidden:YES];
        
    }else{
        
        [self.unboundedLabel setHidden:YES];
        [self.bindingLabel setHidden:NO];
        [self.carTable setHidden:NO];
        [self.carTable reloadData];
        
    }
}

-(void)requestUpdateCompleted:(NSInteger)type
{
    if (type == 1) {
        //成功
        [self showToastMsg:@"修改成功!" Duration:2.0f];
        [self.navigationController popViewControllerAnimated:YES];
        if (self.block) {
            self.block(nil, SucceedCode);
        }
    }else{
        //失败
        [self showToastMsg:@"修改失败!" Duration:2.0f];
    }
}


@end
