//
//  NSDate+Common.h
//  TIMChat
//
//  Created by AlexiChen on 16/3/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kMinuteTimeInterval (60)
#define kHourTimeInterval   (60 * kMinuteTimeInterval)
#define kDayTimeInterval    (24 * kHourTimeInterval)
#define kWeekTimeInterval   (7  * kDayTimeInterval)
#define kMonthTimeInterval  (30 * kDayTimeInterval)
#define kYearTimeInterval   (12 * kMonthTimeInterval)

@interface NSDate (Common)

- (BOOL)isToday;

- (BOOL)isYesterday;

- (NSString *)shortTimeTextOfDate;

- (NSString *)timeTextOfDate;

/** 不进行时差纠正 */
- (NSString *) stringForNormalDataFormatter:(NSString *)formatter;
/** 进行时差纠正 */
- (NSString *) stringForDataFormatter:(NSString *)formatter;
/** 时差纠正之后的时间 */
- (NSDate *) solveOffset;

- (NSArray *)getWeekDateInfo;

- (NSInteger) getWeekDay;

- (NSInteger) getDay;

- (NSInteger) getMonth;
@end
