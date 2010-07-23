/*
 
 CoreStack v1.0 : NSDictionary+JSONDecoder.m
 
 Copyright (c) 2010 Adam Wright
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */
#import "NSDictionary+JSONDecoder.h"

#import "CoreStackConstants.h"


@implementation NSDictionary (NSDictionary_JSONDecoder)

- (BOOL)extract:(NSString*)key intoBool:(BOOL*)target
{
    if ([self objectForKey:key] == nil)
        return FALSE;
    
    *target = [[self objectForKey:key] boolValue];
    
    return TRUE;
}

- (BOOL)extract:(NSString*)key intoInt:(int*)target
{
    if ([self objectForKey:key] == nil)
        return FALSE;
    
    *target = [[self objectForKey:key] intValue];
    
    return TRUE;
}

- (BOOL)extract:(NSString*)key intoDouble:(double*)target
{
    if ([self objectForKey:key] == nil)
        return FALSE;
    
    *target = [[self objectForKey:key] doubleValue];
    
    return TRUE;
}

- (BOOL)extract:(NSString*)key intoString:(NSString**)target
{
    if ([self objectForKey:key] == nil)
        return FALSE;
    
    if (*target)
        [*target release];
    
    *target = [[self objectForKey:key] retain];
    
    return TRUE;
}

- (BOOL)extract:(NSString*)key intoDate:(NSDate**)target
{
    if ([self objectForKey:key] == nil)
        return FALSE;
    
    if (*target)
        [*target release];
    
    *target = [[NSDate dateWithTimeIntervalSince1970:[[self objectForKey:key] intValue]] retain];
    
    return TRUE;
}

- (BOOL)extract:(NSString*)key intoURL:(NSURL**)target
{
    if ([self objectForKey:key] == nil)
        return FALSE;
    
    if (*target)
        [*target release];
    
    *target = [[NSURL URLWithString:[self objectForKey:key]] retain];
    
    return TRUE;
}

- (BOOL)extract:(NSString*)key intoArray:(NSArray**)target
{
    if ([self objectForKey:key] == nil)
        return FALSE;
    
    if (*target)
        [*target release];
    
    *target = [[self objectForKey:key] retain];
    
    return TRUE;
}

- (BOOL)extract:(NSString*)key intoDictionary:(NSDictionary**)target
{
    if ([self objectForKey:key] == nil)
        return FALSE;
    
    if (*target)
        [*target release];
    
    *target = [[self objectForKey:key] retain];
    
    return TRUE;
}

- (BOOL)extract:(NSString*)key intoBool:(BOOL*)target error:(NSError**)error
{
    BOOL result = [self extract:key intoBool:target];
    
    if (!result && error)
        *error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_JSON_KEY_MISSING userInfo:[self userInfoForMissingKey:key]];
    
    return result;
}

- (BOOL)extract:(NSString*)key intoInt:(int*)target error:(NSError**)error
{
    BOOL result = [self extract:key intoInt:target];
    
    if (!result && error)
        *error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_JSON_KEY_MISSING userInfo:[self userInfoForMissingKey:key]];
    
    return result;
}

- (BOOL)extract:(NSString*)key intoDouble:(double*)target error:(NSError**)error
{
    BOOL result = [self extract:key intoDouble:target];
    
    if (!result && error)
        *error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_JSON_KEY_MISSING userInfo:[self userInfoForMissingKey:key]];
    
    return result;
}

- (BOOL)extract:(NSString*)key intoString:(NSString**)target error:(NSError**)error
{
    BOOL result = [self extract:key intoString:target];
    
    if (!result && error)
        *error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_JSON_KEY_MISSING userInfo:[self userInfoForMissingKey:key]];
    
    return result;
}

- (BOOL)extract:(NSString*)key intoDate:(NSDate**)target error:(NSError**)error
{
    BOOL result = [self extract:key intoDate:target];
    
    if (!result && error)
        *error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_JSON_KEY_MISSING userInfo:[self userInfoForMissingKey:key]];
    
    return result;
}

- (BOOL)extract:(NSString*)key intoURL:(NSURL**)target error:(NSError**)error
{
    BOOL result = [self extract:key intoURL:target];
    
    if (!result && error)
        *error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_JSON_KEY_MISSING userInfo:[self userInfoForMissingKey:key]];
    
    return result;
}

- (BOOL)extract:(NSString*)key intoArray:(NSArray**)target error:(NSError**)error
{
    BOOL result = [self extract:key intoArray:target];
    
    if (!result && error)
        *error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_JSON_KEY_MISSING userInfo:[self userInfoForMissingKey:key]];
    
    return result;
}

- (BOOL)extract:(NSString*)key intoDictionary:(NSDictionary**)target error:(NSError**)error
{
    BOOL result = [self extract:key intoDictionary:target];
    
    if (!result && error)
        *error = [NSError errorWithDomain:CS_ERROR_DOMAIN code:CS_ERROR_JSON_KEY_MISSING userInfo:[self userInfoForMissingKey:key]];
    
    return result;
}

- (NSDictionary*)userInfoForMissingKey:(NSString*)key
{
    return [NSDictionary dictionaryWithObject:key forKey:@"missing_json_key"];
}

@end
