# objc4源码分析：objc_removeAssociatedObjects

参考源码：objc4-818.2.tar.gz



Path:objc-runtime.mm

```objective-c
void objc_removeAssociatedObjects(id object) 
{
    if (object && object->hasAssociatedObjects()) {
        _object_remove_assocations(object, /*deallocating*/false);
    }
}	
```



Path:objc-references.mm

```objective-c
// Unlike setting/getting an associated reference,
// this function is performance sensitive because of
// raw isa objects (such as OS Objects) that can't track
// whether they have associated objects.
void
_object_remove_assocations(id object, bool deallocating)
{
    ObjectAssociationMap refs{};

    {
        AssociationsManager manager;
        AssociationsHashMap &associations(manager.get());
        AssociationsHashMap::iterator i = associations.find((objc_object *)object);
        if (i != associations.end()) {
            refs.swap(i->second);

            // If we are not deallocating, then SYSTEM_OBJECT associations are preserved.
            bool didReInsert = false;
            if (!deallocating) {
                for (auto &ref: refs) {
                    if (ref.second.policy() & OBJC_ASSOCIATION_SYSTEM_OBJECT) {
                        i->second.insert(ref);
                        didReInsert = true;
                    }
                }
            }
            if (!didReInsert)
                // erase 擦除操作
                associations.erase(i);
        }
    }

    // Associations to be released after the normal ones.
    SmallVector<ObjcAssociation *, 4> laterRefs;

    // release everything (outside of the lock).
    for (auto &i: refs) {
        if (i.second.policy() & OBJC_ASSOCIATION_SYSTEM_OBJECT) {
            // If we are not deallocating, then RELEASE_LATER associations don't get released.
            if (deallocating)
                laterRefs.append(&i.second);
        } else {
            i.second.releaseHeldValue();
        }
    }
    for (auto *later: laterRefs) {
        later->releaseHeldValue();
    }
}
```

