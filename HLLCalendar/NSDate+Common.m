//
//  NSDate+Common.m
//  TIMChat
//
//  Created by AlexiChen on 16/3/16.
//  Copyright © 2016年 AlexiChen. All rights reserved.
//

#import "NSDate+Common.h"

@implementation NSDate (Common)

- (BOOL)isToday
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([today isEqualToDate:otherDate])
    {
        return YES;
    }
    return NO;
}

- (BOOL)isYesterday
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    NSDate *yesterday = [today dateByAddingTimeInterval: -kDayTimeInterval];
    
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    NSDate *otherDate = [cal dateFromComponents:components];
    
    if([yesterday isEqualToDate:otherDate])
    {
        return YES;
    }
    return NO;

}

- (NSString *)shortTimeTextOfDate
{
    NSDate *date = self;
    
    NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate date]];
    
    interval = -interval;
    
    if ([date isToday])
    {
        // 今天的消息
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"aHH:mm"];
        [dateFormat setAMSymbol:@"上午"];
        [dateFormat setPMSymbol:@"下午"];
        NSString *dateString = [dateFormat stringFromDate:date];
        return dateString;
    }
    else if ([date isYesterday])
    {
        // 昨天
        return @"昨天";
    }
    else if (interval < kWeekTimeInterval)
    {
        // 最近一周
        // 实例化一个NSDateFormatter对象
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        dateFormat.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormat setDateFormat:@"ccc"];
        NSString *dateString = [dateFormat stringFromDate:date];
        return dateString;
    }
    else
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        
        if ([components year] == [today year])
        {
            // 今年
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            
            [dateFormat setDateFormat:@"MM-dd"];
            NSString *dateString = [dateFormat stringFromDate:date];
            return dateString;
        }
        else
        {
            // 往年
            NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yy-MM-dd"];
            NSString *dateString = [dateFormat stringFromDate:date];
            return dateString;
            
        }
    }
    return nil;
}

- (NSString *)timeTextOfDate
{
    NSDate *date = self;
    
    NSTimeInterval interval = [date timeIntervalSinceDate:[NSDate date]];
    
    interval = -interval;
    
    // 今天的消息
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"aHH:mm"];
    [dateFormat setAMSymbol:@"上午"];
    [dateFormat setPMSymbol:@"下午"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    if ([date isToday])
    {
        // 今天的消息
        return dateString;
    }
    else if ([date isYesterday])
    {
        // 昨天
        return [NSString stringWithFormat:@"昨天 %@", dateString];
    }
    else if (interval < kWeekTimeInterval)
    {
        // 最近一周
        // 实例化一个NSDateFormatter对象
        NSDateFormatter* weekFor = [[NSDateFormatter alloc] init];
        weekFor.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [weekFor setDateFormat:@"ccc"];
        NSString *weekStr = [weekFor stringFromDate:date];
        return [NSString stringWithFormat:@"%@ %@", weekStr, dateString];
    }
    else
    {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
        
        NSDateComponents *today = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
        
        if ([components year] == [today year])
        {
            // 今年
            NSDateFormatter *mdFor = [[NSDateFormatter alloc] init];
            [mdFor setDateFormat:@"MM-dd"];
            NSString *mdStr = [mdFor stringFromDate:date];
            return [NSString stringWithFormat:@"%@ %@", mdStr, dateString];
        }
        else
        {
            // 往年
            NSDateFormatter *ymdFormat = [[NSDateFormatter alloc] init];
            [ymdFormat setDateFormat:@"yy-MM-dd"];
            NSString *ymdString = [ymdFormat stringFromDate:date];
            return [NSString stringWithFormat:@"%@ %@", ymdString, dateString];;
            
        }
    }
    return nil;
}

- (NSString *) stringForNormalDataFormatter:(NSString *)formatter{
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    [dateFormatter setDateFormat:formatter];
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *) stringForDataFormatter:(NSString *)formatter{
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    [dateFormatter setDateFormat:formatter];
    
    return [dateFormatter stringFromDate:[self solveOffset]];
}

- (NSDate *) solveOffset{
    
    NSTimeZone * localTimeZone = [NSTimeZone localTimeZone];
    //计算本地时间与时间时间的偏差
    NSInteger offset = [localTimeZone secondsFromGMTForDate:self];
    // 世界时间 + 偏差值 = 中国时区的时间
    return [self dateByAddingTimeInterval:offset];
}

- (NSArray *)getWeekDateInfo{
    
    NSTimeInterval test = [self timeIntervalSince1970];
    
    NSDate * nowDate = [NSDate dateWithTimeIntervalSince1970:test];
    
    NSDate * localDate = [nowDate solveOffset];// 正确的时间
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    calendar.timeZone = [NSTimeZone localTimeZone];
    
    NSDateComponents *comp = [calendar components: NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:localDate];
    
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
//    NSLog(@"\ntody:%@",localDate);
    
    NSDateComponents *weekdayComponents = [calendar components:NSCalendarUnitWeekday fromDate:localDate];
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    componentsToSubtract.day = - (weekdayComponents.weekday - calendar.firstWeekday);
    componentsToSubtract.day = (componentsToSubtract.day-7) % 7;
    
    NSDate *beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:localDate options:0];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour fromDate:beginningOfWeek];
    beginningOfWeek = [calendar dateFromComponents:components];
    componentsToSubtract.day = NSIntegerMax;
    
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {// 周日，但是显示的是周一
        
        firstDiff = -5;
        lastDiff = 1;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay + 2;
        lastDiff = 9 - weekDay;
    }
    
//    NSLog(@"firstDiff: %ld   lastDiff: %ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:localDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate * firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    
    
    NSDateComponents *lastDayComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:localDate];
    [lastDayComp setDay:day + lastDiff];
    NSDate * lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
    
    NSArray * nextFiveDate = [firstDayOfWeek nextDatesArray:5];
    
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:7];
    [result addObject:firstDayOfWeek];
    [result addObjectsFromArray:nextFiveDate];
    [result addObject:lastDayOfWeek];
    
    return result;
}

- (NSArray *) nextDatesArray:(NSInteger)number{
    
    NSMutableArray * array = [NSMutableArray arrayWithCapacity:number];
    
    NSDate * nextDate = [[self solveOffset] nextDate];
    while (number) {
        
        [array addObject:nextDate];
        
        number --;
        
        nextDate = [[nextDate solveOffset] nextDate];
    }
    return array;
}

- (NSDate *)nextDate{
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[self solveOffset]];
    [components setDay:([components day]+1)];
    
    return [gregorian dateFromComponents:components];
}

- (NSInteger) getWeekDay{
    
    NSDate * localDate = self;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone localTimeZone];
    
    NSDateComponents *comp = [calendar components: NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:localDate];
    
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    
    weekDay--;
    
    if (weekDay == 0) {
        weekDay = 7;
    }
    
    return weekDay;
}

- (NSInteger) getDay{
    
    NSDate * localDate = self;// 正确的时间

    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone localTimeZone];
    
    NSDateComponents *comp = [calendar components: NSCalendarUnitDay | NSCalendarUnitWeekday fromDate:localDate];
    
    return [comp day];
}

- (NSInteger) getMonth{

    NSDate * localDate = self;// 正确的时间
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    calendar.timeZone = [NSTimeZone localTimeZone];
    
    NSDateComponents *comp = [calendar components: NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitMonth fromDate:localDate];
    
    return [comp month];
}

@end
