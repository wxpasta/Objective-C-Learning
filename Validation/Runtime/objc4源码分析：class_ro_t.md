# objc4源码分析：class_ro_t



参考源码：libmalloc-317.40.8.tar.gz



```c++
struct class_ro_t {
    uint32_t flags;
    uint32_t instanceStart;
    uint32_t instanceSize;
#ifdef __LP64__
    uint32_t reserved;
#endif

    union {
        const uint8_t * ivarLayout;
        Class nonMetaclass;
    };

    explicit_atomic<const char *> name;
    // With ptrauth, this is signed if it points to a small list, but
    // may be unsigned if it points to a big list.
    void *baseMethodList;
    protocol_list_t * baseProtocols;
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



Path:objc-runtime-new.h

```c++
// Two bits of entsize are used for fixup markers.
// Reserve the top half of entsize for more flags. We never
// need entry sizes anywhere close to 64kB.
//
// Currently there is one flag defined: the small method list flag,
// method_t::smallMethodListFlag. Other flags are currently ignored.
// (NOTE: these bits are only ignored on runtimes that support small
// method lists. Older runtimes will treat them as part of the entry
// size!)
struct method_list_t : entsize_list_tt<method_t, method_list_t, 0xffff0003, method_t::pointer_modifier> {
    bool isUniqued() const;
    bool isFixedUp() const;
    void setFixedUp();

    uint32_t indexOfMethod(const method_t *meth) const {
        uint32_t i = 
            (uint32_t)(((uintptr_t)meth - (uintptr_t)this) / entsize());
        ASSERT(i < count);
        return i;
    }

    bool isSmallList() const {
        return flags() & method_t::smallMethodListFlag;
    }

    bool isExpectedSize() const {
        if (isSmallList())
            return entsize() == method_t::smallSize;
        else
            return entsize() == method_t::bigSize;
    }

    method_list_t *duplicate() const {
        method_list_t *dup;
        if (isSmallList()) {
            dup = (method_list_t *)calloc(byteSize(method_t::bigSize, count), 1);
            dup->entsizeAndFlags = method_t::bigSize;
        } else {
            dup = (method_list_t *)calloc(this->byteSize(), 1);
            dup->entsizeAndFlags = this->entsizeAndFlags;
        }
        dup->count = this->count;
        std::copy(begin(), end(), dup->begin());
        return dup;
    }
};
```



存储原始信息，不包含类别信息。