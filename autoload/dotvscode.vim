function dotvscode#searchDotVSC() abort
    let l:currentDir = execute(':pwd')
    call finddir('.vscode', l:currentDir)

    let l:tmpDir = execute(':pwd')
    while 1
        let l:tmpCurrentDir = execute(':pwd')

        if l:tmpCurrentDir == "\n/"
            echo 'not exists .vscode in root directory'
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
endfunction
