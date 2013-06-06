## Common library code for iOS projects.

[![Build Status](https://travis-ci.org/pivotal/PivotalCoreKit.png?branch=master)](https://travis-ci.org/pivotal/PivotalCoreKit)

Pivotal Core Kit is a workspace which contains projects that mirror Apple's 
system frameworks.  For instance, all extensions and additions to the 
Foundation framework live in the Foundation project under the PCK workspace.
Each project has its own builds, and its own specs.

- <Framework>
  - Core: extensions for use in production code
  - SpecHelper: extenstions for use in spec code only
  - Spec: specs for the PCK extensions


# Library Documentation

## UIKit
### SpecHelpers

you can include all the UI spec helpers:

	#include "UIKit+PivotalSpecHelpers.h"
	
or individually include the ones you want to use:

	#include "UITabBarController+Spec.h"

#### UIKit+PivotalSpecHelpers.h
this header includes the following UI extensions
#### UITabBarController+Spec.h
	- (void)tapTabAtIndex:(NSUInteger)position;

Simulates tapping a tab bar at index.  This will raise an assertion error if the index it out of bounds of the tabs. If the UITabBarController instance has a delegate it will test the -tabBarController:shouldSelectViewController: method and only select the tab based on the results.
			
## MIT License

Copyright (c) 2012 Pivotal Labs (www.pivotallabs.com)
Contact email: adam@pivotallabs.com

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
