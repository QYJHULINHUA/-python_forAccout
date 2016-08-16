

#import "NSString+XH.h"

@implementation NSString (XH)
#pragma mark - 字符串的长度
- (CGSize )sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
- (CGFloat)calculateLabelHeightWithText:(NSString *)labelText LabelWidth:(CGFloat)width Font:(UIFont *)font{
    CGFloat height=[labelText boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.height;
    return height;
}

+ (NSString *)stringIsNull:(id)string
{

    if (![string isKindOfClass:[NSString class]])
    {
        string = [NSString stringWithFormat:@"%@",string];
    }
    
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"])
     {
        return @"";
         
         
     }else
     {
         
         return (NSString *)string;
     }
}

- (NSString *)stringIsNull:(id)string
{
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return @"";
        
    }else{
        
        return (NSString *)string;
    }
}
#pragma mark-判断星期几

+(NSString *)whichweek:(NSString *)dateStr
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateStr];
    NSArray *weekdays = [NSArray arrayWithObjects: @"星期日",@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger n= [comps weekday]-1;
    
    NSString *string = [NSString stringWithFormat:@"%@ %@",dateStr,weekdays[n]];
    
    return string;
    
}
+(NSString *)whichDateweek:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSDate *newdate = [formatter dateFromString:dateStr];
    NSArray *weekdays = [NSArray arrayWithObjects: @"星期日",@"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    NSInteger unitFlags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSWeekdayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:newdate];
    NSInteger n= [comps weekday]-1;
    
    NSString *string = [NSString stringWithFormat:@"%@ %@",dateStr,weekdays[n]];
    
    return string;

}

#pragma mark - 字典转Json字符串
+ (NSString*)convertToJSONData:(id)infoDict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    
    
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    return jsonString;
}

#pragma mark - 将包含"\n"的标志装换为"\r\n"
- (NSString *)replaceNewlinesymbolWithNewSymbol:(NSString *)str
{
    str = [str  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    return [str stringByReplacingOccurrencesOfString:@"\n" withString:@"\r\n"];
}

- (NSString *)replaceNewlinesymbolOfNWithNewSymbol:(NSString *)str
{
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    return [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
}

#pragma mark - 将字符串中间包含的特殊符号去除
+ (NSString *)removeSpecialCharacterOfString:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@"/" withString:@""];
}

+ (NSString *)removeBlankCharacterOfString:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark - NSDate类型的日期转为NSString类型的日期格式
+ (NSString *)dateTimeToStringTime1:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy/MM/dd HH:mm";
    return [df stringFromDate:date];
}

+ (NSString *)dateTimeToStringTime2:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy年MM月dd";
    return [df stringFromDate:date];
}

NSString *Empty(NSString *string)
{
    return [[string class] isSubclassOfClass:[NSNull class]]? @"" : string;
}

