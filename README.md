###单例模式处理

>多人开发时，为了防止其他同事的代码中对单例初始化，做断言处理，在程序任何地方初始化单例类，都会造成程序闪退并报错，虽然这样做并不是很友好。但是考虑到使用单例的目的就是为了让这个对象只初始化一次.

####举例：程序中的数据库操作类命名为`DBHelper`,当调用`[DBHelper alloc]init]` `[DBHelper new]`时程序会闪退并给出提示；

```
Terminating app due to uncaught exception 'NSInternalInconsistencyException', reason: 'There can only be one DBHelper instance.'
```
