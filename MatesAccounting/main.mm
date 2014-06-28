//
//  main.m
//  MatesAccounting
//
//  Created by Lee on 13-11-12.
//  Copyright (c) 2013年 Lee. All rights reserved.
//

#define TEST_MODE 0

#import <UIKit/UIKit.h>

#import "MAAppDelegate.h"

#if !TEST_MODE

int main(int argc, char *argv[])
{
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([MAAppDelegate class]));
    }
}

#else

#import "MAccount+expand.h"
#import <objc/runtime.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#include <iostream>

using namespace std;

@protocol protocol1 <NSObject>

@end

@protocol protocol2 <protocol1>

@end

@interface testClass : NSObject <protocol1>

@property (nonatomic, copy) NSString *s;
@property (nonatomic, copy) NSNumber *n;
@property (nonatomic, assign) NSInteger i;
@property (nonatomic, retain) NSDate *nd;
@property (nonatomic, retain) id d;
@property (nonatomic, strong) NSString *string1;
@property (nonatomic, unsafe_unretained) NSString *string2;
@property (nonatomic, strong) NSNumber *number1;
@property (nonatomic, unsafe_unretained) NSNumber *number2;
//@property (nonatomic, assign) NSInteger ni;
//@property (nonatomic, assign) double d;
//@property (nonatomic, assign) CGFloat cf;

+ (void)testMethod;
- (void)testMethod;

@end

@implementation testClass

+ (void)testMethod
{
}

- (void)testMethod
{
    self.number1 = @(-2);
    // NSLog(@"after--->self.string1 = [[NSString alloc] initWithUTF8String:\"string 1\"];");
    self.number2 = @(-2);
    // NSLog(@"after--->self.string2 = self.string1;");
    id a = [[NSObject alloc] init];
    id b = [[NSObject alloc] init];
    [a description];
    [b description];
    self.number1 = nil;
    // NSLog(@"after--->self.string1 = nil;");
    NSLog(@"number2 = %@", self.number2);
    // NSLog(@"now--->NSLog(self.string2);");
}

@end

@interface testClass0 : NSObject

@property (nonatomic, strong) NSMutableArray *array;

- (void)testMethod;

@end

@implementation testClass0

- (id)init
{
    if (self = [super init]) {
        self.array = [NSMutableArray array];
        testClass *testC = [[testClass alloc] init];
        testC.s = @"sdfas";
        [testC addObserver:self forKeyPath:@"s" options:NSKeyValueObservingOptionNew context:nil];
        [self.array addObject:testC];
    }

    return self;
}

- (void)testMethod
{
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[testClass class]] && [keyPath isEqualToString:@"s"]) {
        NSLog(@"%@", change);
        id newValue = [change objectForKey:NSKeyValueChangeNewKey];
        NSLog(@"%@", newValue);
        if ([newValue isKindOfClass:[NSNull class]]) {
            [object removeObserver:self forKeyPath:@"s" context:nil];
        }
    }
}

@end

typedef struct Node
{
    int value;
    Node *neighborInfo;

    Node () {
        this->value = 0;
        this->neighborInfo = NULL;
    }
} *NodePointer;

// NOTE that there is/are (at least):
// 1 major algorithmic assumption - 1个算法的主要假设
// 2 portability issues - 2个可移植性问题
// 1 syntax error - 1个语法错误
// Function to copy 'nBytes' of data from src to dst.
void myMemcpy(char *dst, const char *src, int nBytes)
{
    if (NULL == dst || strlen(src) < nBytes) {
        cout << strlen(src) << endl << strlen(dst) << endl;
        return;
    }/* debug */

    // Try to be fast and copy a word at a time instead of byte by byte
    int displacement = 0;/* debug */
    int intSize = sizeof(int);
    int charSize = sizeof(char);
    while ((charSize *= 2) <= intSize) {
        ++displacement;
    }

    int *wordDst = (int *)dst;
    int *wordSrc = (int *)src;
    int numWords = nBytes >> displacement/* debug */;
    for (int i = 0; i < numWords; ++i) {
        *wordDst++ = *wordSrc++;
    }

    dst = (char *)wordDst;
    src = (char *)wordSrc;
    int numRemaining = nBytes - (numWords << displacement/* debug */);
    for (int i = 0 ; i </* debug */ numRemaining; ++i)/* debug */ {
        *dst++ = *src++;
    }
}

