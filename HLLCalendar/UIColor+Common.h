//
//  UIColor+Common.h
//  CategoryDemo
//
//  Created by Youngrocky on 16/5/8.
//  Copyright © 2016年 Young Rocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Common)

@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) BOOL canProvideRGBComponents;
@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) UInt32 rgbHex;

#pragma mark - Instancetype Method

/**
 *  返回颜色的colorSpace
 */
- (NSString *)colorSpaceString;

/**
 *  返回颜色的RGB数组，redColor = @[1,0,0,1]
 */
- (NSArray *)arrayFromRGBAComponents;

/**
 *  {1.000, 0.000, 0.000, 1.000} = redColor
 */
- (NSString *)stringFromColor;
/**
 *  FF0000 = redColor
 */
- (NSString *)hexStringFromColor;

#pragma mark - Class Method

/**
 *  根据Hex字符串生成颜色实例，FF0000 = redColor
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

/**
 *  根据Hex字符串以及alpha生成颜色实例，FF0000 = redColor
 *
 */
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert andAlpha:(CGFloat)alpha;

/**
 *   返回一个随机颜色实例
 */
+ (UIColor *)randomColor;

/**
 *  根据RGBHex返回颜色实例，16711680 = redColor
 */
+ (UIColor *)colorWithRGBHex:(UInt32)hex;

@end
