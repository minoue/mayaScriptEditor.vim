if exists("g:loaded_mayaScriptEditor")
    finish
endif
let g:loaded_mayaScriptEditor = 1

let s:save_cpo = &cpo
set cpo&vim


function! GetScriptEditorHistoryPath() abort
    if has("unix")
        let s:uname = system("uname -s")
        if s:uname == "Darwin\n"
            " Mac
            let scriptEditorHistoryPath = $HOME . "/Library/Preferences/Autodesk/maya/scriptEditorHistory.txt"
        else
            " Linux
            let scriptEditorHistoryPath = $HOME . "/maya/scriptEditorHistory.txt"
        endif
    elseif has("win32")
        " Windows
        let scriptEditorHistoryPath = $HOME . "\\Documents\\maya\\scriptEditorHistory.txt"
    endif
    return scriptEditorHistoryPath
endfunction


function! MayaHandler(ch, msg)
    try
        execute "bd ". g:scriptEditorBufferNumber
    catch
    endtry

    if ch_status(a:ch) !=# 'closed'
        call ch_close(a:ch)
    endif
    " echo ch_status(s:ch)
    "
    let scriptEditorPath = GetScriptEditorHistoryPath()
    if filereadable(scriptEditorPath)
        echo ""
    else
        echo "Can't read script editor history file. Maybe it doesn't exist or not readable. \nMake sure to enable writeHistory True in scriptEditorInfo command in Maya"
        return 0
    end

    " https://vi.stackexchange.com/questions/5126/how-to-detect-the-buffer-number-of-new-buffer
    execute "new " . scriptEditorPath
    setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
    let g:scriptEditorBufferNumber = bufnr('%')
    let numOfLines = line('$')
    cal cursor(numOfLines, 0)
    execute "sb " . g:currentWorkingBuffer
endfunction


function! MayaScriptEditorSendCmd()
    let current_file_type = &filetype
    if current_file_type != 'python'
        echo 'Not python file'
        return 0
    endif

    let g:currentWorkingBuffer = bufnr('%')
    let current_file_path = expand('%:p')

    if has("unix")
        let cmd = "execfile('" . current_file_path . "')"
    elseif has("win32")
        let filePath_forWin = substitute(current_file_path, "\\", "/", "g")
        let cmd = "execfile('" . filePath_forWin . "')"
    endif
    
    let options = {'mode': 'raw', 'callback': function('MayaHandler')}
    let ch = ch_open('localhost:23456', options)
    " echo ch_status(s:ch)

    echo "Now running the script... Please wait."
    call ch_sendraw(ch, cmd)
endfunction     
command! MayaScriptEditorSend call MayaScriptEditorSendCmd()


function! MayaScriptEditorClearHistory() abort
    let cmd = "from maya import cmds; cmds.scriptEditorInfo(clearHistoryFile=True)"
    let options = {'mode': 'raw', 'callback': function('MayaHandler')}
    let ch = ch_open('localhost:23456', options)
    call ch_sendraw(ch, cmd)
endfunction
command! MayaScriptEditorClear call MayaScriptEditorClearHistory()


au BufRead,BufNewFile scriptEditorHistory.txt set filetype=mayaScriptEditor

let &cpo = s:save_cpo
unlet s:save_cpo
