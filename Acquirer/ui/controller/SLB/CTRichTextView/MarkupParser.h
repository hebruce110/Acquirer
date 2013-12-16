#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface MarkupParser : NSObject

@property (retain, nonatomic) NSString *font;
@property (retain, nonatomic) UIColor *color;
@property (retain, nonatomic) UIColor *strokeColor;
@property (retain, nonatomic) NSMutableArray *images;

@property (assign, readwrite) CGFloat strokeWidth;
@property (assign, readwrite) CGFloat fontSize;
@property (assign, readwrite) CGFloat lineSpace;
@property (assign, readwrite) CGFloat wordSpace;
@property (assign, readwrite) CTTextAlignment alignment;

-(NSAttributedString*)attrStringFromMarkup:(NSString*)html;

@end
