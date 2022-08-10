#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "LCTool.h"
#import "LCWebView.h"
#import "UIColor+LCColor.h"
#import "UIView+TransitionColor.h"

FOUNDATION_EXPORT double LCToolVersionNumber;
FOUNDATION_EXPORT const unsigned char LCToolVersionString[];

