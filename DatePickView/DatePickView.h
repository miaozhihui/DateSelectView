//
//  DatePickView.h
//  DateSelectView
//
//  Created by miaozhihui on 16/1/5.
//  Copyright © 2016年 DeKuTree. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DataPickerHeight  216

@class DatePickView;

@protocol DatePickViewDelegate <NSObject>

@required
- (void)datePickView:(DatePickView *) datePickView year:(NSString *)year month:(NSString *)month day:(NSString *)day;

@end

@interface DatePickView : UIView<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,weak) id<DatePickViewDelegate>delegate;

@end
