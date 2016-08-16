//
//  IHFMantleMTL.m
//  IHFMedicImage2.0
//
//  Created by ihefe－hulinhua on 16/6/12.
//  Copyright © 2016年 Hanrovey. All rights reserved.
//

#import "IHFMantleMTL.h"
#import <objc/runtime.h>

@implementation IHFMantleMTL

//transform json key to properyt key .if return nil ,will match all properyt
- (NSDictionary *)JSONKeyTransformPropertyKey
{
    return nil;
}

- (Class)getProperytClass:(objc_property_t)property
{
    Class properytClass;
    const char * const attrString = property_getAttributes(property);
    if (!attrString) {
        fprintf(stderr, "ERROR: Could not get attribute string from property %s\n", property_getName(property));
        return nil;
    }
    if (attrString[0] != 'T') {
        fprintf(stderr, "ERROR: Expected attribute string \"%s\" for property %s to start with 'T'\n", attrString, property_getName(property));
        return nil;
    }
    
    const char *typeString = attrString + 1;
    const char *next = NSGetSizeAndAlignment(typeString, NULL, NULL);
    if (!next) {
        fprintf(stderr, "ERROR: Could not read past type in attribute string \"%s\" for property %s\n", attrString, property_getName(property));
        return nil;
    }
    
    size_t typeLength = next - typeString;
    if (!typeLength) {
        fprintf(stderr, "ERROR: Invalid type in attribute string \"%s\" for property %s\n", attrString, property_getName(property));
        return nil;
    }
    // if this is an object type, and immediately followed by a quoted string...
    if (typeString[0] == *(@encode(id)) && typeString[1] == '"') {
        // we should be able to extract a class name
        const char *className = typeString + 2;
        next = strchr(className, '"');
        
        if (!next) {
            fprintf(stderr, "ERROR: Could not read class name in attribute string \"%s\" for property %s\n", attrString, property_getName(property));
            return nil;
        }
        
        if (className != next) {
            size_t classNameLength = next - className;
            char trimmedName[classNameLength + 1];
            
            strncpy(trimmedName, className, classNameLength);
            trimmedName[classNameLength] = '\0';
            
            // attempt to look up the class in the runtime
            properytClass = objc_getClass(trimmedName);
        }
    }
    return properytClass;
}

- (NSMutableDictionary*)propertiesDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i=0; i<outCount; i++) {
        objc_property_t property = properties[i];
        NSString * key = [[NSString alloc]initWithCString:property_getName(property)  encoding:NSUTF8StringEncoding];
        Class keyClass = [self getProperytClass:property];
        if (keyClass&&key) {
            [dictionary setObject:keyClass forKey:key];
        }
        
    }
    free(properties);
    
    return dictionary;
}

- (void)dictionaryToModel:(NSDictionary*)JsonDic
{
    if (![JsonDic isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Error: IHFMantle json to model failure,because JsonDic is not a nsdictionary");
        return ;
    }
    NSMutableDictionary *properyDic = [self propertiesDictionary];
    if (!properyDic) return;
    
    NSDictionary *json_pro_Dic = [self JSONKeyTransformPropertyKey];
    
    NSSet *keys = [NSSet setWithArray:json_pro_Dic.allKeys];
    NSSet *allPropery = [NSSet setWithArray:properyDic.allKeys];
    
    if (keys&&keys.count>0) {
        for (NSString *key in keys) {
            if ([allPropery containsObject:key])
            {
                NSString *JsonKey = json_pro_Dic[key];
                id reallyValue = JsonDic[JsonKey];
                Class valueClass = properyDic[key];
                if ([reallyValue isKindOfClass:valueClass]) {
                    [self setValue:reallyValue forKey:key];
                }
            }
        }
    }else
    {
        for (NSString *key in allPropery) {
            
            id reallyValue = JsonDic[key];
            Class valueClass = properyDic[key];
            if ([reallyValue isKindOfClass:valueClass]) {
                [self setValue:reallyValue forKey:key];
            }
        }
    }
}

@end
