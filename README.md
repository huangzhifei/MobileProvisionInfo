# MobileProvisionInfo
读取 embedded.mobileprovision 文件做一层ios包防重签名

具体可以看解析内容

# 如何查看 embedded.mobileprovision 内容

进入 app 的包内容，通过下面命令查看其详细信息

security cms -D -i embedded.mobileprovision

可以发现这个文件其实是一个 xml。

