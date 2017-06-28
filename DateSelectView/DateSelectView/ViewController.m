//
//  ViewController.m
//  DateSelectView
//
//  Created by miaozhihui on 16/1/5.
//  Copyright © 2016年 DeKuTree. All rights reserved.
//

#import "ViewController.h"
#import "DatePickView.h"
@interface ViewController ()<DatePickViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    textField.backgroundColor = [UIColor greenColor];
    DatePickView *datePick = [[DatePickView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-DataPickerHeight, self.view.frame.size.width, DataPickerHeight)];
    datePick.delegate = self;
    textField.inputView = datePick;
    [self.view addSubview: textField];
    
}
#pragma mark -
#pragma mark - 实现代理方法，得到年月日，处理一些键盘收起的事件，网络请求的事件
- (void)datePickView:(DatePickView *)datePickView year:(NSString *)year month:(NSString *)month day:(NSString *)day
{
    [self.view endEditing:YES];
    NSLog(@"%@-%@-%@",year,month,day);
}
@end
