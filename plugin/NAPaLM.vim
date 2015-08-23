" ============================================================================
" File:        NAPaLM.vim
" Description: vim global plugin that provides a macro for inserting print 
"              statements for any program language.
" Maintainer:  Fergus Hewson - fergdev on github. 
" Last Change: 23 August 2015 
" License:     GNU GENERAL PUBLIC LICENSE
"
" ============================================================================
" SECTION: Script init stuff 
" ============================================================================
"
if exists("loaded_NAPaLM")
    finish
endif
if v:version < 700
    echoerr "NAPaLM: this plugin requires vim >= 7"
    finish
endif
let loaded_NAPaLM = 1

"for line continuation - i.e dont want C in &cpo
let s:old_cpo = &cpo
set cpo&vim


" ============================================================================
" SECTION: My printing functions - I never want to have to type a println 
"          ever again
" ============================================================================
" 
" String to search for when deleting / commenting out NAPaLM print statements 
let g:NAPaLMPrintToken = "NNNNAPaLMMMM"
"
"Function: g:NAPaLMPrintArgs() 
" Assumes the line the cursor on is a method signature, then parses the line
" to extract the method name and the variables being passed to the method.
" Print statements are then inserted for the method name and each of the
" arguments.
"Args:
"Returns: void
" 
function! g:NAPaLMPrintArgs()

    " Get line and number
    let currLineNumber = line('.') 
    let currLine = getline('.')
    if currLine == ''
        return
    end

    " Extract method name
    let methodName = matchstr(currLine, '\vmethod\s+\zs\w+\ze\(') 
    if methodName == ''
        return
    end

    call append(currLineNumber ,'println("\n' . methodName . '")//'.g:NAPaLMPrintToken )
    let currLineNumber += 1

    " Extract args
    let argsStr = matchstr(currLine, '\v\(\zs.*\ze\)' )
    let argsSplit = split(argsStr, ',')
    let i = 0
    let splitLen = len(argsSplit)
    while i < splitLen
        "let arg = argsSplit[i]
        "echom 'SP ' . arg
        let arg = matchstr(argsSplit[i], '\v\s*\w+\s+\zs\w+\ze') 
        "echom 'SP ' . arg
        call append(currLineNumber, 'println("'.arg.' = "+'.arg.')//'.g:NAPaLMPrintToken )
        let currLineNumber += 1
        let i += 1
    endwhile
endfunction

" ============================================================================
"Function: g:NAPaLMPrintVar() 
" Assumes the line the cursor is on a variable assignment, then parses the line
" to extract the variable name. A print statement is then inserted for
" variable
"Args:
"Returns:
"
function! g:NAPaLMPrintVar()

    " Get the current line and the line number
    let currLineNumber = line('.') 
    let currLine = getline('.')
    if currLine == ''
        return
    end
    " Extract method name
    let varName = matchstr(currLine, '\v\zs\w+\ze\s*\=') 
    if varName == '' 
        return
    end

    " Add print statement
    call append(currLineNumber ,'println("' . varName . ' = "+'.varName.')//'.g:NAPaLMPrintToken )
endfunction

" ============================================================================
"Function: g:NAPaLMPrintComment() 
" Comments out print statements inserted by NAPaLM.
"Args:
"Returns: void
"
function! g:NAPaLMComment()
   execute 's/\v.*'.g:NAPaLMPrintToken.'/\/\/&'
endfunction

" ============================================================================
"Function: g:NAPaLMPrintComment() 
" Ucomment NAPaLM print statements.
"Args:
"Returns: void
"
function! g:NAPaLMUncomment()
    execute 's/\v/\/\\zs.*'.g:NAPaLMPrintToken.'/&'
endfunction 

" ============================================================================
"Function: g:NAPaLMPrintComment() 
"Args:
"Returns: void
"
function! g:NAPaLMDelete()
   execute 'g/\v'.g:NAPaLMPrintToken.'/d'
endfunction

" ============================================================================
" SECTION: Language definitions 
" ============================================================================
" Language def structure
" LangName : ['print statement', 'single line comment']
"
" Print statement
"  This token "${name}" is where the variable name will be printed 
"  This token "${var}" is where variable will be printed
"
let s:NAPaLMLanguageDefs = {
    \   'Java'      : ['System.out.println("${name} = " + ${var});', '//'],
    \   'C'         : ['', '//'],
    \   'C++'       : ['', '//'],
    \   'C#'        : ['', '//'],
    \   'Python'    : ['print("${name} = " + ${var})', '#'],
    \   'VimScript' : ['echo "${name} = " + ${var}', '"'],
    \}

let g:NAPaLMCustomLanguageDefs={}
"
" ============================================================================
" SECTION: Default key mappings
" ============================================================================
"
let g:NAPaLMDebug = 1
if g:NAPaLMDebug == 1
    nnoremap <Leader>pa :call g:NAPaLMPrintArgs()<CR> " Print args
    nnoremap <Leader>pv :call g:NAPaLMPrintVar()<CR>  " Print var
    nnoremap <Leader>pc :call g:NAPaLMComment()<CR>   " Comment out print statements
    nnoremap <Leader>pC :call g:NAPaLMUnComment()<CR> " UnComment out print statements
    nnoremap <Leader>pd :call g:NAPaLMDelete()<CR>    " Delete all print statements
else
    nnoremap <silent> <Leader>pa :call g:NAPaLMPrintArgs()<CR> " Print args
    nnoremap <silent> <Leader>pv :call g:NAPaLMPrintVar()<CR>  " Print var
    nnoremap <silent> <Leader>pc :call g:NAPaLMComment()<CR>   " Comment out print statements
    nnoremap <silent> <Leader>pC :call g:NAPaLMUnComment()<CR> " UnComment out print statements
    nnoremap <silent> <Leader>pd :call g:NAPaLMDelete()<CR>    " Delete all print statements
end
