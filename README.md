# mayaScriptEditor.vim

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

