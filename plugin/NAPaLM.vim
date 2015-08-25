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
    let initialLineNumber = currLineNumber
    let currLine = getline('.')
    if currLine == ''
        return
    end

    " Extract method name
    let methodName = matchstr(currLine, '\v\s+\zs\S+\ze\(') 
    if methodName == ''
        return
    end
    " Get file type formater 
    let formatter = s:NAPaLMGetSingleFormatter()
    if formatter == g:NAPaLMNullFormatter 
        echom "No Formatter available"
        return
    end
    " Replace name and var
    let printStatement = substitute(formatter, "${name}", methodName, "")
    call s:NAPaLMAppend(currLineNumber, printStatement)

    let currLineNumber += 1
    
    " Extract args
    let argsStr = matchstr(currLine, '\v\(\zs.*\ze\)' )
    let argsSplit = split(argsStr, ',')
    let i = 0
    let splitLen = len(argsSplit)
    while i < splitLen
        let type = matchstr(argsSplit[i], '\v\s*\zs\w+\ze\s+\w+')
        let arg = matchstr(argsSplit[i], '\v\s*\w+\s+\zs\w+\ze') 
        if arg == '' 
            continue
        end
        let varFormatter = s:NAPaLMGetVarTypeFormatter(type)  

        let printStatement = substitute(varFormatter, "${name}" , arg , "g")
        let printStatement = substitute(printStatement , "${var}"  , arg , "g")

        call s:NAPaLMAppend(currLineNumber, printStatement)

        let currLineNumber += 1
        let i += 1
    endwhile
    
    " Auto indent lines
    exec 'normal! '.initialLineNumber.'G='.currLineNumber.'G'
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
    let currLine       = getline('.')
    if currLine == ''
        return
    end
    " Extract method name
    let varName = matchstr(currLine, '\v\zs\w+\ze\s*\=') 
    if varName == '' 
        return
    end
    " Get file type formater 
    let formatter = s:NAPaLMGetVarFormatter()
    
    " Replace name and var
    let printStatement = substitute(formatter      , "${name}" , varName , "")
    let printStatement = substitute(printStatement , "${var}"  , varName , "")

    " Add print statement
    call s:NAPaLMAppend(currLineNumber, printStatement)

    " Fix indentation
    let nextLineNumber = currLineNumber + 1 
    exec 'normal! '.currLineNumber.'G='.nextLineNumber.'G'
endfunction


" ============================================================================
"Function: g:NAPaLMPrintLine()
"           Gets the current line and puts it into a print statement. 
"Args:
"Returns: void
"
function! g:NAPaLMPrintLine()
    " Get the current line and the line number
    let currLineNumber = line('.')
    let currLine       = getline('.')
    if currLine == ''
        return
    end
    " Get single type formater 
    let formatter = s:NAPaLMGetSingleFormatter()
    
    " Replace name with the current line 
    let printStatement = substitute(formatter      , "${name}" , currLine , "")

    " Add print statement
    call s:NAPaLMAppend(currLineNumber, printStatement)

    " Fix indentation
    let nextLineNumber = currLineNumber + 1 
    exec 'normal! '.currLineNumber.'G='.nextLineNumber.'G'
endfunction

" ============================================================================
"Function: s:NAPaLMAppend(linNumber, printStatement) 
" Appends the given print statement at the provided line number
"Args:
" lineNumer      - The line number to insert the print statement at
" printStatement - The print statement to append the give line number
"Returns: void
"
function! s:NAPaLMAppend(lineNumber, printStatement)
    let commentString = s:NAPaLMGetCommentString()
    call append(a:lineNumber , a:printStatement . ' ' .  commentString . ' ' .  g:NAPaLMPrintToken )
endfunction

" ============================================================================
"Function: g:NAPaLMPrintComment() 
" Comments out print statements inserted by NAPaLM.
"Args:
"Returns: void
"
function! g:NAPaLMComment()
    let commentString = s:NAPaLMGetCommentString()
    " Regex escape comment string
   execute 's/\v.*'.g:NAPaLMPrintToken.'/\/\/&'
endfunction

