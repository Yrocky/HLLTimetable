//
//  HLLEvent.h
//  HLLCalendar
//
//  Created by Rocky Young on 2017/3/9.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HLLEventStatus) {
    
    HLLEventStatusNormal,
    HLLEventStatusAppointment,
    HLLEventStatusFinish,
    HLLEventStatusLiving
};

@interface HLLEvent : NSObject

@property (nonatomic ,assign ,getter=isEmpty) BOOL empty;

@property (nonatomic ,strong) NSString * title;
@property (nonatomic ,strong) NSString * dateString;
@property (nonatomic ,assign) HLLEventStatus status;

@property (nonatomic ,strong) NSString * statusText;
@property (nonatomic ,strong) UIColor * statusColor;

+ (instancetype) emptyEvent;
+ (instancetype) event;

/// test
+ (instancetype) normal;
+ (instancetype) finish;
+ (instancetype) living;
+ (instancetype) appotionment;

@end

@interface NSArray (SortForEvent)

- (NSArray *) sortEvent;

@end

@interface HLLWeekDay : NSObject

@property (nonatomic ,strong) NSString * week;
@property (nonatomic ,strong) NSString * day;

+ (NSArray<HLLWeekDay *> *)weekDays;
+ (NSInteger) todayIndex;
+ (NSString *) todayWeek;
@end
