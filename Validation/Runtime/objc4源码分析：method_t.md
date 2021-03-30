

# objc4源码分析：method_t



参考源码：libmalloc-317.40.8.tar.gz



```c++
struct method_t {
    static const uint32_t smallMethodListFlag = 0x80000000;

    method_t(const method_t &other) = delete;

    // The representation of a "big" method. This is the traditional
    // representation of three pointers storing the selector, types
    // and implementation.
    struct big {
        // 函数名称
        SEL name;
        // 编码（返回值，参数类型）
        const char *types;
        // 指向函数指针（函数地址）
        MethodListIMP imp;
    };

private:
    bool isSmall() const {
        return ((uintptr_t)this & 1) == 1;
    }

    // The representation of a "small" method. This stores three
    // relative offsets to the name, types, and implementation.
    struct small {
        // The name field either refers to a selector (in the shared
        // cache) or a selref (everywhere else).
        RelativePointer<const void *> name;
        RelativePointer<const char *> types;
        RelativePointer<IMP> imp;

        bool inSharedCache() const {
            return (CONFIG_SHARED_CACHE_RELATIVE_DIRECT_SELECTORS &&
                    objc::inSharedCache((uintptr_t)this));
        }
    };

    small &small() const {
        ASSERT(isSmall());
        return *(struct small *)((uintptr_t)this & ~(uintptr_t)1);
    }

    IMP remappedImp(bool needsLock) const;
    void remapImp(IMP imp);
    objc_method_description *getSmallDescription() const;

public:
    static const auto bigSize = sizeof(struct big);
    static const auto smallSize = sizeof(struct small);

    // The pointer modifier used with method lists. When the method
    // list contains small methods, set the bottom bit of the pointer.
    // We use that bottom bit elsewhere to distinguish between big
    // and small methods.
    struct pointer_modifier {
        template <typename ListType>
        static method_t *modify(const ListType &list, method_t *ptr) {
            if (list.flags() & smallMethodListFlag)
                return (method_t *)((uintptr_t)ptr | 1);
            return ptr;
        }
    };

    big &big() const {
        ASSERT(!isSmall());
        return *(struct big *)this;
    }

    SEL name() const {
        if (isSmall()) {
            return (small().inSharedCache()
                    ? (SEL)small().name.get()
                    : *(SEL *)small().name.get());
        } else {
            return big().name;
        }
    }
    const char *types() const {
        return isSmall() ? small().types.get() : big().types;
    }
    IMP imp(bool needsLock) const {
        if (isSmall()) {
            IMP imp = remappedImp(needsLock);
            if (!imp)
                imp = ptrauth_sign_unauthenticated(small().imp.get(),
                                                   ptrauth_key_function_pointer, 0);
            return imp;
        }
        return big().imp;
    }

    SEL getSmallNameAsSEL() const {
        ASSERT(small().inSharedCache());
        return (SEL)small().name.get();
    }

    SEL getSmallNameAsSELRef() const {
        ASSERT(!small().inSharedCache());
        return *(SEL *)small().name.get();
    }

    void setName(SEL name) {
        if (isSmall()) {
            ASSERT(!small().inSharedCache());
            *(SEL *)small().name.get() = name;
        } else {
            big().name = name;
        }
    }

    void setImp(IMP imp) {
        if (isSmall()) {
            remapImp(imp);
        } else {
            big().imp = imp;
        }
    }

    objc_method_description *getDescription() const {
        return isSmall() ? getSmallDescription() : (struct objc_method_description *)this;
    }

    struct SortBySELAddress :
    public std::binary_function<const struct method_t::big&,
                                const struct method_t::big&, bool>
    {
        bool operator() (const struct method_t::big& lhs,
                         const struct method_t::big& rhs)
        { return lhs.name < rhs.name; }
    };

    method_t &operator=(const method_t &other) {
        ASSERT(!isSmall());
        big().name = other.name();
        big().types = other.types();
        big().imp = other.imp(false);
        return *this;
    }
}
```

