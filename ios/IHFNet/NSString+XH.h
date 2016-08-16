
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (XH)
/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;
- (CGFloat)calculateLabelHeightWithText:(NSString *)labelText LabelWidth:(CGFloat )width Font:(UIFont *)font;

/**
 *  字符串判空操作
 */
+ (NSString *)stringIsNull:(id)str;
- (NSString *)stringIsNull:(id)str;

//+(NSString *)whichweek:(NSString *)dateStr;
//+(NSString *)whichDateweek:(NSDate *)date;

/**
 *  字典转Json字符串
 */
+ (NSString*)convertToJSONData:(id)infoDict;

/**
 *  @brief  将一个字符串中的换行符(\n)和空格(" ")替换为"\r\n",PHP接口专用
 *
 *  @param str 包含\n换行符的字符串
 *
 *  @return string--- 去除换行符之后的字符串
 */
- (NSString *)replaceNewlinesymbolOfWithNewSymbol:(NSString *)str;
- (NSString *)replaceNewlinesymbolOfNWithNewSymbol:(NSString *)str;

/**
 *  将字符串中间包含的特殊符号去除
 */
+ (NSString *)removeSpecialCharacterOfString:(NSString *)str;

+ (NSString *)removeBlankCharacterOfString:(NSString *)str;

/**
 *  NSDate类型的日期转为NSString类型的日期格式
 */
+ (NSString *)dateTimeToStringTime1:(NSDate *)date;
+ (NSString *)dateTimeToStringTime2:(NSDate *)date;

/**
 *  @author Hanrovey, 16-04-05 11:04:41
 *  拼接新的时间字符串格式
 */
+ (NSString *)spellNewDateFormatter:(NSString *)str;
+ (NSString *)spellNewBirthdatetimeFormatter:(NSString *)str;
+ (NSString *)spellNewClocktimeFormatter:(NSString *)str;

/*!
 *  判断字符串知否为为空 是NULL 返回@""
 */
NSString *Empty(NSString *string);

NSString *RandomEmpty(NSString *string);

/*!
 *  转置相反字符串
 */
NSString *OppositeString(NSString *string);

/*!
 *  删除字符串前缀
 */
NSString *CutPrefixString(NSString *string,NSString *prefixStr);


/**
 *  @author Hanrovey, 16-04-19 10:04:27
 *
 *  获取当前时间
 */
+ (NSString *)getCurrentTime;

/**
 *  @author Hanrovey, 16-04-27 16:04:54
 *  NSDate转NSString
 */
+ (NSString *)stringFromDate:(NSDate *)date;

/**
 *  @author Hanrovey, 16-04-19 10:04:27
 *  获取时间戳
 */
+ (NSString *)convertTimeStamp:(NSString *)timeStr;

/**
 *  @author Hanrovey, 16-05-10 16:05:05
 *
 *  @brief  汉字转拼音
 */
+ (NSString *)transformChineseToPinyin:(NSString *)chinese;

/**
 *  @author Hanrovey, 16-06-28 14:06:57
 *  转换序列时间格式
 */
+ (NSString *)respellSeriesTime:(NSString *)time;

/**
 *  @author Hanrovey, 16-06-28 14:06:57
 *  转换序列时间格式
 */
+ (NSString *)respellStudydate:(NSString *)time;

/**
 *  @author Hanrovey, 16-07-04 18:07:17
 *
 *  时间戳转日期
 */
+ (NSDate *)transformTimestampToDate:(NSString *)timestamp;
@end
