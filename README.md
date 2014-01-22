cinnamon
========

A shell script to provide assistance for black-box testing programming assignments.

Usage
--

cinnamon.sh [-c=\<comment marker>] \<program file> \<test cases> ...

--

The idea of the script is that a program will be tested by sending input to stdin and it will produce some output to stdout.

Program Sources
--

The program can be a Java program, C program, shell script or any other binary executable.

Note: the script doesn't compile for you; it assumes the code has been compiled.

* (Program).{java,class} files will be executed with
> java (Program)

* (Program).c files will be executed with
> ./(Program)

* (Program).sh files with be executed with
> sh (Program)

* any other file will be executed with:
> ./(Program)

Test Cases
--

Cases should be supplied as text files, likely each case should be in a different file.

A case will have its input printed, then the program is executed and the output is printed.  In the basic scenario, the output must be manually inspected for correctness.

If, however, a case ends with "(Case Name).in" and there is a corresponding "(Case Name).out" file, then the output will be diff-ed with the expected output from the .out file.

Test Case Comments
--

Input files may include comments which will be printed to the screen but removed before being sent to the program.  By default, the comment delimiter is // as in modern C & Java styles.  Any characters following the // to the end of the line will be removed.

The delimiter can be changed with the -c (or --comment) flag.  For example:
> sh cinnamon.sh -c=# my_script.sh test1.txt test2.txt test3.in

(This will use shell style # comments.)