void reverseStringByWorld(char *words, size_t start, size_t end)
{
    if (NULL == words) {
        return;
    }

    size_t leftHead = start;
    size_t rightTail = end;
    for (size_t index = start, reverseIndex = end - 1; index <= reverseIndex; ++index, --reverseIndex) {
        // reverse the words char by char
        if (index < reverseIndex) {
            words[index] += words[reverseIndex];
            words[reverseIndex] = words[index] - words[reverseIndex];
            words[index] -= words[reverseIndex];
        }
        // reverse the word which appears in left
        if (' ' == words[index]) {
            reverseStringByWorld(words, leftHead, index);
            leftHead = index + 1;
        }
        // reverse the word which appears in right
        if (' ' == words[reverseIndex]) {
            reverseStringByWorld(words, reverseIndex + 1, rightTail);
            rightTail = reverseIndex;
        }
    }
    return;
}

void shuffleCards(int *cards, int count)
{
    int index = count;
    srand((unsigned)time(NULL));
    while (--index >= 0) {
        int exchangeIndex = rand() % count;
        if (exchangeIndex != index) {
            cards[exchangeIndex] += cards[index];
            cards[index] = cards[exchangeIndex] - cards[index];
            cards[exchangeIndex] -= cards[index];
        }
    }
    return;
}

NodePointer insertValueToList(NodePointer listHead, int beforeValue, int insertValue)
{
    NodePointer node = new Node();
    node->value = insertValue;
    if (NULL == listHead) {
        return node;
    }

    NodePointer pre = NULL, current = listHead, next = listHead->neighborInfo;
    while (NULL != current) {
        if (beforeValue == current->value) {
            break;
        }
        NodePointer temp = current;
        pre = current;
        current = next;
        if (NULL != next) {
            next = (NodePointer)((long)next->neighborInfo ^ (long)temp);
        }
    }

    node->neighborInfo = (NodePointer)((long)pre ^ (long)current);
    if (NULL == pre) {
        listHead = node;
    } else {
        pre->neighborInfo = (NodePointer)((long)pre->neighborInfo ^ (long)current ^ (long)node);
    }
    if (NULL != current) {
        current->neighborInfo = (NodePointer)((long)node ^ (long)next);
    }

    return listHead;
}

void releaseList(NodePointer listHead)
{
    NodePointer current = listHead, next = listHead->neighborInfo;

    cout << endl << "---------------------------" << endl;
    while (NULL != current) {
        NodePointer temp = current;
        current = next;
        if (NULL != next) {
            next = (NodePointer)((long)next->neighborInfo ^ (long)temp);
        }

        cout << temp->value << " | " << flush;
        delete temp;
    }
    cout << endl << "---------------------------" << endl;
}


#pragma mark - test main

