## Vprix Images

该仓库是`Vprix`项目的应用镜像仓库，它包含多种多样的桌面应用镜像。
比如:`vsCode`,`chromium`,`firfox`等。你可以很简单的通过一行命令在你的服务器上启动这些应用。并且可以通过浏览器访问使用。

你也可以使用这些`image`作为基础镜像，自定义制作出你需要的`App Image`.

这里的每个镜像都使用[vprix-core-images](https://github.com/vprix/vprix-core-images)作为基础镜像构建而成。

## 如何使用

编译`chromium`镜像：
```shell
make build-chromium 
```

运行`chromium`镜像：
```shell
make run-chromium 
```

启动镜像后可以在浏览器输入`http://localhost:8080`访问。

## 关于 Vprix

`vprix`项目希望创建简单，高效，一致的`linux虚拟桌面环境`交付方式。

让大家能够通过简单的一行命令，就得到完整可用的存在云端的桌面环境。

