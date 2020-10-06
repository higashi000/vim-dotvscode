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
    endif

    echo l:settingjson
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