NSString *RandomEmpty(NSString *string)
{
    if([[string class] isSubclassOfClass:[NSNull class]])
    {
        NSDate *date = [NSDate date];
        
        NSDateFormatter *matter = [NSDateFormatter new];
        
        [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        return [matter stringFromDate:date];
    }else
    {
        return string;
    }
}

+ (NSString *)getCurrentTime
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *matter = [NSDateFormatter new];
    
    [matter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    return [matter stringFromDate:date];
}

NSString *OppositeString(NSString *string)
{
    NSMutableString *resultStr = [NSMutableString string];
    for(int i = (int)(string.length - 1) ; i > -1 ; i--)
    {
        NSString  *c = [string substringWithRange:NSMakeRange(i, 1)];
        [resultStr appendFormat:@"%@",c];
    }
    return resultStr;
}

NSString *CutPrefixString(NSString *string,NSString *prefixStr)
{
    NSUInteger loc = prefixStr.length;
    NSUInteger len = string.length - prefixStr.length;
    NSRange tempRange = NSMakeRange(loc, len);
    NSString *resultStr = [string substringWithRange:tempRange];
    return resultStr;
}

+ (NSString *)spellNewDateFormatter:(NSString *)str
{
    if ([str isEqualToString:@""])
    {
        return @"";
        
    }else
    {
        if (str.length >= 8)
        {
            return str;
        }else
        {
            return [NSString stringWithFormat:@"%@/%@/%@",
                    [str substringWithRange:NSMakeRange(0, 4)],
                    [str substringWithRange:NSMakeRange(4, 2)],
                    [str substringWithRange:NSMakeRange(6, 2)]];
        }
    }
}

+ (NSString *)spellNewClocktimeFormatter:(NSString *)str
{
    if ([str isEqualToString:@""])
    {
        return @"";
        
    }else
    {
        if (str.length >= 8)
        {
            return str;
        }else
        {
        return [NSString stringWithFormat:@"%@:%@:%@",
                [str substringWithRange:NSMakeRange(0, 2)],
                [str substringWithRange:NSMakeRange(2, 2)],
                [str substringWithRange:NSMakeRange(4, 2)]];
        }
    }
}

+ (NSString *)spellNewBirthdatetimeFormatter:(NSString *)str
{
    if ([str isEqualToString:@""])
    {
        return @"";
        
    }else
    {
        return [NSString stringWithFormat:@"%@年%@月%@日",
                [str substringWithRange:NSMakeRange(0, 4)],
                [str substringWithRange:NSMakeRange(4, 2)],
                [str substringWithRange:NSMakeRange(6, 2)]];
        
    }
}


//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date
{
    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    //输出currentDateString
//    NSLog(@"%@",currentDateString);
    return currentDateString;
}


+ (NSString *)convertTimeStamp:(NSString *)timeStr
{
//<<<<<<< HEAD
//    //设置时间显示格式:
//    //    NSString* timeStr = @"2011-01-26 17:40:50";
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//    
//    //设置时区,这个对于时间的处理有时很重要
//    //例如你在国内发布信息,用户在国外的另一个时区,你想让用户看到正确的发布时间就得注意时区设置,时间的换算.
//    //例如你发布的时间为2010-01-26 17:40:50,那么在英国爱尔兰那边用户看到的时间应该是多少呢?
//    //他们与我们有7个小时的时差,所以他们那还没到这个时间呢...那就是把未来的事做了
//    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
//    [formatter setTimeZone:timeZone];
//    
//    NSDate *date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
//    
//    //时间转时间戳的方法:
//    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
////    NSLog(@"timeSp:%@",timeSp); //时间戳的值
//=======
//    //设置时间显示格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (timeStr.length >=19)
    {
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        
    }else
    {
        [formatter setDateFormat:@"YYYYMMdd HHmmss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    }
    NSDate *date = [formatter dateFromString:timeStr];
    
    // 差八个时区
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date  dateByAddingTimeInterval:interval];
    
    //时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[localeDate timeIntervalSince1970]];
//>>>>>>> 447f13ea6a99d6570b3247398d1fa88dbc0913a8
    
    return timeSp;

}

// 汉字转拼音
+ (NSString *)transformChineseToPinyin:(NSString *)chinese{
    //将NSString装换成NSMutableString
    NSMutableString *pinyin = [chinese mutableCopy];
    
    //将汉字转换为拼音(带音标)
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    
    //去掉拼音的音标
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    
    //返回最近结果
    return pinyin;
    
}

+ (NSString *)respellSeriesTime:(NSString *)time
{
    NSString *newTime = [NSString stringIsNull:time];
    if (newTime.length > 0)
    {
        if ([newTime containsString:@":"])
        {
            return newTime;
            
        }else
        {
            if (newTime.length > 5)
            {
                return [NSString stringWithFormat:@"%@:%@:%@",
                        [time substringWithRange:NSMakeRange(0, 2)],
                        [time substringWithRange:NSMakeRange(2, 2)],
                        [time substringWithRange:NSMakeRange(4, 2)]];
            }
        }
    }else
    {
        return newTime;
    }
    
    return newTime;
}

+ (NSString *)respellStudydate:(NSString *)time
{
    NSString *newTime = [NSString stringIsNull:time];
    if (newTime.length > 10)
    {
        return [NSString stringWithFormat:@"%@%@%@",
                [newTime substringWithRange:NSMakeRange(0, 4)],
                [newTime substringWithRange:NSMakeRange(5, 2)],
                [newTime substringWithRange:NSMakeRange(8, 2)]];
    }else
    {
        return @"";
    }
}


+ (NSDate *)transformTimestampToDate:(NSString *)timestamp
{
    NSTimeInterval interval = [timestamp doubleValue];
    return [NSDate dateWithTimeIntervalSince1970:interval];
}
@end
