## ios内存管理机制



在每一次runloop中检查对象的retain count，retain count 等于0时，释放对象