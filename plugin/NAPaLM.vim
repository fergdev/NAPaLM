" ============================================================================
" File:        NAPaLM.vim
" Description: vim global plugin that provides a macro for inserting print 
"              statements for any program language.
" Maintainer:  Fergus Hewson - fergdev on github. 
" Last Change: See change log at https://github.com/fergdev/NAPaLM 
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
    let l:currLineNumber = line('.') 
    let l:initialLineNumber = l:currLineNumber
    let l:currLine = getline('.')
    if l:currLine == ''
        return
    end

    " Extract method name
    let l:methodName = matchstr(currLine, '\v\s+\zs\S+\ze\(') 
    if l:methodName == ''
        return
    end
    " Get file type formater 
    let l:formatter = s:NAPaLMGetSingleFormatter()
    if l:formatter == g:NAPaLMNullFormatter 
        echom "No Formatter available"
        return
    end

    " Find line after the line that matches the argument placement pattern
    let l:currLineNumber = s:NAPaLMGetArgsPlacementLine(currLineNumber)  
    
    " Replace name and var
    let l:printStatement = substitute(l:formatter, "${name}", l:methodName, "")
    call s:NAPaLMAppend(l:currLineNumber, l:printStatement)

    let l:currLineNumber += 1
    
    " Extract args
    let l:argsStr = matchstr(l:currLine, '\v\(\zs.*\ze\)' )
    let l:argsSplit = split(l:argsStr, ',')
    let l:index = 0
    let l:splitLen = len(l:argsSplit)
    while l:index < l:splitLen
        let l:type = matchstr(l:argsSplit[l:index], '\v\zs\w+\ze\s+\w+$')
        let l:arg = matchstr(l:argsSplit[l:index], '\v\zs\w+\ze$') 
        if l:arg == '' 
            continue
        end
        let l:varFormatter = s:NAPaLMGetVarTypeFormatter(l:type)  

        let l:printStatement = substitute(l:varFormatter   , "${name}" , l:arg , "g")
        let l:printStatement = substitute(l:printStatement , "${var}"  , l:arg , "g")

        call s:NAPaLMAppend(l:currLineNumber, l:printStatement)

        let l:currLineNumber += 1
        let l:index += 1
    endwhile
    
    " Auto indent lines
    exec 'normal! '.l:initialLineNumber.'G='.l:currLineNumber.'G'
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
    let l:currLineNumber = line('.')
    let l:currLine       = getline('.')
    if l:currLine == ''
        return
    end
    " Extract method name
    let l:varName = matchstr(l:currLine, '\v\zs\w+\ze\s*\=') 
    if l:varName == '' 
        return
    end
    " Attempt to get variable type
    let l:varType = matchstr(l:currLine,'\v<\zs\w.*\ze\s+\w+\s*\=')
    let l:varType = s:NAPaLMProcessVarType(l:varType)

    " Get the formatter for the print statement
    let l:formatter = s:NAPaLMGetVarTypeFormatter(l:varType)  
    
    " Replace name and var
    let l:printStatement = substitute(l:formatter      , "${name}" , l:varName , "")
    let l:printStatement = substitute(l:printStatement , "${var}"  , l:varName , "")

    " Add print statement
    call s:NAPaLMAppend(l:currLineNumber, l:printStatement)

    " Fix indentation
    let l:nextLineNumber = l:currLineNumber + 1 
    exec 'normal! '.l:currLineNumber.'G='.l:nextLineNumber.'G'
endfunction


" ============================================================================
"Function: g:NAPaLMPrintLine()
"           Gets the current line and puts it into a print statement. 
"Args:
"Returns: void
"
function! g:NAPaLMPrintLine()
    " Get the current line and the line number
    let l:currLineNumber = line('.')
    let l:currLine       = getline('.')
    if l:currLine == ''
        return
    end
    " Get single type formater 
    let l:formatter = s:NAPaLMGetSingleFormatter()
    
    " Replace name with the current line 
    let l:printStatement = substitute(l:formatter      , "${name}" , l:currLine , "")

    " Add print statement
    call s:NAPaLMAppend(l:currLineNumber, l:printStatement)

    " Fix indentation
    let l:nextLineNumber = l:currLineNumber + 1 
    exec 'normal! '.l:currLineNumber.'G='.l:nextLineNumber.'G'
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
    let l:commentString = s:NAPaLMGetCommentString()
    call append(a:lineNumber , a:printStatement . ' ' .  l:commentString . ' ' .  g:NAPaLMPrintToken )
