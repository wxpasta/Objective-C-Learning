# objc4源码分析：objc_class



参考源码：libmalloc-317.40.8.tar.gz

### 简写说明

    rw = read write 
    ro = read only
    t = table


### objc_class

Path: objc-runtime-new.h

```objective-c
struct objc_class : objc_object {
  objc_class(const objc_class&) = delete;
  objc_class(objc_class&&) = delete;
  void operator=(const objc_class&) = delete;
  void operator=(objc_class&&) = delete;
    // Class ISA;
    Class superclass;
    // 方法缓存
    cache_t cache;             // formerly cache pointer and vtable
    // 用于获取具体的类信息
    class_data_bits_t bits;    // class_rw_t * plus custom rr/alloc flags

    Class getSuperclass() const {
#if __has_feature(ptrauth_calls)
#   if ISA_SIGNING_AUTH_MODE == ISA_SIGNING_AUTH
        if (superclass == Nil)
            return Nil;

#if SUPERCLASS_SIGNING_TREAT_UNSIGNED_AS_NIL
        void *stripped = ptrauth_strip((void *)superclass, ISA_SIGNING_KEY);
        if ((void *)superclass == stripped) {
            void *resigned = ptrauth_sign_unauthenticated(stripped, ISA_SIGNING_KEY, ptrauth_blend_discriminator(&superclass, ISA_SIGNING_DISCRIMINATOR_CLASS_SUPERCLASS));
            if ((void *)superclass != resigned)
                return Nil;
        }
#endif
            
        void *result = ptrauth_auth_data((void *)superclass, ISA_SIGNING_KEY, ptrauth_blend_discriminator(&superclass, ISA_SIGNING_DISCRIMINATOR_CLASS_SUPERCLASS));
        return (Class)result;

#   else
        return (Class)ptrauth_strip((void *)superclass, ISA_SIGNING_KEY);
#   endif
#else
        return superclass;
#endif
    }

    void setSuperclass(Class newSuperclass) {
#if ISA_SIGNING_SIGN_MODE == ISA_SIGNING_SIGN_ALL
        superclass = (Class)ptrauth_sign_unauthenticated((void *)newSuperclass, ISA_SIGNING_KEY, ptrauth_blend_discriminator(&superclass, ISA_SIGNING_DISCRIMINATOR_CLASS_SUPERCLASS));
#else
        superclass = newSuperclass;
#endif
    }
  
    class_rw_t *data() const {
        return bits.data();
    }
    void setData(class_rw_t *newData) {
        bits.setData(newData);
    }

    void setInfo(uint32_t set) {
        ASSERT(isFuture()  ||  isRealized());
        data()->setFlags(set);
    }

    void clearInfo(uint32_t clear) {
        ASSERT(isFuture()  ||  isRealized());
        data()->clearFlags(clear);
    }

    // set and clear must not overlap
    void changeInfo(uint32_t set, uint32_t clear) {
        ASSERT(isFuture()  ||  isRealized());
        ASSERT((set & clear) == 0);
        data()->changeFlags(set, clear);
    }

#if FAST_HAS_DEFAULT_RR
    bool hasCustomRR() const {
        return !bits.getBit(FAST_HAS_DEFAULT_RR);
    }
    void setHasDefaultRR() {
        bits.setBits(FAST_HAS_DEFAULT_RR);
    }
    void setHasCustomRR() {
        bits.clearBits(FAST_HAS_DEFAULT_RR);
    }
#else
    bool hasCustomRR() const {
        return !(bits.data()->flags & RW_HAS_DEFAULT_RR);
    }
    void setHasDefaultRR() {
        bits.data()->setFlags(RW_HAS_DEFAULT_RR);
    }
    void setHasCustomRR() {
        bits.data()->clearFlags(RW_HAS_DEFAULT_RR);
    }
#endif

#if FAST_CACHE_HAS_DEFAULT_AWZ
    bool hasCustomAWZ() const {
        return !cache.getBit(FAST_CACHE_HAS_DEFAULT_AWZ);
    }
    void setHasDefaultAWZ() {
        cache.setBit(FAST_CACHE_HAS_DEFAULT_AWZ);
    }
    void setHasCustomAWZ() {
        cache.clearBit(FAST_CACHE_HAS_DEFAULT_AWZ);
    }
#else
    bool hasCustomAWZ() const {
        return !(bits.data()->flags & RW_HAS_DEFAULT_AWZ);
    }
    void setHasDefaultAWZ() {
        bits.data()->setFlags(RW_HAS_DEFAULT_AWZ);
    }
    void setHasCustomAWZ() {
        bits.data()->clearFlags(RW_HAS_DEFAULT_AWZ);
    }
#endif

#if FAST_CACHE_HAS_DEFAULT_CORE
    bool hasCustomCore() const {
        return !cache.getBit(FAST_CACHE_HAS_DEFAULT_CORE);
    }
    void setHasDefaultCore() {
        return cache.setBit(FAST_CACHE_HAS_DEFAULT_CORE);
    }
    void setHasCustomCore() {
        return cache.clearBit(FAST_CACHE_HAS_DEFAULT_CORE);
    }
#else
    bool hasCustomCore() const {
        return !(bits.data()->flags & RW_HAS_DEFAULT_CORE);
    }
    void setHasDefaultCore() {
        bits.data()->setFlags(RW_HAS_DEFAULT_CORE);
    }
    void setHasCustomCore() {
        bits.data()->clearFlags(RW_HAS_DEFAULT_CORE);
    }
#endif

#if FAST_CACHE_HAS_CXX_CTOR
    bool hasCxxCtor() {
        ASSERT(isRealized());
        return cache.getBit(FAST_CACHE_HAS_CXX_CTOR);
    }
    void setHasCxxCtor() {
        cache.setBit(FAST_CACHE_HAS_CXX_CTOR);
    }
#else
    bool hasCxxCtor() {
        ASSERT(isRealized());
        return bits.data()->flags & RW_HAS_CXX_CTOR;
    }
    void setHasCxxCtor() {
        bits.data()->setFlags(RW_HAS_CXX_CTOR);
    }
#endif

#if FAST_CACHE_HAS_CXX_DTOR
    bool hasCxxDtor() {
        ASSERT(isRealized());
        return cache.getBit(FAST_CACHE_HAS_CXX_DTOR);
    }
    void setHasCxxDtor() {
        cache.setBit(FAST_CACHE_HAS_CXX_DTOR);
    }
#else
    bool hasCxxDtor() {
        ASSERT(isRealized());
        return bits.data()->flags & RW_HAS_CXX_DTOR;
    }
    void setHasCxxDtor() {
        bits.data()->setFlags(RW_HAS_CXX_DTOR);
    }
#endif

#if FAST_CACHE_REQUIRES_RAW_ISA
    bool instancesRequireRawIsa() {
        return cache.getBit(FAST_CACHE_REQUIRES_RAW_ISA);
    }
    void setInstancesRequireRawIsa() {
        cache.setBit(FAST_CACHE_REQUIRES_RAW_ISA);
    }
#elif SUPPORT_NONPOINTER_ISA
    bool instancesRequireRawIsa() {
        return bits.data()->flags & RW_REQUIRES_RAW_ISA;
    }
    void setInstancesRequireRawIsa() {
        bits.data()->setFlags(RW_REQUIRES_RAW_ISA);
    }
#else
    bool instancesRequireRawIsa() {
        return true;
    }
    void setInstancesRequireRawIsa() {
        // nothing
    }
#endif
    void setInstancesRequireRawIsaRecursively(bool inherited = false);
    void printInstancesRequireRawIsa(bool inherited);

#if CONFIG_USE_PREOPT_CACHES
    bool allowsPreoptCaches() const {
        return !(bits.data()->flags & RW_NOPREOPT_CACHE);
    }
    bool allowsPreoptInlinedSels() const {
        return !(bits.data()->flags & RW_NOPREOPT_SELS);
    }
    void setDisallowPreoptCaches() {
        bits.data()->setFlags(RW_NOPREOPT_CACHE | RW_NOPREOPT_SELS);
    }
    void setDisallowPreoptInlinedSels() {
        bits.data()->setFlags(RW_NOPREOPT_SELS);
    }
    void setDisallowPreoptCachesRecursively(const char *why);
    void setDisallowPreoptInlinedSelsRecursively(const char *why);
#else
    bool allowsPreoptCaches() const { return false; }
    bool allowsPreoptInlinedSels() const { return false; }
    void setDisallowPreoptCaches() { }
    void setDisallowPreoptInlinedSels() { }
    void setDisallowPreoptCachesRecursively(const char *why) { }
    void setDisallowPreoptInlinedSelsRecursively(const char *why) { }
#endif

    bool canAllocNonpointer() {
        ASSERT(!isFuture());
        return !instancesRequireRawIsa();
    }

    bool isSwiftStable() {
        return bits.isSwiftStable();
    }

    bool isSwiftLegacy() {
        return bits.isSwiftLegacy();
    }

    bool isAnySwift() {
        return bits.isAnySwift();
    }

    bool isSwiftStable_ButAllowLegacyForNow() {
        return bits.isSwiftStable_ButAllowLegacyForNow();
    }

    uint32_t swiftClassFlags() {
        return *(uint32_t *)(&bits + 1);
    }
  
    bool usesSwiftRefcounting() {
        if (!isSwiftStable()) return false;
        return bool(swiftClassFlags() & 2); //ClassFlags::UsesSwiftRefcounting
    }

    bool canCallSwiftRR() {
        // !hasCustomCore() is being used as a proxy for isInitialized(). All
        // classes with Swift refcounting are !hasCustomCore() (unless there are
        // category or swizzling shenanigans), but that bit is not set until a
        // class is initialized. Checking isInitialized requires an extra
        // indirection that we want to avoid on RR fast paths.
        //
        // In the unlikely event that someone causes a class with Swift
        // refcounting to be hasCustomCore(), we'll fall back to sending -retain
        // or -release, which is still correct.
        return !hasCustomCore() && usesSwiftRefcounting();
    }

    bool isStubClass() const {
        uintptr_t isa = (uintptr_t)isaBits();
        return 1 <= isa && isa < 16;
    }

    // Swift stable ABI built for old deployment targets looks weird.
    // The is-legacy bit is set for compatibility with old libobjc.
    // We are on a "new" deployment target so we need to rewrite that bit.
    // These stable-with-legacy-bit classes are distinguished from real
    // legacy classes using another bit in the Swift data
    // (ClassFlags::IsSwiftPreStableABI)

    bool isUnfixedBackwardDeployingStableSwift() {
        // Only classes marked as Swift legacy need apply.
        if (!bits.isSwiftLegacy()) return false;

        // Check the true legacy vs stable distinguisher.
        // The low bit of Swift's ClassFlags is SET for true legacy
        // and UNSET for stable pretending to be legacy.
        bool isActuallySwiftLegacy = bool(swiftClassFlags() & 1);
        return !isActuallySwiftLegacy;
    }

    void fixupBackwardDeployingStableSwift() {
        if (isUnfixedBackwardDeployingStableSwift()) {
            // Class really is stable Swift, pretending to be pre-stable.
            // Fix its lie.
            bits.setIsSwiftStable();
        }
    }

    _objc_swiftMetadataInitializer swiftMetadataInitializer() {
        return bits.swiftMetadataInitializer();
    }

    // Return YES if the class's ivars are managed by ARC, 
    // or the class is MRC but has ARC-style weak ivars.
    bool hasAutomaticIvars() {
        return data()->ro()->flags & (RO_IS_ARC | RO_HAS_WEAK_WITHOUT_ARC);
    }

    // Return YES if the class's ivars are managed by ARC.
    bool isARC() {
        return data()->ro()->flags & RO_IS_ARC;
    }


    bool forbidsAssociatedObjects() {
        return (data()->flags & RW_FORBIDS_ASSOCIATED_OBJECTS);
    }

#if SUPPORT_NONPOINTER_ISA
    // Tracked in non-pointer isas; not tracked otherwise
#else
    bool instancesHaveAssociatedObjects() {
        // this may be an unrealized future class in the CF-bridged case
        ASSERT(isFuture()  ||  isRealized());
        return data()->flags & RW_INSTANCES_HAVE_ASSOCIATED_OBJECTS;
    }

    void setInstancesHaveAssociatedObjects() {
        // this may be an unrealized future class in the CF-bridged case
        ASSERT(isFuture()  ||  isRealized());
        setInfo(RW_INSTANCES_HAVE_ASSOCIATED_OBJECTS);
    }
#endif

    bool shouldGrowCache() {
        return true;
    }

    void setShouldGrowCache(bool) {
        // fixme good or bad for memory use?
    }

    bool isInitializing() {
        return getMeta()->data()->flags & RW_INITIALIZING;
    }

    void setInitializing() {
        ASSERT(!isMetaClass());
        ISA()->setInfo(RW_INITIALIZING);
    }

    bool isInitialized() {
        return getMeta()->data()->flags & RW_INITIALIZED;
    }

    void setInitialized();

    bool isLoadable() {
        ASSERT(isRealized());
        return true;  // any class registered for +load is definitely loadable
    }

    IMP getLoadMethod();

    // Locking: To prevent concurrent realization, hold runtimeLock.
    bool isRealized() const {
        return !isStubClass() && (data()->flags & RW_REALIZED);
    }

    // Returns true if this is an unrealized future class.
    // Locking: To prevent concurrent realization, hold runtimeLock.
    bool isFuture() const {
        if (isStubClass())
            return false;
        return data()->flags & RW_FUTURE;
    }

    bool isMetaClass() const {
        ASSERT_THIS_NOT_NULL;
        ASSERT(isRealized());
#if FAST_CACHE_META
        return cache.getBit(FAST_CACHE_META);
#else
        return data()->flags & RW_META;
#endif
    }

    // Like isMetaClass, but also valid on un-realized classes
    bool isMetaClassMaybeUnrealized() {
        static_assert(offsetof(class_rw_t, flags) == offsetof(class_ro_t, flags), "flags alias");
        static_assert(RO_META == RW_META, "flags alias");
        if (isStubClass())
            return false;
        return data()->flags & RW_META;
    }

    // NOT identical to this->ISA when this is a metaclass
    Class getMeta() {
        if (isMetaClassMaybeUnrealized()) return (Class)this;
        else return this->ISA();
    }

    bool isRootClass() {
        return getSuperclass() == nil;
    }
    bool isRootMetaclass() {
        return ISA() == (Class)this;
    }
  
    // If this class does not have a name already, we can ask Swift to construct one for us.
    const char *installMangledNameForLazilyNamedClass();

    // Get the class's mangled name, or NULL if the class has a lazy
    // name that hasn't been created yet.
    const char *nonlazyMangledName() const {
        return bits.safe_ro()->getName();
    }

    const char *mangledName() { 
        // fixme can't assert locks here
        ASSERT_THIS_NOT_NULL;

        const char *result = nonlazyMangledName();

        if (!result) {
            // This class lazily instantiates its name. Emplace and
            // return it.
            result = installMangledNameForLazilyNamedClass();
        }

        return result;
    }
    
    const char *demangledName(bool needsLock);
    const char *nameForLogging();

    // May be unaligned depending on class's ivars.
    uint32_t unalignedInstanceStart() const {
        ASSERT(isRealized());
        return data()->ro()->instanceStart;
    }

    // Class's instance start rounded up to a pointer-size boundary.
    // This is used for ARC layout bitmaps.
    uint32_t alignedInstanceStart() const {
        return word_align(unalignedInstanceStart());
    }

    // May be unaligned depending on class's ivars.
    uint32_t unalignedInstanceSize() const {
        ASSERT(isRealized());
        return data()->ro()->instanceSize;
    }

    // Class's ivar size rounded up to a pointer-size boundary.
    uint32_t alignedInstanceSize() const {
        return word_align(unalignedInstanceSize());
    }

    inline size_t instanceSize(size_t extraBytes) const {
        if (fastpath(cache.hasFastInstanceSize(extraBytes))) {
            return cache.fastInstanceSize(extraBytes);
        }

        size_t size = alignedInstanceSize() + extraBytes;
        // CF requires all objects be at least 16 bytes.
        if (size < 16) size = 16;
        return size;
    }

    void setInstanceSize(uint32_t newSize) {
        ASSERT(isRealized());
        ASSERT(data()->flags & RW_REALIZING);
        auto ro = data()->ro();
        if (newSize != ro->instanceSize) {
            ASSERT(data()->flags & RW_COPIED_RO);
            *const_cast<uint32_t *>(&ro->instanceSize) = newSize;
        }
        cache.setFastInstanceSize(newSize);
    }

    void chooseClassArrayIndex();

    void setClassArrayIndex(unsigned Idx) {
        bits.setClassArrayIndex(Idx);
    }

    unsigned classArrayIndex() {
        return bits.classArrayIndex();
    }
}
```



