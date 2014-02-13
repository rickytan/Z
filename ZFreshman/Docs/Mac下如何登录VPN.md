# Mac 下如何登录 VPN

浙大 VPN 使用的是无 `IPSec` 的 `L2TP` 协议，所以 Mac 电脑下自带的 VPN 连接默认是无法使用的，其实只要添加以下 `VPN` 设置就可以了：

1. 在 `/etc/ppp` 目录下创建空文件：`options`（需要超级权限）;
2. 打开 `options`，并键下以下文件内容：

		plugin L2TP.ppp
		l2tpnoipsec

3. 保存，退出，打开网络设置新建`VPN`，输入用户名密码就好，浙大 VPN 服务器地址为：`lns.zju.edu.cn`，其它可选的有`10.5.1.5`，`10.5.1.7`，`10.5.1.9`