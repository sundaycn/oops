//
//  MCGlobal.h
//  MyCircle
//
//  Created by Samuel on 10/15/13.
//
//

#ifndef MyCircle_MCGlobal_h
#define MyCircle_MCGlobal_h

#define ISDEBUG YES

#define IPHONE5_VIEW_HEIGHT 568
#define HEIGHT_WITH_SCROLLING 75

#define DESENCRYPTED_KEY @"3B71617A40575C58"
#define DESDECRYPTED_KEY @"02FBD079EA8F3457"

#define ServiceName @"com.jxtii.MyCircle"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#endif