### objc_object

Path:objc-private.h

```objective-c
struct objc_object {
private:
    isa_t isa;

public:

    // ISA() assumes this is NOT a tagged pointer object
    Class ISA(bool authenticated = false);

    // rawISA() assumes this is NOT a tagged pointer object or a non pointer ISA
    Class rawISA();

    // getIsa() allows this to be a tagged pointer object
    Class getIsa();
    
    uintptr_t isaBits() const;

    // initIsa() should be used to init the isa of new objects only.
    // If this object already has an isa, use changeIsa() for correctness.
    // initInstanceIsa(): objects with no custom RR/AWZ
    // initClassIsa(): class objects
    // initProtocolIsa(): protocol objects
    // initIsa(): other objects
    void initIsa(Class cls /*nonpointer=false*/);
    void initClassIsa(Class cls /*nonpointer=maybe*/);
    void initProtocolIsa(Class cls /*nonpointer=maybe*/);
    void initInstanceIsa(Class cls, bool hasCxxDtor);

    // changeIsa() should be used to change the isa of existing objects.
    // If this is a new object, use initIsa() for performance.
    Class changeIsa(Class newCls);

    bool hasNonpointerIsa();
    bool isTaggedPointer();
    bool isTaggedPointerOrNil();
    bool isBasicTaggedPointer();
    bool isExtTaggedPointer();
    bool isClass();

    // object may have associated objects?
    bool hasAssociatedObjects();
    void setHasAssociatedObjects();

    // object may be weakly referenced?
    bool isWeaklyReferenced();
    void setWeaklyReferenced_nolock();

    // object may have -.cxx_destruct implementation?
    bool hasCxxDtor();

    // Optimized calls to retain/release methods
    id retain();
    void release();
    id autorelease();

    // Implementations of retain/release methods
    id rootRetain();
    bool rootRelease();
    id rootAutorelease();
    bool rootTryRetain();
    bool rootReleaseShouldDealloc();
    uintptr_t rootRetainCount();

    // Implementation of dealloc methods
    bool rootIsDeallocating();
    void clearDeallocating();
    void rootDealloc();

private:
    void initIsa(Class newCls, bool nonpointer, bool hasCxxDtor);

    // Slow paths for inline control
    id rootAutorelease2();
    uintptr_t overrelease_error();

#if SUPPORT_NONPOINTER_ISA
    // Controls what parts of root{Retain,Release} to emit/inline
    // - Full means the full (slow) implementation
    // - Fast means the fastpaths only
    // - FastOrMsgSend means the fastpaths but checking whether we should call
    //   -retain/-release or Swift, for the usage of objc_{retain,release}
    enum class RRVariant {
        Full,
        Fast,
        FastOrMsgSend,
    };

    // Unified retain count manipulation for nonpointer isa
    inline id rootRetain(bool tryRetain, RRVariant variant);
    inline bool rootRelease(bool performDealloc, RRVariant variant);
    id rootRetain_overflow(bool tryRetain);
    uintptr_t rootRelease_underflow(bool performDealloc);

    void clearDeallocating_slow();

    // Side table retain count overflow for nonpointer isa
    struct SidetableBorrow { size_t borrowed, remaining; };

    void sidetable_lock();
    void sidetable_unlock();

    void sidetable_moveExtraRC_nolock(size_t extra_rc, bool isDeallocating, bool weaklyReferenced);
    bool sidetable_addExtraRC_nolock(size_t delta_rc);
    SidetableBorrow sidetable_subExtraRC_nolock(size_t delta_rc);
    size_t sidetable_getExtraRC_nolock();
    void sidetable_clearExtraRC_nolock();
#endif

    // Side-table-only retain count
    bool sidetable_isDeallocating();
    void sidetable_clearDeallocating();

    bool sidetable_isWeaklyReferenced();
    void sidetable_setWeaklyReferenced_nolock();

    id sidetable_retain(bool locked = false);
    id sidetable_retain_slow(SideTable& table);

    uintptr_t sidetable_release(bool locked = false, bool performDealloc = true);
    uintptr_t sidetable_release_slow(SideTable& table, bool performDealloc = true);

    bool sidetable_tryRetain();

    uintptr_t sidetable_retainCount();
#if DEBUG
    bool sidetable_present();
#endif
}
```

