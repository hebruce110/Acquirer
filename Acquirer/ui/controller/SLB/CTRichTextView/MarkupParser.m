#import "MarkupParser.h"
#import "Helper.h"

/* Callbacks */
static void deallocCallback( void* ref ){
    [(id)ref release];
}
static CGFloat ascentCallback( void *ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"height"] floatValue];
}
static CGFloat descentCallback( void *ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"descent"] floatValue];
}
static CGFloat widthCallback( void* ref ){
    return [(NSString*)[(NSDictionary*)ref objectForKey:@"width"] floatValue];
}

@implementation MarkupParser

-(void)dealloc
{
    _font = nil;
    _color = nil;
    _strokeColor = nil;
    _images = nil;
    
    [super dealloc];
}

-(id)init
{
    self = [super init];
    if (self) {
        _fontSize = 14.0f;
        _strokeWidth = 0;
        _alignment = kCTTextAlignmentCenter;
        _lineSpace = 4.0f;
        _wordSpace = 6.0f;
        
        _font = [UIFont systemFontOfSize:_fontSize].fontName;
        _color = [UIColor blackColor];
        _strokeColor = [UIColor whiteColor];
        _images = [NSMutableArray array];
    }
    return self;
}

-(NSAttributedString*)attrStringFromMarkup:(NSString*)markup
{
    if(!markup) {
        return (nil);
    }
    
    NSMutableAttributedString* aString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    NSRegularExpression* regex = [[NSRegularExpression alloc]
                                  initWithPattern:@"(.*?)(<[^>]+>|\\Z)"
                                  options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators
                                  error:nil];
    NSArray* chunks = [regex matchesInString:markup options:0 range:NSMakeRange(0, [markup length])];
    [regex release];
    
    for (NSTextCheckingResult* b in chunks) {
        NSArray* parts = [[markup substringWithRange:b.range] componentsSeparatedByString:@"<"];
        
        //NSLog(@"### font:%@, fontSize:%0.2f, alignment:%i, lineSpace:%0.2f, wordSpace:%0.2f", _font, _fontSize, _alignment, _lineSpace, _wordSpace);
        
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)_font, _fontSize, NULL);
        
        CTTextAlignment alg = _alignment;
        CTParagraphStyleSetting alignmentSetting;
        alignmentSetting.spec = kCTParagraphStyleSpecifierAlignment;
        alignmentSetting.value = &alg;
        alignmentSetting.valueSize = sizeof(CTTextAlignment);
        
        CGFloat lsp = _lineSpace;
        CTParagraphStyleSetting lineSpaceSetting;
        lineSpaceSetting.spec = kCTParagraphStyleSpecifierLineSpacing;
        lineSpaceSetting.value = &lsp;
        lineSpaceSetting.valueSize = sizeof(CGFloat);
        
        CGFloat wsp = _wordSpace;
        CTParagraphStyleSetting wordSpaceSetting;
        wordSpaceSetting.spec = kCTParagraphStyleSpecifierParagraphSpacing;
        wordSpaceSetting.value = &wsp;
        wordSpaceSetting.valueSize = sizeof(CGFloat);
        
        CTParagraphStyleSetting settings[] = {alignmentSetting, lineSpaceSetting, wordSpaceSetting};
        CTParagraphStyleRef paragraphStyle = CTParagraphStyleCreate(settings, 3);
        
        NSDictionary* attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               (id)_color.CGColor, kCTForegroundColorAttributeName,
                               (id)fontRef, kCTFontAttributeName,
                               (id)_strokeColor.CGColor, (NSString *) kCTStrokeColorAttributeName,
                               (id)[NSNumber numberWithFloat: _strokeWidth], (NSString *)kCTStrokeWidthAttributeName,
                               (id)paragraphStyle, (NSString *)kCTParagraphStyleAttributeName,
                               nil];
        [aString appendAttributedString:[[[NSAttributedString alloc] initWithString:[parts objectAtIndex:0] attributes:attrs] autorelease]];
        
        CFRelease(paragraphStyle);
        CFRelease(fontRef);
        
        if ([parts count] > 1) {
            NSString* tag = (NSString*)[parts objectAtIndex:1];
            if ([tag hasPrefix:@"font"]) {
//                NSRegularExpression* scolorRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=strokeColor=\")\\w+" options:0 error:NULL] autorelease];
//                [scolorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
//                    if ([[tag substringWithRange:match.range] isEqualToString:@"none"]) {
//                        _strokeWidth = 0.0;
//                    } else {
//                        _strokeWidth = -3.0;
//                        _strokeColor = [Helper hexStringToColor:[tag substringWithRange:match.range]];
//                    }
//                }];
//            
//                NSRegularExpression* colorRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=color=\")\\w+" options:0 error:NULL] autorelease];
//                [colorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
//                    _color = [Helper hexStringToColor:[tag substringWithRange:match.range]];
//                }];
//                
//                NSRegularExpression* faceRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=face=\")[^\"]+" options:0 error:NULL] autorelease];
//                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
//                    _font = [tag substringWithRange:match.range];
//                }];
                //只需要粗体、大小和对齐方式
                NSRegularExpression* boldRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=bold=\")[^\"]+" options:0 error:NULL] autorelease];
                [boldRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    BOOL isBold = [[tag substringWithRange:match.range] boolValue];
                    if(isBold)
                    {
                        _font = [UIFont boldSystemFontOfSize:_fontSize].fontName;
                    }
                    else
                    {
                        _font = [UIFont systemFontOfSize:_fontSize].fontName;
                    }
                }];
                
                NSRegularExpression* sizeRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=size=\")[^\"]+" options:0 error:NULL] autorelease];
                [sizeRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    _fontSize = [[tag substringWithRange:match.range] floatValue];
                    _lineSpace = _fontSize * 2.0f / 7.0f;
                }];
                
                NSRegularExpression* alignmentRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=alignment=\")[^\"]+" options:0 error:NULL] autorelease];
                [alignmentRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
                    _alignment = [[tag substringWithRange:match.range] floatValue];
                }];
            }