int main(int argc, char *argv[])
{

#pragma mark - test reverse NSString by CString
    NSString *originString = @"1234567890";
    NSUInteger length = [originString length];
    const char *cString = [originString UTF8String];
    NSMutableString *reverseString = [NSMutableString string];
    for (NSInteger index = length - 1; 0 <= index; --index) {
        [reverseString appendFormat:@"%c", cString[index]];
    }

    length = strlen(cString);
    char s[length + 1];
    s[length] = '\0';
    strcpy(s, cString);
    printf("%s\n", s);

    NSLog(@"originString = %@", originString);
    NSLog(@"reverseString = %@", reverseString);

    return 0;

#pragma mark - test NSString and NSNumber memory
    testClass *tc = [[testClass alloc] init];
    [tc testMethod];
    return 0;

#pragma mark - test KVO
    testClass0 *tc0 = [[testClass0 alloc] init];
    ((testClass *)tc0.array[0]).s = @"wer";
    ((testClass *)tc0.array[0]).s = nil;
    ((testClass *)tc0.array[0]).s = @"aaa";
    return 0;

#pragma mark test NSMutableArray
    testClass *tc1 = [[testClass alloc] init];
    testClass *tc2 = [[testClass alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:tc1];
    [array addObject:tc2];
    [array addObject:tc1];
    NSLog(@"%@", array);
    return 0;

#pragma mark test ^ operation
    NSMutableArray *arr = [NSMutableArray arrayWithArray:nil];
    NSLog(@"%@", arr);
    int x = 1;
    int y = 2;
    int z = x ^ y * y;
    NSLog(@"%d",z);
    return 0;

#pragma mark test CTTelephonyNetworkInfo
    CTTelephonyNetworkInfo *networkInfo;
    networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = networkInfo.subscriberCellularProvider;
    NSLog(@"------%@", carrier.carrierName);
    NSLog(@"------%@", carrier);

#pragma mark test double linked list with only one pointer
    NodePointer head = NULL;
    for (int value = 9; 0 <= value; --value) {
        head = insertValueToList(head, NULL == head ? 0 : head->value, value);
    }
    head = insertValueToList(head, 5, 100);

    releaseList(head);
    return 0;

#pragma mark test shuffle cards
    int cards[52];
    size_t count = (sizeof(cards) / sizeof(cards[0]));
    for (int index = 0; index < count; ++index) {
        cards[index] = index;
    }

    int printCount = 0;
    cout << "---------------------------" << endl;
    for (int index = 0; index < count; ++index) {
        cout << cards[index] << " | " << flush;
        if (10 == ++printCount || count - 1 == index) {
            printCount = 0;
            cout << endl;
        }
    }
    shuffleCards(cards, count);
    printCount = 0;
    cout << "---------------------------" << endl;
    for (int index = 0; index < count; ++index) {
        cout << cards[index] << " | " << flush;
        if (10 == ++printCount || count - 1 == index) {
            printCount = 0;
            cout << endl;
        }
    }
    cout << "---------------------------" << endl;

    return 0;

#pragma mark test reverse string
    char words[] = "Zhuocheng Lee Is A Good Man";

    cout << "----------------------------" << endl;
    cout << "words = " << words << endl;
    reverseStringByWorld(words, 0, strlen(words));
    cout << "words = " << words << endl;
    cout << "----------------------------" << endl;
    return 0;

#pragma mark test string copy
    char *dst = new char[66];
    const char *src = "abcdefghijklmn";
    int nBytes = 9;

    myMemcpy(dst, src, nBytes);
    cout << "----------------------------" << endl;
    cout << endl << "src = " << src << endl;
    cout << endl << "dst = " << dst << endl;
    cout << "----------------------------" << endl;

    delete [] dst;
    return 0;

#pragma mark test NSString
    NSString *ts1 = @"http://fmn.rrimg.com/fmn063/gouwu/20131015/1130/original_txLI_557d00000079118e.Gif";
    NSString *ts2 = @"/p/m3w150h150q85lt_";

    if ([[[ts1 substringFromIndex:ts1.length - 4] lowercaseString] isEqualToString:@".gif"]) {
        return 0;
    }

    NSRange range = [ts1 rangeOfString:@"/" options:NSCaseInsensitiveSearch | NSBackwardsSearch];
    // NSLog(@"location:%u, length:%u", range.location, range.length);
    // NSRange range;
    // range.location = 0;
    // range.length = ts1.length;
    ts2 = [ts1 stringByReplacingOccurrencesOfString:@"/" withString:ts2 options:NSBackwardsSearch range:range];
    NSLog(@"\nts1:%@\nts2:%@", ts1, ts2);

    return 0;

#pragma mark test time coding
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    NSLog(@"%f", [[NSDate date] timeIntervalSince1970]);
    return 0;
    testClass *r1 = [[testClass alloc] init];
    unsigned int propsCount;
    objc_property_t *propList = class_copyPropertyList([r1 class], &propsCount);

    for (int i = 0; i < propsCount; i++) {
        objc_property_t oneProp = propList[i];
        NSString *attrs = [NSString stringWithUTF8String:property_getAttributes(oneProp)];
        NSArray *attrParts = [attrs componentsSeparatedByString:@","];
        NSString *stringName = [[attrParts objectAtIndex:0] substringFromIndex:1];
        NSLog(@"%@", stringName);
    }

    if (propList)
        free(propList);
    return 0;

#pragma mark test object key-value-coding
    testClass *c1 = [[testClass alloc] init];
    testClass *c2 = [[testClass alloc] init];
    // NSDictionary *d1 = @{@"s":@"123", @"n":@10};
    c1.s = @"123";
    c2.s = @"123";
    c1.n = @10;
    c2.n = @10;

    id i = [c1 valueForKey:@"i"];
    NSLog(@"%@", [i description]);
    [c1 setValue:@"" forKey:@"i"];

    // BOOL b1 = [[d1 valueForKey:@"s"] isEqual:[c2 valueForKey:@"s"]];
    // BOOL b2 = [c1 validateValue:nil forKey:@"s" error:nil];
    // NSLog(@"%d", b1);
    // NSLog(@"%d", b2);
    
    return 0;

#pragma mark test date
    NSDate *date = [NSDate date];
    date = [NSDate dateWithTimeIntervalSince1970:[date timeIntervalSince1970] - (24 * 60 * 60)];
    NSLog(@"%f \n %@ \n %@", [date timeIntervalSince1970], [NSDate date], date);
    return 0;

#pragma mark test date
    date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date];
    NSUInteger dateKey = [components year] * 10000 + [components month] * 100 + [components day];
    NSLog(@"date : %@ %d-%d-%d %d",
          date,
          [components year],
          [components month],
          [components day],
          dateKey
          );
    return 0;

#pragma mark test protocol
    testClass *protocolClass = [[testClass alloc] init];
    BOOL isConforms = [protocolClass conformsToProtocol:@protocol(protocol1)];
    NSLog(@"isConforms : %d", isConforms);
    return 0;

#pragma mark test dictionary key-value-coding
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@"testValue" forKey:@"testKey"];
    NSLog(@"%@", dict);
    return 0;

}

#endif