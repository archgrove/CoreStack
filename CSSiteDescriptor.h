/*
 
 CoreStack v1.0 : CSSiteDescriptor.h
 
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

#import <Foundation/Foundation.h>

enum CSSiteState
{
    CSSiteStateUnknown,
    CSSiteStateNormal,
    CSSiteStateClosedBeta,
    CSSiteStateOpenBeta,
    CSSiteStateLinkedMeta
};

@interface CSSiteDescriptor : NSObject<NSCoding> {
    NSString *name;
    NSURL *logo_url;
    NSString *api_endpoint;
    NSURL *site_url;
    NSString *description;
    NSURL *icon_url;
    NSArray *aliases;
    enum CSSiteState state;
    NSString *styling_link_color;
    NSString *styling_tag_foreground_color;
    NSString *styling_tag_background_color;    
}

@property (readonly) NSString *name;
@property (readonly) NSURL *logo_url;
@property (readonly) NSString *api_endpoint;
@property (readonly) NSURL *site_url;
@property (readonly) NSString *description;
@property (readonly) NSURL *icon_url;
@property (readonly) NSArray *aliases;
@property (readonly) enum CSSiteState state;
@property (readonly) NSString *styling_link_color;
@property (readonly) NSString *styling_tag_foreground_color;
@property (readonly) NSString *styling_tag_background_color;

- (id)initWithName:(NSString*)_name andEndPoint:(NSString*)_api_endpoint;
- (BOOL)updateFromJSON:(id)json error:(NSError**)error;

@end