//            //不需要处理图片
//            if ([tag hasPrefix:@"img"]) {
//                
//                __block NSNumber* width = [NSNumber numberWithInt:0];
//                __block NSNumber* height = [NSNumber numberWithInt:0];
//                __block NSString* fileName = @"";
//                
//                NSRegularExpression* widthRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=width=\")[^\"]+" options:0 error:NULL] autorelease];
//                [widthRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){ 
//                    width = [NSNumber numberWithInt: [[tag substringWithRange: match.range] intValue] ];
//                }];
//                
//                NSRegularExpression* faceRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=height=\")[^\"]+" options:0 error:NULL] autorelease];
//                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
//                    height = [NSNumber numberWithInt: [[tag substringWithRange:match.range] intValue]];
//                }];
//                
//                NSRegularExpression* srcRegex = [[[NSRegularExpression alloc] initWithPattern:@"(?<=src=\")[^\"]+" options:0 error:NULL] autorelease];
//                [srcRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){
//                    fileName = [tag substringWithRange: match.range];
//                }];
//                
//                [self.images addObject:
//                 [NSDictionary dictionaryWithObjectsAndKeys:
//                  width, @"width",
//                  height, @"height",
//                  fileName, @"fileName",
//                  [NSNumber numberWithInt: [aString length]], @"location",
//                  nil]
//                 ];
//                
//                CTRunDelegateCallbacks callbacks;
//                callbacks.version = kCTRunDelegateVersion1;
//                callbacks.getAscent = ascentCallback;
//                callbacks.getDescent = descentCallback;
//                callbacks.getWidth = widthCallback;
//                callbacks.dealloc = deallocCallback;
//                
//                NSDictionary* imgAttr = [[NSDictionary dictionaryWithObjectsAndKeys:
//                                          width, @"width",
//                                          height, @"height",
//                                          nil] retain];
//                
//                CTRunDelegateRef delegate = CTRunDelegateCreate(&callbacks, imgAttr);
//                NSDictionary *attrDictionaryDelegate = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                        (id)delegate, (NSString*)kCTRunDelegateAttributeName,
//                                                        nil];
//                
//                [aString appendAttributedString:[[[NSAttributedString alloc] initWithString:@" " attributes:attrDictionaryDelegate] autorelease]];
//            }
        }
    }
    
    return (NSAttributedString*)[aString autorelease];
}

@end