objc_object结构根本就是isa。



### class_rw_t

Path: objc-runtime-new.h

````objective-c
struct class_rw_t {
    // Be warned that Symbolication knows the layout of this structure.
    uint32_t flags;
    uint16_t witness;
#if SUPPORT_INDEXED_ISA
    uint16_t index;
#endif

    explicit_atomic<uintptr_t> ro_or_rw_ext;

    Class firstSubclass;
    Class nextSiblingClass;

private:
    using ro_or_rw_ext_t = objc::PointerUnion<const class_ro_t, class_rw_ext_t, PTRAUTH_STR("class_ro_t"), PTRAUTH_STR("class_rw_ext_t")>;

    const ro_or_rw_ext_t get_ro_or_rwe() const {
        return ro_or_rw_ext_t{ro_or_rw_ext};
    }

    void set_ro_or_rwe(const class_ro_t *ro) {
        ro_or_rw_ext_t{ro, &ro_or_rw_ext}.storeAt(ro_or_rw_ext, memory_order_relaxed);
    }

    void set_ro_or_rwe(class_rw_ext_t *rwe, const class_ro_t *ro) {
        // the release barrier is so that the class_rw_ext_t::ro initialization
        // is visible to lockless readers
        rwe->ro = ro;
        ro_or_rw_ext_t{rwe, &ro_or_rw_ext}.storeAt(ro_or_rw_ext, memory_order_release);
    }

