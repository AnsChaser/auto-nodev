

# 简介
`auto-nodev` 可以在启动 `cmd` 或 `powershell` 时自动将终端切换到指定的 `node` 版本。


# 安装

下载并解压本项目后，根据使用的终端进行相应的设置

## Windows Command Prompt (cmd)

1. 打开注册表编辑器，地址栏跳转到此目录：

   ```
   HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor
   ```

2. 在右侧空白处右键新建一个字符串值，  
   值名称设置为 `AutoRun`  
   数据设置为 `~\scrips\auto-nodev.bat` 的路径

## Windows PowerShell

1. 打开 powershell 的 profile 文件，路径如下，没有的话新建一个：

   ```
   // powershell < 7
   %USERPROFILE%\Documents\WindowsPowerShell\profile.ps1
   // powershell >= 7
   %USERPROFILE%\Documents\PowerShell\profile.ps1
   ```

2. 在文件的最后添加一行以下内容：

   ```
   & filepath
   ```

   其中 `filepath` 替换为 `~\scripts\auto-nodev.ps1` 的路径


# 配置

1. 如果你已经安装了 [nvm](https://github.com/coreybutler/nvm-windows) 来管理node版本，
   则无需进行其它任何配置。

2. 你也可以自行管理不同版本的 node.js ，但是请按以下目录结构来管理它们：

   ```
   .
   |-- nodes_root
       |-- v14.21.3
           |-- node.exe
           |-- npm
       |-- v16.20.1
       |-- v18.17.1
   ```

   注意 `node.exe` 所在的文件夹名称应该是它的版本号  
   现在只需要添加一个环境变量即可  
   变量名称为 `AUTO_NODEV_NODES_ROOT`  
   变量的值为不同版本的 node.js 所在的目录，即上述的 `nodes_root` 的路径


# 使用

1. 设置本地 node 版本  
   在项目根目录中创建一个名为 `.node-version` 的文件  
   在文件中写入该项目使用的 node.js 版本  
   此文件可以使用命令 `node -v > .node-version` 自动生成

2. 自动切换 node 版本  
   设置好本地版本后，在项目根目录打开 `cmd` 或 `powershell` 将会自动切换到该版本  
   使用 `node -v` 可以查看当前 node 版本，此更改只会在当前运行的终端生效  
   在 `vscode` 中打开项目文件夹后，新建终端时也会自动切换到已设置的 node 版本  

