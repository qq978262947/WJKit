//
//  ViewController.m
//  内存管理实例
//
//  Created by 汪俊 on 2018/4/18.
//  Copyright © 2018年 汪俊. All rights reserved.
//

#import "MemoryManagementVC.h"
#import "Dog.h"

@interface MemoryManagementVC ()
// 三、与内存有关的修饰符
// strong ：强引用，ARC中使用，与MRC中retain类似，使用之后，计数器+1。
// weak ：弱引用 ，ARC中使用，如果只想的对象被释放了，其指向nil，可以有效的避免野指针，其引用计数为1。
// readwrite : 可读可写特性，需要生成getter方法和setter方法时使用。
// readonly : 只读特性，只会生成getter方法 不会生成setter方法，不希望属性在类外改变。
// assign ：赋值特性，不涉及引用计数，弱引用，setter方法将传入参数赋值给实例变量，仅设置变量时使用。
// retain ：表示持有特性，setter方法将传入参数先保留，再赋值，传入参数的retaincount会+1。
// copy ：表示拷贝特性，setter方法将传入对象复制一份，需要完全一份新的变量时。
// nonatomic ：非原子操作，不加同步，多线程访问可提高性能，但是线程不安全的。决定编译器生成的setter getter是否是原子操作。
// atomic ：原子操作，同步的，表示多线程安全，与nonatomic相反。

@end

@implementation MemoryManagementVC
__weak NSString *string_weak_ = nil;
__weak Dog *dog_weak_ = nil;

