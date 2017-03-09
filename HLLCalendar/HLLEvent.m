//
//  HLLEvent.m
//  HLLCalendar
//
//  Created by Rocky Young on 2017/3/9.
//  Copyright © 2017年 Rocky Young. All rights reserved.
//

#import "HLLEvent.h"
#import "UIColor+Common.h"
#import "NSDate+Common.h"

@implementation HLLEvent

+ (instancetype) emptyEvent{
    
    HLLEvent * event = [[HLLEvent alloc] init];
    event.empty = YES;
    return event;
}

+ (instancetype) event{
    
    HLLEvent * event = [[HLLEvent alloc] init];
    return event;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.empty = NO;
        
        self.title = @"xxxxx";
        self.dateString = @"00:00-00:50";
    }
    return self;
}

// test
+ (instancetype) normal{
    
    HLLEvent * event = [[HLLEvent alloc] init];
    event.status = HLLEventStatusNormal;
    return event;
}
+ (instancetype) finish{
    HLLEvent * event = [[HLLEvent alloc] init];
    event.status = HLLEventStatusFinish;
    return event;
}
+ (instancetype) living{
    HLLEvent * event = [[HLLEvent alloc] init];
    event.status = HLLEventStatusLiving;
    return event;
}
+ (instancetype) appotionment{
    HLLEvent * event = [[HLLEvent alloc] init];
    event.status = HLLEventStatusAppointment;
    return event;
}

- (void)setStatus:(HLLEventStatus)status{
    
    switch (status) {
        case HLLEventStatusAppointment:
            self.statusText = @"点名！！！";
            self.statusColor = [UIColor colorWithHexString:@"FF6655"];
            break;
            
        case HLLEventStatusFinish:
            self.statusText = @"懒得去";
            self.statusColor = [UIColor colorWithHexString:@"B7B7B7"];
            break;
            
        case HLLEventStatusLiving:
            self.statusText = @"很感兴趣";
            self.statusColor = [UIColor colorWithHexString:@"53B1D9"];
            break;
            
        case HLLEventStatusNormal:
            self.statusText = @"可能点名";
            self.statusColor = [UIColor colorWithHexString:@"F2BB5A"];
            break;
        default:
            self.statusText = @"";
            self.statusColor = [UIColor whiteColor];
            break;
    }
}
@end


@implementation HLLWeekDay

+ (NSArray<HLLWeekDay *> *)weekDays{
    
    NSArray * weeks = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSArray * days = [[NSDate date] getWeekDateInfo];
    
    NSMutableArray * weekDays = [NSMutableArray array];
    
    for (NSInteger index = 0; index < weeks.count; index ++) {
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        
        //
        NSDate * day = days[index];
        NSDate * yesterday = [day dateByAddingTimeInterval: -kDayTimeInterval];
        
        [dateFormatter setDateFormat:@"d"];
        NSString * formatterDay = [dateFormatter stringFromDate:yesterday];
        
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        
        NSString * week = weeks[index];
        HLLWeekDay * weekDay = [[HLLWeekDay alloc] init];
        weekDay.week = week;
        weekDay.day = formatterDay;
        
        [weekDays addObject:weekDay];
    }
    
    return weekDays;
}

+ (NSInteger) todayIndex{
    
    NSArray * weeks = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSArray * days = [[NSDate date] getWeekDateInfo];
    
    for (NSInteger index = 0; index < weeks.count; index ++) {
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        
        //
        NSDate * day = days[index];
        NSDate * yesterday = [day dateByAddingTimeInterval: -kDayTimeInterval];
        
        [dateFormatter setDateFormat:@"dd"];
        NSString * formatterDay = [dateFormatter stringFromDate:yesterday];
        NSString * todayFromatterDay = [dateFormatter stringFromDate:[NSDate date]];
        
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        
        if ([todayFromatterDay isEqualToString:formatterDay]) {
            
            return index;
        }
    }
    return NSNotFound;
}

+ (NSString *) todayWeek{

    NSArray * weeks = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSArray * days = [[NSDate date] getWeekDateInfo];
    
    for (NSInteger index = 0; index < weeks.count; index ++) {
        
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        
        //
        NSDate * day = days[index];
        NSDate * yesterday = [day dateByAddingTimeInterval: -kDayTimeInterval];
        
        [dateFormatter setDateFormat:@"dd"];
        NSString * formatterDay = [dateFormatter stringFromDate:yesterday];
        NSString * todayFromatterDay = [dateFormatter stringFromDate:[NSDate date]];
        
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        
        if ([todayFromatterDay isEqualToString:formatterDay]) {
            
            return weeks[index];
        }
    }
    return @"";
}
@end