    class_rw_ext_t *extAlloc(const class_ro_t *ro, bool deep = false);

public:
    void setFlags(uint32_t set)
    {
        __c11_atomic_fetch_or((_Atomic(uint32_t) *)&flags, set, __ATOMIC_RELAXED);
    }

    void clearFlags(uint32_t clear) 
    {
        __c11_atomic_fetch_and((_Atomic(uint32_t) *)&flags, ~clear, __ATOMIC_RELAXED);
    }

    // set and clear must not overlap
    void changeFlags(uint32_t set, uint32_t clear) 
    {
        ASSERT((set & clear) == 0);

        uint32_t oldf, newf;
        do {
            oldf = flags;
            newf = (oldf | set) & ~clear;
        } while (!OSAtomicCompareAndSwap32Barrier(oldf, newf, (volatile int32_t *)&flags));
    }

    class_rw_ext_t *ext() const {
        return get_ro_or_rwe().dyn_cast<class_rw_ext_t *>(&ro_or_rw_ext);
    }

    class_rw_ext_t *extAllocIfNeeded() {
        auto v = get_ro_or_rwe();
        if (fastpath(v.is<class_rw_ext_t *>())) {
            return v.get<class_rw_ext_t *>(&ro_or_rw_ext);
        } else {
            return extAlloc(v.get<const class_ro_t *>(&ro_or_rw_ext));
        }
    }