" ============================================================================
"Function: g:NAPaLMPrintComment() 
" Ucomment NAPaLM print statements.
"Args:
"Returns: void
"
function! g:NAPaLMUncomment()
    let commentString = s:NAPaLMGetCommentString()
    " Regex escape comment string
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
" LangName : ['single print', 'var print', 'single line comment']
"
" Single print statement
"  This token "${name}" is where the variable name will be printed 
"
" Var print statement
"  This token "${name}" is where the variable name will be printed 
"  This token "${var}" is where variable will be printed
"
" Single line comment
"  The string that does a single line coment for the lang
"
let s:NAPaLMLanguageDefs = {
    \  'java' : ['System.out.println("${name}");', 
    \            'System.out.println("${name} = " + ${var});' , 
    \           {},
    \            '//'
    \            ],
    \  'c'    : ['printf("${name}");',
    \            'printf("${name} = %s\n", ${var});',
    \            {
    \                'char'   : 'printf("${name} = %s\n", ${var});',
    \                'int'    : 'printf("${name} = %d\n", ${var});',
    \                'float'  : 'printf("${name} = %f\n", ${var});',
    \                'double' : 'printf("${name} = %f\n", ${var});',
    \            },
    \            '//'
    \            ],
    \  'cpp'  : ['cout << "${name}"',
    \            'cout << "${name} = " << ${var} << "\n";',
    \            {},
    \            '//'],
    \  'cs'   : ['Console.WriteLine("${name}")',
    \            'Console.WriteLine("${name} = " + ${var});',
    \            {},
    \            '//'],
    \  'python'  : ['print("${name}")',
    \            'print("${name} = " + ${var})',
    \            {},
    \            '#'],
    \  'vim'  : ['echo "${name}"',
    \            'echo "${name} = " . ${var}',
    \            {},
    \            '"'],
    \  'javascript'   : ['console.log("${name}");',
    \                    'console.log("${name} = " + ${var});',
    \                    {},
    \                    '//'],
    \}

if exists("g:NAPaLMCustomLanguageDefs") == 0
    let g:NAPaLMCustomLanguageDefs={}
endif
"
" The formatter to use when there is no langdef availabe
let g:NAPaLMNullFormatter = 'NAPaLM : No formatter available'

" ============================================================================
"Function: s:NAPaLMGetLangDef() 
"Args:
"Returns: The langdef for the current file.
"
function s:NAPaLMGetLangDef()
    let l:currFileType = &filetype
    " Check custom lang defs
    let l:custLangDef = get(g:NAPaLMCustomLanguageDefs, l:currFileType, [])
    if l:custLangDef != [] 
        return l:custLangDef
    endif
    " Check default lang defs
    let l:defaultLangDef = get(s:NAPaLMLanguageDefs, l:currFileType, [] )
    if l:defaultLangDef != [] 
        return l:defaultLangDef
    endif
    return [] 
endfunction

" ============================================================================
"Function: s:NAPaLMGetSingleFormatter()
"Args:
"Returns: A formatter string for a single print statement for the current 
"         filetype.
"
function! s:NAPaLMGetSingleFormatter()
    let currLangDef = s:NAPaLMGetLangDef()
    if currLangDef == [] 
        return g:NAPaLMNullFormatter
    endif
    return currLangDef[0] 
endfunction

" ============================================================================
"Function: s:NAPaLMGetVarFormatter()  
"Args:
"Returns: A formatter string for a var print statement for the current 
"         filetype.
"
function! s:NAPaLMGetVarFormatter()
    let currLangDef = s:NAPaLMGetLangDef()
    if currLangDef == [] 
        return g:NAPaLMNullFormatter
    endif
    return currLangDef[1] 
endfunction

" ============================================================================
"Function: s:NAPaLMGetVarTypeFormatter()  
"Args:
"Returns: Gets the print formater for a give var type. If a formatter is not
"         available for the given type, the defualt formatter is returned.
"
function! s:NAPaLMGetVarTypeFormatter(varType) 
    let l:currLangDef = s:NAPaLMGetLangDef()
    if l:currLangDef == [] 
        return g:NAPaLMNullFormatter
    endif
    let l:formatterMap = l:currLangDef[2]
    let l:varFormatter = get(l:formatterMap, a:varType, "" )
    if l:varFormatter == "" 
        return l:currLangDef[1] 
    endif

    return l:varFormatter 
endfunction

" ============================================================================
"Function: s:NAPaLMGetCommentString()  
"Args:
"Returns: The comment string for the current filetype.
"
function! s:NAPaLMGetCommentString() 
    let currLangDef = s:NAPaLMGetLangDef()
    if currLangDef == [] 
        return g:NAPaLMNullFormatter
    endif
    return currLangDef[3] 
endfunction

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
    nnoremap <Leader>pl :call g:NAPaLMPrintLine()<CR> " Print current line
else
    nnoremap <silent> <Leader>pa :call g:NAPaLMPrintArgs()<CR> " Print args
    nnoremap <silent> <Leader>pv :call g:NAPaLMPrintVar()<CR>  " Print var
    nnoremap <silent> <Leader>pc :call g:NAPaLMComment()<CR>   " Comment out print statements
    nnoremap <silent> <Leader>pC :call g:NAPaLMUnComment()<CR> " UnComment out print statements
    nnoremap <silent> <Leader>pd :call g:NAPaLMDelete()<CR>    " Delete all print statements
    nnoremap <silent> <Leader>pl :call g:NAPaLMPrintLine()<CR> " Print current line
end
