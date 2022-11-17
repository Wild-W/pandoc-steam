# Pandoc-Steam
Custom steam flavored BBCode pandoc writer (convert markdown/HTML/etc to steam formatting!)

## Requirements
- [Pandoc](https://pandoc.org/installing.html)

## Demonstration
Markdown
```markdown
# H1
 
Lorem ipsum dolor sit amet, *consectetur* adipisicing elit, sed do eiusmod
tempor incididunt ut **labore et dolore magna aliqua**. Ut enim ad minim veniam,
 
 
> quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
 
consequat. ***Duis aute irure dolor*** in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. ~~Excepteur sint occaecat~~ cupidatat nonproident, sunt in culpa qui officia deserunt mollit anim id est laborum.
 
## H2
 
Lorem ipsum dolor sit amet, *consectetur* adipisicing elit, sed do eiusmod
tempor incididunt ut **labore et dolore magna aliqua**. Ut enim ad minim veniam,
quis nostrud^hello^ ^world^ exercitation ullamco laboris nisi ut aliquip ex ea commodo~fooBar~
consequat. 
 
---
 
***Duis aute irure dolor*** in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. ~~Excepteur sint occaecat~~ cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
 
### H3
 
unordered list:
 
* item-1
  * sub-item-1
  * sub-item-2
- item-2
  - sub-item-3
  - sub-item-4
+ item-3
  + sub-item-5
  + sub-item-6
```

Convert with pandoc
```sh
$ pandoc -t steamwriter.lua test.md
```

Steam BBCode
```bbcode
[h1]H1[/h1]
Lorem ipsum dolor sit amet, [i]consectetur[/i] adipisicing elit, sed do eiusmod
tempor incididunt ut [b]labore et dolore magna aliqua[/b]. Ut enim ad minim veniam,
[quote]
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
[/quote]
consequat. [b][i]Duis aute irure dolor[/i][/b] in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. [strike]Excepteur sint occaecat[/strike] cupidatat nonproident, sunt in culpa qui officia deserunt mollit anim id est laborum.
[h2]H2[/h2]
Lorem ipsum dolor sit amet, [i]consectetur[/i] adipisicing elit, sed do eiusmod
tempor incididunt ut [b]labore et dolore magna aliqua[/b]. Ut enim ad minim veniam,
quis nostrudʰᵉˡˡᵒ ʷᵒʳˡᵈ exercitation ullamco laboris nisi ut aliquip ex ea commodofₒₒBₐᵣ
consequat.
[hr][/hr]
[b][i]Duis aute irure dolor[/i][/b] in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. [strike]Excepteur sint occaecat[/strike] cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
[h3]H3[/h3]
unordered list:
[list][*]item-1
[list][*]sub-item-1
[*]sub-item-2[/list]
[*]item-2
[list][*]sub-item-3
[*]sub-item-4[/list]
[*]item-3
[list][*]sub-item-5
[*]sub-item-6[/list][/list]
```

![image](https://user-images.githubusercontent.com/39774593/202514406-504dc3f7-077a-4e0e-92c5-a9d67edea586.png)