    class_rw_ext_t *deepCopy(const class_ro_t *ro) {
        return extAlloc(ro, true);
    }

    const class_ro_t *ro() const {
        auto v = get_ro_or_rwe();
        if (slowpath(v.is<class_rw_ext_t *>())) {
            return v.get<class_rw_ext_t *>(&ro_or_rw_ext)->ro;
        }
        return v.get<const class_ro_t *>(&ro_or_rw_ext);
    }

    void set_ro(const class_ro_t *ro) {
        auto v = get_ro_or_rwe();
        if (v.is<class_rw_ext_t *>()) {
            v.get<class_rw_ext_t *>(&ro_or_rw_ext)->ro = ro;
        } else {
            set_ro_or_rwe(ro);
        }
    }

  	// 方法列表
    const method_array_t methods() const {
        auto v = get_ro_or_rwe();
        if (v.is<class_rw_ext_t *>()) {
            return v.get<class_rw_ext_t *>(&ro_or_rw_ext)->methods;
        } else {
            return method_array_t{v.get<const class_ro_t *>(&ro_or_rw_ext)->baseMethods()};
        }
    }

    	// 属性列表
    const property_array_t properties() const {
        auto v = get_ro_or_rwe();
        if (v.is<class_rw_ext_t *>()) {
            return v.get<class_rw_ext_t *>(&ro_or_rw_ext)->properties;
        } else {
            return property_array_t{v.get<const class_ro_t *>(&ro_or_rw_ext)->baseProperties};
        }
    }

