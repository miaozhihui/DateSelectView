//
//  DatePickView.m
//  DateSelectView
//
//  Created by miaozhihui on 16/1/5.
//  Copyright © 2016年 DeKuTree. All rights reserved.
//

#define screenWidth [UIScreen mainScreen].bounds.size.width
#define pickerWidth screenWidth/9
#define viewWidth self.bounds.size.width
#define viewHeight self.bounds.size.height
#define titleColor [UIColor colorWithRed:0.55f green:0.55f blue:0.55f alpha:1.00f]
#define contentColor [UIColor colorWithRed:0.48f green:0.48f blue:0.48f alpha:1.00f]

#import "DatePickView.h"

@implementation DatePickView
{
    //年、月、日PickerView
    UIPickerView *_yearPickerView;
    UIPickerView *_monthPickerView;
    UIPickerView *_dayPickerView;
    //年、月、日数组
    NSMutableArray *_yearArray;
    NSMutableArray *_monthArray;
    NSMutableArray *_dayArray;
    NSMutableArray *_daysArray;
    //日期、星期
    UILabel *_dateLabel;
    UILabel *_weekLabel;
    //年、月、日
    NSString *_year;
    NSString *_month;
    NSString *_day;
    NSString *_week;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initDate];
        [self loadData];
        [self initSubViews];
        [self markSelect];
    }
    return self;
}
#pragma mark -
#pragma mark - 取系统当前日期给年、月、日、星期赋值
- (void)initDate
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate:currentDate];
    NSArray *dateArray = [dateStr componentsSeparatedByString:@"-"];
    _year = dateArray[0];
    
    _month = [NSString stringWithFormat:@"%d",[dateArray[1] intValue]];
    _day = [NSString stringWithFormat:@"%d",[dateArray[2] intValue]];
    _week = [self weekWithYear:[_year integerValue] month:[_month integerValue] day:[_day integerValue]];
}
#pragma mark -
#pragma mark - 给年、月、日数组添加值
- (void)loadData
{
    _yearArray = [NSMutableArray array];
    _monthArray = [NSMutableArray array];
    _dayArray = [NSMutableArray array];
    _daysArray = [NSMutableArray array];
    for(int i=1900;i<=2100;i++)
    {
        [_yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    for(int i=1;i<=12;i++)
    {
        [_monthArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    NSMutableArray *tempArray = nil;
    for(int i=0;i<4;i++)
    {
        if(i==0)
        {
            tempArray = [[NSMutableArray alloc] init];
            for(int j=1;j<=28;j++)
            {
                [tempArray addObject:[NSString stringWithFormat:@"%d",j]];
            }
            [_daysArray addObject: tempArray];
            tempArray = nil;
        }
        else if (i==1)
        {
            tempArray = [[NSMutableArray alloc] init];
            for(int j=1;j<=29;j++)
            {
                [tempArray addObject:[NSString stringWithFormat:@"%d",j]];
            }
            [_daysArray addObject: tempArray];
            tempArray = nil;
        }
        else if (i==2)
        {
            tempArray = [[NSMutableArray alloc] init];
            for(int j=1;j<=30;j++)
            {
                [tempArray addObject:[NSString stringWithFormat:@"%d",j]];
            }
            [_daysArray addObject: tempArray];
            tempArray = nil;
        }
        else if (i==3)
        {
            tempArray = [[NSMutableArray alloc] init];
            for(int j=1;j<=31;j++)
            {
                [tempArray addObject:[NSString stringWithFormat:@"%d",j]];
            }
            [_daysArray addObject: tempArray];
            tempArray = nil;
        }
    }
    _dayArray = [self getDaysWithYear:[_year integerValue] month:[_month integerValue]];
}
#pragma mark -
#pragma mark - 加载子控件
- (void)initSubViews
{
    // 顶部分割线
    UIView *topLineView = [[UIView alloc] init];
    topLineView.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    topLineView.frame = CGRectMake(0, 0, viewWidth , 1);
    [self addSubview:topLineView];
    // 工具条
    UIView *toolBarView = [[UIView alloc] init];
    toolBarView.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.00f];
    toolBarView.frame = CGRectMake(CGRectGetMinX(topLineView.frame), CGRectGetMaxY(topLineView.frame), CGRectGetWidth(topLineView.frame), 44);
    [self addSubview:toolBarView];
    // 工具条左侧label
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.adjustsFontSizeToFitWidth = YES;
    _dateLabel.textColor = titleColor;
    _dateLabel.text = [NSString stringWithFormat:@"%@年%@月%@日 %@",_year,_month,_day,_week];
    _dateLabel.frame = CGRectMake(10, 0, screenWidth*3/5, CGRectGetHeight(toolBarView.frame));
    [toolBarView addSubview:_dateLabel];
    // 工具条右侧功能键
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    confirmBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    confirmBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [confirmBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    confirmBtn.frame = CGRectMake(viewWidth-50-10, CGRectGetMinY(_dateLabel.frame), 50, CGRectGetHeight(_dateLabel.frame));
    [toolBarView addSubview:confirmBtn];
    // 底部分割线
    UIView *bottomLineView = [[UIView alloc] init];
    bottomLineView.backgroundColor = [UIColor colorWithRed:0.92f green:0.92f blue:0.92f alpha:1.00f];
    bottomLineView.frame = CGRectMake(CGRectGetMinX(topLineView.frame), CGRectGetMaxY(toolBarView.frame), CGRectGetWidth(topLineView.frame), 1);
    [self addSubview:bottomLineView];
    // 日历baseView
    UIView *baseView = [[UIView alloc] init];
    baseView.backgroundColor = [UIColor whiteColor];
    baseView.frame = CGRectMake(CGRectGetMinX(topLineView.frame), CGRectGetMaxY(bottomLineView.frame), CGRectGetWidth(topLineView.frame), viewHeight-CGRectGetMaxY(bottomLineView.frame));
    [self addSubview:baseView];
    // 选择年份pickerView
    _yearPickerView = [[UIPickerView alloc] init];
    _yearPickerView.dataSource = self;
    _yearPickerView.delegate = self;
    _yearPickerView.frame = CGRectMake(pickerWidth, 0, pickerWidth, CGRectGetHeight(baseView.frame));
    [baseView addSubview:_yearPickerView];
    // 年label
    UILabel *yearLabel = [[UILabel alloc] init];
    yearLabel.text = @"年";
    yearLabel.adjustsFontSizeToFitWidth = YES;
    yearLabel.textColor = contentColor;
    yearLabel.textAlignment = NSTextAlignmentCenter;
    yearLabel.frame = CGRectMake(CGRectGetMaxX(_yearPickerView.frame), CGRectGetMinY(_yearPickerView.frame), CGRectGetWidth(_yearPickerView.frame), CGRectGetHeight(_yearPickerView.frame));
    [baseView addSubview:yearLabel];
    // 选择月份pickerView
    _monthPickerView = [[UIPickerView alloc] init];
    _monthPickerView.dataSource = self;
    _monthPickerView.delegate = self;
    _monthPickerView.frame = CGRectMake(CGRectGetMaxX(yearLabel.frame), CGRectGetMinY(_yearPickerView.frame), CGRectGetWidth(_yearPickerView.frame), CGRectGetHeight(_yearPickerView.frame));
    [baseView addSubview:_monthPickerView];
    // 月label
    UILabel *monthLabel = [[UILabel alloc] init];
    monthLabel.text = @"月";
    monthLabel.adjustsFontSizeToFitWidth = YES;
    monthLabel.textColor = contentColor;
    monthLabel.textAlignment = NSTextAlignmentCenter;
    monthLabel.frame = CGRectMake(CGRectGetMaxX(_monthPickerView.frame), CGRectGetMinY(_yearPickerView.frame), CGRectGetWidth(_yearPickerView.frame), CGRectGetHeight(_yearPickerView.frame));
    [baseView addSubview:monthLabel];
    // 选择日pickerView
    _dayPickerView = [[UIPickerView alloc] init];
    _dayPickerView.dataSource = self;
    _dayPickerView.delegate = self;
    _dayPickerView.frame = CGRectMake(CGRectGetMaxX(monthLabel.frame), CGRectGetMinY(_yearPickerView.frame), CGRectGetWidth(_yearPickerView.frame), CGRectGetHeight(_yearPickerView.frame));
    [baseView addSubview:_dayPickerView];
    // 日label
    UILabel *dayLabel = [[UILabel alloc] init];
    dayLabel.text = @"日";
    dayLabel.adjustsFontSizeToFitWidth = YES;
    dayLabel.textColor = contentColor;
    dayLabel.textAlignment = NSTextAlignmentCenter;
    dayLabel.frame = CGRectMake(CGRectGetMaxX(_dayPickerView.frame), CGRectGetMinY(_yearPickerView.frame), CGRectGetWidth(_yearPickerView.frame), CGRectGetHeight(_yearPickerView.frame));
    [baseView addSubview:dayLabel];
    // 星期label
    _weekLabel = [[UILabel alloc] init];
    _weekLabel.text = _week;
    _weekLabel.adjustsFontSizeToFitWidth = YES;
    _weekLabel.textColor = contentColor;
    _weekLabel.textAlignment = NSTextAlignmentCenter;
    _weekLabel.frame = CGRectMake(CGRectGetMaxX(dayLabel.frame), CGRectGetMinY(_yearPickerView.frame), CGRectGetWidth(_yearPickerView.frame), CGRectGetHeight(_yearPickerView.frame));
    [baseView addSubview:_weekLabel];
}
#pragma mark -
#pragma mark - 默认选中当前日期
- (void)markSelect
{
    for (int i=0; i<_yearArray.count; i++)
    {
        if([_year isEqualToString:_yearArray[i]])
        {
            [_yearPickerView selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
    for (int i=0; i<_monthArray.count; i++)
    {
        if([_month isEqualToString:_monthArray[i]])
        {
            [_monthPickerView selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
    for (int i=0; i<_dayArray.count; i++)
    {
        if([_day isEqualToString:_dayArray[i]])
        {
            [_dayPickerView selectRow:i inComponent:0 animated:YES];
            break;
        }
    }
}
#pragma mark -
#pragma mark - 根据年、月、日计算星期
- (NSString *)weekWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSString *week = nil;
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorian dateFromComponents:comps];
    NSDateComponents *weekComps = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    long weekDay = [weekComps weekday]-1;
    switch (weekDay)
    {
        case 1:
            week = @"周一";
            break;
        case 2:
            week = @"周二";
            break;
        case 3:
            week = @"周三";
            break;
        case 4:
            week = @"周四";
            break;
        case 5:
            week = @"周五";
            break;
        case 6:
            week = @"周六";
            break;
        case 0:
            week = @"周日";
            break;
        default:
            break;
    }
    return week;
}
#pragma mark -
#pragma mark - 判断是否是闰年
- (BOOL)isLeapYear:(NSInteger)year
{
    BOOL flag = NO;
    if(year%400==0||(year%4==0&&year%100!=0))
    {
        flag = YES;
    }
    return flag;
}
#pragma mark -
#pragma mark - 根据年月返回月份的天数
- (NSMutableArray *)getDaysWithYear:(NSInteger)year month:(NSInteger)month
{
    NSMutableArray *tempArray = [NSMutableArray array];
    switch (month)
    {
        case 2:
            if(![self isLeapYear:year])
            {
                tempArray = _daysArray[0];
            }
            else
            {
                tempArray = _daysArray[1];
            }
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            tempArray = _daysArray[2];
            break;
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            tempArray = _daysArray[3];
            break;
        default:
            break;
    }
    return tempArray;
}
#pragma mark -
#pragma mark - 确认按钮点击事件
- (void)doneClick
{
    if ([self isBlankString:_year])
    {
        _year = _yearArray[0];
    }
    if ([self isBlankString:_month])
    {
        _month = _monthArray[0];
    }
    if ([self isBlankString:_day])
    {
        _day = _dayArray[0];
    }
    [_delegate datePickView:self year:_year month:_month day:_day];
}
#pragma mark -
#pragma mark - 判断是否是空字符串(YES 是 NO 不是)
-(BOOL)isBlankString:(NSString *)string
{
    if (string == nil)
    {
        return YES;
    }
    if (string == NULL)
    {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]])
    {
        return YES;
    }
    // 把字符串里的空格和换行替换掉检测原字符串的长度是否大于0
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0)
    {
        return YES;
    }
    return NO;
}
#pragma mark -
#pragma mark - pickerView数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == _yearPickerView)
    {
        return _yearArray.count;
    }
    else if (pickerView == _monthPickerView)
    {
        return _monthArray.count;
    }
    else
    {
        return _dayArray.count;
    }
}
#pragma mark -
#pragma mark - pickerView代理方法
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 44;
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = (UILabel *)view;
    if(label == nil)
    {
        label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = contentColor;
        label.adjustsFontSizeToFitWidth = YES;
    }
    if(pickerView == _yearPickerView)
    {
        label.text = [NSString stringWithFormat:@"%@",_yearArray[row]];
    }
    else if (pickerView == _monthPickerView)
    {
        label.text = [NSString stringWithFormat:@"%@",_monthArray[row]];
    }
    else
    {
        label.text = [NSString stringWithFormat:@"%@",_dayArray[row]];
    }
    return label;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView == _yearPickerView)
    {
        _year = _yearArray[row];
        
    }
    else if (pickerView == _monthPickerView)
    {
        _month = _monthArray[row];
    }
    else if (pickerView == _dayPickerView)
    {
        _day = _dayArray[row];
    }
    _dayArray = [self getDaysWithYear:[_year integerValue] month:[_month integerValue]];
    [_dayPickerView reloadAllComponents];
    NSString *lastDay = [_dayArray lastObject];
    if(_day.intValue>lastDay.intValue)
    {
        _day = lastDay;
    }
    _week = [self weekWithYear:[_year integerValue] month:[_month integerValue] day:[_day integerValue]];
    _weekLabel.text = _week;
    _dateLabel.text = [NSString stringWithFormat:@"%@年%@月%@日 %@",_year,_month,_day,_week];
}

@end
