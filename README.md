# NAPaLM
Not Another Print Line (a) Macro |NAPaLM|. Initially this project will be supported in vim, however I cannot rule out other texteditors.

## Philosophy
The aim of this project to automate the writing of debug print statements, so you will never have to write a Println ever again!!!

## Features

### Print variable 
The simplest use case for NAPaLM is printing a variable to the console. Below is an example in Java, where we have a string we want printed to the console.
```
    public class VarTest {
        public static void main(String[] args){
            String helloString = "Hello, World";
        }
    }
```

The default mapping for variable print is <Leader>pa. Moving the cursor the line containing the variable and entering the variable mapping will generate a print statement below the current line.

```
    public class VarTest {
        public static void main(String[] args){
            String helloString = "Hello, World";
            System.out.println("helloString = " + helloString); // NNNNAPaLMMMM
        }
    }
```

### Print method arguments

#### Comment (toggle) all NAPaLM print statements

#### Remove all NAPaLM print statements

#### Easy custom language support 

Custom languages can be added to NAPaLM by following the pattern below.
NAPaLM needs to know how to fomat a simple print statement, a variable print statement and the comment string for the language.

```
let g:NAPaLMCustomLanguageDefs = {
    \  'umajin' : {'println("${name}")',
    \              'println("${name} = " + ${var})',
    \              '//'},
    \}
``` 

You can even override the default language definitions. The custom language definition map is checked before the default language definition. 

```
let g:NAPaLMCustomLanguageDefs = {
    \ 'java' : {'sps' : 'System.out.println("!!!!${name}!!!!");', 
    \           'vps' : 'System.out.println("!!!!${name} = " + ${var} + "!!!!");' , 
    \           'comment' : '//'
    \            },
    \ }
```

There is also support for languaes where you need a specific print statement for different datatypes. A good example is C where you need provide a formatter string for each data type.

```
let g:NAPaLMCustomLanguageDefs = {
    \  'c'    : {
    \             'sps' : 'printf("${name}");',
    \             'vps' : 'printf("${name} = %s\n", ${var});',
    \             'ops' :
    \             {
    \                'char'   : 'printf("${name} = %s\n", ${var});',
    \                'int'    : 'printf("${name} = %d\n", ${var});',
    \                'float'  : 'printf("${name} = %f\n", ${var});',
    \                'double' : 'printf("${name} = %f\n", ${var});',
    \             },
    \            'comment' : '//',
    \            'app'     : '{'
    \            },
    \ }
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