/**
 1.MRC（人工引用计数），手动管理内存。
 MRC模式下，所有的对象都需要手动的添加retain、release代码来管理内存。使用MRC，需要遵守谁创建，谁回收的原则。也就是谁alloc，谁release；谁retain，谁release。
 当引用计数为0的时候，必须回收，引用计数不为0，不能回收，如果引用计数为0，但是没有回收，会造成内存泄露。如果引用计数为0，继续释放，会造成野指针。为了避免出现野指针，我们在释放的时候，会先让指针=nil。
 2.ARC(自动引用计数)，自动管理内存。
 ARC是IOS5推出的新功能，通过ARC，可以自动的管理内存。在ARC模式下，只要没有强指针（强引用）指向对象，对象就会被释放。在ARC模式下，不允许使用retain、release、retainCount等方法。并且，如果使用dealloc方法时，不允许调用[super dealloc]方法。
 ARC模式下的property变量修饰词为strong、weak，相当于MRC模式下的retain、assign。strong :代替retain，缺省关键词，代表强引用。weak：代替assign，声明了一个可以自动设置nil的弱引用，但是比assign多一个功能，指针指向的地址被释放之后，指针本身也会自动被释放。
 
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear-string: %@", string_weak_);
    NSLog(@"viewWillAppear-dog: %@", dog_weak_);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"viewDidAppear-string: %@", string_weak_);
    NSLog(@"viewDidAppear-dog: %@", dog_weak_);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 例子里面的类都是比较奇葩的名字，没有什么好名字，名字照抄了一下
#pragma mark - MRC
    // 首先我们看看mrc下的内存如何操作
//    [self demo1];
    // 接下来我们看看NSString引用计数问题
//    [self demo2];
#pragma mark - 自动释放池
//    　　现在已经明确了，当不再使用一个对象时应该将其释放，但是在某些情况下，我们很难理清一个对象什么时候不再使用（比如小狗死亡的时间不确定），这可怎么办？
//    ObjC提供autorelease方法来解决这个问题，当給一个对象发送autorelease消息时，方法会在未来某个时间給这个对象发送release消息将其释放，在这个时间段内，对象还是可以使用的。
//    那autorelease的原理是什么呢？
//    　　原理就是对象接收到autorelease消息时，它会被添加到了当前的自动释放池中，当自动释放池被销毁时，会給池里所有的对象发送release消息。
//    这里就引出了自动释放池这个概念，什么是自动释放池呢？ 顾名思义，就是一个池，这个池可以容纳对象，而且可以自动释放，这就大大增加了我们处理对象的灵活性。
//    下面介绍下自动释放池的创建👇
//    方法一：使用NSAutoreleasePool来创建
//    [self demo3];
//    方法二：@autoreleasepool
//    [self demo4];
//    我们可以看到demo3中 [[NSAutoreleasePool alloc]init];自动释放池的创建
//    [pool release];自动释放池的释放
//    而demo4中则是在@autoreleasepool {//这里写代码}
//    只是不同的表现形式而已
//    自动释放池的销毁时间是确定的，一般是在程序事件处理之后释放，或者由我们自己手动释放。（[pool release];）
    
//    场景：现在xiaoming和xiaowang都想和小狗一起玩耍，但是他们的需求不一样，他们的玩耍时间不一样，流程如下
//    [self demo5]; // 手动释放
    
//    [self demo6];
    
//    [self demo7];
    
//    自动释放池中的对象会集中同一时间释放，如果操作需要生成的对象较多占用内存空间大，可以使用多个释放池来进行优化。比如在一个循环中需要创建大量的临时变量，可以创建内部的池子来降低内存占用峰值。
//    不过我个人觉得这种情况基本上不会出现。因为现在手机的性能很好，内存充足，但是还是模拟下吧
    
    //    基本原则 - 引用下
//    　　无规矩不成方圆，在iOS开发中也存在规则来约束开发者进行内存管理，总的来讲有三点：
//    　　1）当你通过new、alloc或copy方法创建一个对象时，它的引用计数为1，当不再使用该对象时，应该向对象发送release或者autorelease消息释放对象。
//    　　2）当你通过其他方法获得一个对象时，如果对象引用计数为1且被设置为autorelease，则不需要执行任何释放对象的操作；
//    　　3）如果你打算取得对象所有权，就需要保留对象并在操作完成之后释放，且必须保证retain和release的次数对等。
//
//    　　应用到文章开头的例子中，每出生一个小狗（生成对象），最后都要面临死亡（释放对象），如果只出生而不死亡（对象创建了没有释放），那居住面积就会越来越少（可用内存越来越少），到最后一个小狗都没有了（内存被耗尽），就再也没有小狗可申请了（无资源可申请使用），因此，必须要遵守规则：申请必须归还（规则1），申请几个必须归还几个（规则3），如果小狗被设定死亡时间则不会主动死亡（规则2）。
    
#pragma mark - ARC
//    在MRC时代，必须严格遵守以上规则，否则内存问题将成为恶魔一样的存在，然而来到ARC时代，事情似乎变得轻松了，不用再写无止尽的ratain和release似乎让开发变得轻松了，对初学者变得更友好。
    
//    ARC的修饰符
//    __strong：强引用，持有所指向对象的所有权，无修饰符情况下的默认值。如需强制释放，可置nil。当不需要使用时，强制销毁定时器
//    __weak：弱引用，不持有所指向对象的所有权，引用指向的对象内存被回收之后，引用本身会置nil，避免野指针。
//    比如避免循环引用的弱引用声明： __weak __typeof(self) weakSelf = self;
//    __autoreleasing：自动释放对象的引用，一般用于传递参数
//    比如一个读取数据的方法 - (void)loadData:(NSError **)error;
//    当你调用时会发现这样的提示
//    NSError * error;
//    [dataTool loadData:(NSError *__autoreleasing *)]
    
//    这是编译器自动帮我们插入以下代码
//    NSError * error;
//    NSError * __autoreleasing tmpErr = error;
//    [dataTool loadData:&tmpErr];
//
//　　__unsafe_unretained：为兼容iOS5以下版本的产物，可以理解成MRC下的weak，现在基本用不到，这里不作描述。
//
//
//　　3.4 属性的内存管理
//    　　ObjC2.0引入了@property，提供成员变量访问方法、权限、环境、内存管理类型的声明，下面主要说明ARC中属性的内存管理。
//
//    　　属性的参数分为三类，基本数据类型默认为(atomic,readwrite,assign)，对象类型默认为(atomic,readwrite,strong)，其中第三个参数就是该属性的内存管理方式修饰，修饰词可以是以下之一：
//　　assign：直接赋值
//    　　assign一般用来修饰基本数据类型 - int,BOOL等
//    例如： @property (nonatomic, assign) NSInteger count;
    
//    当然也可以修饰ObjC对象，但是不推荐，因为被assign修饰的对象释放后，指针还是指向释放前的内存，在后续操作中可能会导致内存问题引发崩溃。
//    retain：release旧值，再retain新值（引用计数＋1）
//    　　retain和strong一样，都用来修饰ObjC对象。
//    　　使用set方法赋值时，实质上是会先保留新值，再释放旧值，再设置新值，避免新旧值一样时导致对象被释放的的问题。
//    - (void)setCount:(NSObject *)count {
//        [count retain];   // retain（引用计数＋1）
//        [_count release]; // 释放老值
//        _count = count;   // 保留新值
//    }
//    ARC对应写法
//    - (void)setCount:(NSObject *)count {
//        _count = count;
//    }
// 为什么这样就可以了，其实本质还是和上面一致，只是系统帮我们干了这些
    
//    copy：release旧值，再copy新值（拷贝内容）
//    　　一般用来修饰String、Dict、Array等需要保护其封装性的对象，尤其是在其内容可变的情况下，因此会拷贝（深拷贝）一份内容給属性使用，避免可能造成的对源内容进行改动。
//
//    　　使用set方法赋值时，实质上是会先拷贝新值，再释放旧值，再设置新值。 基本和上面一样 只是最后一句改为_count = [count copy];
//    　　实际上，遵守NSCopying的对象都可以使用copy，当然，如果你确定是要共用同一份可变内容，你也可以使用strong或retain。
//       @property (nonatomic, copy) NSString * name;
    
//    weak：ARC新引入修饰词，可代替assign，比assign多增加一个特性（置nil，见上文）。
//    　　weak和strong一样用来修饰ObjC对象。
//    　　使用set方法赋值时，实质上不保留新值，也不释放旧值，只设置新值。 直白的说就是没有[count retain];和[_count release];
//    　　比如常用的代理的声明
    
#pragma mark - 内存管理 (堆栈)
//    移动设备的内存及其有限，每一个APP所能占用的内存是有限制的
//    什么行为会增加APP的内存占用
//    创建一个oc对象
//    定义一个变量
//    调用一个函数或者方法
    
//              内存管理范围
//    任何继承了NSObject的对象
//    对其它非对象类型无效
//    简单来说：
    //    只有oc对象需要进行内存管理
    //    非oc对象类型比如基本数据类型不需要进行内存管理
//    所以问题就来了，为什么OC对象需要进行内存管理，而其它非对象类型比如基本数据类型就不需要进行内存管理呢？
//    只有OC对象才需要进行内存管理的本质原因？
    //    因为：Objective-C的对象在内存中是以堆的方式分配空间的,并且堆内存是由你释放的，就是release
    //    OC对象存放于堆里面(堆内存要程序员手动回收)
    //    非OC对象一般放在栈里面(栈内存会被系统自动回收)
    //    堆里面的内存是动态分配的，所以也就需要程序员手动的去添加内存、回收内存
    //    对于栈来讲，是由系统编译器自动管理，不需要程序员手动管理
    //    对于堆来讲，释放工作由程序员手动管理，不及时回收容易产生内存泄露
    //    按分配方式分
    //    堆是动态分配和回收内存的，没有静态分配的堆
    //    栈有两种分配方式：静态分配和动态分配
    //    静态分配是系统编译器完成的，比如局部变量的分配
    //    动态分配是有alloc函数进行分配的，但是栈的动态分配和堆是不同的，它的动态分配也由系统编译器进行释放，不需要程序员手动管理
    
#pragma mark - 扩展
//    为了更好的理解内存管理机制，我们自己写个自动释放池
//    如何下手呢，那我们先来推理下，一步步先走走看
//    简单说，autorelease对象的释放动作由AutoReleasePool完成，所有autorelease对象在其【对应】的AutoReleasePool释放的过程中，都会受到一条release消息，也就是说，pool析构的实际也就是autorelease对象析构的时机，注意，这里的【对应】指的是离改autorelese最近的那一个AutoRelasePool。
//    有这么几种情况必须自己创建AutoReleasePool：
//    1：程序没有界面，也就是没有消息循环的程序，
//    2：一个循环内创建大量临时的autorelease对象，那么写法最好是这样的：
//    [self demo8];
    
// ⚠️注意：
//    1：避免循环引用，如果两个对象互相为对方的成员变量，那么这两个对象一定不能同时为retain，否则，两个对象的dealloc函数形成死锁，两个对象都无法释放。
//    2：不要滥用autorelease，如果一个对象的生命周期很清晰，那最好在结束使用后马上调用release，过多的等待autorelease对象会给内存造成不必要的负担。
//    3：编码过程中，建议将内存相关的函数，如init, dealloc, viewdidload, viewdidunload等函数放在最前，这样比较显眼，忘记处理的概率也会降低。
//    4：AutoReleasePool对象在释放的过程中，在IOS下，release和drain没有区别。但为了一致性，还是推荐使用drain。
    // NSAutoReleasePool *pool = [[NSAutoReleasePool alloc] init];
    // NSString *temp = [[[NSString alloc] init] autorelease];
    // [pool drain];
    
    [self demo9];
    
    
//    应用程序的内存管理是程序运行时内存分配的过程，使用它，并当你用完它的时候释放它。写得好的程序应该尽可能少的使用内存。在Objective-C，它也可以被看作是分布 数据和代码的许多块当中的有限的内存资源的所有权的方法。当您完成通过这一指南的工作，你将有一些关于你的应用程序的内存管理知识，你需要明确管理对象的生命周期，并且当他们不再需要管理时释放他们。
//    虽然内存管理通常被认为是在单独对象的水平，你的目标其实是管理 object graphs，你要确保你在内存中没有比实际需要 更多的对象。
//    Objective-C的应用程序提供了内存管理的两种方法。
//    在本指南中说明的方法，通过跟踪你自己的对象，明确地管理内存，被称为“手动保留释放(manual retain-release)”或MRR。这是用一个模型来实现，称为引用计数，是基础类 NSObject 提供的，并与运行环境相结合。
    
//    有两种主要类型的问题，即不正确的内存管理导致：
//    释放或改写仍在使用的数据
//    这会导致内存损坏，通常会导致应用程序崩溃，或者更糟，破坏用户数据。
//    不释放不再使用的数据导致内存泄漏
//    内存泄漏就是分配的内存不释放，即使它永远不会再次使用。泄漏导致您的应用程序使用的内存量的不断增加，这反过来又可能导致较差的系统性能或您的应用程序被终止。
//    然而，从引用计数的角度思考内存管理，经常是适得其反，因为你往往会考虑内存管理的实施细则方面，而不是在你的实际目标方面。相反，你应该从对象所有权的角度去思考内存管理。
    
//    你自己通过 alloc 返回一个 string。遵守内存管理规则，你必须在失去引用之前放弃该字符串的所有权。但是如果使用release，字符串将在返回之前被释放（并且该方法将返回一个无效对象）。使用autorelease，你表示要放弃所有权，但允许方法的调用者在它被销毁之前使用返回的字符串。上面demo9的例子便是如此
    
//    通常，你不应该在 dealloc 中来管理稀缺系统资源，比如文件描述符、网络连接、缓存等。尤其注意，你不应该这样设计类：你想让系统什么时候调用 dealloc，系统就什么时候调用。dealloc 的调用可能会被推迟或者搁置，比如因为 bug 或者程序销毁系统性能下降。
//    相反，如果你有一个类，管理了稀缺资源，它就必须知道它什么时候不再需要这些资源,并在此时立即释放资源。通常情况下,此时,你会调用 release 来 dealloc,但是因 为此前你已经释放了资源,这里就不会遇到任何问题。
    
//    我们看看这个.m文件
//    int main(int argc, char * argv[]) {
//        @autoreleasepool {
//            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//        }
//    }
//    如果不写这个块的话，那么由UIApplicationMain函数所自动释放的那些对象，就没有自动释放池可以容纳了，于是系统会发出警告信息，所以说，这个池可以理解成最外围捕捉全部自动释放对象所用的池,会在程序退出时自动释放。可以把autorelease pool理解成一个类似父类与子类的关系，main()创建了父类，每个Runloop自动生成的或者开发者自定义的autorelease pool都会成为该父类的子类。当父类被释放的时候，没有被释放的子类也会被释放，这样所有子类中的对象也会收到release消息。
//    做多线程开发时,需要在线程调度方法中手动添加自动释放池，尤其是当执行循环的时候，如果循环内部有使用类的快速创建方法创建的对象， 一定要将循环体放到自动释放池中。
//    关于NSAutoreleasePool
//    NSAutoreleasePool实际上是个对象引用计数自动处理器，在官方文档中被称为是一个类。
//    NSAutoreleasePool可以同时有多个，它的组织是个栈，总是存在一个栈顶pool，也就是当前pool，每创建一个pool，就往栈里压一个，改变当前pool为新建的pool，然后，每次给pool发送release消息，就弹出栈顶的pool，改当前pool为栈里的下一个 pool。
//    在每个OC对象都有自己的引用计数器，内部都专门4个字节的存储空间来存储引用计数器。其实引用计数器的作用就是用来判断对象要不要被回收。对象刚被创建时，默认计数器值为1，当计数器的值变为0时，则对象销毁，其占用的内存被系统回收。
//    总结:个人的理解的话，可能是这样子的，在MRC和ARC中其实每个Runloop都会自动创建一个自动释放池，然后在ARC中我们不需要retain和release和autorelease，因为编译器会自动的帮我们生成，而在MRC中的话，只要还有人在使用某个对象，那么这个对象就不会被回收；只要你想使用这个对象，那么就应该让这个对象的引用计数器+1；当你不想使用这个对象时，应该让对象的引用计数器-1；如果你通过alloc,new,copy来创建了一个对象，那么你就必须调用release或者autorelease方法。只要你用了retain生成一个对象,你就要release它。当对象被销毁时，系统会自动向对象发送一条dealloc消息，一般会重写dealloc方法，在这里释放相关的资源，dealloc就像是对象的“临终遗言”。一旦重写了dealloc方法就必须调用[super dealloc]，并且放在代码块的最后调用，不能直接调用dealloc方法。系统自带的方法中，如果不包含alloc new copy等，则这些方法返回的对象都是autorelease的，如[NSDate date]；
    
    // 内存处理不正确的隐患:
//    内存泄露:不再需要的对象没有释放
//    引起的问题:程序的内存占有量不断增加,最终会被耗尽导致程序崩溃
//    野指针:没有进行初始化得指针
//    引起的问题:浪费内存资源,如果调用程序会出现未知的结果,甚至导致程序崩溃
//    空指针:一个指针指向一个被销毁的对象
//    引起的问题:调用悬空指针指向的属性或者方法时,程序会出现未知的结果,甚至导致程序崩溃
//    僵尸对象:过度释放的对象
//    引起的问题:指向僵尸对象的指针成为野指针,给野指针发送消息会报EXC_BAD_ACCESS 错误
    
//    非自己持有的对象无法释放---注意以下两点,如果发生这样的情况会导致程序崩溃
//    通过alloc new copy mutableCopy方法或者通过retain方法持有的对象,一旦不再需要时,必须进行释放,除此之外其他方法获得的对象绝对不能释放,一旦释放会造成程序崩溃
//    自己持有的对象释放后再次释放,造成僵死对象,引起程序崩溃或在访问废弃的对象时崩溃
//    id obj = [[NSObject alloc] init]; [obj release]; [obj release]; // 再次释放
    
//    被释放的对象为僵尸对象
//    指向僵尸对象的指针是野指针
//    空指针 是把指针位 nil
//    不会报错
    
//    那么，什么是僵尸对象?什么是野指针?什么是空指针?如何避免野指针错误?
//    被释放的对象为僵尸对象
//    指向僵尸对象的指针为野指针
//    空指针是把指针为nil
    
//    1. 僵尸对象 已经被销毁的对象(不能再使用的对象)
//    2. 野指针 指向僵尸对象(不可用内存)的指针 给野指针发消息会报EXC_BAD_ACCESS错误
//    3. 空指针 没有指向存储空间的指针(里面存的是nil, 也就是0) 给空指针发消息是没有任何反应的
//    4. 为了避免野指针错误的常见办法: 在对象被销毁之后, 将指向对象的指针变为空指针
    
    // 接着继续看看AutoreleasePool
//    AutoreleasePoolPage 这个类的完整定义也在 NSObject.mm 这个文件里面
//#define POOL_SENTINEL nil   // 哨兵对象
//    static pthread_key_t const key = AUTORELEASE_POOL_KEY;  // 用于 TLS 获得 hotPage 的 key
//    static uint8_t const SCRIBBLE = 0xA3;  // 乱写的数据，用于填充被释放对象所占据的“帧”
//    static size_t const SIZE = PAGE_MAX_SIZE;  // 该类重载了 new 操作符，为 page 对象分配 SIZE 这么大的内存空间
//    static size_t const COUNT = SIZE / sizeof(id);
//    magic_t const magic;    // 应该是类似于魔数之类的东西，用于标记和判断什么？
//    id *next;    // 能放置对象的下一个地址或栈顶
//    pthread_t const thread;    // 与该 page 对象绑定的线程
//    AutoreleasePoolPage * const parent;
//    AutoreleasePoolPage *child;
//    uint32_t const depth;    // page 的深度，或者说是这个里链表头部的距离，第一个结点为 0，第二个为 1，以此类推
//    uint32_t hiwat;    // high water 高水位？不清楚其作用
//    首先是 POOL_SENTINEL，也就是刚刚提到哨兵对象，实际只是 nil 的别名而已。使用过 NSAutoreleasePool 的人都知道，Pool 是可以嵌套使用的，而在实现上，由于每个 Pool 不是独立的结构，就要依靠这个哨兵来区分各个 Pool 块：
    
#ifdef DEBUG
//    UIViewController *vc = [[NSClassFromString(@"TestFunctionVC") alloc]init];
//    [vc retain];
//    [self presentViewController:vc animated:YES completion:nil];
#endif
}

- (void)demo1 {
    //模拟：小狗出世了
    Dog *dog = [[Dog alloc]init];                          // +1         由 0 -> 1
    //模拟：小狗又生了小狗，需要将其引用计数加1
    [dog retain];                                           // +1
    NSLog(@"小狗的引用计数为 %ld",dog.retainCount);
    //模拟：小狗老死了，需要将其引用计数减1
    [dog release];                                          // -1
    NSLog(@"小狗的引用计数为 %ld",dog.retainCount);
    //小狗孩子夭折了，将其引用计数减1
    [dog release];                                          // -1
    //将指针置nil，否则变为野指针
    dog = nil;                                              // 指针置空
    
    //  打印结果如下：
//    2018-04-18 18:00:56.124836+0800 内存管理实例[90646:1627648] 小狗出世了！初始引用计数为 1
//    2018-04-18 18:00:56.125009+0800 内存管理实例[90646:1627648] 小狗的引用计数为 2
//    2018-04-18 18:00:56.125123+0800 内存管理实例[90646:1627648] 小狗的引用计数为 1
//    2018-04-18 18:00:56.125221+0800 内存管理实例[90646:1627648] 小狗死了
    
//    分析一下 - 如上所述 首先mrc情况下，内存自己管理，alloc申请内存空间会+1，retain会加1.release会减1，指针需要手动置空。负责创建也需要负责释放
}

- (void)demo2 {
    NSString *str = @"hello World";
    NSLog(@"%ld", str.retainCount);
    
    //  打印结果如下：
//    2018-04-18 18:08:13.866268+0800 内存管理实例[90782:1649508] -1
    
//    会发现引用计数为－1，这可以理解为NSString实际上是一个字符串常量，是没有引用计数的（或者它的引用计数是一个很大的值（使用%lu可以打印查看），对它做引用计数操作没实质上的影响）。
    
//    2）赋值不会拥有某个对象
    Dog *dog = [[Dog alloc]init];
    NSString *name = dog.name;
    NSLog(@"name:%@", name);
//    这里仅仅是指针赋值操作，并不会增加name的引用计数，需要持有对象必须要发送retain消息。
    
    //    dealloc
    //    　　由于释放对象是会调用dealloc方法，因此重写dealloc方法来查看对象释放的情况，如果没有调用则会造成内存泄露。在上面的例子中我们通过重写dealloc让小狗被释放的时候打印日志来告诉我们已经完成释放。
//    我们增加这样一个操作
    [dog release];
    NSLog(@"%ld", dog.retainCount);
    
    //  打印结果如下：
//    2018-04-18 18:14:33.441906+0800 内存管理实例[90920:1673820] 小狗出世了！初始引用计数为 1
//    2018-04-18 18:14:33.442030+0800 内存管理实例[90920:1673820] 小狗死了
//    崩溃了：信息如下
//    Thread 1: EXC_BAD_ACCESS (code=EXC_I386_GPFLT)
    
//    原因分析
//    是因为对引用计数为1的对象release时，系统知道该对象将被回收，就不会再对该对象的引用计数进行减1操作，这样可以增加对象回收的效率。
//    另外，对已释放的对象发送消息是不可取的，因为对象的内存已被回收，如果发送消息时，该内存已经被其他对象使用了，得到的结果是无法确定的，甚至会造成崩溃。- 我们就崩溃了
}

- (void)demo3 {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc]init];
    //这里写代码
    [pool release];
}

- (void)demo4 {
    //    自动释放池创建后，就会成为活动的池子，释放池子后，池子将释放其所包含的所有对象。
    
    @autoreleasepool {
        //这里写代码
    }
    
//    自动释放池什么时候创建？
//    　　app使用过程中，会定期自动生成和销毁自动释放池，一般是在程序事件处理之前创建，当然我们也可以自行创建自动释放池，来达到我们一些特定的目的。
    
//    自动释放池什么时候销毁？
//    　　自动释放池的销毁时间是确定的，一般是在程序事件处理之后释放，或者由我们自己手动释放。
}

- (void)demo5 {
    //创建一个自动释放池
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; // 此处打印为小狗出世了！初始引用计数为 1
    //模拟：宠物中心派出小狗
    Dog *dog = [[Dog alloc]init];
    
    //模拟：xiaoming需要和小狗玩耍，需要将其引用计数加1
    [dog retain];
    NSLog(@"小狗的引用计数为 %ld",dog.retainCount);                  // 此处打印为小狗的引用计数为 2
    
    //模拟：xiaowang需要和小狗玩耍，需要将其引用计数加1
    [dog retain];
    NSLog(@"小狗的引用计数为 %ld",dog.retainCount);                  // 此处打印为小狗的引用计数为 3
    
    //模拟：xiaoming确定不想和小狗玩耍了，需要将其引用计数减1
    [dog release];
    NSLog(@"小狗的引用计数为 %ld",dog.retainCount);                  // 此处打印为小狗的引用计数为 2
    
    //模拟：xiaowang不确定何时不想和小狗玩耍了，将其设置为自动释放
    [dog autorelease];                                            // 小狗自动释放 （初始的alloc会因为NSAutoreleasePool而自动检测释放 - 即局部变量dog的引用计数）
    NSLog(@"小狗的引用计数为 %ld",dog.retainCount);
    
    //没人需要和小狗玩耍了，将其引用计数减1
    [dog release];                                                //
    
    NSLog(@"释放池子");
    [pool release];                                               // 此处释放池子

    //  打印结果如下：
//    2018-04-19 10:31:21.848978+0800 内存管理实例[96255:1970561] 小狗出世了！初始引用计数为 1
//    2018-04-19 10:31:21.849253+0800 内存管理实例[96255:1970561] 小狗的引用计数为 2
//    2018-04-19 10:31:21.849434+0800 内存管理实例[96255:1970561] 小狗的引用计数为 3
//    2018-04-19 10:31:21.849538+0800 内存管理实例[96255:1970561] 小狗的引用计数为 2
//    2018-04-19 10:31:21.849705+0800 内存管理实例[96255:1970561] 小狗的引用计数为 2
//    2018-04-19 10:31:21.849795+0800 内存管理实例[96255:1970561] 释放池子
//    2018-04-19 10:31:21.849878+0800 内存管理实例[96255:1970561] 小狗死了
}

- (void)demo6 {
    //创建一个自动释放池
    @autoreleasepool {
        //模拟：宠物中心派出小狗
        Dog *dog = [[Dog alloc]init];
        
        //模拟：xiaoming需要和小狗玩耍，需要将其引用计数加1
        [dog retain];
        NSLog(@"小狗的引用计数为 %ld",dog.retainCount);
        
        //模拟：xiaowang需要和小狗玩耍，需要将其引用计数加1
        [dog retain];
        NSLog(@"小狗的引用计数为 %ld",dog.retainCount);
        
        //模拟：xiaoming确定不想和小狗玩耍了，需要将其引用计数减1
        [dog release];
        NSLog(@"小狗的引用计数为 %ld",dog.retainCount);
        
        //模拟：xiaowang不确定何时不想和小狗玩耍了，将其设置为自动释放
        [dog autorelease];
        NSLog(@"小狗的引用计数为 %ld",dog.retainCount);
        
        //没人需要和小狗玩耍了，将其引用计数减1
        [dog release];
        
        NSLog(@"释放池子");
    }
    // 自动释放池结束的时候会释放，类似于java的垃圾回收机制
//    自动释放池实质上只是在释放的时候給池中所有对象对象发送release消息，不保证对象一定会销毁，如果自动释放池向对象发送release消息后对象的引用计数仍大于1，对象就无法销毁。
    
    //  打印结果如下：
//    2018-04-19 10:43:31.585166+0800 内存管理实例[96967:2010534] 小狗出世了！初始引用计数为 1
//    2018-04-19 10:43:31.585377+0800 内存管理实例[96967:2010534] 小狗的引用计数为 2
//    2018-04-19 10:43:31.585497+0800 内存管理实例[96967:2010534] 小狗的引用计数为 3
//    2018-04-19 10:43:31.585621+0800 内存管理实例[96967:2010534] 小狗的引用计数为 2
//    2018-04-19 10:43:31.585735+0800 内存管理实例[96967:2010534] 小狗的引用计数为 2
//    2018-04-19 10:43:31.585887+0800 内存管理实例[96967:2010534] 释放池子
//    2018-04-19 10:43:31.586001+0800 内存管理实例[96967:2010534] 小狗死了
    
//    和楼上的demo5一样！就不挨个标注了，只是池子的表现形式变成了@autoreleasepool{}这种形式
//    autorelease不会改变对象的引用计数 如上[dog autorelease];
}

- (void)demo7 {
//    在管理对象释放的问题上，自动帮助我们释放池节省了大量的时间，但是有时候它却未必会达到我们期望的效果，比如在一个循环事件中，如果循环次数较大或者事件处理占用内存较大，就会导致内存占用不断增长，可能会导致不希望看到的后果。
//    　　模拟一个
//    for (int i = 0; i < 100000; i ++) {
//        Dog *dog  = [[Dog alloc]init];
//        NSLog(@"%i", i);
//    }
    
//    打印数据太多，取第一条和最后一条
//    2018-04-19 11:21:32.613473+0800 内存管理实例[98111:2114562] 0
//    2018-04-19 11:22:03.875922+0800 内存管理实例[98111:2114562] 99999
//    整整34秒有余
//    自动释放池的释放时间是确定的，这个例子中自动释放池会在循环事件结束时释放，在这个十万次的循环中，每次都会生成一个字符串并打印，这些字符串对象都放在池子中并直到循环结束才会释放，内存加了2MB
    
//    for (int i = 0; i < 100000; i ++) {
//        @autoreleasepool {
//            Dog *dog  = [[Dog alloc]init];
//            [dog autorelease];
//            NSLog(@"%i", i);
//        }
//    }
//    打印数据太多，取第一条和最后一条
//    2018-04-19 11:23:04.136971+0800 内存管理实例[98148:2121087] 0
//    2018-04-19 11:23:43.609808+0800 内存管理实例[98148:2121087] 99999
//    但是内存一直为41MB
        //    我们的类太纯净了，内存占用太低，决定换个大点的试试
    @autoreleasepool {
        for (int i = 0; i < 100000; i ++) {
            UILabel *label  = [[UILabel alloc]init];
            [label autorelease];
            NSLog(@"%i", i);
        }
    }
//    打印数据太多，取第一条和最后一条
//    2018-04-19 11:31:27.957140+0800 内存管理实例[98345:2144658] 0
//    2018-04-19 11:32:38.119956+0800 内存管理实例[98345:2144658] 99981
// 内存激增为268.7MB, 而后慢慢回退到126.3MB
    
//    for (int i = 0; i < 100000; i ++) {
//        @autoreleasepool {
//            UILabel *label  = [[UILabel alloc]init];
//            [label autorelease];
//            NSLog(@"%i", i);
//        }
//    }
// 内存少许波动到51.5MB
    
//    虽然我们的结论印证了，但是内存增长有些不明白，于是查看下是否存在内存泄漏
//    上下两个都开软件跑了，并没有内存泄漏。至于系统控件的内存占用情况暂时就不过深研究了 （我认为是系统缓存的原因，就不加以验证了）
}

- (void)demo8 {
    NSAutoreleasePool *outPool = [[NSAutoreleasePool alloc] init];
    for (int index = 0; index != 1000000; ++index) {
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        NSString *temp = [[[NSString alloc] init] autorelease];
        [pool drain];
    }
    [outPool release];
//    若果没有循环中的pool, 那么直到结束循环之前，这1000000个autorelease 临时对象都不会被释放掉，占用大量内存。
}

- (void)demo9 {
    @autoreleasepool {
        // 场景 1
//            NSString *string = [NSString stringWithFormat:@"wangjun"];
//            [string autorelease];
//            string_weak_ = string;
//        2018-04-23 10:39:32.330172+0800 内存管理实例[21338:264240] string: wangjun
//        2018-04-23 10:39:32.330480+0800 内存管理实例[21338:264240] viewWillAppear-string: wangjun
//        2018-04-23 10:39:32.335723+0800 内存管理实例[21338:264240] viewDidAppear-string: wangjun
        
        // 场景 2
//        @autoreleasepool {
//            NSString *string = [NSString stringWithFormat:@"wangjun"];
//            [string autorelease];
//            string_weak_ = string;
//        }

//        2018-04-23 10:40:26.148156+0800 内存管理实例[21427:268621] string: wangjun
//        2018-04-23 10:40:26.148489+0800 内存管理实例[21427:268621] viewWillAppear-string: wangjun
//        2018-04-23 10:40:26.153563+0800 内存管理实例[21427:268621] viewDidAppear-string: wangjun
        
        // 场景 3
//        NSString *string = nil;
//        [string autorelease];
//        @autoreleasepool {
//            string = [NSString stringWithFormat:@"wangjun"];
//            [string autorelease];
//            string_weak_ = string;
//        }
//        2018-04-23 10:42:10.742877+0800 内存管理实例[21560:276371] string: wangjun
//        2018-04-23 10:42:10.743300+0800 内存管理实例[21560:276371] viewWillAppear-string: wangjun
//        2018-04-23 10:42:10.749923+0800 内存管理实例[21560:276371] viewDidAppear-string: wangjun
//        NSLog(@"string: %@", string_weak_);
    }
    
//    所有的打印均是三个都有值 - 这个确实不太明白 把它放外面试试
//    NSLog(@"out-string: %@", string_weak_);
//    2018-04-23 10:47:26.928205+0800 内存管理实例[21982:298663] string: wangjun
//    2018-04-23 10:47:26.929300+0800 内存管理实例[21982:298663] out-string: wangjun
//    2018-04-23 10:47:26.930164+0800 内存管理实例[21982:298663] viewWillAppear-string: wangjun
//    2018-04-23 10:47:26.938898+0800 内存管理实例[21982:298663] viewDidAppear-string: wangjun
    
    
//    加个五秒延迟试试
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"delay-string: %@", string_weak_);
//    });
//    2018-04-23 10:48:42.772056+0800 内存管理实例[22096:303834] string: wangjun
//    2018-04-23 10:48:42.772450+0800 内存管理实例[22096:303834] viewWillAppear-string: wangjun
//    2018-04-23 10:48:42.778037+0800 内存管理实例[22096:303834] viewDidAppear-string: wangjun
//    2018-04-23 10:48:47.772563+0800 内存管理实例[22096:303834] delay-string: wangjun
    
//    发现string_weak_的值并没有释放，为什么呢？没想明白，先换种方式来看一看
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    NSString *string = nil;
//    NSLog(@"1.string的引用计数为 %ld",string.retainCount);
//    @autoreleasepool {
//        string = [[NSString stringWithFormat:@"wangjun"] autorelease];
//        NSLog(@"2.string的引用计数为 %ld",string.retainCount);
//        [string autorelease];
//        NSLog(@"3.string的引用计数为 %ld",string.retainCount);
////        string_weak_ = string;
//    }
//    [pool drain];
//    NSLog(@"4.string的引用计数为 %ld",string.retainCount);
//    NSLog(@"string_weak_: %@", string_weak_);
//    2018-04-23 10:52:56.058796+0800 内存管理实例[22404:321133] string: wangjun
//    2018-04-23 10:52:56.059124+0800 内存管理实例[22404:321133] viewWillAppear-string: wangjun
//    2018-04-23 10:52:56.064441+0800 内存管理实例[22404:321133] viewDidAppear-string: wangjun
//    再来确认一下是不是string_weak_的问题，注释 string_weak_ = string;打印string再试试
//    NSLog(@"string: %@", string);
//    string没有释放，那是为什么呢，看看string的引用计数
//    这可以理解-NSString实际上是一个字符串常量，是没有引用计数的（或者它的引用计数是一个很大的值（使用%lu可以打印查看），对它做引用计数操作没实质上的影响。所以更换为对象进行测试
    
    // 场景 1
//    Dog *dog = [[[Dog alloc]init]autorelease];
//    dog_weak_ = dog;
//    2018-04-23 11:05:31.810964+0800 内存管理实例[23018:370877] dog: <Dog: 0x6000000101a0>
//    2018-04-23 11:05:31.811366+0800 内存管理实例[23018:370877] viewWillAppear-dog: <Dog: 0x6000000101a0>
//    2018-04-23 11:05:31.816334+0800 内存管理实例[23018:370877] viewDidAppear-dog: (null)
    
    // 场景 2
//    @autoreleasepool {
//        Dog *dog = [[[Dog alloc]init]autorelease];
//        dog_weak_ = dog;
//    }
//    2018-04-23 11:06:10.018790+0800 内存管理实例[23073:375005] dog: (null)
//    2018-04-23 11:06:10.019057+0800 内存管理实例[23073:375005] viewWillAppear-dog: (null)
//    2018-04-23 11:06:10.023976+0800 内存管理实例[23073:375005] viewDidAppear-dog: (null)
    
    // 场景 3
//            __strong Dog *dog = nil;
//            NSLog(@"1.dog的引用计数为 %ld",dog.retainCount);
//            @autoreleasepool {
//                dog = [[[Dog alloc]init]autorelease];
//                NSLog(@"2.dog的引用计数为 %ld",dog.retainCount);
//                dog_weak_ = dog;
//                NSLog(@"3.dog的引用计数为 %ld",dog.retainCount);
//            }
//    2018-04-23 11:06:33.261722+0800 内存管理实例[23100:377361] dog: (null)
//    2018-04-23 11:06:33.262037+0800 内存管理实例[23100:377361] viewWillAppear-dog: (null)
//    2018-04-23 11:06:33.267587+0800 内存管理实例[23100:377361] viewDidAppear-dog: (null)
//    NSLog(@"dog_weak_: %@", dog_weak_);
//    NSLog(@"dog: %@", dog);
//    按我的推断打印应该是
//    2018-04-23 11:11:58.631250+0800 内存管理实例[23321:402572] dog: 有值
//    2018-04-23 11:11:58.631628+0800 内存管理实例[23321:402572] viewWillAppear-dog: (null)
//    2018-04-23 11:11:58.636159+0800 内存管理实例[23321:402572] viewDidAppear-dog: (null)
    
//    但是第一条确是没值的，单步调试，发现dog是有值的，但是dog_weak_没值，而且是出了自动释放池就没值了
//    再添加一个NSLog(@"dog: %@", dog);，允许。发现程序崩溃，原来dog的内存已被释放了。
//    再来观察一下dog的引用计数，更加深入了解一下自动释放池的工作原理和生命周期
//
    
//    分析一下 3 种情况下，我们都通过 [[[Dog alloc]init]autorelease] 创建了一个 autoreleased 对象。并且，为了能够在 viewWillAppear 和 viewDidAppear 中继续访问这个对象，我们使用了一个全局的 __weak 变量 dog_weak_ 来指向它。因为 __weak 变量有一个特性就是它不会影响所指向对象的生命周期，这里我们正是利用了这个特性。
//    场景 1：当使用 [[[Dog alloc]init]autorelease] 创建一个对象时，这个对象的引用计数为 1 ，并且这个对象被系统自动添加到了当前的 autoreleasepool 中。当使用局部变量 Dog 指向这个对象 。因为在 ARC 下  Dog *dog 本质上就是 __strong Dog *dog 。所以在 viewDidLoad 方法返回前，这个对象是一直存在的，且引用计数为 2 。而当 viewDidLoad 方法返回时，局部变量 dog 被回收，指向了 nil 。因此，其所指向对象的引用计数 -1 ，变成了 1 。
    
//    我们在上面已经提到了 -[NSAutoreleasePool release] 方法.其最终是通过调用 AutoreleasePoolPage::pop(void *) 函数来负责对 autoreleasepool 中的 autoreleased 对象执行 release 操作的。
//    那这里的 AutoreleasePoolPage 是什么东西呢？其实，autoreleasepool 是没有单独的内存结构的，它是通过以 AutoreleasePoolPage 为结点的双向链表来实现的。我们打开 runtime 的源码工程，在 NSObject.mm 文件的第 438-932 行可以找到 autoreleasepool 的实现源码。通过阅读源码，我们可以知道：
//    每一个线程的 autoreleasepool 其实就是一个指针的堆栈；
//    去查了一下：
//    每一个指针代表一个需要 release 的对象或者 POOL_SENTINEL（哨兵对象，代表一个 autoreleasepool 的边界）；
//    一个 pool token 就是这个 pool 所对应的 POOL_SENTINEL 的内存地址。当这个 pool 被 pop 的时候，所有内存地址在 pool token 之后的对象都会被 release ；
//    这个堆栈被划分成了一个以 page 为结点的双向链表。pages 会在必要的时候动态地增加或删除；
//    Thread-local storage（线程局部存储）指向 hot page ，即最新添加的 autoreleased 对象所在的那个 page 。
    
    //    将@autoreleasepool {}还原为C代码： -
//    extern "C" __declspec(dllimport) void * objc_autoreleasePoolPush(void);
//    extern "C" __declspec(dllimport) void objc_autoreleasePoolPop(void *);
//    struct __AtAutoreleasePool {
//        __AtAutoreleasePool() {atautoreleasepoolobj = objc_autoreleasePoolPush();}
//        ~__AtAutoreleasePool() {objc_autoreleasePoolPop(atautoreleasepoolobj);}
//        void * atautoreleasepoolobj;
//    };
//    / *@autoreleasepool */ { __AtAutoreleasePool __autoreleasepool;
//    }
//    苹果对 @autoreleasepool {} 的实现真的是非常巧妙，真正可以称得上是代码的艺术。苹果通过声明一个 __AtAutoreleasePool 类型的局部变量 __autoreleasepool 来实现 @autoreleasepool {} 。当声明 __autoreleasepool 变量时，构造函数 __AtAutoreleasePool() 被调用，即执行 atautoreleasepoolobj = objc_autoreleasePoolPush(); ；当出了当前作用域时，析构函数 ~__AtAutoreleasePool() 被调用，即执行 objc_autoreleasePoolPop(atautoreleasepoolobj); 。也就是说 @autoreleasepool {} 的实现代码可以进一步简化如下：
    
//    / *@autoreleasepool */ {
//        void *atautoreleasepoolobj = objc_autoreleasePoolPush();
//        // 用户代码，所有接收到 autorelease 消息的对象会被添加到这个 autoreleasepool 中
//        objc_autoreleasePoolPop(atautoreleasepoolobj);
//    }
    
//    push操作
//    void *objc_autoreleasePoolPush(void) {
//        if (UseGC) return nil;
//        return AutoreleasePoolPage::push();
//    }
    
//    pop 操作
//    static inline void *push() {
//        id *dest = autoreleaseFast(POOL_SENTINEL);
//        assert(*dest == POOL_SENTINEL);
//        return dest;
//    }
    
//    push 函数通过调用 autoreleaseFast 函数来执行具体的插入操作。
//    static inline id *autoreleaseFast(id obj) {
//        AutoreleasePoolPage *page = hotPage();
//        if (page && !page->full()) {
//            return page->add(obj);
//        } else if (page) {
//            return autoreleaseFullPage(obj, page);
//        } else {
//            return autoreleaseNoPage(obj);
//        }
//    }
    
//    autoreleaseFast 函数在执行一个具体的插入操作时，分别对三种情况进行了不同的处理：
//    当前 page 存在且没有满时，直接将对象添加到当前 page 中，即 next 指向的位置；
//    当前 page 存在且已满时，创建一个新的 page ，并将对象添加到新创建的 page 中；
//    当前 page 不存在时，即还没有 page 时，创建第一个 page ，并将对象添加到新创建的 page 中。
//    每调用一次 push 操作就会创建一个新的 autoreleasepool ，即往 AutoreleasePoolPage 中插入一个 POOL_SENTINEL ，并且返回插入的 POOL_SENTINEL 的内存地址。
    
//    autorelease 操作
//    通过 NSObject.mm 源文件，我们可以找到 -autorelease 方法的实现：
//    - (id)autorelease {
//        return ((id)self)->rootAutorelease();
//    }
    
//    通过查看 ((id)self)->rootAutorelease() 的方法调用，我们发现最终调用的就是 AutoreleasePoolPage 的 autorelease 函数。
//    __attribute__((noinline,used))
//    id objc_object::rootAutorelease2() {
//        assert(!isTaggedPointer());
//        return AutoreleasePoolPage::autorelease((id)this);
//    }
    
//    AutoreleasePoolPage 的 autorelease 函数的实现对我们来说就比较容量理解了，它跟 push 操作的实现非常相似。只不过 push 操作插入的是一个 POOL_SENTINEL ，而 autorelease 操作插入的是一个具体的 autoreleased 对象。
    
//    static inline id autorelease(id obj) {
//        assert(obj);
//        assert(!obj->isTaggedPointer());
//        id *dest __unused = autoreleaseFast(obj);
//        assert(!dest  || * dest == obj);
//        return obj;
//    }
    
//    这个自己也没全弄明白，就不叙述了
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
