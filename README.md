# mayaScriptEditor.vim

* Use channel support in vim8, so no language interfaces are required.
* Can get script editor output/history inside vim.

<img src="https://github.com/minoue/mayaScriptEditor.vim/blob/media/images/preview.gif" width="600">

## Requirements
vim8


## Install
* vim-plug  
```
Plug 'minoue/mayaScriptEditor.vim'
```

## Usage
### Maya
You have to open command port inside Maya first.

```python
from maya import cmds
cmds.commandPort(name=":23456", prefix="python", sourceType="mel")
```

### vim

In Normal mode, run the follwing command.

```
MayaScriptEditorSend
```

**Make sure to save before running the command as this command doesn't send texts in a buffer but file path to Maya**

### If you want to get script editor output inside vim...

<img src="https://github.com/minoue/mayaScriptEditor.vim/blob/media/images/preview2.gif" width="600">

#### maya
Set 'writehistory' on.  

```
cmds.scriptEditorInfo(wh=True)
```

#### vim
Set enableOutput option True.

```
let g:MayaScriptEditorEnableOutput = 1
```