    	// 协议列表
    const protocol_array_t protocols() const {
        auto v = get_ro_or_rwe();
        if (v.is<class_rw_ext_t *>()) {
            return v.get<class_rw_ext_t *>(&ro_or_rw_ext)->protocols;
        } else {
            return protocol_array_t{v.get<const class_ro_t *>(&ro_or_rw_ext)->baseProtocols};
        }
    }
}
````



### class_ro_t

Path: objc-runtime-new.h

```objective-c
struct class_ro_t {
    uint32_t flags;
    uint32_t instanceStart;
    // instance 对象占用的内存
    uint32_t instanceSize;
#ifdef __LP64__
    uint32_t reserved;
#endif

    union {
        const uint8_t * ivarLayout;
        Class nonMetaclass;
    };

    // 类名
    explicit_atomic<const char *> name;
    // With ptrauth, this is signed if it points to a small list, but
    // may be unsigned if it points to a big list.
    void *baseMethodList;
    protocol_list_t * baseProtocols;
    //  成员变量列表
    const ivar_list_t * ivars;

    const uint8_t * weakIvarLayout;
    property_list_t *baseProperties;

    // This field exists only when RO_HAS_SWIFT_INITIALIZER is set.
    _objc_swiftMetadataInitializer __ptrauth_objc_method_list_imp _swiftMetadataInitializer_NEVER_USE[0];

    _objc_swiftMetadataInitializer swiftMetadataInitializer() const {
        if (flags & RO_HAS_SWIFT_INITIALIZER) {
            return _swiftMetadataInitializer_NEVER_USE[0];
        } else {
            return nil;
        }
    }

    const char *getName() const {
        return name.load(std::memory_order_acquire);
    }

    static const uint16_t methodListPointerDiscriminator = 0xC310;
#if 0 // FIXME: enable this when we get a non-empty definition of __ptrauth_objc_method_list_pointer from ptrauth.h.
        static_assert(std::is_same<
                      void * __ptrauth_objc_method_list_pointer *,
                      void * __ptrauth(ptrauth_key_method_list_pointer, 1, methodListPointerDiscriminator) *>::value,
                      "Method list pointer signing discriminator must match ptrauth.h");
#endif

    method_list_t *baseMethods() const {
#if __has_feature(ptrauth_calls)
        method_list_t *ptr = ptrauth_strip((method_list_t *)baseMethodList, ptrauth_key_method_list_pointer);
        if (ptr == nullptr)
            return nullptr;

        // Don't auth if the class_ro and the method list are both in the shared cache.
        // This is secure since they'll be read-only, and this allows the shared cache
        // to cut down on the number of signed pointers it has.
        bool roInSharedCache = objc::inSharedCache((uintptr_t)this);
        bool listInSharedCache = objc::inSharedCache((uintptr_t)ptr);
        if (roInSharedCache && listInSharedCache)
            return ptr;

        // Auth all other small lists.
        if (ptr->isSmallList())
            ptr = ptrauth_auth_data((method_list_t *)baseMethodList,
                                    ptrauth_key_method_list_pointer,
                                    ptrauth_blend_discriminator(&baseMethodList,
                                                                methodListPointerDiscriminator));
        return ptr;
#else
        return (method_list_t *)baseMethodList;
#endif
    }

    uintptr_t baseMethodListPtrauthData() const {
        return ptrauth_blend_discriminator(&baseMethodList,
                                           methodListPointerDiscriminator);
    }

    class_ro_t *duplicate() const {
        bool hasSwiftInitializer = flags & RO_HAS_SWIFT_INITIALIZER;

        size_t size = sizeof(*this);
        if (hasSwiftInitializer)
            size += sizeof(_swiftMetadataInitializer_NEVER_USE[0]);

        class_ro_t *ro = (class_ro_t *)memdup(this, size);

        if (hasSwiftInitializer)
            ro->_swiftMetadataInitializer_NEVER_USE[0] = this->_swiftMetadataInitializer_NEVER_USE[0];

#if __has_feature(ptrauth_calls)
        // Re-sign the method list pointer if it was signed.
        // NOTE: It is possible for a signed pointer to have a signature
        // that is all zeroes. This is indistinguishable from a raw pointer.
        // This code will treat such a pointer as signed and re-sign it. A
        // false positive is safe: method list pointers are either authed or
        // stripped, so if baseMethods() doesn't expect it to be signed, it
        // will ignore the signature.
        void *strippedBaseMethodList = ptrauth_strip(baseMethodList, ptrauth_key_method_list_pointer);
        void *signedBaseMethodList = ptrauth_sign_unauthenticated(strippedBaseMethodList,
                                                                  ptrauth_key_method_list_pointer,
                                                                  baseMethodListPtrauthData());
        if (baseMethodList == signedBaseMethodList) {
            ro->baseMethodList = ptrauth_auth_and_resign(baseMethodList,
                                                         ptrauth_key_method_list_pointer,
                                                         baseMethodListPtrauthData(),
                                                         ptrauth_key_method_list_pointer,
                                                         ro->baseMethodListPtrauthData());
        } else {
            // Special case: a class_ro_t in the shared cache pointing to a
            // method list in the shared cache will not have a signed pointer,
            // but the duplicate will be expected to have a signed pointer since
            // it's not in the shared cache. Detect that and sign it.
            bool roInSharedCache = objc::inSharedCache((uintptr_t)this);
            bool listInSharedCache = objc::inSharedCache((uintptr_t)strippedBaseMethodList);
            if (roInSharedCache && listInSharedCache)
                ro->baseMethodList = ptrauth_sign_unauthenticated(strippedBaseMethodList,
                                                                  ptrauth_key_method_list_pointer,
                                                                  ro->baseMethodListPtrauthData());
        }
#endif

        return ro;
    }

    Class getNonMetaclass() const {
        ASSERT(flags & RO_META);
        return nonMetaclass;
    }

    const uint8_t *getIvarLayout() const {
        if (flags & RO_META)
            return nullptr;
        return ivarLayout;
    }
}
```

