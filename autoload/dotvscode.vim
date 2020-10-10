let s:save_cpo = &cpo
set cpo&vim

function dotvscode#searchDotVSC() abort
    let l:currentDir = execute(':pwd')
    call finddir('.vscode', l:currentDir)

    let l:tmpDir = execute(':pwd')
    while 1
        let l:tmpCurrentDir = execute(':pwd')

        if l:tmpCurrentDir == "\n/"
            let l:tmpCurrentDir = ''
            break
        endif

        let l:isExistDotVSC = isdirectory('.vscode')
        if l:isExistDotVSC
            echo l:tmpDir
            break
        endif

        call execute(':cd ..')
    endwhile

    call execute(':cd '.strpart(l:currentDir, 1))

    return strpart(l:tmpCurrentDir, 1)
endfunction

function dotvscode#loadSettingsJSON() abort
    let l:filepath = dotvscode#searchDotVSC()

    let s:V = vital#dotvscode#new()
    let s:J = s:V.import('Web.JSON')

    let l:settingjson = ''

    if l:filepath != ''
    for line in readfile(l:filepath . '/.vscode/settings.json')
        let l:settingjson = l:settingjson . line
    endfor
    else
        echo 'failed search .vscode'
        return
    endif

    let l:parseJSON = s:J.decode(l:settingjson)

    let g:dotvscode#existsSettingsJSON = v:true
    return l:parseJSON
endfunction

function dotvscode#setVSCodeSettings() abort
    let l:settingsJSON = dotvscode#loadSettingsJSON()

    if g:dotvscode#existsSettingsJSON == v:false
        return
    endif

    if has_key(l:settingsJSON, 'editor.insertSpaces') && l:settingsJSON['editor.insertSpaces'] == v:true
        set expandtab
    elseif has_key(l:settingsJSON, 'editor.insertSpaces') && l:settingsJSON['editor.insertSpaces'] == v:false
        set noexpandtab
    endif

    if has_key(l:settingsJSON, 'editor.tabSize')
        let &shiftwidth = l:settingsJSON['editor.tabSize']
    else
        set shiftwidth=4
    endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
