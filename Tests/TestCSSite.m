/*
 
 CoreStack v1.0 : CSObjectVector.m
 
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


#import "JSON.h"
#import "TestCSSite.h"
#import "Intercepters.h"

#import "CSUser.h"
#import "CSQuestion.h"

@implementation TestCSSite

- (void)setUpClass
{
    siteDescriptor = [[CSSiteDescriptor alloc] init];
    
    NSDictionary *testData = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"TestData" ofType:@"plist"]];
    
    [siteDescriptor updateFromJSON:[[testData objectForKey:@"SiteDescriptor"] JSONValue] error:nil];
}

- (void)tearDownClass
{
    [siteDescriptor release];
}

- (void)testSiteCreation
{
    CSSite *site = [[[CSSite alloc] initWithDescriptor:siteDescriptor] autorelease];
    
    GHAssertEqualObjects(site.descriptor.name, @"Stack Overflow", @"Site failed to initialize correctly");
}

- (void)testObjectFetch
{
    CSSite *site = [[[CSSite alloc] initWithDescriptor:siteDescriptor] autorelease];    
    RequestIntercepter *intercept = [[[RequestIntercepter alloc] init] autorelease];
    
    // Rely on the behaviour that, if there is no cached object, it will fetch one
    [site requestObjectSet:[CSUser requestParamsForObjectWithIdentifier:1200] notify:intercept];
    
    GHAssertNotNil(intercept.result, @"Excepted a result for SOF user 1200");
    
    GHAssertEqualStrings([[intercept.result first] display_name], @"Adam Wright", @"Excepted Adam Wright!");
}

- (void)testSetFetch
{
    CSSite *site = [[[CSSite alloc] initWithDescriptor:siteDescriptor] autorelease];    
    RequestIntercepter *intercept = [[[RequestIntercepter alloc] init] autorelease];
    
    // Rely on the behaviour that, if there is no cached object, it will fetch one
    id params = [[CSRequestParams alloc] initWithURLFragment:@"users/1200/favorites" andResponseVectorKey:@"questions" andType:[CSQuestion class]];
    [site requestObjectSet:params notify:intercept];
    
    GHAssertNotNil(intercept.result, @"Excepted a result for SOF user 1200");
    
    GHAssertEquals((int)[intercept.result count], 2, @"Excepted 2 favorite questions");
}

@end
