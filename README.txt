CoreStack v1.0 : README
 
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

CoreStack : An Objective C 2.0 interface to the Stack Exchange API. Also uses
http://code.google.com/p/json-framework/ and
http://github.com/gabriel/gh-unit/. 

OVERVIEW

This document assumes you've read the beginner material regarding the API
at http://stackapps.com/, and are familiar with Objective C.

CoreStack is a purely asynchronous API built around requesting object sets from
StackExchange sites. The key class structure is:

CSSiteDescriptor Describes a Stack Exchange Site, including API endpoints
CSAuth           Represents the StackAuth site
CSSite:          Represents a single Stack Exchange site
CSObject:        Encapsulates an object (User, Comment etc) from a site
CSObjectVector:  Encapsulates a list of objects from a site
CSRequestParams: Encapsulates a request for objects from a site
CSRequestToken:  Represents a request made of a site, but not yet delivered

All CSObject subclasses expose properties that match the structure documented
in the API help at http://api.stackapps.com/1.0/help.

USAGE:

Link all the files outside of the Tests directory, along with the contents of
the JSON folder with your application. Link against SystemConfiguration.framework.
Then just dive in - a typical usage
might be as follows:

0. Change the definition CS_API_KEY in CoreStackConstants to match your API key
1. Create a CSSiteDescriptor via initWithName:andEndPoint:
2. Pass this descriptor to CSSite via initWithDescriptor
3. Write a class conforming to CSObjectRequestDelegate
4. Obtain request parameters for user 1200 with
   [CSUser requestParamsForObjectWithIdentifier:1200]
5. Pass the parameters and your delegate to your site instance via 
   requestObjects:notify:. Store the request token.
6. Wait for your requestComplete:forRequest:error: delegate method
   to be invoked. If you get bored, call cancelRequest: on CSSite
7. Call [objects first] the delivered results set to see the user.
   If the passed error is not nil, check CoreStackConstants.h for
   error codes
8. Examine properties of the delivered user object. You might want
   to read their comments, so obtain a CSRequestParams via
   [user requestParamsForComments] and make another request
   
A more involved usage will create a CSAuth instance, and become its delegate
to receive notification of all the Stack Exchange sites. You can then use these
sites to built CSSite instances.

NOTES:

* The API should work with both garbage collection and manual memory management
* There are the barest minimum of (i.e. virtually zero) unit tests in the Tests
  folder. Expanding this set is a good idea.
* The API is only asynchronous. Data download will occur in the background, but
  all results will be delivered on the main thread
* You will need a runloop for this API to function. If you're using UIKit or
  Application Kit, you've almost certainly got one already
* Delegate objects for CSAuth and notification delegates for CSSite are *not*
  retained. You must unset the CSAuth delegate or call CSSite cancelRequest: if
  your delegate is about to dealloc
* All classes apart from CSSite conform to NSCoding. You are encouraged to
  serialise objects for state preservation, rather than just storing IDs and
  mass-downloading them again upon restart.
* The easiest way to explore the API is to just read the header files. Look out
  for requestParamsFor* method signatures (these are both static and instance
  methods)
* All objects are returned in a CSObjectVector - even single results. This
  matches the Stack Exchange API design.
* You should rarely need to create CSRequestParam or CSObject instances
  yourself.  Use provided class and instance methods to build request
  parameters, and obtain your CSObjects via CSSite requests or NSCoding
  initFromCoder deserialisations.