endfunction

" ============================================================================
"Function: g:NAPaLMPrintComment() 
" Comments out print statements inserted by NAPaLM.
"Args:
"Returns: void
"
function! g:NAPaLMComment()
    let l:commentString = s:NAPaLMGetCommentString()
    " Regex escape comment string
   silent execute 's/\v.*'.g:NAPaLMPrintToken.'/\/\/&'
endfunction

" ============================================================================
"Function: g:NAPaLMPrintComment() 
" Ucomment NAPaLM print statements.
"Args:
"Returns: void
"
function! g:NAPaLMUncomment()
    let l:commentString = s:NAPaLMGetCommentString()
    " Regex escape comment string
    silent execute 's/\v/\/\\zs.*'.g:NAPaLMPrintToken.'/&'
endfunction 

" ============================================================================
"Function: g:NAPaLMDelete() 
" Deletes all NAPaLM inserted print statements.
"Args:
"Returns: void
"
function! g:NAPaLMDelete()
   silent execute 'g/\v'.g:NAPaLMPrintToken.'/d'
endfunction

" ============================================================================
" SECTION: Language definitions 
" ============================================================================
" Language def structure
" LangName : {'single print', 'var print', 'single line comment'}
"
" Single print statement - 'sps' 
"  This token "${name}" is where the variable name will be printed 
"
" Defulat Var print statement - 'vps'
"  This token "${name}" is where the variable name will be printed 
"  This token "${var}" is where variable will be printed
"
" Object print statements - 'ops'
"  Map of print statements for different ojbect types
"  Same formate as Var print statement
"
" Single line comment 'comment'
"  The string that does a single line coment for the lang
"
" Args placement pattern - 'app'
"  A pattern to search for to place args print statements, needed for cpp
"  to place print statements after next {.
"
" Stripped keywords - 'sk'
"  A list of keywords to strip from variable types i.e (const,cpp) (final,java)
"
let s:NAPaLMLanguageDefs = {
    \  'java' : { 
    \             'sps'     : 'System.out.println("${name}");',
    \             'vps'     : 'System.out.println("${name} = " + ${var});' ,
    \             'ops'     : {},
    \             'comment' : '//',
    \             'app'     : '{',
    \             'sk'      : ['final']
    \            },
    \  'c'    : {
    \             'sps' : 'printf("${name}");',
    \             'vps' : 'printf("${name} = %s\n", ${var});',
    \             'ops' :
    \             {
    \                'char*'                  : 'printf("${name} = %s\n", ${var});',
    \                'char'                   : 'printf("${name} = %c\n", ${var});',
    \                'singed char'            : 'printf("${name} = %c\n", ${var});',
    \                'unsigned char'          : 'printf("${name} = %c\n", ${var});',
    \                'short'                  : 'printf("${name} = %hi\n", ${var});',
    \                'short int'              : 'printf("${name} = %hi\n", ${var});',
    \                'singed short'           : 'printf("${name} = %hi\n", ${var});',
    \                'signed short int'       : 'printf("${name} = %hi\n", ${var});',
    \                'unsigned short'         : 'printf("${name} = %hu\n", ${var});',
    \                'unsigned short int'     : 'printf("${name} = %hu\n", ${var});',
    \                'int'                    : 'printf("${name} = %d\n", ${var});',
    \                'signed int'             : 'printf("${name} = %d\n", ${var});',
    \                'unsigned'               : 'printf("${name} = %u\n", ${var});',
    \                'unsigned int'           : 'printf("${name} = %u\n", ${var});',
    \                'long'                   : 'printf("${name} = %li\n", ${var});',
    \                'long int'               : 'printf("${name} = %li\n", ${var});',
    \                'singed long'            : 'printf("${name} = %li\n", ${var});',
    \                'singed long int'        : 'printf("${name} = %li\n", ${var});',
    \                'unsigned long'          : 'printf("${name} = %lu\n", ${var});',
    \                'unsigned long int'      : 'printf("${name} = %lu\n", ${var});',
    \                'long long'              : 'printf("${name} = %lli\n", ${var});',
    \                'long long int'          : 'printf("${name} = %lli\n", ${var});',
    \                'singed long long'       : 'printf("${name} = %lli\n", ${var});',
    \                'singed long long int'   : 'printf("${name} = %lli\n", ${var});',
    \                'unsigned long long'     : 'printf("${name} = %llu\n", ${var});',
    \                'unsigned long long int' : 'printf("${name} = %llu\n", ${var});',
    \                'float'                  : 'printf("${name} = %f\n", ${var});',
    \                'double'                 : 'printf("${name} = %f\n", ${var});',
    \                'long double'            : 'printf("${name} = %Lf\n", ${var});',
    \             },
    \            'comment' : '//',
    \            'app'     : '{',
    \            'sk'      : ['const']
    \            },
    \  'cpp'  : {
    \            'sps'     : 'cout << "${name}";',
    \            'vps'     : 'cout << "${name} = " << ${var} << "\n";',
    \            'ops'     : {},
    \            'comment' : '//',
    \            'app'     : '{',
    \            'sk'      : ['const']
    \            },
    \  'cs'   : {
    \            'sps'     : 'Console.WriteLine("${name}");',
    \            'vps'     : 'Console.WriteLine("${name} = " + ${var});',
    \            'ops'     : {},
    \            'comment' : '//',
    \            'app'     : '{',
    \            'sk'      : ['const', 'readonly']
    \           },
    \  'python'  : {
    \            'sps'     : 'print("${name}")',
    \            'vps'     : 'print("${name} = " + ${var})',
    \            'ops'     : {},
    \            'comment' : '#',
    \            },
    \  'vim'  : {
    \            'sps'     : 'echo "${name}"',
    \            'vps'     : 'echo "${name} = " . ${var}',
    \            'ops'     : {},
    \            'comment' : '"',
    \           },
    \  'javascript'   : {
    \           'sps'     : 'console.log("${name}");',
    \           'vps'     : 'console.log("${name} = " + ${var});',
    \           'ops'     : {},
    \           'comment' : '//',
    \           'app'     : '{'
    \           },
    \  'objc'   : {
    \           'sps' : 'NSLog(@"${name}");',
    \           'vps' : 'NSLog(@"${name} = %s", ${var});',
    \           'ops' : 
    \           {
    \               'NSString'           : 'NSLog(@"${name} = %@" + ${var});',
    \               'BOOL'               : 'NSLog(@"${name} = %d" + ${var});',
    \               'bool'               : 'NSLog(@"${name} = %d" + ${var});',
    \               'Boolean'            : 'NSLog(@"${name} = %d" + ${var});',
    \               'char'               : 'NSLog(@"${name} = %c" + ${var});',
    \               'unsigned char'      : 'NSLog(@"${name} = %c" + ${var});',
    \               'short'              : 'NSLog(@"${name} = %hd" + ${var});',
    \               'unsigned short'     : 'NSLog(@"${name} = %hu" + ${var});',
    \               'int'                : 'NSLog(@"${name} = %i" + ${var});',
    \               'usigned int'        : 'NSLog(@"${name} = %u" + ${var});',
    \               'long'               : 'NSLog(@"${name} = %ld" + ${var});',
    \               'unsigned long'      : 'NSLog(@"${name} = %lu" + ${var});',
    \               'long long'          : 'NSLog(@"${name} = %lld" + ${var});',
    \               'unsigned long long' : 'NSLog(@"${name} = %llu" + ${var});',
    \               'float'              : 'NSLog(@"${name} = %f" + ${var});',
    \               'double'             : 'NSLog(@"${name} = %f" + ${var});',
    \               'long double'        : 'NSLog(@"${name} = %Lf" + ${var});',
    \           },
    \           'comment' : '//',
    \           'app'     : '{',
    \           'sk'      : ['const']
    \           },
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
    let l:custLangDef = get(g:NAPaLMCustomLanguageDefs, l:currFileType, {})
    if l:custLangDef != {} 
        return l:custLangDef
    endif
    " Check default lang defs
    let l:defaultLangDef = get(s:NAPaLMLanguageDefs, l:currFileType, {})
    if l:defaultLangDef != {} 
        return l:defaultLangDef
    endif
    return {} 
endfunction

" ============================================================================
"Function: s:NAPaLMGetSingleFormatter()
"Args:
"Returns: A formatter string for a single print statement for the current 
"         filetype.
"
function! s:NAPaLMGetSingleFormatter()
    let l:currLangDef = s:NAPaLMGetLangDef()
    if l:currLangDef == {} 
        return g:NAPaLMNullFormatter
    endif
    return l:currLangDef['sps'] 
endfunction

" ============================================================================
"Function: s:NAPaLMGetVarFormatter()  
"Args:
"Returns: A formatter string for a var print statement for the current 
"         filetype.
"
function! s:NAPaLMGetVarFormatter()
    let l:currLangDef = s:NAPaLMGetLangDef()
    if l:currLangDef == {} 
        return g:NAPaLMNullFormatter
    endif
    return l:currLangDef['vps'] 
endfunction

" ============================================================================
"Function: s:NAPaLMGetVarTypeFormatter()  
"Args:
"Returns: Gets the print formater for a give var type. If a formatter is not
"         available for the given type, the defualt formatter is returned.
"
function! s:NAPaLMGetVarTypeFormatter(varType) 
    let l:currLangDef = s:NAPaLMGetLangDef()
    if l:currLangDef == {} 
        return g:NAPaLMNullFormatter
    endif
    let l:formatterMap = l:currLangDef['ops']
    let l:varFormatter = get(l:formatterMap, a:varType, "" )
    if l:varFormatter == "" 
        return l:currLangDef['vps'] 
    endif

    return l:varFormatter 
endfunction

" ============================================================================
"Function: s:NAPaLMGetCommentString()  
"Args:
"Returns: The comment string for the current filetype.
"
function! s:NAPaLMGetCommentString() 
    let l:currLangDef = s:NAPaLMGetLangDef()
    if l:currLangDef == {} 
        return g:NAPaLMNullFormatter
    endif
    return l:currLangDef['comment'] 
endfunction

" ============================================================================
"Function: s:NAPaLMGetArgsPlacementPattern()
"Args:
"Returns: The args placement pattern for the current language
"
function! s:NAPaLMGetArgsPlacementPattern() 
    let l:currLangDef = s:NAPaLMGetLangDef()
    if l:currLangDef == {} 
        return g:NAPaLMNullFormatter
    endif
    let l:argsPlacementPattern = get(l:currLangDef, 'app', '')
    return l:argsPlacementPattern 
endfunction

" ============================================================================
"Function: s:NAPaLMGetArgsPlacementLine()  
"Args: startLine - the line to start searching from
"Returns: The line to start placing argument print statements after.
"
function! s:NAPaLMGetArgsPlacementLine(startLineNumber) 
    let l:argsPlacementPattern = s:NAPaLMGetArgsPlacementPattern()
    if l:argsPlacementPattern == ''
        return a:startLineNumber
    end
    let l:currentLineNumber = a:startLineNumber
    let l:maxLineNumber = a:startLineNumber + 10
    while l:currentLineNumber < l:maxLineNumber 
        let l:currentLine = getline(l:currentLineNumber)
        if l:currentLine =~ l:argsPlacementPattern
           return l:currentLineNumber 
        end
        let l:currentLineNumber += 1
    endwhile
    return a:startLineNumber
endfunction

" ============================================================================
"Function: s:NAPaLMGetStrippedKeywords()  
"Args: 
"Returns: The list of keywords to strip from an arguments definition.
"
function! s:NAPaLMGetStrippedKeywords() 
    let l:currLangDef = s:NAPaLMGetLangDef()
    if l:currLangDef == {} 
        return '' 
    endif
    let l:strippedKeywords = get(l:currLangDef, 'sk', [])
    return l:strippedKeywords 
endfunction

" ============================================================================
"Function: s:NAPaLMProcessVarType() 
" Process a given var type string to get the true var type (i.e removes
" const,final) 
"Args: varType - the var type string to process
"Returns: The true vartype string
"
function! s:NAPaLMProcessVarType(varType)
    let l:varType = a:varType
    let l:strippedKeywords = s:NAPaLMGetStrippedKeywords()
    let l:skIndex = 0
    let l:slLength = len(l:strippedKeywords)
    while l:skIndex < l:slLength
        let l:varType = substitute(l:varType, l:strippedKeywords[l:skIndex], '', '')
        let l:skIndex = l:skIndex + 1
    endwhile
    return s:NAPaLMStrip(l:varType)
endfunction

function! s:NAPaLMStrip(input_string)
    return substitute(a:input_string, '^\s*\(.\{-}\)\s*$', '\1', '')
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
