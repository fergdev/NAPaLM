# NAPaLM
Not Another Print Line (a) Macro |NAPaLM|. Initially this project will be supported in vim, however I cannot rule out other texteditors.

## Philosophy
The aim of this project to automate the writing of debug print statements, so you will never have to write a Println ever again!!!

## Features

#### Print variable 

#### Print method arguments

#### Comment (toggle) all NAPaLM print statements

#### Remove all NAPaLM print statements

#### Easy custom language support 
Custom languages can be added to NAPaLM by following the pattern below.
NAPaLM needs to know how to fomat a simple print statement, a variable print statement and the comment string for the language.
```
let g:NAPaLMCustomLanguageDefs = {
    \  'umajin' : ['println("${name}")',
    \              'println("${name} = " + ${var})',
    \              '//'],
    \}
``` 
## Default Supported Languages
To start with NAPaLM wil support the top 5 programming languages on TIOBE [TIOBE](www.tiobe.com/index.php/tiobe_index).

1. Java
2. C
3. C++
4. C#
5. Python

Vimscript and JavaScript have been added to made my life easier :P.

## Default key mappings
```
<Leader>pa Print function arguments
<Leader>pv Print variable
<Leader>pc Comment out print statements
<Leader>pC Uncomment out print statements
<Leader>pd Delete all NAPaLM print statements
```
